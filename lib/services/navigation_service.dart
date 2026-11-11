import 'package:flutter/material.dart';

/// Lets a plain service (no BuildContext of its own — e.g. [InactivityService]
/// forcing a sign-out) push a route. Wired into `MaterialApp(navigatorKey: ...)`
/// in main.dart.
final navigatorKey = GlobalKey<NavigatorState>();
