# Verdad Oculta — Server Data Minimization Model

## Status

**DESIGN GATE — NOT APPROVED FOR PRODUCTION**

This document defines what the backend should know, what it may retain, and what must deliberately not become part of the normal case database. It complements the anonymous-submission boundary, archive access model and case lifecycle.

## Objective

The server must process disclosures without turning operational convenience into an identity database.

The default rule is:

> If a data element is not required to receive, protect, preserve, review, communicate or publish a case, it should not be collected.

## Logical data domains

The backend is separated into independent security domains:

1. **Submission envelope** — the minimum information needed to receive and track an anonymous submission.
2. **Protected evidence** — encrypted originals and integrity information, isolated from account data.
3. **Investigation workspace** — review findings, classification decisions and controlled references to evidence.
4. **Publication archive** — approved derivatives only, with their publication classification.
5. **Member entitlement** — membership/account state used to authorize approved archive material.
6. **Secure correspondence** — anonymous case communication, kept separate from member identity.
7. **Operational security** — narrowly scoped security events required to protect the service.

These domains must not be collapsed into a single user/case record.

## Minimum submission record

A maximum-anonymity submission should require only:

- random case reference;
- protocol/envelope version;
- protected content reference;
- integrity digest or equivalent verified integrity reference;
- processing state;
- creation/receipt time only where operationally necessary;
- non-sensitive processing metadata required for quotas and resource control.

A case reference must not encode identity, membership, device information, filenames or timestamps.

## Data that must not be part of the normal submission identity record

The application must not intentionally create a submission-to-identity mapping containing:

- legal name;
- email address;
- telephone number;
- postal address;
- contacts/address book;
- GPS coordinates;
- advertising identifier;
- analytics identifier;
- membership identifier;
- investigator identifier;
- unnecessary device identifier;
- authentication credentials for another service;
- raw filesystem path;
- original filename unless independently justified for evidence processing;
- plaintext source material;
- plaintext private keys;
- sensitive URL parameters.

Network-level metadata is a separate infrastructure threat and retention problem. Application code must not duplicate it into case records merely for convenience.

## Protected evidence record

The protected evidence domain may contain:

- opaque evidence identifier;
- encrypted object/reference;
- cryptographic integrity information;
- encryption protocol and key-version identifiers;
- processing/quarantine state;
- bounded resource metadata required for safe processing;
- retention/deletion state;
- security classification.

The database must not need plaintext evidence to represent the case.

## Investigation data

Investigation records should reference protected evidence by opaque identifiers and contain only the minimum information required for review:

- review status;
- evidence references;
- provenance findings;
- corroboration findings;
- analyst notes where necessary;
- classification decision;
- publication decision and approval state.

Investigation records must not silently become a copy of the original submission. Export, duplication and derivative creation require explicit authorization and auditability.

## Publication archive

Only an approved derivative may enter a public or member-facing publication domain.

Search indexes, thumbnails, previews, caches and CDN objects inherit the classification of their source unless an explicitly approved derivative policy says otherwise.

A protected original must never become public merely because a derivative was published.

## Membership and entitlement

Membership data authorizes access to already-approved archive material. It must not be used to identify anonymous informants.

Payment processing may update entitlement state, but payment records must not become a shortcut to protected evidence authorization.

The member domain must not contain:

- confidential source identity;
- protected original content;
- anonymous correspondence credentials;
- investigator-only notes.

## Secure correspondence

Anonymous replies require a separate credential and threat model. A case reference alone is not sufficient authentication.

Correspondence must remain logically separate from membership identity and must not require an email address or phone number for the maximum-anonymity path.

## Operational logs

Logs must be designed around security events, not content collection.

Allowed examples, subject to review and retention limits:

- service health events;
- coarse processing failures;
- authorization failures without sensitive request content;
- rate-limit events using the minimum necessary identifier;
- administrative security events with controlled access.

Never log by default:

- submission contents;
- plaintext evidence;
- encryption keys;
- credentials;
- full request URLs containing sensitive parameters;
- raw request bodies;
- source identity data;
- anonymous correspondence contents.

Error reporting and crash telemetry must be explicitly reviewed before entering the protected flow. Third-party telemetry is excluded by default.

## Retention

Every retained field requires a documented purpose and retention rule.

Default posture:

- protected originals: retained only under the case preservation policy;
- temporary plaintext/workspace data: shortest practical lifetime;
- operational logs: shortest period compatible with security operations;
- rejected submissions: no retained plaintext unless a documented security/legal reason exists;
- publication derivatives: retained according to archive policy;
- account/entitlement data: retained only as required for the service and applicable obligations.

Deletion must be verifiable at the application/storage layer where technically feasible. Backups and immutable storage require a separate retention and deletion strategy.

## Access control

Server-side authorization is authoritative. The client cannot grant itself access by sending a classification, tier, case reference or role claim.

Access must be least-privilege and fail-closed. Protected originals require a stronger authorization boundary than publication derivatives.

## Required review before implementation

Before this model becomes a production database schema:

- map every field to a concrete purpose;
- define retention and deletion behavior;
- define network metadata handling separately;
- define backup and disaster-recovery exposure;
- define access roles and audit events;
- define anonymous correspondence credentials;
- define encryption/key references without exposing key material;
- review GDPR/data-protection implications with qualified counsel;
- test that telemetry, logs and caches do not recreate the identity graph;
- perform an independent security/privacy review.

## Decision

**Do not build a conventional user-centric case table.** Build separate security domains with opaque references and explicit authorization boundaries. The first implementation should favor fewer fields and stronger isolation over convenience.
