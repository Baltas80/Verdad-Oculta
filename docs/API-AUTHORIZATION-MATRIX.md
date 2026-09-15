# Verdad Oculta — API Authorization Matrix and Contract

## Status

Architecture gate only. This document defines the authorization contract; it does not authorize a production API or real sensitive submissions.

## 1. Security model

The API follows **default deny**. A request is allowed only when the server can establish the required actor, capability, resource state, classification and action.

Authorization is evaluated server-side, after request validation and authentication/capability validation, and before protected-resource access. Client-supplied role, classification, entitlement or ownership claims are untrusted input.

Logical actors are separate:

- `INFORMANT_ANONYMOUS` — maximum-anonymity submission/reply capability only.
- `MEMBER` — authenticated account with approved archive entitlement.
- `INVESTIGATOR` — separately authenticated investigation identity with least-privilege case access.
- `ADMIN` — privileged administrative identity with separately controlled sensitive operations.
- `SYSTEM_WORKER` — narrowly scoped non-human service identity for declared processing tasks.

## 2. Protected resources

- `SUBMISSION` — intake metadata and processing state.
- `PROTECTED_ORIGINAL` — original evidence in protected/quarantine/encrypted storage.
- `INVESTIGATION_CASE` — investigation metadata and controlled references to evidence.
- `MEMBER_DERIVATIVE` — explicitly approved material for the member archive.
- `PUBLIC_DERIVATIVE` — explicitly approved public material.
- `CORRESPONDENCE` — anonymous source/investigator communication.
- `ENTITLEMENT` — membership/support access state.
- `AUDIT` — security/administrative audit events.

## 3. Actions

`CREATE`, `READ`, `LIST`, `UPDATE`, `CLASSIFY`, `DERIVE`, `PUBLISH`, `REPLY`, `DELETE`, `EXPORT`.

No action not explicitly allowed by policy is permitted.

## 4. Authorization matrix

