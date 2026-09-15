# Implementation roadmap

**Status: controlled planning — production remains blocked**

This roadmap prevents feature-first development from outrunning the security model. Work is completed only when the relevant evidence exists.

## Gate 0 — Design and repository baseline

- Approved visual identity remains locked.
- Repository structure and CI are understood.
- Security and authorization contracts are versioned.
- No production submission path is enabled.

**Current:** substantially satisfied.

## Gate 1 — Authorization policy

- Define actor/resource/action matrix.
- Implement default-deny policy as a deterministic server-side component.
- Add positive and negative authorization tests.
- Prove membership never grants confidential-original access.
- Prove case references are not credentials.

**Current:** policy documented; executable server policy and tests remain open.

## Gate 2 — Cryptographic envelope

- Select maintained, reviewed primitives.
- Define versioned envelope format.
- Define key hierarchy, generation, storage, rotation and destruction.
- Define authenticated encryption and associated-data rules.
- Add interoperability and corruption/replay tests.
- Independent review before production use.

**Current:** design only; no production cryptographic implementation approved.

## Gate 3 — Intake quarantine

- Receive into an isolated quarantine boundary.
- Enforce request and resource limits before parsing.
- Hash original bytes before transformation.
- Validate actual file type.
- Defend against traversal, decompression bombs and nested archives.
- Scan/analyse untrusted material in isolation.
- Never execute informant files in the production application process.
- Store only after classification and required encryption.

**Current:** contracts documented; implementation and operational validation remain open.

## Gate 4 — Storage and retention

- Encrypt sensitive objects before durable storage.
- Separate identity, content, correspondence and publication domains.
- Apply least-privilege object authorization server-side.
- Define retention/deletion semantics across primary storage, replicas and backups.
- Ensure search, thumbnails, caches and telemetry cannot expose confidential material.

**Current:** architecture documented; production implementation remains open.

## Gate 5 — Anonymous correspondence

- Implement independent high-entropy reply capability.
- Store only a verifier, never plaintext capability.
- Expiry, revocation, rotation and rate limiting.
- Non-enumerating errors.
- Replay/idempotency controls.
- Authenticated encryption for messages.
- Fail closed on missing cryptographic state.
- Security review before production.

**Current:** protocol documented; implementation remains open.

## Gate 6 — Client security and platform adapters

- Secure local storage per platform.
- Metadata minimization for supported file/media types.
- No sensitive data in logs, analytics, crash reports or URLs.
- Minimum permissions.
- Platform-specific security behind stable interfaces.
- Verify Android, iOS/iPadOS, Web, Windows, macOS and Linux independently.

**Current:** Flutter client exists; platform evidence remains incomplete.

## Gate 7 — Verification and release

- Static analysis passes.
- Tests pass.
- Security tests pass.
- Required platform builds pass.
- Dependencies are pinned and reviewed.
- SBOM generated and reviewed.
- Threat model updated from implementation evidence.
- Independent security review completed.
- Production gate explicitly approved.

**Current:** not satisfied.

## Development rule

Do not implement a later gate when doing so would create a production dependency on an unsatisfied earlier security gate. Demo/local functionality may exist, but must be clearly labelled and must not silently communicate with production systems.

## Evidence rule

A documented intention is not evidence of implementation. A passing CI run proves only the checks that actually executed. A platform is not marked buildable until an actual reproducible build succeeds. A security control is not marked satisfied until it has implementation evidence and the required review.
