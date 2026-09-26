import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Plain-Dart CSV encoding — no `csv` package needed at this scale. Quotes
/// a field only when it contains a comma, quote, or newline, doubling any
/// embedded quotes, per the standard CSV escaping rule.
String buildCsv(List<List<Object?>> rows) {
  String encodeField(Object? value) {
    final s = value?.toString() ?? '';
    if (s.contains(',') || s.contains('"') || s.contains('\n')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }

  return rows.map((row) => row.map(encodeField).join(',')).join('\r\n');
}

/// Writes [rows] to a temp CSV file and opens the native share sheet with it
/// as a real file attachment (not text) — this is what makes WhatsApp/
/// email/Files all show up as proper document targets. Uses
/// `getTemporaryDirectory()` (the app's cache dir) rather than
/// `Directory.systemTemp`, since share_plus's Android implementation serves
/// shared files via its own FileProvider over the cache dir specifically.
Future<void> shareAsCsv(
  String filename,
  List<List<Object?>> rows, {
  String? subject,
}) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsString(buildCsv(rows));

  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path)], subject: subject),
  );
}
