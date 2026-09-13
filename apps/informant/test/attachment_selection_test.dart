import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/attachment_selection.dart';

void main() {
  test('keeps attachment selection types explicit', () {
    expect(RevealAttachmentKind.values, contains(RevealAttachmentKind.document));
    expect(RevealAttachmentKind.values, contains(RevealAttachmentKind.photograph));
    expect(RevealAttachmentKind.values, contains(RevealAttachmentKind.video));
    expect(RevealAttachmentKind.values, contains(RevealAttachmentKind.audio));
    expect(RevealAttachmentKind.values, contains(RevealAttachmentKind.text));
    expect(RevealAttachmentKind.values, contains(RevealAttachmentKind.multiple));
  });

  test('selected attachment does not contain path or identity data', () {
    const attachment = SelectedAttachment(name: 'evidence.pdf', sizeBytes: 1024);

    expect(attachment.name, 'evidence.pdf');
    expect(attachment.sizeBytes, 1024);
  });
}
