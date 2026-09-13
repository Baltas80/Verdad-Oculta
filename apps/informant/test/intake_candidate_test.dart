import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/content_type.dart';
import 'package:verdad_oculta/intake_candidate.dart';

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
      '1d9f5a8e1d2b7d5b0d3b7f7f9b7d1d5d5e0e6c8b7f5e5a5a6a3c7e7b0c2d1e9f',
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
}
