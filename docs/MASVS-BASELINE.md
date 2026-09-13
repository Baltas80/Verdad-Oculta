# Verdad Oculta — OWASP MASVS Baseline

## Purpose

Use the current OWASP Mobile Application Security Verification Standard (MASVS) as the mobile security baseline. This is a project tracking document, not a claim of compliance.

OWASP currently organizes MASVS around storage, cryptography, authentication/authorization, network communication, platform interaction, code quality, resilience and privacy.

## Baseline mapping

| Area | Project requirement | Status |
|---|---|---|
| MASVS-STORAGE | No sensitive plaintext in ordinary storage; secure platform key storage | Design / not verified |
| MASVS-CRYPTO | Established strong cryptography; reviewed key lifecycle | Design gate |
| MASVS-AUTH | Investigator and optional informant-contact authentication model | Not implemented |
| MASVS-NETWORK | TLS and authenticated application protocol; no plaintext fallback | Not implemented |
| MASVS-PLATFORM | Minimize permissions and secure platform integration | Partial prototype |
| MASVS-CODE | Static analysis, tests, dependency pinning and secure update process | Partial / CI active |
| MASVS-RESILIENCE | Tamper/reverse-engineering requirements for production threat model | Not assessed |
| MASVS-PRIVACY | Data minimization, no unnecessary tracking/telemetry and separation of identity/content | Design / partial |

## Mandatory verification evidence

Before accepting real sensitive disclosures, each applicable control must have evidence such as code review, automated test, platform test, configuration inspection, penetration/security testing or independent review. A design statement alone does not count as verification.

## Specific storage requirements

- Cryptographic keys must not be hardcoded in the application package.
- Long-lived local key material must use platform secure storage where applicable.
- Sensitive data must not be written to public/shared storage in plaintext.
- Backups, crash reporting, logs and support tooling must be reviewed for unintended sensitive-data exposure.

## Specific cryptography requirements

- No custom cryptographic algorithms or protocols.
- Use maintained implementations of established primitives.
- Define key generation, storage, use, rotation, revocation, recovery and destruction before implementation.
- Authentication/integrity failure must prevent plaintext release.
- Protocol/version failures must fail closed rather than downgrade.

## Verification rule

A control remains **NOT VERIFIED** until reproducible evidence exists. Passing unit tests alone is not sufficient evidence for platform keystore behaviour, network configuration or an independent security review.

## References

- OWASP MASVS
- OWASP MASTG
- Project `THREAT-MODEL.md`
- Project `SECURITY-IMPLEMENTATION-GATE.md`
- Project `KEY-LIFECYCLE.md`
