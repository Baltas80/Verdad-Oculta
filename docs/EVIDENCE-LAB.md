# Evidence Laboratory

## Purpose

The Evidence Laboratory is an isolated analysis environment for untrusted files received by Verdad Oculta. The production API, encrypted evidence store, and investigator workstation must not execute untrusted submissions directly.

## Trust boundary

`Informant client -> encrypted intake -> quarantine -> analysis broker -> isolated lab -> findings -> investigator`

The lab receives controlled copies or derived representations. The original evidence remains preserved and encrypted according to the case retention policy.

## Analysis tiers

### Tier 0 — never execute

Use static analysis only for file types or cases where execution creates disproportionate risk. Examples include unknown executables, highly suspicious samples, and files selected by policy for static-only handling.

### Tier 1 — isolated document/media analysis

For common documents and media, perform parser and structure checks in a restricted worker. No host credentials, no production network, no investigator workstation access.

### Tier 2 — disposable sandbox

High-risk files may be opened in a disposable VM or microVM with:

- no route to the production network;
- no access to host credentials or personal files;
- tightly controlled virtual hardware;
- restricted or simulated external services;
- resource quotas for CPU, memory, disk, and runtime;
- snapshot/revert lifecycle;
- automatic destruction after the analysis window.

### Tier 3 — specialized detonation

Exceptional samples may require a separately controlled malware-research environment. This environment is operationally isolated from the main evidence platform and is not a general-purpose browsing or execution service.

## Network policy

The default sandbox network state is **deny**. Any controlled network simulation or observation must be explicitly enabled by policy. Direct access to internal services, management interfaces, credentials, metadata stores, or investigator systems is prohibited.

## Output model

The laboratory emits structured findings such as:

- cryptographic file hashes;
- format/type identification;
- malware scanner results;
- parser/structural anomalies;
- observed process/network indicators;
- risk classification;
- analysis timestamp and tool/version identifiers.

It should not copy unbounded sandbox output into application logs.

## Reproducibility and evidence integrity

Each analysis job references an immutable evidence hash. Tool versions and analysis configuration are recorded sufficiently to reproduce the decision without exposing the informant identity.

The original object is never modified by an analysis worker.

## Resource controls

Controls must include per-file, per-batch, and per-case limits for:

- upload size;
- extracted size;
- file count;
- archive nesting depth;
- runtime;
- CPU and memory;
- outbound requests.

## Failure handling

A crashed, timed-out, or compromised worker is discarded. Failure must not cause plaintext fallback or make the original evidence available to the investigator.

## Security boundary

A virtual machine is an additional containment layer, not an absolute security guarantee. Hypervisor and guest escape vulnerabilities remain possible. The platform therefore uses layered isolation and keeps high-risk operations away from production systems.

## Software strategy

The lab should prefer mature, actively maintained, security-reviewed components for virtualization, sandboxing, malware analysis, file identification, archive processing, and media/document parsing. Exact products and versions must be selected during implementation and tracked in the software manifest/SBOM.

No custom malware-detection engine or custom hypervisor should be developed merely for this project.

## Production gate

The Evidence Laboratory must undergo dedicated threat modeling, isolation testing, resource-exhaustion testing, escape testing, dependency review, and independent security assessment before real hostile files are analyzed.
