/// Deterministic client-side authorization policy model.
///
/// This is a policy primitive for testing and shared-domain decisions. It is
/// not a substitute for server-side authorization and does not grant access
/// to any protected resource by itself.
enum Actor {
  informantAnonymous,
  member,
  investigator,
  admin,
  systemWorker,
}

enum Resource {
  submission,
  protectedOriginal,
  investigationCase,
  memberDerivative,
  publicDerivative,
  correspondence,
  entitlement,
  audit,
}

enum Action {
  create,
  read,
  list,
  update,
  classify,
  derive,
  publish,
  reply,
  delete,
  export,
}

enum Classification {
  confidential,
  restricted,
  memberArchive,
  public,
}

final class AuthorizationRequest {
  const AuthorizationRequest({
    required this.actor,
    required this.resource,
    required this.action,
    this.classification,
    this.explicitApproval = false,
    this.caseCapabilityVerified = false,
  });

  final Actor actor;
  final Resource resource;
  final Action action;
  final Classification? classification;
  final bool explicitApproval;
  final bool caseCapabilityVerified;
}

class AuthorizationPolicy {
  const AuthorizationPolicy._();

  /// Default-deny policy. The client may use this for deterministic UI/domain
  /// gating, but the server remains authoritative for every protected action.
  static bool isAllowed(AuthorizationRequest request) {
    // Never allow a client assertion to bypass classification boundaries.
    if (_memberAccessViolation(request)) return false;
    if (_anonymousAccessViolation(request)) return false;

    return switch (request.actor) {
      Actor.informantAnonymous => _informant(request),
      Actor.member => _member(request),
      Actor.investigator => _investigator(request),
      Actor.admin => _admin(request),
      Actor.systemWorker => _systemWorker(request),
    };
  }

  static bool _anonymousAccessViolation(AuthorizationRequest r) {
    if (r.actor != Actor.informantAnonymous) return false;
    return switch (r.resource) {
      Resource.submission => r.action != Action.create,
      Resource.correspondence =>
        r.action != Action.read && r.action != Action.reply,
      _ => true,
    };
  }

  static bool _memberAccessViolation(AuthorizationRequest r) {
    if (r.actor != Actor.member) return false;
    if (r.resource == Resource.protectedOriginal ||
        r.resource == Resource.correspondence ||
        r.resource == Resource.audit) {
      return true;
    }
    if (r.classification == Classification.confidential ||
        r.classification == Classification.restricted) {
      return true;
    }
    return false;
  }

  static bool _informant(AuthorizationRequest r) {
    if (r.resource == Resource.correspondence) {
      return r.caseCapabilityVerified &&
          (r.action == Action.read || r.action == Action.reply);
    }
    return r.resource == Resource.submission && r.action == Action.create;
  }

  static bool _member(AuthorizationRequest r) {
    return (r.resource == Resource.memberDerivative ||
            r.resource == Resource.publicDerivative) &&
        (r.action == Action.read || r.action == Action.list) &&
        (r.classification == null ||
            r.classification == Classification.memberArchive ||
            r.classification == Classification.public);
  }

  static bool _investigator(AuthorizationRequest r) {
    return switch (r.resource) {
      Resource.investigationCase =>
        r.action == Action.read ||
        r.action == Action.list ||
        r.action == Action.update ||
        r.action == Action.classify ||
        r.action == Action.derive,
      Resource.protectedOriginal =>
        r.action == Action.read && r.explicitApproval,
      Resource.correspondence =>
        (r.action == Action.read || r.action == Action.reply) &&
            r.explicitApproval,
      Resource.memberDerivative || Resource.publicDerivative =>
        r.action == Action.read || r.action == Action.list,
      _ => false,
    };
  }

  static bool _admin(AuthorizationRequest r) {
    // Administration is still constrained by explicit approval for the most
    // sensitive material; this prevents a generic "admin" flag from becoming
    // an implicit confidential-content capability.
    if (r.resource == Resource.protectedOriginal ||
        r.resource == Resource.correspondence) {
      return r.explicitApproval &&
          (r.action == Action.read ||
              r.action == Action.list ||
              r.action == Action.export ||
              r.action == Action.delete);
    }
    return switch (r.resource) {
      Resource.submission ||
      Resource.investigationCase ||
      Resource.memberDerivative ||
      Resource.publicDerivative ||
      Resource.entitlement ||
      Resource.audit =>
        r.action == Action.read ||
            r.action == Action.list ||
            r.action == Action.update ||
            r.action == Action.classify ||
            r.action == Action.derive ||
            r.action == Action.publish ||
            r.action == Action.delete ||
            r.action == Action.export,
      _ => false,
    };
  }

  static bool _systemWorker(AuthorizationRequest r) {
    return switch (r.resource) {
      Resource.submission ||
      Resource.protectedOriginal ||
      Resource.investigationCase ||
      Resource.correspondence =>
        r.action == Action.read ||
            r.action == Action.update ||
            r.action == Action.delete,
      Resource.memberDerivative || Resource.publicDerivative =>
        r.action == Action.read || r.action == Action.update,
      _ => false,
    };
  }
}
