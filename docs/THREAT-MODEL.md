# Verdad Oculta — Threat Model

## Assets

- Informant identity and contact information.
- Submitted documents, images, video, audio and text.
- Case tracking credentials and reply-channel secrets.
- Cryptographic keys and protocol state.
- Investigation metadata and access records.

## Primary threats

1. Device compromise before or during submission.
2. Network observation or manipulation.
3. Server compromise and database/object-storage theft.
4. Metadata leakage through files, logs, telemetry or URLs.
5. Correlation of case activity with identity.
6. Unauthorized investigator access.
7. Malicious or compromised dependencies and build infrastructure.
8. Accidental disclosure through backups, crash reports or support tooling.

## Security objectives

- Minimize identity collection.
- Protect content before server-side storage.
- Keep identity and case content logically separate.
- Minimize metadata at the earliest practical point.
- Make privileged access auditable.
- Fail closed when required security capabilities are unavailable.
- Make security limitations explicit to informants.

## Important limitation

No client application can guarantee anonymity against a fully compromised endpoint. The architecture therefore minimizes exposure and assumes that endpoint compromise remains a residual risk.

## Review status

Initial threat model. Must be reviewed and expanded before production launch.
