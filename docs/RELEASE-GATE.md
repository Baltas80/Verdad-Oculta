# Verdad Oculta — release gate

Functional priority order:

1. Informant intake flow.
2. Staging backend integration.
3. Receipt and anonymous correspondence.
4. Attachment quarantine and isolated analysis.
5. Review/classification and publication of approved derivatives.
6. Public/member archive separation.
7. Admin authorization and audit trail.
8. Membership entitlement and payment integration.
9. Anonymous donations.
10. Production hardening and release packaging.

A feature is considered complete only when its positive and negative tests pass. UI polish is intentionally deferred until this gate is substantially complete.

## Current hard blockers

- Real staging endpoint has not been configured in source control (correctly: it must remain deployment configuration).
- Real submission/receipt flow is not enabled in the public client.
- Production intake remains disabled.
- Payment and donation providers are not connected.
- Admin backend is not yet a production authorization surface.

## Definition of done for the first testable release

- The app builds for Android and Web.
- A synthetic report can traverse the staging flow and return a receipt.
- The receipt can authenticate a synthetic correspondence channel.
- Synthetic attachments are quarantined and never executed.
- Only explicitly approved derivatives can enter public/member archives.
- Membership never grants access to protected originals.
- Admin actions are authenticated and audited without storing report contents in ordinary logs.
- No production secrets are committed to Git.
