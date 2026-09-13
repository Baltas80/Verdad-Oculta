import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Computes a SHA-256 digest for already-buffered content.
///
/// This is an integrity primitive only. It does not imply that content is
/// trusted, safe, correctly typed, or suitable for storage or transmission.
String sha256Hex(Uint8List bytes) => sha256.convert(bytes).toString();
