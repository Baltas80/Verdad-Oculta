# Anonymous reply protocol

**Status: DESIGN GATE — NOT PRODUCTION**

This protocol defines how Verdad Oculta can support an anonymous correspondence channel without turning the public case reference into an authentication secret.

## Boundary

```
PUBLIC CASE REFERENCE
        !=
SECRET REPLY CAPABILITY
        !=
MEMBER ACCOUNT
        !=
INVESTIGATION ACCOUNT
```

The case reference is a non-secret lookup/display identifier. The reply capability is an independent high-entropy secret credential. Possession of the case reference alone must never authorize correspondence.

## Capability requirements

- Generate the capability with a cryptographically secure random source from a reviewed implementation.
- Target at least 256 bits of entropy.
- Never derive the capability from the case reference, timestamp, device identifier, filename or other predictable data.
- Never place the capability in URLs, analytics events, crash reports or ordinary application logs.
- Do not expose the capability to investigator/member/public domains.
- Treat loss of the capability as loss of the anonymous channel unless a separate, identity-free recovery mechanism has been independently reviewed.
- Do not store the capability in plaintext on the server. Store only a verifier derived with a reviewed cryptographic KDF/password-hashing construction.

## Authorization flow

```
case reference
       |
       +---- display / lookup context only
       |
reply capability
       |
       +---- verifier check
       |
       +---- expiry / revocation / rate-limit checks
       |
       v
anonymous correspondence channel
```

The verifier must be checked server-side before reading or writing correspondence. Client-supplied flags such as `authorized=true`, `role`, `classification` or `entitled=true` are untrusted.

## Anti-enumeration controls

Failure responses must be intentionally generic. A caller must not be able to distinguish:

- nonexistent case;
- existing case with wrong capability;
- expired capability;
- revoked capability;
- unauthorized message action.

Rate limiting and abuse controls must operate without creating unnecessary identity records.

Repeated failed capability verification must be delayed or blocked according to server-side policy.

## Replay and message ordering

Correspondence operations must define replay protection before production:

- one-time or idempotent request identifiers for non-idempotent writes;
- monotonic message sequence or equivalent server-side ordering;
- duplicate detection;
- expiry of stale write attempts;
- atomic authorization + write semantics.

A replayed request must not create a duplicate message or bypass an authorization decision.

## Confidentiality and transport

Correspondence content is sensitive.

Production implementation must use the approved authenticated-encryption design and the hardened transport selected for the deployment. This document does not select a new cipher or invent a cryptographic protocol.

The correspondence service must not:

- place plaintext messages in URLs;
- log request bodies;
- store plaintext capability values;
- persist unnecessary client metadata;
- expose protected correspondence through search, cache, thumbnails or publication APIs.

## Separation of domains

The correspondence channel is attached to the disclosure case through opaque internal references.

It must remain separate from:

- member identity;
- membership entitlement;
- investigator account profiles;
- publication records;
- public search indexes.

An investigator may access correspondence only when the server-side authorization policy grants that action and the case policy allows it.

Membership never grants access to confidential correspondence.

## Lifecycle

Each capability requires explicit:

1. generation;
2. binding to the correspondence channel;
3. secure verifier storage;
4. activation;
5. expiry policy;
6. revocation;
7. rotation/replacement rules;
8. destruction;
9. backup/restore handling.

Deletion must account for replicas, backups and immutable storage according to the retention policy.

## Fail-closed requirements

Correspondence access must stop when any required security dependency is unavailable, including:

- missing or invalid verifier;
- unknown capability state;
- invalid case state;
- unavailable key material;
- unavailable storage authorization;
- failed integrity/authentication checks;
- malformed request;
- replay detection failure.

No plaintext or weaker-authentication fallback is permitted.

## Residual threats

This protocol does not make an endpoint or network observer harmless. Residual threats include:

- compromise of the informant device;
- theft of the reply capability;
- traffic/network metadata correlation;
- compromised server or administrator environment;
- malicious or compromised dependencies;
- backup exposure;
- denial of service.

These remain part of the full threat model.

## Mandatory staging tests

Before production:

1. valid capability authorizes only its bound channel;
2. case-reference-only access is denied;
3. wrong capability is denied;
4. expired capability is denied;
5. revoked capability is denied;
6. capability enumeration produces non-distinguishing errors;
7. brute-force attempts are rate-limited;
8. replayed writes are rejected or made safely idempotent;
9. member access to confidential correspondence is denied;
10. investigator access requires the server-side authorization state;
11. capability values do not appear in logs, URLs or telemetry;
12. backup/restore preserves revocation and expiry semantics;
13. missing crypto/key/storage state fails closed;
14. concurrent requests cannot bypass authorization or ordering.

## Production gate

Implementation remains blocked until the capability storage, cryptographic construction, server-side authorization, transport, retention and abuse controls are implemented and independently reviewed.
