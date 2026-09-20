# GlobaLeaks intake integration contract

**Status: DESIGN / STAGING CONTRACT — NOT PRODUCTION**

This contract defines the smallest adapter that Verdad Oculta should own if the project adopts self-hosted GlobaLeaks as the secure intake and correspondence engine. The adapter must not reimplement GlobaLeaks security-sensitive internals.

## Selected external boundary

GlobaLeaks 5.0.99 exposes a REST API with whistleblower routes including:

- `/api/auth/receiptauth`
- `/api/whistleblower/submission`
- `/api/whistleblower/submission/attachment`
- `/api/whistleblower/wbtip`
- `/api/whistleblower/wbtip/comments`
- `/api/whistleblower/wbtip/wbfiles`

The public server also exposes context/configuration data used to construct a submission.

GlobaLeaks documents anonymous whistleblower access through a randomly generated 16-digit receipt. The receipt is the access credential for the submitted report and is not recoverable by the organization. The implementation also hashes receipt material at rest and includes controls intended to reduce the lifetime of cleartext receipt material.

## Verdad Oculta boundary

The Flutter client should not depend directly on the full GlobaLeaks object model.

Use a narrow adapter with application concepts such as:

```
Verdad Oculta Draft
  -> Validate local pre-flight
  -> Adapter prepare/submit
  -> External receipt/capability
  -> Local presentation reference
```

The adapter is responsible only for protocol mapping, transport policy, error normalization and compatibility.

It must not:

- bypass GlobaLeaks authorization;
- store protected originals;
- duplicate confidential content into a second database;
- invent an alternative encryption protocol;
- expose GlobaLeaks internal IDs as public Verdad Oculta references;
- accept client-supplied roles or permissions;
- place secrets in URLs or logs.

## Submission mapping

The production mapping must be verified against the exact deployed GlobaLeaks version before implementation.

Known request fields for the submission endpoint include:

```
context_id
receivers
identity_provided
answers
receipt
```

Verdad Oculta should keep its own UI/domain model separate from these transport fields.

The default maximum-anonymity mode should map to no contributor identity fields. Any optional contact mode requires an explicit, separately reviewed identity path.

## Receipt / capability handling

GlobaLeaks provides a 16-digit anonymous receipt. Verdad Oculta must treat this value as a secret credential.

The client must:

- show it only when necessary;
- avoid logging it;
- avoid analytics/crash telemetry;
- never place it in URLs;
- make clear that loss can prevent recovery of the anonymous channel;
- separate the user-facing case reference from the secret credential.

Whether a second Verdad Oculta capability is required remains a threat-model decision. Do not add a second credential layer merely for convenience.

## Correspondence mapping

GlobaLeaks exposes the whistleblower report and comments through its whistleblower endpoints.

Verdad Oculta should expose only the application-level correspondence operations:

- retrieve messages;
- send reply;
- upload permitted follow-up evidence;
- download permitted responses.

The adapter must normalize GlobaLeaks errors into non-enumerating application outcomes and must not expose backend implementation details to the informant.

## File mapping

The current Flutter client performs only local pre-flight checks. These remain advisory.

GlobaLeaks or the hardened server-side intake boundary remains authoritative for:

- payload limits;
- MIME/type validation;
- storage;
- encryption;
- report/file authorization;
- server-side processing.

Verdad Oculta must not execute received files.

Any additional malware-analysis pipeline must be isolated from the protected intake store and must consume controlled copies or streams according to the finalized quarantine architecture.

## Publication and membership boundary

GlobaLeaks protected reports remain outside the public/member archive.

The publication service consumes only explicitly approved derivatives:

```
Protected original
    -> human review
    -> approved derivative
    -> PUBLIC or MEMBER ARCHIVE
```

No payment event, member entitlement, search index, cache, thumbnail or public identifier may grant access to the protected original.

## Required staging tests

Before any production integration:

1. submit a synthetic report;
2. verify anonymous receipt issuance;
3. authenticate with the receipt;
4. verify correspondence;
5. verify attachment upload;
6. verify attachment download authorization;
7. verify malformed requests are rejected;
8. verify oversized payloads are rejected;
9. verify rate limiting / proof-of-work behavior;
10. verify no credentials appear in logs or URLs;
11. verify protected content cannot be fetched without the appropriate backend authorization;
12. verify an entitlement/payment event cannot grant protected access;
13. verify backup/restore handling for sensitive material;
14. verify Tor-only deployment behavior where required;
15. verify the combined threat model and security gate.

## Production decision

Adopt this boundary only after the deployed GlobaLeaks version, exact API payloads, encryption configuration, receipt handling, retention/deletion behavior and integration attack surface have been reviewed.

The fastest safe path is:

**reuse mature secure intake + keep Verdad Oculta custom code narrow.**

References:

- GlobaLeaks 5.0.99 documentation: https://docs.globaleaks.org/en/devel/technical/security/application-security.html
- GlobaLeaks setup documentation: https://docs.globaleaks.org/en/devel/setup/
- GlobaLeaks source: https://github.com/globaleaks/globaleaks-whistleblowing-software
