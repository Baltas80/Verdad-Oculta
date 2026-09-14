import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/archive_entry_policy.dart';

void main() {
  test('allows a new regular file entry', () {
    expect(
      evaluateArchiveEntry(
        kind: ArchiveEntryKind.regular,
        normalizedPath: 'evidence/report.pdf',
        pathAlreadySeen: false,
      ),
      ArchiveEntryDecision.allow,
    );
  });

  test('allows a directory entry', () {
    expect(
      evaluateArchiveEntry(
        kind: ArchiveEntryKind.directory,
        normalizedPath: 'evidence/',
        pathAlreadySeen: false,
      ),
      ArchiveEntryDecision.allow,
    );
  });

  test('rejects symbolic links', () {
    expect(
      evaluateArchiveEntry(
        kind: ArchiveEntryKind.symbolicLink,
        normalizedPath: 'evidence/link',
        pathAlreadySeen: false,
      ),
      ArchiveEntryDecision.reject,
    );
  });

  test('rejects hard links', () {
    expect(
      evaluateArchiveEntry(
        kind: ArchiveEntryKind.hardLink,
        normalizedPath: 'evidence/link',
        pathAlreadySeen: false,
      ),
      ArchiveEntryDecision.reject,
    );
  });

  test('rejects unknown entry kinds', () {
    expect(
      evaluateArchiveEntry(
        kind: ArchiveEntryKind.other,
        normalizedPath: 'evidence/item',
        pathAlreadySeen: false,
      ),
      ArchiveEntryDecision.reject,
    );
  });

  test('rejects duplicate normalized paths', () {
    expect(
      evaluateArchiveEntry(
        kind: ArchiveEntryKind.regular,
        normalizedPath: 'evidence/report.pdf',
        pathAlreadySeen: true,
      ),
      ArchiveEntryDecision.reject,
    );
  });

  test('rejects an empty normalized path', () {
    expect(
      evaluateArchiveEntry(
        kind: ArchiveEntryKind.regular,
        normalizedPath: '',
        pathAlreadySeen: false,
      ),
      ArchiveEntryDecision.reject,
    );
  });
}
