import 'content_type.dart';

/// Immutable, non-sensitive representation of a validated intake candidate.
///
/// This record is intentionally not a transport or storage object. It cannot
/// be created without a content digest and a content type result. An
/// [DetectedContentType.unknown] value remains explicitly untrusted and must
/// be handled by the server-side policy rather than upgraded implicitly.
class IntakeRecord {
  const IntakeRecord({
    required this.sha256,
    required this.contentType,
    required this.sizeBytes,
  });

  final String sha256;
  final DetectedContentType contentType;
  final int sizeBytes;

  bool get hasKnownContentType =>
      contentType != DetectedContentType.unknown;

  bool get isStructurallyValid =>
      sizeBytes >= 0 && _isSha256Hex(sha256);

  static bool _isSha256Hex(String value) {
    if (value.length != 64) return false;
    for (final codeUnit in value.codeUnits) {
      final isDigit = codeUnit >= 0x30 && codeUnit <= 0x39;
      final isLowerHex = codeUnit >= 0x61 && codeUnit <= 0x66;
      final isUpperHex = codeUnit >= 0x41 && codeUnit <= 0x46;
      if (!isDigit && !isLowerHex && !isUpperHex) return false;
    }
    return true;
  }
}
