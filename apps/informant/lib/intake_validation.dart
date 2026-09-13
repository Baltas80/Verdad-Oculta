import 'attachment_selection.dart';

/// Conservative client-side intake checks.
///
/// This is a pre-flight gate only. It does not identify a file's real MIME
/// type, inspect archives, scan for malware, or make a file safe to process.
/// Those operations belong to the isolated server-side intake pipeline.
class IntakeValidation {
  static const int maxSingleFileBytes = 50 * 1024 * 1024;

  const IntakeValidation._();

  static String? validate(SelectedAttachment attachment) {
    if (attachment.sizeBytes < 0) {
      return 'Invalid file size';
    }
    if (attachment.sizeBytes > maxSingleFileBytes) {
      return 'File exceeds the 50 MiB client-side limit';
    }
    if (!_isSafeName(attachment.name)) {
      return 'File name is not safe';
    }
    return null;
  }

  static bool _isSafeName(String name) {
    if (name.isEmpty || name.length > 255) return false;
    if (name.contains('/') || name.contains('\\')) return false;
    if (name.contains('\u0000')) return false;
    for (final codeUnit in name.codeUnits) {
      if (codeUnit < 0x20 || codeUnit == 0x7f) return false;
    }
    return name != '.' && name != '..';
  }
}
