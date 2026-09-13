import 'package:file_picker/file_picker.dart';

enum RevealAttachmentKind {
  document,
  photograph,
  video,
  audio,
  text,
  multiple,
}

class SelectedAttachment {
  const SelectedAttachment({
    required this.name,
    required this.sizeBytes,
  });

  final String name;
  final int sizeBytes;
}

/// Local attachment selection only.
///
/// This layer deliberately does not upload, decrypt, encrypt, or persist
/// sensitive content. It only obtains the user's explicit file selection so
/// that the secure intake pipeline can process it later.
class AttachmentSelection {
  const AttachmentSelection._();

  static Future<List<SelectedAttachment>> pick(
    RevealAttachmentKind kind,
  ) async {
    final files = await FilePicker.pickFiles(
      allowMultiple: kind == RevealAttachmentKind.multiple,
      type: _fileType(kind),
      allowedExtensions: _extensions(kind),
    );

    return files
        .map(
          (file) => SelectedAttachment(
            name: file.name,
            sizeBytes: file.size,
          ),
        )
        .toList(growable: false);
  }

  static FileType _fileType(RevealAttachmentKind kind) => switch (kind) {
        RevealAttachmentKind.photograph => FileType.image,
        RevealAttachmentKind.video => FileType.video,
        RevealAttachmentKind.audio => FileType.audio,
        RevealAttachmentKind.document => FileType.custom,
        RevealAttachmentKind.text => FileType.custom,
        RevealAttachmentKind.multiple => FileType.any,
      };

  static List<String>? _extensions(RevealAttachmentKind kind) => switch (kind) {
        RevealAttachmentKind.document => const [
            'pdf',
            'doc',
            'docx',
            'odt',
            'rtf',
          ],
        RevealAttachmentKind.text => const [
            'txt',
            'md',
            'csv',
            'json',
          ],
        _ => null,
      };
}
