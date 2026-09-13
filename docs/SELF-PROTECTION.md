# Self-protection and abuse response

## Objective

The Verdad Oculta client must detect tampering and protect sensitive operations without attempting to damage, disable, or penetrate the device or network of a suspected attacker.

## Detection signals

The implementation may evaluate:

- application/package signature and integrity;
- unexpected client modification;
- unsupported or revoked application versions;
- debugging/instrumentation indicators where platform APIs permit reliable detection;
- abnormal protocol behaviour;
- repeated authentication or protocol failures.

No single signal is treated as proof of compromise.

## Response

For a high-confidence security event, the preferred response is:

1. stop sensitive operations;
2. avoid transmitting plaintext or weaker fallback data;
3. revoke the affected client credential/key where applicable;
4. invalidate active sessions/tokens;
5. apply server-side rate limits and network controls;
6. retain only the minimum security telemetry needed for investigation.

## IP addresses and device identifiers

IP blocking may be used as a temporary abuse-control measure, preferably with expiry and rate limits. A permanent IP ban is not a reliable identity control because addresses can be dynamic, shared, NATed, reassigned, or hidden behind VPN/Tor/proxies.

A device identifier supplied by an application is also not sufficient as a permanent security identity because it can be reset, changed, spoofed, or unavailable under platform privacy restrictions.

For durable revocation, use a server-recognised cryptographic client credential/key with a revocation record. The credential must not reveal the informant's real-world identity.

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
