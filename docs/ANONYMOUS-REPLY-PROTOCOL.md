# Anonymous reply capability protocol

**Status: DESIGN GATE — NOT APPROVED FOR PRODUCTION**

This document defines the security boundary for two-way correspondence with an informant without creating an ordinary identity account. It does not implement the channel and does not provide an absolute anonymity guarantee.

## Security objective

Allow an informant to retrieve and send case correspondence using an independent high-entropy capability, while keeping the capability, case content, investigator identity and member identity in separate security domains.

The protocol must preserve maximum anonymity and fail closed when any required security control is unavailable.

## Credential model

Each correspondence channel has two independent values:

- `case_ref`: a random, non-identifying case reference. It is not a secret and is never sufficient to authorize correspondence.
- `reply_capability`: a cryptographically random, high-entropy secret generated for the correspondence channel. The exact representation and generation API must be selected during implementation review.

The capability must not be derived from the case reference, timestamp, device identifier, submission content, member account or any predictable value.

The server must not store the plaintext capability. It stores only a verifier produced by a reviewed cryptographic password-hashing/KDF construction, with parameters and version recorded for future migration.

The capability must never appear in URLs, analytics, crash reports, ordinary logs, filenames or externally visible identifiers.

## Authorization boundary

A correspondence operation is authorized only after:

1. strict request parsing and bounded validation;
2. capability verification;
3. channel state and expiry/revocation checks;
4. replay/idempotency validation where applicable;
5. server-side authorization for the requested operation;
6. minimal security audit event generation.

`case_ref` alone, a member entitlement, a payment event, a client-supplied role, or a guessed identifier must never authorize access.

## Capability lifecycle

The capability has explicit states:

`ISSUED -> ACTIVE -> EXPIRED | REVOKED`

- Expiry is mandatory and purpose-specific.
- Revocation must immediately prevent new correspondence operations.
- Rotation creates a new capability without exposing the previous secret.
- Recovery must not silently fall back to identity-based recovery if maximum anonymity was selected.
- Loss of the capability may therefore result in permanent loss of anonymous access; this trade-off must be explicit in the UX.
- Capability material must be removed from local temporary storage when no longer required, subject to platform-specific secure-storage verification.

## Brute-force and enumeration resistance

The service must use bounded verification work, rate limiting and abuse controls without creating unnecessary identity records.

Externally visible errors must not reveal whether a case reference, channel or capability exists. Requests that fail authorization should return a generic outcome.

Rate limiting must account for distributed abuse and must not rely exclusively on an informant IP address as an identity mechanism.

No security control may log the plaintext capability or a value that permits reconstruction of it.

## Replay and message integrity

Correspondence messages require authenticated encryption and replay protection using an established, reviewed protocol selected by the cryptography decision gate.

The protocol must define:

- unique message identifiers or an equivalent sequence mechanism;
- idempotency for retried operations;
- ordering semantics where ordering matters;
- duplicate detection;
- ciphertext integrity verification;
- behavior for missing, corrupted or out-of-order messages.

No custom cryptographic primitive or custom authenticated-encryption construction is permitted.

## Confidentiality boundary

Correspondence content is sensitive disclosure material and must be encrypted before durable storage. Plaintext correspondence must not enter ordinary application logs, analytics, crash telemetry, URLs or search indexes.

Investigator access must be least-privilege and auditable. Member accounts and membership entitlements have no authority over confidential correspondence.

The correspondence channel must not become an indirect identity bridge between informant, investigator and member domains.

## Retention and deletion

Correspondence retention must have a documented purpose and bounded lifetime. Expiry or deletion must account for active storage, replicas, backups and immutable storage where applicable.

Deletion events must not expose message content or secrets in audit records.

## Fail-closed conditions

The channel must reject the operation when any required capability is unavailable or invalid, including:

- missing or unverifiable capability;
- expired or revoked channel;
- unavailable cryptographic key material;
- unsupported protocol version;
- integrity failure;
- replay detected where replay is not idempotent;
- authorization ambiguity;
- unavailable secure storage or transport controls required by the protocol.

There must be no plaintext or weaker-security fallback.

## Residual threats

This protocol does not by itself defeat:

- compromise of the informant endpoint;
- compromise of the investigator endpoint;
- network-level traffic analysis or correlation;
- theft of the reply capability;
- malicious or compromised infrastructure;
- legal or operational disclosure outside the technical system;
- metadata correlation across independent systems.

These threats require separate controls in the threat model, transport design, endpoint security baseline and operational procedures.

## Mandatory implementation tests

Before production approval, tests must demonstrate at minimum:

1. case reference alone cannot authorize access;
2. invalid capability is rejected;
3. expired capability is rejected;
4. revoked capability is rejected;
5. capability is never persisted or logged in plaintext;
6. capability generation is independent of case content and identity;
7. brute-force attempts are bounded and rate-limited;
8. authorization failures are non-enumerating;
9. replayed non-idempotent messages are rejected;
10. retried idempotent requests do not duplicate messages;
11. corrupted ciphertext is rejected;
12. correspondence is not exposed to members;
13. correspondence is not exposed through search, cache or thumbnails;
14. missing cryptographic state fails closed;
15. plaintext fallback is impossible;
16. retention and revocation behavior is deterministic and audited without sensitive content.

## Production gates

Production use remains blocked until this protocol is implemented with reviewed cryptographic primitives, secure local storage, authenticated transport, server-side encrypted storage, abuse controls, dependency/SBOM verification, platform-specific validation, threat-model review and independent security review.
