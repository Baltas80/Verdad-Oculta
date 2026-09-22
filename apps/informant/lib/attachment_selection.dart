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
    final List<PlatformFile> files;

    if (kind == RevealAttachmentKind.multiple) {
      files = await FilePicker.pickFiles(
        type: _fileType(kind),
        allowedExtensions: _extensions(kind),
      );
    } else {
      final file = await FilePicker.pickFile(
        type: _fileType(kind),
        allowedExtensions: _extensions(kind),
      );
      files = file == null ? const [] : [file];
    }

    final selected = <SelectedAttachment>[];
    for (final file in files) {
      final size = file.lengthSync() ?? await file.length() ?? 0;
      selected.add(
        SelectedAttachment(
          name: file.name,
          sizeBytes: size,
          path: file.path,
        ),
      );
    }
    return selected;
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
