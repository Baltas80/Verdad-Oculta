# Release gates

No public release is considered production-ready until all applicable gates are green.

## Gate A — source quality

- Flutter analyze passes.
- Unit/widget tests pass.
- No plaintext secrets in source.
- Dependency versions are reviewed and pinned where practical.

## Gate B — platform builds

- Android release build succeeds.
- Web release build succeeds.
- Windows release build succeeds.
- Linux release build succeeds.
- macOS release build succeeds.
- iOS build validation succeeds.

## Gate C — security

- Threat model reviewed.
- Cryptographic design reviewed.
- Key management reviewed.
- Secure storage tested on supported platforms.
- Transport controls tested.
- Metadata minimization tested against representative files.
- Sensitive logging and telemetry review completed.
- Access-control and investigator audit model tested.
- Independent security assessment completed.

## Gate D — operational readiness

- Backup and recovery policy reviewed.
- Incident response procedure documented.
- Data retention/deletion policy documented.
- Privacy documentation reviewed for the actual implementation.
- Release signing performed through protected credentials.

## Current release status

Prototype only. Real informant submissions remain disabled until the security gates are satisfied.
