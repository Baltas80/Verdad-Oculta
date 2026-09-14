# Verdad Oculta — Anonymous Submission Boundary

## Objective

Design the submission path so Verdad Oculta does not need to know the informant's identity in order to receive a disclosure.

## Core principle

> We do not collect an identity merely so that we can promise to protect it later. We minimize identity collection at the architecture level.

The maximum-anonymity submission flow does not require a name, email address, telephone number, membership account or profile.

## Separation

The following domains remain separate:

`INFORMANT SUBMISSION != MEMBER ACCOUNT != INVESTIGATION ACCOUNT`

A case reference is not a user identifier. Membership cannot be used to submit a case through an identity-linked shortcut.

## Data minimization

The submission service must not intentionally collect unnecessary:

- names;
- email addresses;
- telephone numbers;
- contacts;
- GPS location;
- advertising identifiers;
- analytics identifiers;
- unnecessary device identifiers;
- unnecessary filenames or filesystem paths;
- sensitive request headers;
- sensitive URL parameters.

Technical network metadata required by infrastructure must be treated as a separate threat-model and retention problem; the application must not create additional identifying records merely for convenience.

## Encryption boundary

Sensitive content should be protected on the informant device before server-side durable storage using the project's approved cryptographic envelope. Encryption does not by itself guarantee anonymity, so transport, metadata, endpoint and operational controls remain separate requirements.

The current repository encryption design is explicitly a proposal and not approved for production. It requires authenticated public-key distribution, per-case keys, authenticated encryption, key lifecycle controls and independent review before activation.

## Case references

Case references must be generated from cryptographically secure randomness and must not encode:

- identity;
- email;
- timestamp-derived identity information;
- device identifiers;
- filenames;
- membership identifiers.

A tracking reference is not automatically an authentication secret. Any anonymous reply mechanism requires a separate credential design.

## Local handling

Sensitive source material and temporary plaintext should exist locally only for the minimum time necessary. The application must not write sensitive material to shared storage, ordinary logs, analytics, crash telemetry or URLs. OWASP recommends minimizing local sensitive storage and using platform keystores for cryptographic keys. citeturn0search2turn0search9

## Failure behavior

If metadata minimization, encryption, key validation, secure storage or protected transmission cannot be completed, the submission must stop. There must be no plaintext fallback.

## Threat boundary

The platform cannot control a compromised informant device or every external network observation. Those remain explicit residual threats. The product promise should therefore describe what Verdad Oculta itself collects and protects, rather than claiming that no party in the world could ever identify a contributor.

## Production gate

Before accepting real sensitive submissions:

- data-flow mapping verified;
- server/request logging reviewed;
- telemetry and third-party SDKs excluded from the protected flow;
- network metadata strategy reviewed;
- cryptographic envelope independently reviewed;
- secure local storage verified on each supported platform;
- anonymous reply channel separately reviewed;
- penetration/security testing completed.
