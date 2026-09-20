# Production submission block

Production intake is intentionally blocked until all of the following are independently verified:

- dedicated production backend and secrets are provisioned outside the repository;
- transport boundary is verified;
- anonymous receipt handling is verified;
- submission and correspondence tests pass with synthetic staging data;
- attachment quarantine and isolation are verified;
- protected originals cannot be reached through public/member paths;
- publication requires explicit approval of a derivative;
- membership/payment state cannot authorize protected storage;
- logs and telemetry contain no report contents or receipt credentials;
- backup, deletion and retention behavior are reviewed;
- legal/privacy review is completed for the actual deployment jurisdiction.

A green Flutter build is necessary but not sufficient for release.
