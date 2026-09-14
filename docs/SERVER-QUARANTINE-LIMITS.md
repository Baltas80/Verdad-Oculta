# Verdad Oculta — Server quarantine resource-limit baseline

## Status

**Design baseline — NOT IMPLEMENTED. Production approval: NO.**

These values are a reviewable starting point for the server-side quarantine contract. They are not production configuration and must be validated against the final deployment architecture, threat model and operational capacity before activation.

## Proposed baseline

| Resource | Baseline limit | Required behavior on violation |
|---|---:|---|
| Individual object | 50 MiB | Reject before hashing/analysis |
| Total request | 100 MiB | Reject before durable processing |
| Objects per case | 20 | Reject the request |
| Archive nesting depth | 3 levels | Reject |
| Archive expansion ratio | 20:1 | Reject |
| Decompressed archive output | 100 MiB | Reject |
| Per-object analysis wall time | 30 s | Abort and reject/controlled-review according to policy |
| Total case analysis time | 5 min | Abort and reject/controlled-review according to policy |
| Analyzer memory budget | 512 MiB per isolated job | Terminate job and fail closed |
| Concurrent analysis jobs | Deployment-specific, hard bounded | Apply backpressure without bypassing quarantine |

## Ordering rules

Limits must be enforced before expensive operations wherever possible. In particular:

1. Reject invalid or excessive request/object sizes before hashing.
2. Reject excessive archive depth or expansion before full extraction.
3. Apply CPU, memory and wall-time limits to every untrusted-file analysis job.
4. Never increase a limit dynamically based on client-supplied metadata.
5. Never bypass quarantine because an object has a known or apparently safe type.

## Archive safety

Archive processing must account for:

- nested archives;
- compression bombs;
- duplicate filenames;
- absolute paths;
- `..` path components;
- symlink/hard-link entries where supported;
- excessive file counts;
- excessive cumulative uncompressed size;
- malformed central directories or truncated members.

Before any extraction, a future isolated extractor must validate each entry against a metadata-only admission policy. The current client contract rejects symbolic links, hard links, unknown entry kinds, duplicate normalized paths and empty normalized paths. This is a reviewable policy primitive only; it does not parse or extract archives and does not replace server-side enforcement.

Extraction must target an isolated temporary location and must not permit writes outside that location. Archive members must never be executed as part of validation or extraction.

## Denial semantics

A resource-limit violation must produce a deterministic security outcome. The service may expose only a generic rejection category to the client; internal diagnostics must avoid raw disclosure content and infrastructure-sensitive details.

Timeout, memory exhaustion, analyzer crash, incomplete extraction or any inability to establish the required safety condition is **not** a successful analysis.

## Abuse controls

Rate and concurrency controls are required, but they must be designed to avoid unnecessarily creating identifying records. Abuse controls must not weaken encryption, quarantine, anonymity, or fail-closed behavior.

## Required validation evidence

Before these values can become production configuration, the project must demonstrate:

- unit/integration tests for each limit;
- negative tests at and above each boundary;
- archive bomb and nesting tests using synthetic non-sensitive fixtures;
- timeout and memory-exhaustion behavior;
- concurrent-load behavior under bounded capacity;
- proof that rejected material cannot reach durable storage;
- retention/deletion verification for quarantine material;
- independent security review of the selected limits.

Until that evidence exists, this document remains a design baseline only.
