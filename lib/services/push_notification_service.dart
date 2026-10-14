import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/supabase_client.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background FCM message: ${message.messageId}');
}

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for real-time payment and account alerts.',
  importance: Importance.high,
);

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  RealtimeChannel? _notificationsSubscription;
  RealtimeChannel? _transactionsSubscription;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Create high-importance Android notification channel
      final androidPlugin = _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(_channel);

      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _localNotificationsPlugin.initialize(
        initializationSettings,
      );

      // Listen for foreground FCM messages and show local notification banners
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        final android = message.notification?.android;

        if (notification != null && android != null && !kIsWeb) {
          showNotification(
            title: notification.title ?? 'Notification',
            body: notification.body ?? '',
          );
        }
      });

      // Handle token setup and refresh
      await syncToken();
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        MerchantRepository.instance.saveFcmToken(token);
      });

      _initialized = true;
    } catch (e) {
      debugPrint('PushNotificationService initialization error: $e');
    }
  }

  /// Trigger an instant high-priority heads-up local push notification.
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      await _localNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: '@mipmap/launcher_icon',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error showing local push notification: $e');
    }
  }

  /// Listen for incoming realtime notification rows and completed transactions.
  void listenToRealtimeNotifications() {
    _notificationsSubscription?.unsubscribe();
    _transactionsSubscription?.unsubscribe();

    try {
      // 1. Listen for new notification alerts in `merchant_notifications`
      _notificationsSubscription = supabase
          .channel('public:merchant_notifications')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'merchant_notifications',
            callback: (payload) {
              final newRow = payload.newRecord;
              final title = newRow['title']?.toString();
              final body = newRow['body']?.toString();
              if (title != null && body != null) {
                showNotification(title: title, body: body);
              }
            },
          )
          .subscribe();

      // 2. Listen for transaction status completions in `transactions`
      _transactionsSubscription = supabase
          .channel('public:transactions')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'transactions',
            callback: (payload) {
              final newRow = payload.newRecord;
              final status = newRow['status']?.toString();
              if (status == 'completed') {
                final amount = (newRow['amount'] as num?) ?? 0;
                final type = newRow['type']?.toString() ?? 'payment';
                final channel = newRow['channel']?.toString() ?? '';
                final counterparty = newRow['counterparty_name']?.toString();

                final typeLabel = type == 'payment'
                    ? 'Payment'
                    : (type == 'payout' ? 'Payout' : 'Transaction');

                showNotification(
                  title: '$typeLabel Completed 🎉',
                  body:
                      'Successfully processed ${money(amount)}${counterparty != null && counterparty.isNotEmpty ? ' from $counterparty' : ''}${channel.isNotEmpty ? ' via $channel' : ''}',
                );
              }
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Error subscribing to realtime transactions/notifications: $e');
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      debugPrint('Request push notification permission error: $e');
      return false;
    }
  }

  Future<void> syncToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await MerchantRepository.instance.saveFcmToken(token);
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }
}
