# Security implementation gate

The informant client is a disclosure prototype until every gate below is satisfied.

## Required before production submissions

- Threat model reviewed and versioned.
- Cryptographic protocol selected from established, reviewed standards and maintained implementations.
- Key lifecycle defined: generation, storage, rotation, recovery and destruction.
- Sensitive data never enters logs, analytics, crash telemetry or URLs.
- Metadata minimization verified for each supported media type.
- Secure local storage verified on every target platform.
- Transport security configured and tested.
- Server cannot derive informant identity from case content or ordinary operational records.
- Encrypted object storage and access controls independently tested.
- Anonymous reply channel threat model completed.
- Abuse prevention designed without creating unnecessary identity records.
- Dependency versions pinned and software bill of materials generated.
- Static analysis, tests and platform builds pass in CI.
- Independent security review completed before accepting real sensitive disclosures.

## Fail-closed rule

If a required security capability is unavailable, the production submission path must stop. It must never silently fall back to plaintext, weaker encryption, or a mode that exposes identity.

## Current status

Prototype / local demonstration. No real sensitive information should be submitted through the current build.
