import 'dart:typed_data';

/// Conservative content-signature detection for already-buffered bytes.
///
/// A result of [unknown] is intentional: callers must not infer a MIME type
/// from a filename or extension when the content signature is unavailable.
/// This is a client-side primitive only and does not establish that content is
/// safe to process.
enum DetectedContentType {
  pdf,
  png,
  jpeg,
  gif,
  webp,
  zip,
  gzip,
  unknown,
}

DetectedContentType detectContentType(Uint8List bytes) {
  if (_startsWith(bytes, const [0x25, 0x50, 0x44, 0x46, 0x2D])) {
    return DetectedContentType.pdf;
  }
  if (_startsWith(bytes, const [
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
  ])) {
    return DetectedContentType.png;
  }
  if (_startsWith(bytes, const [0xFF, 0xD8, 0xFF])) {
    return DetectedContentType.jpeg;
  }
  if (_startsWith(bytes, const [0x47, 0x49, 0x46, 0x38])) {
    return DetectedContentType.gif;
  }
  if (_startsWith(bytes, const [0x52, 0x49, 0x46, 0x46]) &&
      _containsAt(bytes, const [0x57, 0x45, 0x42, 0x50], 8)) {
    return DetectedContentType.webp;
  }
  if (_startsWith(bytes, const [0x50, 0x4B, 0x03, 0x04]) ||
      _startsWith(bytes, const [0x50, 0x4B, 0x05, 0x06]) ||
      _startsWith(bytes, const [0x50, 0x4B, 0x07, 0x08])) {
    return DetectedContentType.zip;
  }
  if (_startsWith(bytes, const [0x1F, 0x8B])) {
    return DetectedContentType.gzip;
  }
  return DetectedContentType.unknown;
}

bool _startsWith(Uint8List bytes, List<int> signature) {
  if (bytes.length < signature.length) return false;
  for (var i = 0; i < signature.length; i++) {
    if (bytes[i] != signature[i]) return false;
  }
  return true;
}

bool _containsAt(Uint8List bytes, List<int> signature, int offset) {
  if (bytes.length < offset + signature.length) return false;
  for (var i = 0; i < signature.length; i++) {
    if (bytes[offset + i] != signature[i]) return false;
  }
  return true;
}
