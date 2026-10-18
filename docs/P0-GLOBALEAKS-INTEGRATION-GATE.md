# P0 — GlobaLeaks integration and production submission gate

**Decision:** prepare the GlobaLeaks-backed architecture.  
**Production status:** BLOCKED. Real submissions must remain disabled.

## Scope of this change

This branch adds a compile-time default-off submission gate and negative unit tests. It does not implement or claim a working submission API. The current GlobaLeaks client is a read-only health check; a healthy response is not evidence that submissions, receipts, attachments, correspondence, encryption, anonymity, or authorization are correctly configured.

The local demo may continue to create in-memory `DEMO-...` references. Those references are not GlobaLeaks receipts, server-side case identifiers, or proof that a disclosure was transmitted.

## Selected architecture

- Flutter remains the user-facing multiplatform client.
- Self-hosted GlobaLeaks is the selected candidate for authoritative protected intake and whistleblower correspondence.
- Verdad Oculta must own only a narrow, versioned adapter; it must not reimplement GlobaLeaks authorization, receipt handling, or security-sensitive internals.
- Public/member publication and membership entitlements remain separate from protected originals. Payment or membership status must never grant access to protected source material.
- No custom cryptographic protocol is introduced by this integration work.

## Gate behavior

`ProductionSubmissionGate.isEnabled` is a source-controlled constant set to `false`. Calling `requireEnabled()` throws `ProductionSubmissionBlocked`. No build-time environment variable, staging URL, or health-check result can enable it.

This gate is a defensive guard for future integration code, not proof that every conceivable network path is blocked. Before release, review the entire repository for all outbound submission paths and prove that each one is gated. Do not change the constant to `true` as a deployment shortcut.

## Required integration contract verification

Before implementing any submission operation, pin and verify the exact GlobaLeaks server release and its official API contract. Confirm all request/response schemas and security semantics against that deployed version; do not rely on remembered endpoint names or this document alone.

The implementation must specify and test:

1. Server version, provenance, dependency/SBOM and security-advisory review.
2. Anonymous submission flow, context/receiver mapping and validation.
3. Receipt issuance, entropy, secret handling, loss/recovery semantics and storage.
4. Attachment upload/download, size/type limits, server-side quarantine and malware handling.
5. Correspondence authentication, authorization and non-enumerating errors.
6. Transport, deployment isolation, Tor requirements and metadata/log minimization.
7. Retention, deletion, backup/restore, investigator roles and audit boundaries.
8. Separation between protected originals and reviewed publication derivatives.
9. Abuse prevention, rate limiting and denial-of-service limits.
10. Cross-platform client behavior and dependency compatibility.

## Mandatory release gates

Real submissions stay disabled until all applicable items have evidence:

- Threat model updated for the combined Flutter + GlobaLeaks deployment and reviewed.
- Exact server/API compatibility verified against a controlled staging instance.
- Synthetic-only end-to-end tests pass, including malformed input and oversized attachments.
- Negative tests prove no submission occurs when configuration is absent, the backend is unhealthy, authorization fails, or any required control is unavailable.
- No secrets or sensitive content appear in URLs, logs, analytics or crash telemetry.
- Secure storage, metadata minimization, retention/deletion and backup/restore are validated.
- All supported platform builds and automated checks pass.
- Independent security review signs off on the complete deployment and protocol boundary.
- Release owner explicitly authorizes opening the gate in a separate change.

## Evidence currently available

- `GlobaleaksHealthClient` validates HTTPS and performs only a read-only health request.
- `ProductionSubmissionGate` defaults closed and has negative unit tests.
- Existing project security and release-gate documents already classify the product as a prototype and require production submissions to remain disabled.

## Evidence not yet available

- No verified live GlobaLeaks staging deployment or exact deployed API contract was inspected in this task.
- No real submission, receipt, attachment or correspondence adapter is implemented.
- No end-to-end tests against GlobaLeaks were run.
- No local Flutter test/analyze command was available through the GitHub-only editing path; the added tests must run in CI.
- No independent security review or production approval exists.

**Conclusion:** this is a preparation step, not production readiness. Keep the production gate closed.
