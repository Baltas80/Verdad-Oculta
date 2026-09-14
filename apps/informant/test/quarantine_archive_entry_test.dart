import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/quarantine_archive_entry.dart';

void main() {
  test('accepts ordinary relative archive member paths', () {
    expect(isSafeArchiveMemberPath('documents/report.pdf'), isTrue);
    expect(isSafeArchiveMemberPath('evidence/image.png'), isTrue);
  });

  test('rejects empty, absolute and drive-qualified paths', () {
    expect(isSafeArchiveMemberPath(''), isFalse);
    expect(isSafeArchiveMemberPath('/tmp/report.pdf'), isFalse);
    expect(isSafeArchiveMemberPath('\\tmp\\report.pdf'), isFalse);
    expect(isSafeArchiveMemberPath('C:\\temp\\report.pdf'), isFalse);
  });

  test('rejects traversal components using either separator', () {
    expect(isSafeArchiveMemberPath('../report.pdf'), isFalse);
    expect(isSafeArchiveMemberPath('evidence/../../report.pdf'), isFalse);
    expect(isSafeArchiveMemberPath('..\\report.pdf'), isFalse);
    expect(isSafeArchiveMemberPath('evidence\\..\\report.pdf'), isFalse);
  });

  test('rejects empty path components and NUL characters', () {
    expect(isSafeArchiveMemberPath('evidence//report.pdf'), isFalse);
    expect(isSafeArchiveMemberPath('evidence\\\\report.pdf'), isFalse);
    expect(isSafeArchiveMemberPath('evidence/report\u0000.pdf'), isFalse);
  });
}
