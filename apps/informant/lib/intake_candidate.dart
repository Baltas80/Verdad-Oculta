import 'dart:typed_data';

import 'content_hash.dart';
import 'content_type.dart';
import 'intake_record.dart';

/// Builds a deterministic, non-sensitive intake candidate from content bytes.
///
/// This operation performs only integrity and structural identification. It
/// does not trust the result as safe, does not inspect archives, does not scan
/// for malware, and does not persist or transmit the supplied bytes.
///
/// Oversized input is rejected before hashing so the candidate builder does not
/// perform unnecessary CPU work on content that cannot pass the intake bound.
IntakeRecord buildIntakeCandidate(Uint8List bytes) {
  if (bytes.length > IntakeRecord.maxSizeBytes) {
    throw ArgumentError.value(
      bytes.length,
      'bytes',
      'Content exceeds the maximum intake size.',
    );
  }

  return IntakeRecord(
    sha256: sha256Hex(bytes),
    contentType: detectContentType(bytes),
    sizeBytes: bytes.length,
  );
}
