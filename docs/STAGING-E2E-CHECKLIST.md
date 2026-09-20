# Verdad Oculta — staging end-to-end gate

Status: READY FOR STAGING IMPLEMENTATION

This checklist is the gate before any public intake is enabled.

## Environment

- Dedicated staging GlobaLeaks instance.
- Synthetic data only.
- No production keys, wallets, member records or real submissions.
- HTTPS only.
- If the deployment is onion-only, enforce the expected Tor boundary before testing.

## Flow

1. Health check succeeds.
2. Anonymous submission context is retrieved.
3. Synthetic report is prepared locally.
4. Synthetic attachment is selected and validated.
5. Submission is sent through the narrow GlobaLeaks adapter.
6. Anonymous receipt is returned and displayed once.
7. Receipt is not logged, persisted in analytics, or placed in URLs.
8. Receipt authentication opens the anonymous channel.
9. Synthetic correspondence can be retrieved.
10. Synthetic reply can be sent.
11. Synthetic attachment can be retrieved only through authorized access.
12. Protected original remains outside public/member archive.
13. Publication pipeline can consume only an explicitly approved derivative.
14. Member entitlement cannot authorize protected originals.
15. Audit/security telemetry contains event metadata only, never report contents or credentials.

## Negative tests

- Invalid receipt is rejected without account enumeration.
- Missing authorization is rejected.
- Expired/revoked capability is rejected.
- Oversized attachment is rejected.
- Unsupported file type is rejected.
- Malformed submission is rejected.
- Duplicate submission behavior is deterministic.
- Direct access to protected storage is denied.
- Public/member URLs cannot resolve protected originals.
- Payment/membership state cannot be used as a protected-storage credential.
- Backend errors do not expose internal paths, tokens or secrets.

## Release gate

The staging flow must pass all positive and negative tests before production intake is enabled. A passing Flutter CI build alone is not sufficient evidence of backend security.
