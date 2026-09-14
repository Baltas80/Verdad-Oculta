# Verdad Oculta — Server-side quarantine contract

## Status

**Design contract — NOT IMPLEMENTED. Production approval: NO.**

This document defines the minimum server-side boundary required before an untrusted disclosure object can enter analysis or durable storage. It is intentionally non-operational and contains no live endpoint, credential, storage configuration or acceptance path.

## Security boundary

The server must treat every uploaded object as hostile until the complete quarantine gate succeeds.

Required flow:

`RECEIVE → QUARANTINE → RESOURCE LIMITS → TYPE VALIDATION → HASH → ANALYSIS → CLASSIFICATION → ENCRYPTED STORAGE`

No object may bypass quarantine because its filename, claimed MIME type, client metadata or declared hash appears trustworthy.

## Quarantine requirements

1. Receive into isolated, non-executable temporary storage.
2. Assign an opaque server-side quarantine identifier that contains no informant identity.
3. Apply hard limits before expensive processing:
   - maximum object size;
   - maximum total request size;
   - maximum object count per case;
   - maximum archive nesting/decompression expansion;
   - maximum processing time and memory budget.
4. Validate the actual file signature independently from the client declaration.
5. Compute a server-side cryptographic hash after resource limits pass.
6. Perform malware/content analysis in an isolated analysis boundary.
7. Reject, retain for controlled review, or promote only according to an explicit classification policy.
8. Store accepted content only in encrypted storage with least-privilege access controls.
9. Remove quarantine material according to a documented retention policy after promotion or rejection.

## Mandatory rejection conditions

The server must fail closed on:

- size or resource-limit violations;
- malformed or truncated input;
- unsupported or ambiguous file types;
- path traversal or unsafe archive entries;
- archive expansion beyond configured limits;
- analysis timeout or resource exhaustion;
- analyzer errors where safety cannot be established;
- hash/integrity mismatch;
- storage or encryption failure;
- missing or invalid security configuration.

There must be no fallback to direct object storage, execution, plaintext persistence, or weaker inspection when a security control fails.

## Isolation requirements

Untrusted files must never be executed directly by the intake service. Any dynamic analysis, if later approved, must run in a separately isolated environment with tightly bounded CPU, memory, filesystem, network and process capabilities.

The intake API must not expose internal filesystem paths, analyzer output containing sensitive content, stack traces, credentials or infrastructure identifiers to the client.

## Metadata minimization

Quarantine identifiers, object keys, logs and metrics must avoid informant identity and raw sensitive content. Filenames and embedded metadata are untrusted and potentially identifying. Operational telemetry must use opaque identifiers and aggregate security outcomes wherever possible.

## Evidence and auditability

Security-relevant events should record the minimum information needed to investigate the processing decision, without storing raw disclosure content in ordinary logs. Access to quarantined or accepted evidence must be authenticated, authorized and auditable.

## Production gate

Before implementation is approved, the project must produce evidence for:

- concrete resource limits and denial behavior;
- isolated quarantine storage configuration;
- actual file-type validation;
- analyzer isolation and failure semantics;
- encrypted storage and access-control tests;
- retention/deletion verification;
- abuse/rate-limit controls that do not unnecessarily identify informants;
- negative tests for oversized, malformed, nested and adversarial archives;
- operational monitoring that does not leak sensitive content;
- independent security review.

Until that evidence exists, this contract is documentation only and the production disclosure path remains closed.
