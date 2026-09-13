# Verdad Oculta — Intake Pipeline

## Purpose

Define the fail-closed processing boundary for files supplied by an informant. The client-side checks are pre-flight controls only; the authoritative security boundary is server-side.

## Required order

`RECEIVE -> QUARANTINE -> SIZE/RESOURCE LIMITS -> HASH -> REAL TYPE IDENTIFICATION -> ARCHIVE SAFETY CHECKS -> ANALYSIS -> CLASSIFICATION -> ENCRYPTED STORAGE`

No stage may silently bypass a failed previous stage.

## Receive and quarantine

- Accept input only through an authenticated transport gateway using TLS.
- Assign a non-sensitive random intake identifier.
- Write the original object only to a dedicated quarantine area with restrictive access controls.
- Do not expose the original object to application logs, URLs, analytics, investigator workstations, or general-purpose application workers.
- Preserve the original bytes as an immutable object once admitted to quarantine.

## Resource limits

Enforce limits independently of the client, including:

- maximum object size;
- maximum request/body size;
- maximum extracted size;
- maximum file count per archive and batch;
- maximum archive nesting depth;
- maximum parser/runtime duration;
- CPU and memory quotas;
- maximum outbound requests from analysis workers.

A client-side 50 MiB limit is not a substitute for these server-side controls.

## Hash

Compute SHA-256 over the received bytes before analysis. The digest is an integrity reference, not a trust decision and not proof that content is safe.

Do not use the digest as an authentication secret.

## Real type identification

Identify content from bytes using mature maintained file-identification tooling. Filename extensions and user-declared types are advisory only.

The current Flutter client contains a conservative signature primitive for common formats (PDF, PNG, JPEG, GIF, WebP, ZIP and GZIP), but this does not replace server-side identification.

If the type cannot be established safely, classify the object as unknown and route it to the policy-defined restricted analysis path or reject it. Never infer a trusted type from the filename alone.

## Intake record contract

The client now has an explicit immutable `IntakeRecord` contract containing only the minimum structural fields needed for a future secure hand-off: SHA-256 digest, detected content type and byte size.

- A record is structurally invalid unless the digest is exactly 64 hexadecimal characters and the size is non-negative.
- `unknown` content type remains explicitly untrusted; it does not become trusted through filename or extension.
- The record is not a transport, storage, authentication, or authorization object.
- No identity, path, URL, plaintext content, or secret is included in the record.

This contract is a local boundary only. It does not imply that the content is safe or that server-side validation has occurred.

## Archive safety

ZIP/GZIP and other containers require inspection before extraction. Enforce compressed and uncompressed size limits, entry-count limits, nesting-depth limits, safe path handling, and duplicate/overlap checks where applicable.

Extraction must occur in an isolated workspace with quotas. Never extract directly into a production application filesystem.

## Analysis

Untrusted files must not be executed directly in production. Analysis should use the Evidence Laboratory controls defined in `EVIDENCE-LAB.md`.

Prefer static analysis for unknown or high-risk content. Any controlled execution requires a disposable, isolated environment with deny-by-default networking and resource quotas.

## Classification

Produce a bounded structured result such as:

- content type;
- SHA-256 digest;
- parser/structural findings;
- scanner findings;
- risk classification;
- tool/version identifiers.

Do not copy raw unbounded tool output into application logs.

## Encrypted storage

Only content that has passed the applicable intake and analysis policy may move from quarantine to encrypted evidence storage. Sensitive content must remain ciphertext at rest, with keys managed independently through approved key-management controls.

Identity records and evidence records remain separate.

## Fail-closed rules

- Failed validation stops progression.
- Unknown content never becomes trusted merely because a filename looks safe.
- Analysis failure, timeout, worker crash, or resource exhaustion leaves the object quarantined.
- No plaintext fallback is permitted.
- No real sensitive submission is enabled until the production security gate is satisfied.

## Current implementation status

Implemented client-side primitives: attachment selection, basic filename/size validation, SHA-256 hashing, conservative content-signature detection, and the explicit intake-record structural contract. These primitives are not yet a complete secure intake pipeline and must not be represented as such.