| Actor | Resource | CREATE | READ | LIST | UPDATE | CLASSIFY | DERIVE | PUBLISH | REPLY | DELETE | EXPORT |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| INFORMANT_ANONYMOUS | SUBMISSION | ALLOW | ALLOW own capability-scoped state only | DENY | DENY | DENY | DENY | DENY | ALLOW own reply capability only | DENY | DENY |
| INFORMANT_ANONYMOUS | PROTECTED_ORIGINAL | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INFORMANT_ANONYMOUS | INVESTIGATION_CASE | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INFORMANT_ANONYMOUS | MEMBER_DERIVATIVE | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INFORMANT_ANONYMOUS | PUBLIC_DERIVATIVE | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INFORMANT_ANONYMOUS | CORRESPONDENCE | DENY | ALLOW own capability-scoped channel only | DENY | DENY | DENY | DENY | DENY | ALLOW | DENY | DENY |
| INFORMANT_ANONYMOUS | ENTITLEMENT | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INFORMANT_ANONYMOUS | AUDIT | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| MEMBER | SUBMISSION | DENY | DENY unless explicitly approved non-confidential derivative/state | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| MEMBER | PROTECTED_ORIGINAL | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| MEMBER | INVESTIGATION_CASE | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| MEMBER | MEMBER_DERIVATIVE | DENY | ALLOW entitled material | ALLOW entitled material | DENY | DENY | DENY | DENY | DENY | DENY | ALLOW entitled material when explicitly enabled |
| MEMBER | PUBLIC_DERIVATIVE | DENY | ALLOW | ALLOW | DENY | DENY | DENY | DENY | DENY | DENY | ALLOW |
| MEMBER | CORRESPONDENCE | DENY | DENY source-confidential channel | DENY | DENY | DENY | DENY | DENY | DENY only where a separate non-confidential member channel exists | DENY | DENY |
| MEMBER | ENTITLEMENT | DENY | ALLOW own entitlement state | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| MEMBER | AUDIT | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INVESTIGATOR | SUBMISSION | DENY | ALLOW assigned/authorized case metadata | ALLOW assigned scope | ALLOW assigned scope | ALLOW within role | ALLOW via controlled derivative workflow | DENY direct publication | ALLOW assigned correspondence | DENY | DENY unless explicitly authorized |
| INVESTIGATOR | PROTECTED_ORIGINAL | DENY | ALLOW assigned/authorized evidence | DENY | DENY | ALLOW assigned scope | ALLOW through controlled workflow | DENY | DENY | DENY | DENY unless explicitly authorized |
| INVESTIGATOR | INVESTIGATION_CASE | DENY | ALLOW assigned scope | ALLOW assigned scope | ALLOW assigned scope | ALLOW | ALLOW | DENY | ALLOW | DENY | DENY unless explicitly authorized |
| INVESTIGATOR | MEMBER_DERIVATIVE | DENY | ALLOW when required for assigned investigation | ALLOW assigned scope | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INVESTIGATOR | PUBLIC_DERIVATIVE | DENY | ALLOW | ALLOW | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INVESTIGATOR | CORRESPONDENCE | DENY | ALLOW assigned anonymous channels | ALLOW assigned scope | ALLOW assigned scope | DENY | DENY | DENY | ALLOW | DENY | DENY |
| INVESTIGATOR | ENTITLEMENT | DENY | DENY member billing/access details unless explicitly required | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| INVESTIGATOR | AUDIT | DENY | ALLOW security events needed for assigned work | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| ADMIN | SUBMISSION | DENY | ALLOW only operationally required scope | ALLOW controlled scope | ALLOW controlled scope | ALLOW | ALLOW controlled workflow | DENY direct publication | ALLOW controlled scope | ALLOW under retention policy | ALLOW only when explicitly authorized |
| ADMIN | PROTECTED_ORIGINAL | DENY | ALLOW only explicitly authorized scope | DENY | DENY | ALLOW | ALLOW controlled workflow | DENY direct publication | DENY unless separately authorized | ALLOW under retention policy | ALLOW only with explicit authorization |
| ADMIN | INVESTIGATION_CASE | DENY | ALLOW controlled scope | ALLOW controlled scope | ALLOW controlled scope | ALLOW | ALLOW | DENY direct publication | ALLOW | ALLOW under policy | ALLOW only when explicitly authorized |
| ADMIN | MEMBER_DERIVATIVE | DENY | ALLOW | ALLOW | ALLOW controlled scope | DENY | ALLOW | ALLOW only after publication gate | DENY | ALLOW under policy | ALLOW controlled scope |
| ADMIN | PUBLIC_DERIVATIVE | DENY | ALLOW | ALLOW | ALLOW controlled scope | DENY | ALLOW | ALLOW after explicit publication approval | DENY | ALLOW under policy | ALLOW |
| ADMIN | CORRESPONDENCE | DENY | ALLOW only when operationally/security required | DENY | ALLOW controlled scope | DENY | DENY | DENY | ALLOW controlled scope | ALLOW under policy | DENY unless explicitly authorized |
| ADMIN | ENTITLEMENT | DENY | ALLOW operational scope | ALLOW | ALLOW | DENY | DENY | DENY | DENY | DENY | DENY |
| ADMIN | AUDIT | DENY | ALLOW | ALLOW | ALLOW controlled scope | DENY | DENY | DENY | DENY | DENY | ALLOW only for authorized security/audit purposes |
| SYSTEM_WORKER | SUBMISSION | ALLOW only declared processing step | ALLOW minimum required fields | DENY | UPDATE processing state only | DENY unless explicitly assigned | DENY | DENY | DENY | DENY | DENY |
| SYSTEM_WORKER | PROTECTED_ORIGINAL | DENY | ALLOW only for declared isolated processing | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| SYSTEM_WORKER | INVESTIGATION_CASE | DENY | DENY unless explicitly assigned | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| SYSTEM_WORKER | MEMBER_DERIVATIVE | DENY | DENY unless explicitly assigned | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| SYSTEM_WORKER | PUBLIC_DERIVATIVE | DENY | DENY unless explicitly assigned | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| SYSTEM_WORKER | CORRESPONDENCE | DENY | DENY unless explicitly assigned | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| SYSTEM_WORKER | ENTITLEMENT | DENY | DENY unless explicitly assigned | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |
| SYSTEM_WORKER | AUDIT | CREATE security events only | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY | DENY |

> The matrix is intentionally conservative. Any implementation-specific permission must narrow, not broaden, these boundaries without an explicit architecture/security review.

## 5. Classification boundary

The authorization model is independent of membership tier.

| Classification | Public | Member | Investigator | Admin |
|---|---:|---:|---:|---:|
| `PUBLIC` | ALLOW | ALLOW | ALLOW | ALLOW |
| `MEMBER_ARCHIVE` | DENY | ALLOW if entitled | ALLOW if required | ALLOW |
| `RESTRICTED` | DENY | DENY | ALLOW if authorized | ALLOW |
| `CONFIDENTIAL` | DENY | DENY | ALLOW only explicitly authorized | ALLOW only explicitly authorized |
| `PROTECTED_ORIGINAL` | DENY | DENY | ALLOW only explicitly authorized | ALLOW only explicitly authorized |

A higher membership tier never overrides `CONFIDENTIAL`, `PROTECTED_ORIGINAL` or investigator authorization. Search indexes, caches, thumbnails and exports inherit the highest classification of their source unless an explicitly approved derivative is created.

## 6. Payment and entitlement

A payment provider may emit a verified event that changes an account's entitlement state. The payment event must not directly grant access to a protected object.

Required separation:

`PAYMENT EVENT -> VERIFIED ENTITLEMENT STATE -> AUTHORIZATION POLICY -> APPROVED MEMBER_DERIVATIVE`

Never:

`PAYMENT EVENT -> PROTECTED_ORIGINAL`

Client-provided `tier`, `isMember`, `isInvestigator`, `classification` or similar fields are ignored for authorization.

## 7. Anonymous correspondence

The anonymous channel uses:

