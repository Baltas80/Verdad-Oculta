import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/member_archive.dart';
import 'package:verdad_oculta/membership_entitlement.dart';

void main() {
  test('free users only see public archive content', () {
    final items = MemberArchive.visibleFor(MembershipTier.free);
    expect(items.length, 1);
    expect(items.single.classification, ArchiveClassification.public);
  });

  test('member tier sees selected member content', () {
    final items = MemberArchive.visibleFor(MembershipTier.member);
    expect(items.length, 2);
    expect(
      items.any((item) => item.classification == ArchiveClassification.memberArchive),
      isTrue,
    );
  });
}
