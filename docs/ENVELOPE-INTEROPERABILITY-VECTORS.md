# Envelope interoperability vectors

## Status

**Test-contract proposal — NOT APPROVED FOR PRODUCTION.**

This document defines the fixture contract for the future envelope interoperability harness. It does not implement cryptography and must not be interpreted as evidence that the disclosure channel is secure.

## Purpose

Provide deterministic, non-sensitive inputs that can be exchanged between the future Flutter client and an independently implemented service-side reference implementation. The harness must test protocol agreement without using real disclosure material.

## Fixture structure

Each vector must identify, at minimum:

- protocol version;
- cryptographic suite identifier;
- service public-key identifier/version;
- synthetic plaintext payload;
- synthetic recipient key material appropriate to the selected test environment;
- expected envelope field set and encoding;
- expected success/failure result;
- expected rejection reason for negative vectors.

Private test keys and plaintext fixtures must contain synthetic data only and must never be reused as production credentials or included in application configuration.

## Required positive vectors

The first harness should cover:

1. a minimal synthetic text payload;
2. a payload containing binary bytes;
3. a payload large enough to exercise streaming boundaries without approaching production resource limits;
4. a repeated plaintext fixture that must produce independently valid envelopes when fresh per-case keys are used.

The harness must verify successful decryption, integrity, field parsing and protocol-version agreement. It must not assert a byte-for-byte ciphertext match unless the protocol specification explicitly defines all randomness and serialization inputs required for such a comparison.

## Required negative vectors

Before any production approval, the harness must demonstrate deterministic rejection of at least:

- unsupported protocol version;
- unsupported suite identifier;
- unknown/revoked recipient-key identifier;
- malformed envelope encoding;
- missing required field;
- invalid field length/type;
- truncated ciphertext or stream;
- modified ciphertext;
- modified authenticated metadata where AAD is defined;
- modified wrapped content key;
- reordered or otherwise structurally invalid stream data.

A rejected vector must not yield plaintext and must not fall back to another algorithm, key or serialization format.

## Canonicalization gate

No fixture may be treated as an interoperability authority until the exact wire encoding, field ordering/canonicalization, binary representation and authenticated-associated-data rules have been separately reviewed and frozen.

The harness must fail if an implementation silently normalizes or invents unspecified fields. This prevents a test suite from accidentally becoming the de facto protocol specification.

## Cross-language requirement

At least one independent implementation must consume the same non-sensitive vectors. The Flutter implementation alone is insufficient evidence of interoperability.

The test matrix should record:

- implementation/language;
- dependency versions and provenance;
- platform/runtime;
- vector identifier;
- result;
- rejection reason where applicable.

## Security boundaries

This harness does not prove:

- anonymous transport;
- endpoint security;
- secure local key storage;
- public-key distribution authenticity;
- server private-key custody;
- malware safety of received evidence;
- anonymity or legal protection.

Those remain separate gates in `SECURITY-IMPLEMENTATION-GATE.md` and `THREAT-MODEL.md`.

## Implementation gate

Do not add `sodium`, `secretstream`, sealed-box code or production envelope serialization solely to satisfy this document. First freeze the protocol decisions and complete the dependency/provenance review described in `ENVELOPE-ENCRYPTION-PROTOCOL.md`.

Once those decisions are approved, implement the smallest interoperability harness possible using synthetic vectors, run it against an independent reference implementation, and preserve the resulting evidence in CI.
