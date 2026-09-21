import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/membership_entitlement.dart';

void main() {
  test('public archive is available to every tier', () {
    for (final tier in MembershipTier.values) {
      expect(
        MembershipEntitlement.canAccess(tier, ArchiveClassification.public),
        isTrue,
      );
    }
  });

  test('member archive requires a paid tier', () {
    expect(
      MembershipEntitlement.canAccess(
        MembershipTier.free,
        ArchiveClassification.memberArchive,
      ),
      isFalse,
    );

    for (final tier in [
      MembershipTier.member,
      MembershipTier.investigator,
      MembershipTier.supporter,
    ]) {
      expect(
        MembershipEntitlement.canAccess(
          tier,
          ArchiveClassification.memberArchive,
        ),
        isTrue,
      );
    }
  });

  test('membership never grants protected or confidential access', () {
    for (final tier in MembershipTier.values) {
      for (final classification in [
        ArchiveClassification.restricted,
        ArchiveClassification.confidential,
        ArchiveClassification.protectedOriginal,
      ]) {
        expect(
          MembershipEntitlement.canAccess(tier, classification),
          isFalse,
        );
      }
    }
  });
}
