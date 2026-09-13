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

  test('accepts an attachment exactly at the client-side size limit', () {
    const attachment = SelectedAttachment(
      name: 'evidence.pdf',
      sizeBytes: IntakeValidation.maxSingleFileBytes,
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

  test('rejects negative file sizes', () {
    const attachment = SelectedAttachment(
      name: 'evidence.pdf',
      sizeBytes: -1,
    );

    expect(IntakeValidation.validate(attachment), isNotNull);
  });

  test('rejects empty, dot, and dot-dot names', () {
    for (final name in ['', '.', '..']) {
      final attachment = SelectedAttachment(name: name, sizeBytes: 1);
      expect(IntakeValidation.validate(attachment), isNotNull);
    }
  });

  test('accepts a name at the 255 character boundary', () {
    final attachment = SelectedAttachment(
      name: '${'a' * 251}.pdf',
      sizeBytes: 1,
    );

    expect(attachment.name.length, 255);
    expect(IntakeValidation.validate(attachment), isNull);
  });

  test('rejects names longer than 255 characters', () {
    final attachment = SelectedAttachment(
      name: '${'a' * 252}.pdf',
      sizeBytes: 1,
    );

    expect(attachment.name.length, 256);
    expect(IntakeValidation.validate(attachment), isNotNull);
  });

  test('rejects path traversal separators', () {
    for (final name in [
      '../evidence.pdf',
      r'..\evidence.pdf',
      'folder/evidence.pdf',
      r'folder\evidence.pdf',
    ]) {
      final attachment = SelectedAttachment(name: name, sizeBytes: 1);
      expect(IntakeValidation.validate(attachment), isNotNull);
    }
  });

  test('rejects control characters and null bytes in names', () {
    for (final name in [
      'evidence\n.pdf',
      'evidence\r.pdf',
      'evidence\t.pdf',
      'evidence\u0000.pdf',
      'evidence\u007f.pdf',
    ]) {
      final attachment = SelectedAttachment(name: name, sizeBytes: 1);
      expect(IntakeValidation.validate(attachment), isNotNull);
    }
  });

  test('does not claim to perform real type or malware detection', () {
    const attachment = SelectedAttachment(name: 'evidence.bin', sizeBytes: 1);

    // A safe filename is not proof that the content is safe. The validator
    // intentionally has no API for MIME sniffing or malware verdicts.
    expect(IntakeValidation.validate(attachment), isNull);
  });
}
