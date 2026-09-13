import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/attachment_selection.dart';
import 'package:verdad_oculta/intake_validation.dart';

void main() {
  test('accepts a normal attachment within the limit', () {
    const attachment = SelectedAttachment(
      name: 'evidence.pdf',
      sizeBytes: 1024,
    );

    expect(IntakeValidation.validate(attachment), isNull);
  });

  test('rejects oversized attachments', () {
    const attachment = SelectedAttachment(
      name: 'evidence.pdf',
      sizeBytes: IntakeValidation.maxSingleFileBytes + 1,
    );

    expect(IntakeValidation.validate(attachment), isNotNull);
  });

  test('rejects path traversal names', () {
    const attachment = SelectedAttachment(
      name: '../evidence.pdf',
      sizeBytes: 1024,
    );

    expect(IntakeValidation.validate(attachment), isNotNull);
  });

  test('rejects control characters and null bytes in names', () {
    const control = SelectedAttachment(name: 'evidence\n.pdf', sizeBytes: 1);
    const nul = SelectedAttachment(name: 'evidence\u0000.pdf', sizeBytes: 1);

    expect(IntakeValidation.validate(control), isNotNull);
    expect(IntakeValidation.validate(nul), isNotNull);
  });

  test('does not claim to perform real type or malware detection', () {
    const attachment = SelectedAttachment(name: 'evidence.bin', sizeBytes: 1);

    // A safe filename is not proof that the content is safe. The validator
    // intentionally has no API for MIME sniffing or malware verdicts.
    expect(IntakeValidation.validate(attachment), isNull);
  });
}
