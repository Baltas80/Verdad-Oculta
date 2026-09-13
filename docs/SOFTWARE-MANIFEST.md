# Security software strategy

This project should reuse mature security software rather than implement equivalent low-level components from scratch.

## Candidate components

| Function | Candidate | Role | Status |
|---|---|---|---|
| Antivirus scanning | ClamAV | Signature-based malware screening in quarantine | Evaluate/integrate |
| Rule matching | YARA | File/pattern classification and triage | Evaluate/integrate |
| Dynamic analysis | CAPE Sandbox | Controlled malware behavior analysis | Evaluate/integrate |
| General virtualization | QEMU + KVM where available | Full VM isolation for higher-risk analysis | Evaluate/integrate |
| Lightweight isolation | Firecracker | MicroVM isolation for suitable Linux workloads | Evaluate/integrate |
| File identification | libmagic/file-type detection | Identify content from bytes, not filename alone | Evaluate/integrate |
| Hashing | Platform/standard cryptographic libraries | SHA-256 and related integrity identifiers | Approved approach; exact library to be selected |

## Selection principles

- Prefer actively maintained, security-focused open-source software with clear licensing.
- Pin versions for production builds and track them in the SBOM.
- Keep scanners and sandboxes isolated from the main application and evidence store.
- Do not upload confidential evidence to third-party scanning services unless a future legal/security review explicitly approves that data path.
- Multiple independent detections are preferred for high-risk files.
- No component is treated as an absolute guarantee of safety.

## Current research notes

QEMU provides full-system emulation and can use accelerators such as KVM on Linux and Hypervisor Framework on macOS. Firecracker provides minimal KVM-based microVMs with a deliberately small virtual device surface and a separate jailer layer. YARA is designed for pattern-based identification and classification of malware samples. CAPE provides a sandbox workflow for dynamic analysis.

## Important boundary

This manifest records candidates, not a claim that every component has already been installed or integrated. Exact versions, configurations, licenses, update policy, and security review are required before production use.
