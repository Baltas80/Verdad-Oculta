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

## Current evidence snapshot

The following evidence is currently available in the repository:

- Flutter CI run #81 verified dependency resolution, static analysis, tests and a Web release build for master commit `87df90fa8e05ccc7f0450d2a7be7a050bc746d93`.
- Flutter CI run #82 verified dependency resolution, static analysis, tests and a Web release build for architecture commit `a4b19ee78e2dfca2b2af16f596bf8de66197448e`.
- The server-side quarantine contract is documented with explicit fail-closed behavior.
- A reviewable quarantine resource-limit baseline is documented; it is not production configuration.
- The threat model includes envelope-encryption-specific threats and controls.
- The envelope-encryption protocol remains a design proposal and is explicitly not approved for production.
- The client dependency declarations currently pin the direct `crypto` and `file_picker` versions.
- The authorization architecture defines default-deny behavior, separated security domains, classification boundaries and mandatory negative tests.

The following gates remain **OPEN / NOT SATISFIED** and must not be inferred from the evidence above:

- production cryptographic implementation and independent review;
- service-side key custody and rotation/recovery controls;
- server-side quarantine implementation and untrusted-file analysis;
- authenticated transport and encrypted object storage;
- verified secure local storage across every supported platform;
- metadata minimization validation for every supported media type;
- anonymous reply-channel design and implementation;
- SBOM generation and supply-chain verification;
- Android, iOS, Windows, macOS and Linux release-build evidence;
- independent security review.

## Fail-closed rule

If a required security capability is unavailable, the production submission path must stop. It must never silently fall back to plaintext, weaker encryption, or a mode that exposes identity.

## Current status

**Prototype / local demonstration. Production gate CLOSED.** No real sensitive information should be submitted through the current build.