`RANDOM CASE REF + INDEPENDENT HIGH-ENTROPY REPLY CAPABILITY`

The case reference alone is insufficient authentication. The reply capability is separate from membership identity and must be handled as a secret/capability, not ordinary case metadata.

A lost anonymous capability must not trigger identity-based recovery by default. Replay, brute-force, expiry/revocation, rate limiting and message confidentiality require separate implementation and security review.

## 8. API contract rules

### Versioning

All future HTTP API endpoints use a versioned namespace such as `/v1/`. The exact framework and deployment topology are intentionally unspecified at this architecture stage.

### Resource identifiers

- Use opaque, non-sequential identifiers.
- Never expose database primary keys as external correlation handles.
- Keep case references, member identifiers and correspondence capabilities in separate namespaces.
- Do not put sensitive information in URL paths or query parameters.

### Request validation

Every endpoint must apply strict schema validation, bounded sizes, canonical parsing and content-type validation independent of filename claims. Ambiguous or malformed security-relevant input fails closed.

### Replay and idempotency

Submission creation and other non-idempotent operations require an explicit replay/idempotency strategy. Retries must not create duplicate cases, duplicate messages or duplicate authorization effects.

Idempotency keys must not contain identity, secrets or sensitive content. Capability-bearing requests must additionally define replay detection, expiry and revocation behavior before production.

### Error behavior

External errors must be generic and must not disclose stack traces, filesystem paths, database structure, scanner internals, key material, authorization reasons that enable enumeration, or sensitive resource existence when disclosure would aid an attacker.

Internal security events may retain the minimum information required for defense and investigation, without content, source identity, reply secrets, private keys or authorization headers.

### Authorization order

The intended order is:

`PARSE -> VALIDATE -> AUTHENTICATE/CAPABILITY CHECK -> AUTHORIZE -> ACCESS -> AUDIT MINIMAL SECURITY EVENT`

Authorization must occur before protected-resource access. A failed authorization must not reveal protected metadata through alternate response paths, timing-sensitive enumeration where avoidable, caches, search indexes or error messages.

## 9. Mandatory negative tests

The eventual policy implementation must reject at least these cases:

1. `MEMBER -> READ(CONFIDENTIAL)` = **DENY**.
2. `MEMBER -> READ(PROTECTED_ORIGINAL)` = **DENY**.
3. `MEMBER -> EXPORT(CONFIDENTIAL)` = **DENY**.
4. Higher payment tier -> confidential access = **DENY**.
5. `INFORMANT_ANONYMOUS` with another case reference -> read/reply = **DENY**.
6. Case reference without independent reply capability -> correspondence access = **DENY**.
7. Client submits `role=ADMIN` -> effective role remains server-derived = **DENY escalation**.
8. Client submits `classification=PUBLIC` for confidential evidence -> server classification remains authoritative = **DENY downgrade**.
9. Client submits `entitlement=INVESTIGATOR` -> entitlement remains server-derived = **DENY escalation**.
10. Payment webhook directly requests protected evidence -> **DENY**; only entitlement state may change after event verification.
11. Investigator requests unrelated member identity -> **DENY** unless a separately approved operational need exists.
12. Search/index/cache attempts to expose a higher-classification source through a lower-classification view -> **DENY**.
13. Missing/expired/revoked correspondence capability -> **DENY**.
14. Malformed/ambiguous authorization state -> **DENY**.
15. Missing cryptographic/key/storage state -> **DENY**; never plaintext or weaker fallback.
16. Replayed non-idempotent submission/message -> **DENY duplicate effect**.
17. Protected original passed directly to publication storage -> **DENY**.
18. Publication without approved sanitized derivative and explicit publication authorization -> **DENY**.

## 10. Positive authorization tests

The eventual policy implementation must also prove the minimum required positive paths:

1. Anonymous informant can create a submission through the protected intake boundary without a member account.
2. Anonymous informant can read only its own capability-scoped submission state.
3. Anonymous informant can use only its own valid reply capability.
4. An entitled member can read approved `MEMBER_ARCHIVE` derivatives and public derivatives.
5. An investigator can access only assigned/authorized investigation scope.
6. A controlled worker can perform only its declared processing operation.
7. An administrator can perform only explicitly authorized privileged operations.
8. A verified payment event can update entitlement state without exposing protected evidence.

## 11. Production gate

This contract remains design-only until:

- endpoint inventory maps every endpoint to this matrix;
- authentication/capability mechanisms are independently reviewed;
- policy decisions are covered by automated positive and negative tests;
- object-level authorization is tested against cross-case access;
- replay/idempotency controls are implemented and tested;
- error behavior and enumeration resistance are tested;
- logs are reviewed for minimization;
- upload quarantine and protected storage boundaries are verified;
- cryptographic and key-lifecycle decisions are approved;
- dependency/SBOM review is complete;
- supported-platform secure local handling is verified;
- penetration/security review is complete.

Until these gates pass, no real sensitive disclosure, confidential member archive or production anonymous correspondence is enabled.
