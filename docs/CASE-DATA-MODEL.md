# Verdad Oculta — Case Data Model

## Status

**DESIGN GATE — NOT APPROVED FOR PRODUCTION**

This document turns the lifecycle and data-minimization rules into a reviewable logical model. It is intentionally storage-technology agnostic. No database schema or ORM model is authorized by this document.

## Design objective

Represent a disclosure as a set of isolated security-domain records rather than a single user-centric row.

The model must preserve three distinctions:

1. **What was submitted** — protected original evidence.
2. **What investigators concluded about the material** — review and classification records.
3. **What the public/member archive is allowed to receive** — approved derivatives.

An anonymous submission must remain possible without creating a member account or an identity profile.

## Logical entities

### 1. Case

The case is the minimum operational container.

Permitted attributes:

- opaque `case_ref`;
- lifecycle state;
- security classification;
- protocol/envelope version;
- created/received timestamps only where operationally necessary;
- retention state;
- non-sensitive counters/quotas required for processing.

The Case record must not contain source identity, member identity, raw content, filesystem paths or private cryptographic material.

### 2. EvidenceObject

Represents one submitted or derived object.

Permitted attributes:

- opaque `evidence_id`;
- `case_ref`;
- object role (`PROTECTED_ORIGINAL`, `DERIVATIVE`, or another explicitly defined role);
- encrypted storage reference;
- integrity digest/reference;
- protocol/key-version references that do not reveal key material;
- bounded size/resource metadata;
- processing/quarantine state;
- classification;
- retention state.

A protected original is never represented as a public/member object by changing a client-visible flag.

### 3. EvidenceAssessment

Represents a review assertion about an EvidenceObject.

Permitted attributes:

- opaque assessment identifier;
- evidence reference;
- evidence state (`REPORTED`, `RECEIVED`, `INTEGRITY_CHECKED`, `PROVENANCE_REVIEWED`, `CORROBORATED`, `UNRESOLVED`, `DISPUTED`);
- reviewer role/opaque investigator reference where required for accountability;
- findings/notes according to least-privilege policy;
- assessment timestamp;
- review version.

Assessment data is not a replacement for the protected original.

### 4. PublicationDerivative

Represents a sanitized artifact explicitly approved for release.

Permitted attributes:

- opaque derivative identifier;
- source evidence reference;
- immutable content hash/version;
- sanitized publication artifact reference;
- publication classification (`MEMBER_ARCHIVE` or `PUBLIC`);
- approval state;
- approval record/reference;
- release metadata that is safe for the intended audience.

The derivative must be independently addressable. Changes to the protected original must not silently change an approved derivative.

### 5. CorrespondenceChannel

Represents the separate anonymous reply capability.

Permitted attributes:

- opaque channel identifier;
- case reference;
- credential verifier/reference rather than plaintext reply secret;
- channel state;
- bounded message counters;
- creation/expiry/retention state.

The channel must not contain member identifiers or require email/phone for maximum-anonymity use.

### 6. MemberEntitlement

Represents paid/account access to already-approved archive material.

Permitted attributes:

- opaque member/account identifier;
- entitlement tier/state;
- provider reference required for billing reconciliation;
- start/expiry/revocation state;
- minimal audit timestamps.

It must not contain anonymous submission credentials, protected originals or source identity.

## Relationship rules

Logical relationships are intentionally one-way and opaque where possible:

`Case -> EvidenceObject -> Assessment`

`EvidenceObject -> Approved PublicationDerivative`

`Case -> CorrespondenceChannel`

`MemberEntitlement -> AuthorizationPolicy -> PublicationDerivative`

There is deliberately **no** relationship:

`MemberEntitlement -> Case -> Informant identity`

and no member-facing query may traverse from a membership account into protected source material.

## Classification rules

### CONFIDENTIAL

Protected original/source-sensitive material. Never directly resolvable by public or member access paths.

### RESTRICTED

Material under review, legally/security restricted, or otherwise not approved for public/member release.

### MEMBER_ARCHIVE

Sanitized material explicitly approved for authenticated members.

### PUBLIC

Sanitized material explicitly approved for general publication.

Classification is independent from membership tier. A higher payment tier cannot downgrade a protected object.

## State invariants

The implementation must reject impossible combinations, including:

- `CONFIDENTIAL + PUBLIC audience`;
- `PROTECTED_ORIGINAL + MEMBER_ARCHIVE audience`;
- `DERIVATIVE + no source/approval record`;
- `PUBLIC + no explicit publication approval`;
- `CorrespondenceChannel + member identity binding in maximum-anonymity mode`;
- `Case + identity profile created solely because a submission was received`.

## Identifier rules

All externally visible identifiers must be opaque and non-sequential.

A `case_ref`, `evidence_id`, `derivative_id`, `channel_id` and `member_id` are distinct namespaces and must not be interchangeable.

Identifiers must not encode:

- names;
- emails;
- phone numbers;
- timestamps;
- device identifiers;
- filenames;
- membership tiers.

## Audit boundaries

Audit records should capture privileged security events rather than content.

Examples:

- protected evidence access granted/denied;
- classification changed;
- derivative approved/rejected;
- entitlement changed;
- privileged export attempted/completed;
- cryptographic key version retired.

Audit records must not copy plaintext evidence, correspondence contents, private keys or unnecessary identity data.

## Retention boundaries

Retention is evaluated per domain, not per case alone.

- Protected originals follow preservation/legal policy.
- Temporary processing material has the shortest practical lifetime.
- Assessments remain only as long as needed for investigation/accountability.
- Publication derivatives follow the archive policy.
- Correspondence follows its specific communication/retention policy.
- Membership/entitlement data follows service, billing and legal requirements.

Backups, replicas, caches, search indexes and immutable stores require explicit treatment; deleting the primary record is not by itself proof of complete deletion.

## Migration rule

Before implementing a real database, every physical field must map to one logical entity and one documented purpose. A field added for convenience without a security/privacy justification should be rejected.

## Production gate

This model becomes implementation-ready only after:

- field-level data-flow mapping;
- retention/deletion specification;
- authorization matrix;
- correspondence credential design;
- cryptographic envelope approval;
- storage isolation design;
- backup/replica analysis;
- negative authorization tests;
- independent security/privacy review.
