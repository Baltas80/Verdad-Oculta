# Platform Architecture

## Target platforms
Android, iOS/iPadOS, Web, Windows, macOS and Linux.

## Product surfaces
1. Informant client: mobile + web, with desktop support where justified.
2. Investigation console: browser-first, with optional desktop packaging.
3. Backend: independent API, encrypted object storage and minimal operational database.

## Engineering rules
- Shared presentation and domain code where practical.
- Platform-specific security adapters behind stable interfaces.
- No secrets in source control.
- No dynamic dependency versions.
- No custom cryptographic primitives.
- Sensitive content must not enter analytics, telemetry or ordinary application logs.
- Security-sensitive code requires tests and review before release.

## Initial module boundaries
- app/informant
- app/investigation
- packages/design_system
- packages/security_core
- packages/secure_storage
- packages/case_protocol
- backend/api
- backend/storage
- backend/audit

The exact framework and versions must be pinned after validating the current stable toolchain and its security-maintenance posture.
