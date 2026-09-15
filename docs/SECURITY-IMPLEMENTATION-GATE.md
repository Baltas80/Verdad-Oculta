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

The latest verified Flutter CI evidence is:

- Flutter CI run #78 for commit `3981f56ff23e8896a9fb04f824a1c4fc9542b8c7` completed successfully on 2026-09-14.
- The `analyze-and-test` job completed successfully, including dependency resolution, static analysis, tests and the Web release build.
- The test-only regression correction ensures the local demo does not present local preparation as a completed disclosure transmission.
- The server-side quarantine contract is documented with explicit fail-closed behavior.
- A reviewable quarantine resource-limit baseline is documented; it is not production configuration.
- The threat model includes envelope-encryption-specific threats and controls.
- The envelope-encryption protocol remains a design proposal and is explicitly not approved for production.
- The envelope interoperability vector contract is documented using synthetic, non-sensitive fixtures and explicitly requires independent interoperability evidence before production approval.
- The client dependency declarations currently pin the direct `crypto` and `file_picker` versions.

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
