# Cryptography plan

## Purpose

Define the cryptographic decision before any real disclosure data is encrypted, stored or transmitted. This document is a design gate, not an implementation.

## Current state

The informant client currently uses SHA-256 for content integrity/deterministic intake records. SHA-256 is not encryption and does not provide confidentiality.

The current `crypto` dependency is pinned to `3.0.6`. A newer `3.0.7` release exists, but upgrading it is not required for this design decision and must be validated independently before adoption.

## Candidate implementation stack

- `cryptography` 2.9.0: candidate high-level Dart cryptography API for established primitives and protocols supported by the package.
- `cryptography_flutter` 2.3.4: candidate native-backed adapter for supported Apple/Android platforms.
- Platform secure key facilities remain authoritative for long-lived local key protection: Android Keystore and Apple Keychain/Secure Enclave where appropriate.

These packages are candidates only. No production cryptographic implementation is approved by this document.

## Protocol must be defined first

Before adding encryption to the disclosure path, the project must specify and review:

1. Threat model and trust boundaries.
2. What is encrypted on the device, in transit and at rest.
3. Case-key generation and ownership.
4. Key wrapping/distribution for the investigation service.
5. Authentication and integrity of ciphertext.
6. Key rotation, revocation, recovery and destruction.
7. Anonymous reply-channel cryptographic model.
8. Failure behaviour. There must be no plaintext or weaker fallback.
9. Metadata minimization and what the server can still observe.
10. Recovery and backup constraints that do not create a new identity leak.

## Design constraints

- No custom cryptography.
- Prefer maintained, reviewed implementations of established standards.
- Use authenticated encryption; confidentiality without integrity is insufficient.
- Keep keys separate per case or security domain rather than using one global application key.
- Do not place secrets in source control, URLs, ordinary logs, analytics or crash telemetry.
- Do not persist plaintext sensitive material unless an explicit, reviewed requirement permits it.
- Cryptographic decisions must be documented before code is committed.

## Decision gate

**Status: NOT APPROVED FOR PRODUCTION ENCRYPTION.**

The next security task is to produce the protocol and key-lifecycle specification, review it against the threat model, and only then introduce the minimum mature cryptographic dependency required by that specification.

## Verification requirements

Before production:

- dependency versions pinned;
- licenses and provenance recorded in `SOFTWARE-MANIFEST.md`;
- SBOM generated;
- unit/integration/property tests for cryptographic boundaries;
- platform-specific secure-storage validation;
- negative/failure tests proving fail-closed behaviour;
- independent cryptographic/security review.
