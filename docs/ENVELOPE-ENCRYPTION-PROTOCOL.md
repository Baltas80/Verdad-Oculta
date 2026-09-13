# Envelope encryption protocol

## Status

**Design proposal — NOT APPROVED FOR PRODUCTION.**

This document defines the minimum cryptographic envelope that can be reviewed before implementation. It deliberately does not introduce code or claim that the disclosure channel is currently secure.

## Objective

Protect each disclosure as an independent encrypted case while allowing the authorized investigation service to recover the case content without receiving a reusable application-wide encryption key.

## Proposed construction

For each case:

1. Generate a fresh random symmetric content key `K_case` using a cryptographically secure random generator.
2. Encrypt the case payload as a stream with an authenticated-encryption construction suitable for files and large media. The current candidate is libsodium `crypto_secretstream_xchacha20poly1305`.
3. Wrap `K_case` to an investigation-service public key using an established public-key encryption mechanism. The current candidate is libsodium sealed boxes (`crypto_box_seal`) using the service public key.
4. Store/transmit only the encrypted payload plus the minimum envelope metadata required to decrypt and validate it.
5. Keep the corresponding service private key exclusively on the investigation/service side; it must never be embedded in the informant client.

This is a candidate construction, not an approval to deploy it.

## Why this construction is being evaluated

`crypto_secretstream` is designed for encrypted sequences/files and provides authenticated decryption, stream ordering/integrity checks, and rekeying support. It is therefore preferable to independently encrypting arbitrary file chunks with ad-hoc nonce management.

Libsodium sealed boxes are designed for anonymous encryption to a recipient public key: only the recipient can decrypt, while the sender's identity is not authenticated by the construction. That property is compatible with a maximum-anonymity submission model, but it also means sender authentication must not be assumed from the envelope.

## Envelope fields

The final wire format must be versioned and specified before implementation. At minimum it will need to distinguish:

- protocol version;
- cryptographic suite identifier;
- service public-key identifier/version;
- secretstream header;
- wrapped `K_case`;
- ciphertext object or stream reference;
- integrity/deduplication reference where required;
- non-sensitive size information required by transport/storage.

The exact encoding, canonicalization and authenticated-associated-data rules remain review items. They must not be improvised in application code.

## Authentication and metadata

Encryption does not authenticate the informant. In maximum-anonymity mode, no sender identity is included in the cryptographic envelope.

The service public key must itself be distributed and pinned/authenticated through a separately reviewed trust mechanism. Trusting an attacker-controlled public key would permit encryption to the wrong recipient.

Metadata must be minimized. Filenames, EXIF, document metadata, filesystem paths and other potentially identifying attributes must be treated as sensitive and removed or isolated where technically and legally appropriate before transmission.

## Key lifecycle

`K_case`:

- generated once per case;
- never reused as a global application key;
- kept only for the minimum required local processing lifetime;
- wrapped only for the authorized service key(s);
- destroyed locally after successful protected handoff where recovery requirements permit;
- not written to ordinary logs, URLs, analytics, crash telemetry or source control.

Service key pairs require independent rotation, revocation, backup and recovery procedures defined in `KEY-LIFECYCLE.md`.

## Failure rules

Any cryptographic initialization, key lookup, public-key validation, encryption, stream finalization, wrapping, upload integrity check or decryption failure must abort the protected operation.

There must be no fallback to plaintext, unauthenticated encryption, a default key, a hard-coded key, or an alternate weaker algorithm.

## Important limitation

The proposed envelope does not by itself provide:

- anonymous network transport;
- protection against a fully compromised endpoint;
- secure local storage on every platform;
- sender authentication;
- secure anonymous two-way replies;
- malware safety for received evidence;
- legal anonymity guarantees.

Those controls remain separate security gates.

## Dependency decision gate

Before implementation, the project must verify:

- exact Dart/package versions and dependency graph;
- libsodium version and provenance;
- platform coverage for Android, iOS, web, Windows, macOS and Linux;
- native/web build reproducibility;
- license compatibility;
- SBOM output;
- key-memory handling and disposal behavior;
- test vectors and cross-language interoperability;
- service-side implementation and key custody;
- independent cryptographic review.

The current Dart `sodium` package exposes libsodium 1.0.22 and supports the six project targets, but its recent release status means supply-chain and reproducibility checks remain mandatory before adoption.

## Decision

**Candidate: libsodium `secretstream` + recipient-public-key wrapping.**

**Production approval: NO.**

The next implementation gate is a threat-model review of this construction, followed by a small interoperability test harness using non-sensitive test vectors. No real disclosure data should enter this path until all security gates are satisfied.
