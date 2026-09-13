# Verdad Oculta — Reveal Protocol

## Purpose
Define the application-level contract for receiving sensitive disclosures while minimizing identity and metadata exposure.

## States
1. Draft — information exists only locally.
2. Prepared — content selected and metadata minimization completed.
3. Protected — cryptographic envelope created by an approved implementation.
4. Submitted — protected payload accepted by the transport gateway.
5. Received — server acknowledges durable encrypted storage.
6. Under review — investigation team processes the case.
7. Response available — a reply is available through the anonymous case channel.

## Required properties
- No plaintext sensitive content in logs, analytics, crash reports, or URLs.
- No identity fields are required for maximum-anonymity submissions.
- Tracking codes are random case references, not identity identifiers.
- Content and identity records must remain separate.
- Server-side storage must contain ciphertext for sensitive content.
- Cryptographic algorithms and protocols must come from reviewed, maintained implementations; no custom cryptography.
- Metadata minimization happens before upload whenever technically possible.

## Explicit non-goals
- Do not promise absolute anonymity.
- Do not put PII, documents, media, private keys, or plaintext secrets on a public blockchain.
- Do not use the tracking code as an authentication secret without an additional security design.

## Implementation gate
The production submission path must remain disabled until the threat model, cryptographic design, key-management design, transport controls, secure storage, deletion policy, audit logging policy, and independent security review are complete.
