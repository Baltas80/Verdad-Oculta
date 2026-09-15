# Verdad Oculta — API Security Boundary

## Status

Architecture gate only. No production API is authorized by this document.

## Principle

The backend API must expose the smallest possible interface between the informant client, protected case storage, investigation tooling and publication/archive services.

The client is untrusted. Authorization, validation, classification and storage decisions are server-side.

## Service separation

Preferred logical boundaries:

`EDGE/GATEWAY -> INTAKE -> QUARANTINE -> CASE SERVICE -> PROTECTED STORAGE`

Separate privileged services should handle investigation, publication derivatives, membership entitlement and administration. A payment event must never directly authorize access to protected evidence.

## Informant API

The anonymous intake surface should expose only operations necessary for:

1. obtaining authenticated service configuration/public keys;
2. preparing a protected submission;
3. transmitting protected content;
4. receiving a non-identifying case reference;
5. checking anonymous communication state using the separate reply capability.

It must not expose investigator data, membership data, internal storage paths, scanner internals, database identifiers or operational secrets.

## Request validation

Every endpoint must apply:

- strict schema validation;
- bounded request and body sizes;
- content-type validation independent from filename claims;
- canonical parsing before security decisions;
- replay protection where applicable;
- authentication/authorization before protected-resource access;
- fail-closed behavior on malformed or ambiguous state.

Validation errors must not disclose internal paths, stack traces, database structure, scanner details or key identifiers that aid correlation.

## Identifiers

Externally visible identifiers must be opaque and non-sequential. Internal database IDs must never be exposed when they could become correlation handles.

Case references, message capabilities and member identifiers are separate namespaces.

## Logging

Protected endpoints must not log:

- plaintext submission content;
- message content;
- reply secrets;
- private keys;
- authorization headers or tokens;
- sensitive URLs/query parameters;
- unnecessary device identifiers;
- filenames or filesystem paths when avoidable.

Security events should be minimized and structured around the event required for operational defense. Retention must be explicit and reviewed.

## Rate limiting

Abuse controls must be designed so that rate limiting does not require persistent identity tracking in the anonymous path.

The production design must explicitly evaluate IP-based limits and their retention/correlation consequences. Do not introduce long-lived identifying profiles merely to make throttling convenient.

## Protected storage boundary

The API must never write untrusted uploads directly into a publication store. The authoritative path is:

`RECEIVE -> QUARANTINE -> RESOURCE LIMITS -> HASH -> REAL TYPE IDENTIFICATION -> ARCHIVE SAFETY -> ISOLATED ANALYSIS -> CLASSIFICATION -> ENCRYPTED STORAGE`

Protected originals and approved derivatives remain separate authorization domains.

## Error and availability behavior

If the service cannot establish the required cryptographic, authorization or storage state, it must reject the operation rather than downgrade to plaintext, weaker authentication or an alternate storage path.

## Production gate

Before a production API exists:

- complete data-flow diagram reviewed;
- endpoint inventory and authorization matrix completed;
- request/response schemas versioned;
- authentication and capability design independently reviewed;
- logging and retention tested;
- upload quarantine tested;
- dependency and SBOM review completed;
- abuse/rate-limit model tested;
- database compromise scenarios assessed;
- TLS configuration and certificate/public-key distribution reviewed;
- penetration/security testing completed.
