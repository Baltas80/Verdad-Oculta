# Self-protection and access revocation

## Objective

The Verdad Oculta client must detect tampering and protect sensitive operations without attempting to damage, disable, or penetrate the device or network of a suspected attacker.

## Threat levels

- `normal`: no relevant anomaly.
- `suspicious`: anomaly detected; sensitive operations may be rate-limited or require revalidation.
- `compromised`: client integrity or protocol guarantees are not trusted; sensitive operations are denied.
- `revoked`: the cryptographic client credential is revoked and cannot establish a trusted session until controlled re-enrollment/recovery.

## Detection signals

The implementation may evaluate:

- application/package signature and integrity;
- unexpected client modification;
- unsupported or revoked application versions;
- debugging/instrumentation indicators where platform APIs permit reliable detection;
- abnormal protocol behaviour;
- repeated authentication or protocol failures;
- credential replay or other server-side abuse signals.

No single weak signal is treated as proof of compromise. High-impact revocation should require corroboration or authorized administrative action where practical.

## Response sequence

For a high-confidence security event:

1. stop sensitive operations;
2. never fall back to plaintext or a weaker protocol;
3. invalidate active sessions/tokens where appropriate;
4. revoke the affected cryptographic client credential/key;
5. apply server-side rate limits and network controls;
6. retain only the minimum security telemetry needed for investigation;
7. require controlled re-enrollment/recovery before restoring trust.

## IP addresses

IP blocking may be used as a temporary abuse-control measure, preferably with expiry and rate limits. A permanent IP ban is not a reliable identity control because addresses can be dynamic, shared, NATed, reassigned, or hidden behind VPN/Tor/proxies.

## Device/client identity

A device identifier supplied by an application is not sufficient as a permanent security identity because it can be reset, changed, spoofed, or unavailable under platform privacy restrictions.

For durable revocation, use a server-recognised cryptographic client credential/key protected by the platform where possible. The credential must not reveal the informant's real-world identity. Exact attestation and key-lifecycle mechanisms require security review before production.

## Prohibited responses

The client and backend must not:

- shut down or lock the user's operating system;
- delete unrelated user data;
- damage or disable another device;
- attack an originating IP or external system;
- attempt unauthorised access to an attacker's device;
- use counterattack payloads.

## Privacy constraint

Security telemetry must be minimised. IP addresses and device-related signals must only be retained for a documented security purpose and for the minimum justified period. Retention and legal basis must be defined before production deployment.

## Production gate

This document defines the policy. Production implementation requires reviewed protocol and key lifecycle, platform-specific protection, server-side revocation storage, rate limiting, abuse detection, audit controls, and independent security review.
