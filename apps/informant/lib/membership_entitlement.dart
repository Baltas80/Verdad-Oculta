enum MembershipTier {
  free,
  member,
  investigator,
  supporter,
}

enum ArchiveClassification {
  public,
  memberArchive,
  restricted,
  confidential,
  protectedOriginal,
}

class MembershipEntitlement {
  const MembershipEntitlement._();

  static bool canAccess(
    MembershipTier tier,
    ArchiveClassification classification,
  ) {
    if (classification == ArchiveClassification.protectedOriginal ||
        classification == ArchiveClassification.confidential ||
        classification == ArchiveClassification.restricted) {
      return false;
    }

    if (classification == ArchiveClassification.public) {
      return true;
    }

    return tier != MembershipTier.free &&
        classification == ArchiveClassification.memberArchive;
  }
}
