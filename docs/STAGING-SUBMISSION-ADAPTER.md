# Staging submission adapter gate

The production client does not send submissions yet.

The next implementation must use a dedicated staging GlobaLeaks endpoint and a narrow adapter with these operations only:

- `health()`
- `getSubmissionContext()`
- `submitSynthetic()`
- `authenticateReceipt()`
- `listCorrespondence()`
- `sendCorrespondence()`
- `uploadSyntheticAttachment()`

Constraints:

1. Endpoint must be configured explicitly; no arbitrary URL supplied by a report or deep link may become a backend endpoint.
2. HTTPS/Tor transport policy is enforced by the adapter.
3. Receipts are secrets and must never enter logs, analytics, URLs or crash reports.
4. The adapter must not persist report contents or attachments outside the secure intake system.
5. Only synthetic staging data may be submitted during this phase.
6. Production submission remains disabled until the E2E checklist passes.
7. Backend error responses are normalized; internal paths, tokens and server diagnostics are not exposed to the client.

This document is the implementation gate, not a claim that real submission is enabled.
