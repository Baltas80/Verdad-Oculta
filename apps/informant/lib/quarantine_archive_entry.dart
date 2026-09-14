/// Conservative archive-member path validator for quarantine contracts.
///
/// This helper does not extract or access files. It only rejects path forms
/// that must never be accepted as archive destinations. The server must
/// independently enforce the same policy during actual extraction.
bool isSafeArchiveMemberPath(String path) {
  if (path.isEmpty || path.contains('\u0000')) {
    return false;
  }

  if (path.startsWith('/') || path.startsWith('\\')) {
    return false;
  }

  if (RegExp(r'^[A-Za-z]:').hasMatch(path)) {
    return false;
  }

  final segments = path.split(RegExp(r'[/\\]'));
  if (segments.any((segment) => segment == '..' || segment.isEmpty)) {
    return false;
  }

  return true;
}
