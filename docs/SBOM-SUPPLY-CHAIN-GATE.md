# SBOM and supply-chain gate

## Status

Architecture/release contract. SBOM generation and supply-chain verification are **NOT YET IMPLEMENTED** and this document does not approve production release.

## Objective

Maintain reproducible evidence of the software components used to build Verdad Oculta, including direct and transitive dependencies and CI actions, without introducing unnecessary tooling or weakening the existing build pipeline.

## Required evidence before production

- Direct application dependencies are pinned or otherwise constrained to reviewed versions.
- The resolved dependency graph is captured from the actual CI build environment.
- An SBOM is generated in a machine-readable format such as SPDX or CycloneDX.
- The SBOM identifies direct and transitive components where the selected generator supports them.
- GitHub Actions and their pinned references are included in supply-chain review; mutable major-version tags are not treated as immutable provenance.
- Dependency licenses are identified and reviewed for production distribution.
- Known vulnerability findings are reviewed rather than automatically ignored.
- Dependency updates are introduced through controlled changes and must pass the existing CI gates.
- SBOM generation itself must not consume or expose sensitive disclosure content.
- Release artifacts must be traceable to the source commit, toolchain version and dependency resolution used to build them.

## Controlled updates

Dependabot is configured for the Flutter `pub` ecosystem and GitHub Actions. Update pull requests remain subject to the repository's normal review, security gates, static analysis, tests and affected-platform build validation.

Automated dependency updates must never be merged merely because an update is available. Security impact, compatibility, provenance, licensing and CI evidence remain required.

## Flutter dependency evidence

The current application declares exact direct versions for `crypto` and `file_picker`. The CI workflow resolves dependencies with the pinned Flutter toolchain before analysis, testing and the Web release build.

A generated `pubspec.lock` is not currently present in the repository. This means the current CI does not yet provide a committed, reviewable resolved dependency graph. Production supply-chain approval therefore remains blocked until the project establishes a deliberate lockfile/reproducibility policy and generates the corresponding SBOM evidence.

## GitHub Actions provenance

The current workflow uses third-party actions by major-version references. This is acceptable for the current prototype CI but is insufficient as final production provenance evidence. Before production release, action references should be reviewed and, where appropriate, pinned to immutable commit SHAs with a documented update process.

## Fail-closed release rule

Missing, stale or unverifiable SBOM/provenance evidence blocks production release. The project must not claim supply-chain verification from the existence of this document alone.
