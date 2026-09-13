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
9. Substitution or misdistribution of the investigation service public key.
10. Incorrect envelope canonicalization, versioning or associated-data handling.
11. Key reuse, weak randomness, incorrect key lifecycle or unsafe key retention.
12. Partial or corrupted ciphertext being accepted as valid evidence.

## Security objectives

- Minimize identity collection.
- Protect content before server-side storage.
- Keep identity and case content logically separate.
- Minimize metadata at the earliest practical point.
- Make privileged access auditable.
- Fail closed when required security capabilities are unavailable.
- Make security limitations explicit to informants.
- Ensure the recipient public key is authenticated and pinned through a separately reviewed trust mechanism.
- Use an independently specified, versioned envelope format with authenticated integrity checks.
- Prevent cryptographic key reuse across unrelated cases and prevent plaintext fallback.

## Envelope-specific controls to verify before implementation

The candidate construction in `ENVELOPE-ENCRYPTION-PROTOCOL.md` must not be implemented in production until all of the following are evidenced:

- recipient public-key authenticity, distribution and rotation procedure;
- exact envelope encoding and canonicalization;
- authenticated-associated-data definition;
- fresh per-case content-key generation and lifecycle;
- authenticated encryption and complete-stream finalization checks;
- deterministic rejection of malformed, truncated, reordered or tampered envelopes;
- cross-language interoperability using non-sensitive test vectors;
- dependency provenance, pinned versions and reproducible builds;
- key-memory handling and disposal behavior on every supported client platform;
- service-side private-key custody and access controls.

The threat model must treat the envelope as an additional control layer, not as a replacement for secure transport, endpoint security, metadata minimization, server isolation or investigator authorization.

## Important limitation

No client application can guarantee anonymity against a fully compromised endpoint. The architecture therefore minimizes exposure and assumes that endpoint compromise remains a residual risk.

## Review status

Initial threat model extended with envelope-encryption risks. Must receive formal security review and be expanded before production launch.
