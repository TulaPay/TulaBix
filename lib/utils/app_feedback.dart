import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Small cross-screen helpers for the "wire the dead buttons with local
/// behaviour" pass — toasts, clipboard, native share, and link/email launches.
class AppFeedback {
  const AppFeedback._();

  static void toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> copy(
    BuildContext context,
    String text, {
    String label = 'Copied to clipboard',
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) toast(context, label);
  }

  static Future<void> share(String text, {String? subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }

  /// Open a URL / mailto / sms link externally. Returns false (and toasts) if
  /// no handler is available.
  static Future<bool> launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await canLaunchUrl(uri) &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      toast(context, 'Nothing on this device can open that link');
    }
    return ok;
  }

  static Future<void> email(
    BuildContext context, {
    required String to,
    String subject = '',
    String body = '',
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      query: _encodeQuery({'subject': subject, 'body': body}),
    );
    final ok = await canLaunchUrl(uri) && await launchUrl(uri);
    if (!ok && context.mounted) {
      await copy(context, to, label: 'Support email copied');
    }
  }

  static String _encodeQuery(Map<String, String> params) => params.entries
      .where((e) => e.value.isNotEmpty)
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
