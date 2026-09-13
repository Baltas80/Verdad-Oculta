import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/content_type.dart';
import 'package:verdad_oculta/intake_candidate.dart';
import 'package:verdad_oculta/intake_record.dart';

void main() {
  test('builds a deterministic PDF intake candidate', () {
    final bytes = Uint8List.fromList([
      0x25,
      0x50,
      0x44,
      0x46,
      0x2D,
    ]);

    final record = buildIntakeCandidate(bytes);

    expect(record.sizeBytes, bytes.length);
    expect(record.contentType, DetectedContentType.pdf);
    expect(record.hasKnownContentType, isTrue);
    expect(record.isStructurallyValid, isTrue);
    expect(
      record.sha256,
      '38523c087796e5d5dd1cf9bad1fb026781a838dd9dd2cf8af58b9f6502a46778',
    );
  });

  test('does not upgrade unknown content to a known type', () {
    final record = buildIntakeCandidate(Uint8List.fromList([0x01, 0x02, 0x03]));

    expect(record.contentType, DetectedContentType.unknown);
    expect(record.hasKnownContentType, isFalse);
    expect(record.isStructurallyValid, isTrue);
  });

  test('empty content remains structurally valid but type-unknown', () {
    final record = buildIntakeCandidate(Uint8List(0));

    expect(record.sizeBytes, 0);
    expect(record.contentType, DetectedContentType.unknown);
    expect(record.hasKnownContentType, isFalse);
    expect(record.isStructurallyValid, isTrue);
  });

  test('rejects content above the intake bound before hashing', () {
    final bytes = Uint8List(IntakeRecord.maxSizeBytes + 1);

    expect(
      () => buildIntakeCandidate(bytes),
      throwsArgumentError,
    );
  });
}
