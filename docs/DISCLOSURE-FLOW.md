# Disclosure flow

## Purpose
Verdad Oculta is designed as a disclosure channel for people who hold information or evidence they believe should be investigated. The product goal is to protect the source while giving the investigation team a verifiable case to review.

## User flow

1. Select evidence type.
2. Describe the information.
3. Select confidentiality level.
4. Protect the package locally.
5. Submit through the secure transport layer.
6. Receive a non-identifying tracking code.
7. Use the secure inbox for follow-up communication.

## Security boundary

The current Flutter interface is a product prototype. The confirmation screen explicitly identifies the local/demo state. No real sensitive submission, cryptographic protection, anonymity guarantee, or investigator backend is claimed until the corresponding security components are implemented and independently reviewed.

## Production requirements

- Client-side encryption for sensitive payloads before upload where the protocol permits it.
- Authenticated transport (TLS) in addition to application-level protection.
- Strict separation between source identity, case content, and operational metadata.
- Metadata minimization before transmission.
- Platform-backed key protection.
- No advertising, tracking, or unnecessary analytics in the informant client.
- No sensitive content in application logs or crash reports.
- Cryptographic protocol review; no custom cryptography.
- Threat model, abuse model, privacy assessment, penetration testing, and independent security review before production disclosure use.
