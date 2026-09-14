# Verdad Oculta — Publication Redaction Pipeline

## Status

Design baseline. This document defines the boundary between protected originals and material approved for publication. It does not authorize real-world publication or automated release of sensitive material.

## Core rule

Verdad Oculta must never publish a received file directly merely because it was submitted, verified, or selected for disclosure.

The protected original and the publication copy are separate objects with separate access controls.

`RECEIVE -> PROTECT -> PRESERVE ORIGINAL -> REDACTION -> REVIEW -> PUBLISH COPY`

## Protected original

The original submission is preserved in a restricted/quarantine area. It may contain identifying information, metadata, private communications, or other sensitive material. It is never exposed to public or member archive permissions.

The original must not be copied into public object storage, public CDN paths, analytics systems, crash reports, logs, previews, thumbnails, search indexes, or ordinary backups.

## Redaction targets

The publication review must consider, as applicable:

- names and aliases;
- faces and identifying images;
- phone numbers and email addresses;
- postal addresses and precise locations;
- identity numbers, account numbers and signatures;
- vehicle registration and other identifiers;
- document properties and embedded metadata;
- EXIF/GPS and media metadata;
- filenames and directory names;
- audio characteristics or speech that may identify a person;
- timestamps, operational details or combinations of facts that enable indirect identification;
- information about uninvolved third parties;
- credentials, secrets, access tokens or private keys;
- information whose publication could create an avoidable safety risk.

The review must consider indirect re-identification, not only obvious names or identifiers. AEPD notes that removing direct identifiers alone does not establish anonymity and that residual re-identification risk must be assessed. See AEPD guidance referenced in the repository security documentation.

## Media-specific handling

### Documents

Create a sanitized publication derivative. Remove or replace metadata and hidden properties. Render/flatten where appropriate so removed content cannot remain in document layers, revision history, comments, annotations, attachments, or embedded objects.

### Images

Remove metadata and redact identifying regions before publication. The original image remains protected. Do not rely on visual cropping alone if the original remains accessible through a predictable URL or derivative service.

### Video

Review frames, audio tracks, subtitles, filenames, container metadata and embedded streams. Redaction may require face/plate masking, audio alteration or removal of identifying segments. Do not expose the original stream through previews or transcoding infrastructure.

### Audio

Review speech content, metadata and potentially identifying voice characteristics. Publication may require transcription-only, edited audio, or removal of identifying portions.

### Text

Review direct and indirect identifiers, quotations that could reveal the source, URLs, embedded documents, hidden markup and contextual combinations that enable re-identification.

## Automated controls

Automation may detect candidates for redaction, metadata and dangerous embedded content, but automated detection is not sufficient for release.

Every publication candidate containing potentially identifying or sensitive material requires human review before release.

Automated controls must fail closed: if a required scan, transformation, validation, or integrity check fails, the publication copy remains unreleased.

## Human review

The reviewer must verify:

1. The publication copy is derived from the intended original.
2. Required metadata has been removed or intentionally retained and documented.
3. Direct identifiers have been removed or justified.
4. Indirect re-identification risk has been considered.
5. The redaction has not accidentally removed material necessary to understand the evidence.
6. The publication copy does not contain credentials or secrets.
7. The original remains inaccessible to the publication audience.
8. The final publication object is the exact object whose hash/version was approved.

## Access classes

- `CONFIDENTIAL`: protected original and source-sensitive material.
- `RESTRICTED`: material undergoing review or not approved for release.
- `MEMBER_ARCHIVE`: sanitized material explicitly approved for authenticated members.
- `PUBLIC`: sanitized material explicitly approved for general publication.

A membership entitlement must never bypass the redaction pipeline.

## Publication manifest

Each released object should have an internal immutable manifest containing at least:

- publication object identifier;
- source/original reference that is not exposed publicly;
- transformation/redaction version;
- publication classification;
- approval timestamp;
- reviewer/approval role identifier, without exposing private reviewer data;
- final content hash;
- non-sensitive processing status.

The manifest must not contain the source identity or unnecessary identifying metadata.

## No direct publication path

The architecture must make this invariant technically enforceable:

`CONFIDENTIAL -> PUBLIC` is invalid.

The only permitted transition is:

`CONFIDENTIAL -> RESTRICTED -> sanitized derivative -> human approval -> MEMBER_ARCHIVE or PUBLIC`.

If a case is never approved for publication, its protected original remains protected.

## Security requirements

Sensitive local data must be protected and must not leak through logs, caches, backups or public storage. OWASP MASVS specifically requires secure storage and prevention of sensitive-data leakage, and recommends minimizing sensitive-data access. Production implementation must satisfy the repository security gates and undergo independent review before handling real submissions.

## Legal gate

This pipeline is a technical safety control, not a legal authorization to publish. Publication decisions require the project's legal policy and, for high-risk material, legal review.

## Non-negotiable principle

> Preserve the evidence. Protect the people. Publish only the version that is safe and authorized to publish.
