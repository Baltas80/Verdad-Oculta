/// Reviewable, non-operational archive-entry policy contract.
///
/// This model does not open, extract or execute archives. It only represents
/// metadata that a future isolated server-side extractor must validate before
/// admitting an archive entry.
enum ArchiveEntryKind {
  regular,
  directory,
  symbolicLink,
  hardLink,
  other,
}

enum ArchiveEntryDecision {
  allow,
  reject,
}

/// Metadata-only admission rule for an archive entry.
///
/// Links and unknown entry kinds are rejected by default. A duplicate
/// normalized path is also rejected to avoid ambiguous overwrite semantics.
ArchiveEntryDecision evaluateArchiveEntry({
  required ArchiveEntryKind kind,
  required String normalizedPath,
  required bool pathAlreadySeen,
}) {
  if (normalizedPath.isEmpty || pathAlreadySeen) {
    return ArchiveEntryDecision.reject;
  }

  if (kind == ArchiveEntryKind.symbolicLink ||
      kind == ArchiveEntryKind.hardLink ||
      kind == ArchiveEntryKind.other) {
    return ArchiveEntryDecision.reject;
  }

  return ArchiveEntryDecision.allow;
}
