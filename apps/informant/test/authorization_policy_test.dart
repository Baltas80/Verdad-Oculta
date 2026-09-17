import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/authorization_policy.dart';

void main() {
  test('anonymous informant may create a submission', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.informantAnonymous,
          resource: Resource.submission,
          action: Action.create,
        ),
      ),
      isTrue,
    );
  });

  test('anonymous informant cannot read a submission with case reference alone', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.informantAnonymous,
          resource: Resource.submission,
          action: Action.read,
        ),
      ),
      isFalse,
    );
  });

  test('anonymous correspondence requires independent capability verification', () {
    const request = AuthorizationRequest(
      actor: Actor.informantAnonymous,
      resource: Resource.correspondence,
      action: Action.read,
    );

    expect(AuthorizationPolicy.isAllowed(request), isFalse);
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.informantAnonymous,
          resource: Resource.correspondence,
          action: Action.read,
          caseCapabilityVerified: true,
        ),
      ),
      isTrue,
    );
  });

  test('members may read public and member archive derivatives', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.member,
          resource: Resource.publicDerivative,
          action: Action.read,
          classification: Classification.public,
        ),
      ),
      isTrue,
    );
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.member,
          resource: Resource.memberDerivative,
          action: Action.read,
          classification: Classification.memberArchive,
        ),
      ),
      isTrue,
    );
  });

  test('members cannot access confidential or restricted material', () {
    for (final classification in [
      Classification.confidential,
      Classification.restricted,
    ]) {
      expect(
        AuthorizationPolicy.isAllowed(
          AuthorizationRequest(
            actor: Actor.member,
            resource: Resource.memberDerivative,
            action: Action.read,
            classification: classification,
          ),
        ),
        isFalse,
      );
    }
  });

  test('members cannot read protected originals or correspondence', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.member,
          resource: Resource.protectedOriginal,
          action: Action.read,
          classification: Classification.confidential,
        ),
      ),
      isFalse,
    );
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.member,
          resource: Resource.correspondence,
          action: Action.read,
        ),
      ),
      isFalse,
    );
  });

  test('investigators need explicit approval for protected originals', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.investigator,
          resource: Resource.protectedOriginal,
          action: Action.read,
          classification: Classification.confidential,
        ),
      ),
      isFalse,
    );
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.investigator,
          resource: Resource.protectedOriginal,
          action: Action.read,
          classification: Classification.confidential,
          explicitApproval: true,
        ),
      ),
      isTrue,
    );
  });

  test('investigators need explicit approval for confidential correspondence', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.investigator,
          resource: Resource.correspondence,
          action: Action.reply,
        ),
      ),
      isFalse,
    );
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.investigator,
          resource: Resource.correspondence,
          action: Action.reply,
          explicitApproval: true,
        ),
      ),
      isTrue,
    );
  });

  test('payment or entitlement state does not grant protected evidence', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.member,
          resource: Resource.entitlement,
          action: Action.update,
        ),
      ),
      isFalse,
    );
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.member,
          resource: Resource.protectedOriginal,
          action: Action.read,
          explicitApproval: true,
        ),
      ),
      isFalse,
    );
  });

  test('administrators still require explicit approval for protected evidence', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.admin,
          resource: Resource.protectedOriginal,
          action: Action.read,
        ),
      ),
      isFalse,
    );
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.admin,
          resource: Resource.protectedOriginal,
          action: Action.read,
          explicitApproval: true,
        ),
      ),
      isTrue,
    );
  });

  test('system workers cannot publish content or grant themselves authorization', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.systemWorker,
          resource: Resource.publicDerivative,
          action: Action.publish,
        ),
      ),
      isFalse,
    );
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.systemWorker,
          resource: Resource.protectedOriginal,
          action: Action.read,
        ),
      ),
      isTrue,
    );
  });

  test('member cannot publish or classify archive content', () {
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.member,
          resource: Resource.memberDerivative,
          action: Action.publish,
          classification: Classification.memberArchive,
        ),
      ),
      isFalse,
    );
    expect(
      AuthorizationPolicy.isAllowed(
        const AuthorizationRequest(
          actor: Actor.member,
          resource: Resource.memberDerivative,
          action: Action.classify,
          classification: Classification.memberArchive,
        ),
      ),
      isFalse,
    );
  });
}
