# Verdad Oculta — Authorization and Anonymous Reply Boundary

## Status

Design gate only. This document does not authorize production authentication, messaging or real submissions.

## Objective

Allow an informant to retrieve a response about their case without requiring the submission to become an identity-linked account.

## Security domains

`INFORMANT != MEMBER != INVESTIGATOR != ADMIN`

A member account must never become the implicit identity of an anonymous submission. Investigator access is separately authenticated and authorized.

## Case reference versus reply credential

A case reference is a non-identifying locator. It is not, by itself, an authentication secret.

Anonymous communication requires a separate high-entropy reply credential or equivalent cryptographic capability. The design must prevent a database read-only leak from becoming sufficient to read the communication channel.

The reply credential must not encode:

- identity;
- membership tier;
- timestamp-derived identity information;
- device identifiers;
- filenames;
- predictable case sequence numbers.

## Preferred authorization model

The production design should use capability-style authorization:

`RANDOM CASE REF + INDEPENDENT HIGH-ENTROPY REPLY SECRET -> SERVER-SIDE AUTHORIZATION`

The server stores only the minimum verifier/material required by the selected passwordless capability scheme. The plaintext reply secret must not be stored in ordinary database fields or logs.

Where practical, the client should receive the reply secret only once and should be warned that losing it may make anonymous recovery impossible. Recovery must not silently fall back to email, phone, membership account or identity verification.

## Message protection

Anonymous replies must be protected independently of ordinary member messaging. Message confidentiality and authorization are separate controls.

A future implementation must define:

- message encryption scope;
- sender/recipient key roles;
- key generation and rotation;
- replay protection;
- message ordering;
- deletion and retention;
- attachment handling;
- rate limiting without identity collection;
- abuse controls that do not defeat anonymity;
- audit events that contain no message content or source identity.

## Server-side authorization

The informant client must never decide whether a message is accessible. The server must enforce the authorization boundary on every request and fail closed on:

- missing credential;
- invalid credential;
- expired/revoked capability;
- malformed case reference;
- ambiguous authorization state;
- unavailable key material;
- backend integrity failure.

Authorization must be checked independently from membership entitlement. Payment must never grant access to confidential informant communications.

## Anti-correlation requirements

The reply mechanism must not introduce unnecessary correlation between:

- anonymous submission and member account;
- anonymous submission and investigator account;
- case reference and network metadata;
- separate cases from the same informant;
- reply retrieval and publication identity.

Operational telemetry, analytics SDKs and advertising identifiers are prohibited from the protected communication path unless a future security review explicitly proves they cannot create identifying leakage. The default is exclusion.

## Failure and recovery

There is no identity-based recovery in maximum-anonymity mode unless the informant explicitly chooses an identity-linked channel in a separate, clearly disclosed mode.

If the anonymous credential is lost, the platform must not infer or reconstruct the informant's identity merely to restore access.

## Production gate

Before activation:

- formal authorization threat model reviewed;
- capability entropy and verifier design reviewed;
- cryptographic message protocol independently reviewed;
- replay and brute-force protections tested;
- rate limiting tested for abuse without unnecessary identity collection;
- database compromise scenario tested;
- network metadata and correlation risks assessed;
- secure local handling verified on every supported platform;
- investigator/admin authorization tested separately;
- audit logging reviewed for minimization;
- penetration/security testing completed.
