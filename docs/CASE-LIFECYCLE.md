# Verdad Oculta — Disclosure Case Lifecycle

## Status

Design baseline. This document defines the lifecycle of a disclosure case. It does not authorize production submissions or publication.

## Principle

A case is an operational container for a disclosure. It is not proof of any particular explanation or conclusion.

A case may contain documents, photographs, video, audio, text, testimony, integrity records, review notes and publication derivatives.

## Lifecycle

`DRAFT -> PREPARED -> PROTECTED -> SUBMITTED -> RECEIVED -> UNDER_REVIEW -> CLASSIFIED -> PUBLISHED or ARCHIVED`

A case may also enter `RESTRICTED`, `WITHHELD`, or `CLOSED` states when publication is not appropriate or the investigation is complete.

### DRAFT

Information exists only in the informant's local workflow. Nothing has been transmitted.

### PREPARED

Selected material has passed local pre-flight validation and metadata-minimization preparation. This does not mean the material is safe or authentic.

### PROTECTED

The approved cryptographic envelope has been created successfully. Plaintext fallback is forbidden.

### SUBMITTED

The protected payload has been transmitted to the service gateway.

### RECEIVED

The service has durably accepted the protected object and assigned a non-identifying case reference. Receipt does not imply acceptance as authentic evidence.

### UNDER_REVIEW

Authorized investigators review provenance, integrity, context, safety and publication suitability.

### CLASSIFIED

The case and its derivatives receive explicit access classifications:

- `CONFIDENTIAL` — protected original/source-sensitive material.
- `RESTRICTED` — material under review or unsuitable for member/public release.
- `MEMBER_ARCHIVE` — sanitized material explicitly approved for authenticated members.
- `PUBLIC` — sanitized material explicitly approved for general publication.

### PUBLISHED

Only an approved sanitized derivative is released. The protected original remains inaccessible to the publication audience.

### ARCHIVED

The case or approved derivative is retained according to its classification and retention policy.

## Evidence states

Evidence inside a case must not be represented simply as true/false. Each item may carry separate assessments such as:

- `REPORTED` — contributor states or submits it.
- `RECEIVED` — platform received the object.
- `INTEGRITY_CHECKED` — hash/format integrity checks passed.
- `PROVENANCE_REVIEWED` — available provenance was examined.
- `CORROBORATED` — independently supported by additional evidence.
- `UNRESOLVED` — material remains unexplained or insufficiently established.
- `DISPUTED` — significant contradictory evidence exists.

These labels describe evidence handling, not a predetermined interpretation of UAP, NHI or any other phenomenon.

## Access invariants

1. A member account can never access `CONFIDENTIAL` content.
2. A member account can never access the protected original merely because a derivative exists.
3. Payment status is never an authorization source for confidential material.
4. The informant client never decides server-side access permissions.
5. `CONFIDENTIAL -> PUBLIC` is invalid.
6. Publication requires a sanitized derivative and explicit approval.
7. Case references must not encode identity information.
8. Investigation access is least-privilege and auditable.

## Anonymous source boundary

The anonymous submission path does not require a membership account. Membership identity and disclosure identity are separate domains. The system must not create a hidden link between them for convenience, analytics or personalization.

## Publication boundary

The publication pipeline remains:

`PROTECTED ORIGINAL -> REDACTION -> HUMAN REVIEW -> APPROVED DERIVATIVE -> MEMBER_ARCHIVE/PUBLIC`

The publication copy has its own immutable content hash/version. A later change to the original must not silently alter an already approved publication.

## Closure

A case can be closed because it was published, archived, withheld, duplicated, invalid, unsafe to process, legally restricted, or otherwise completed. Closure must not imply that an unresolved phenomenon has been explained.

## Security gate

Any unavailable security capability must stop the relevant transition. The system must fail closed rather than downgrade encryption, access controls or privacy protections.
