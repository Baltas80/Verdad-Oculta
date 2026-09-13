import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/content_type.dart';
import 'package:verdad_oculta/intake_record.dart';

void main() {
  test('accepts a valid SHA-256 digest and known type', () {
    const record = IntakeRecord(
      sha256:
          '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
      contentType: DetectedContentType.pdf,
      sizeBytes: 42,
    );

    expect(record.isStructurallyValid, isTrue);
    expect(record.hasKnownContentType, isTrue);
  });

  test('rejects a malformed digest', () {
    const record = IntakeRecord(
      sha256: 'not-a-digest',
      contentType: DetectedContentType.pdf,
      sizeBytes: 42,
    );

    expect(record.isStructurallyValid, isFalse);
  });

  test('rejects a negative size', () {
    const record = IntakeRecord(
      sha256:
          '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
      contentType: DetectedContentType.png,
      sizeBytes: -1,
    );

    expect(record.isStructurallyValid, isFalse);
  });

  test('unknown type remains explicitly untrusted', () {
    const record = IntakeRecord(
      sha256:
          '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
      contentType: DetectedContentType.unknown,
      sizeBytes: 42,
    );

    expect(record.isStructurallyValid, isTrue);
    expect(record.hasKnownContentType, isFalse);
  });
}
