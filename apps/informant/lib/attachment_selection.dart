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
    this.path,
  });

  final String name;
  final int sizeBytes;
  final String? path;
}

/// Local attachment selection only.
///
/// This layer deliberately does not upload, decrypt, encrypt, or persist
/// sensitive content. It obtains the user's explicit selection so that a
/// later secure intake pipeline can validate and protect it.
class AttachmentSelection {
  const AttachmentSelection._();

  static Future<List<SelectedAttachment>> pick(
    RevealAttachmentKind kind,
  ) async {
    final result = await FilePicker.pickFiles(
      allowMultiple: kind == RevealAttachmentKind.multiple,
      type: _fileType(kind),
      allowedExtensions: _extensions(kind),
      withData: false,
    );

    if (result == null) return const [];

    return result.files
        .map(
          (file) => SelectedAttachment(
            name: file.name,
            sizeBytes: file.size,
            path: file.path,
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
