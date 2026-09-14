# Verdad Oculta — Retention and Deletion Policy

## Status

**DESIGN GATE — NOT APPROVED FOR PRODUCTION**

This document defines the technical retention model for the platform. It does not replace legal advice or establish final statutory retention periods.

## Principle

Retention is a security decision, not merely a storage-cost decision.

Every retained field or object must have:

- a defined purpose;
- an owning security domain;
- a defined retention rule;
- an authorized deletion process;
- an identified backup/replica consequence.

The default is to retain less, for less time, with narrower access.

## Retention domains

### Protected originals

Protected original evidence may be retained only when required by the case-preservation policy, investigation needs, legal obligations or a documented preservation decision.

Deletion must not be triggered merely by a member entitlement change or publication event.

### Temporary plaintext

Temporary plaintext created during local or isolated server processing must have the shortest practical lifetime. Temporary workspaces, caches and parser outputs must be included in the deletion path.

### Quarantine data

Untrusted uploads remain in quarantine until the relevant security processing has completed. Rejected material must not automatically become a long-lived archive copy.

### Investigation records

Investigation notes, assessments and review metadata are retained only for documented research, accountability, legal or operational purposes. They must not become an uncontrolled copy of protected evidence.

### Publication derivatives

Approved public/member derivatives may be retained under the archive policy. The derivative is independent from the protected original and has its own lifecycle/version.

### Secure correspondence

Anonymous correspondence requires a separate retention policy covering message content, unread state, expiration and credential lifecycle. Correspondence retention must not be determined by membership status.

### Membership and entitlement

Account and billing-related data follows the service's legal, contractual and payment-provider requirements. It must remain separate from anonymous disclosure records.

### Operational security logs

Operational logs use the minimum information required for security and service reliability. Retention should be as short as practical for the stated purpose.

Logs must not be used as a shadow identity database.

## Deletion states

A logical object may transition through:

`ACTIVE -> RETENTION_PENDING -> DELETION_REQUESTED -> DELETED -> VERIFIED`

`LEGAL_HOLD` or another documented preservation state may pause deletion where justified.

A deletion request must be explicit about which security domains and replicas it affects.

## Deletion requirements

Deletion procedures must account for:

- primary database/object storage;
- replicas;
- asynchronous queues;
- caches/CDNs;
- search indexes;
- thumbnails/previews;
- local temporary files;
- crash/error storage;
- support exports;
- backups;
- immutable/WORM retention where applicable.

A primary-row delete is not sufficient evidence that all copies are gone.

## Verification

Where technically feasible, deletion must produce a non-sensitive verification record showing that the deletion workflow completed for the defined storage scope.

The verification record must not preserve the deleted sensitive content merely to prove deletion.

## Backup strategy

Backups are a separate security domain. They must have:

- encryption at rest;
- controlled administrative access;
- documented retention;
- documented restore access;
- recovery testing;
- a plan for deleted data that remains present until backup expiry or secure purge capability exists.

Backup metadata must not create a new identity graph.

## Legal hold

A preservation hold may suspend ordinary deletion where a qualified legal/operational decision requires it. The existence, scope and expiry/review date of a hold must itself be controlled and audited.

A hold must not silently broaden access to protected evidence.

## Failure behavior

If deletion cannot be completed for a storage domain, the system must mark the operation as incomplete rather than claiming successful deletion.

If retention state is unknown or corrupt, protected material must remain access-restricted until the state is reconciled.

## Privacy and security basis

The policy follows the project's existing data-minimization model and OWASP's requirement to securely store sensitive data and prevent leakage from storage, backups and related mechanisms. OWASP specifically identifies unencrypted private storage, insecure shared storage, and keys stored outside secure platform facilities as weaknesses.

## Production gate

Before production retention/deletion:

- assign a documented purpose to every retained field;
- define exact retention periods or event-based rules with qualified legal/privacy review;
- document backup/replica behavior;
- implement deletion across primary and secondary storage;
- test cache/index/preview cleanup;
- test failure and partial-deletion states;
- test legal-hold behavior;
- independently review the design.
