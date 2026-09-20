# Backend strategy: mature secure intake first

**Status: DECISION PROPOSAL — NOT PRODUCTION**

## Objective

Accelerate Verdad Oculta without recreating a secure whistleblowing backend from scratch.

## Candidate

Evaluate self-hosted **GlobaLeaks 5.0.99** as the secure intake and correspondence engine.

The current GlobaLeaks security documentation describes a Python backend with a REST API, Tor-based anonymity support, minimized sensitive metadata logging, encrypted reports/attachments/messages, RBAC, rate limiting, AppArmor/firewall hardening, and a security-oriented architecture. It also publishes SBOM material and security documentation.

Source references:

- https://docs.globaleaks.org/en/devel/technical/security/application-security.html
- https://docs.globaleaks.org/en/devel/getting-started/introduction.html
- https://github.com/globaleaks/globaleaks-whistleblowing-software

## Proposed Verdad Oculta architecture

```
Verdad Oculta Flutter client
        |
        | narrow integration adapter
        v
GlobaLeaks secure intake/correspondence
        |
        +--> protected report/evidence
        |
        +--> anonymous receipt/correspondence
        |
        v
Verdad Oculta review/publication layer
        |
        +--> approved PUBLIC derivative
        +--> approved MEMBER ARCHIVE derivative
        +--> protected original remains isolated
```

The public archive, membership system, publication workflow and Verdad Oculta-specific classification remain separate from the secure intake engine.

## Why this can reduce risk and time

GlobaLeaks already implements security-sensitive mechanisms that would otherwise require a large custom backend. Reusing a mature project narrows the amount of new security-critical code that Verdad Oculta must own.

The objective is not to assume that GlobaLeaks automatically satisfies every Verdad Oculta requirement. It must be evaluated as a dependency and deployment component.

## Mandatory compatibility review

Before adoption, verify:

1. exact 5.0.99 source and dependency provenance;
2. SBOM and current security advisories;
3. anonymous receipt/correspondence semantics;
4. Tor Onion Service deployment;
5. data retention/deletion behavior;
6. export and derivative boundaries;
7. API surface required by the Flutter client;
8. identity/content separation;
9. investigator/RBAC model;
10. audit logging and metadata retention;
11. file-size and attachment limits;
12. quarantine/malware-analysis integration boundary;
13. backup and restore behavior;
14. deployment isolation and host hardening;
15. licensing and operational obligations.

## Non-negotiable integration rules

- Do not expose GlobaLeaks protected originals to the membership/publication subsystem.
- Do not copy confidential originals into a second database unless strictly necessary and separately protected.
- Keep publication derivatives logically and cryptographically separated from protected originals.
- Payment/entitlement events must never become a direct path to protected source material.
- The Flutter app must not implement a second parallel security backend.
- No custom cryptography is introduced merely to bridge the systems.
- All adapter requests must use strict schemas, bounded input and least privilege.
- Secrets remain outside source control.
- Production acceptance remains blocked until the combined threat model and independent security review are complete.

## Decision gate

Adopt GlobaLeaks only if the compatibility/security review shows that the combination has a smaller and more auditable trusted computing base than a bespoke intake backend.

If adopted, the implementation target becomes:

**Flutter UX + narrow adapter + hardened self-hosted GlobaLeaks + separate publication/membership layer**

rather than:

**Flutter UX + custom whistleblower backend + custom encryption + custom correspondence + custom file security**

## Current status

This proposal does not enable production submissions. It is a time/risk reduction strategy for the implementation phase.
