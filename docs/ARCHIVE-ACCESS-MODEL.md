# Verdad Oculta — Archive Access Control Model

## Status

Design baseline. No production authorization system is implemented by this document.

## Security domains

Verdad Oculta separates four domains:

1. **Informant domain** — anonymous disclosure and case references.
2. **Investigation domain** — authorized handling of protected cases.
3. **Member domain** — authenticated access to approved member material.
4. **Public domain** — unauthenticated access to approved public material.

A user's existence in one domain must not automatically grant access to another.

## Classification matrix

| Classification | Public | Member | Investigator | System security role |
|---|---:|---:|---:|---:|
| `PUBLIC` | Read | Read | Read | Manage |
| `MEMBER_ARCHIVE` | No | Read | Read | Manage |
| `RESTRICTED` | No | No | Controlled | Manage |
| `CONFIDENTIAL` | No | No | Controlled, least privilege | Manage |

The exact investigator roles and service accounts require a separate authorization design.

## Non-negotiable rules

- Authorization is enforced server-side.
- The client must never unlock archive content by checking a local subscription flag.
- A payment provider webhook may update an entitlement, but it must not grant access directly to content storage.
- Content delivery requires an authorization decision for the specific object and classification.
- Protected originals are stored separately from publication derivatives.
- Member access can only resolve to explicitly approved `MEMBER_ARCHIVE` objects.
- Public endpoints can only resolve to explicitly approved `PUBLIC` objects.
- Predictable object paths must not expose protected originals.
- Search indexes must contain only fields appropriate to the user's authorization level.
- Caches, thumbnails, previews and CDN objects inherit the source object's maximum classification unless an independently approved derivative exists.

## Membership boundary

Membership is an entitlement, not a content classification.

A member tier such as `MEMBER`, `INVESTIGATOR` or `SUPPORTER` may map to a defined set of capabilities, but content must still carry an independent classification and publication approval.

This prevents a future payment-tier change from accidentally exposing confidential evidence.

## Access decision

Conceptually:

`ALLOW = authenticated_subject + active_entitlement + object_classification + explicit_policy + case_state`

For public material, authentication may be absent. For member material, an authenticated account and active entitlement are required. For confidential material, membership is never sufficient.

The real implementation must use a server-side authorization policy rather than this formula as executable security logic.

## Audit

Privileged investigation access should generate minimal security audit events containing only what is required for accountability. Sensitive content, source identity, document text and unnecessary metadata must not enter ordinary logs.

## Failure behavior

- Missing entitlement: deny.
- Expired entitlement: deny.
- Unknown classification: deny.
- Missing approval: deny.
- Object not found or unauthorized: return an indistinguishable safe response where appropriate to prevent enumeration.
- Authorization service unavailable: deny sensitive access.

## Privacy

Membership records are separate from anonymous disclosure records. No product analytics or personalization may create a hidden association between a member account and an anonymous case.

Sensitive local archive data must also follow secure-storage requirements; OWASP specifically warns against unencrypted sensitive storage and insecure handling of keys. citeturn0search0turn0search9

## Future implementation gate

Before production member access:

- server-side authorization implemented;
- negative authorization tests for every classification;
- object-storage isolation verified;
- cache/CDN/preview behavior verified;
- subscription webhook authenticity verified;
- entitlement revocation tested;
- audit logging reviewed for data minimization;
- independent security review completed.
