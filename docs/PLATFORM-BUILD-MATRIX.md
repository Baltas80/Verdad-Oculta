# Platform build matrix

Verdad Oculta is designed as a multiplatform Flutter project. Local development hardware is now available; cloud CI remains the authoritative environment for reproducible validation and production artifacts.

| Target | CI environment | Output / validation |
|---|---|---|
| Android | Linux | APK/AAB, analyze, tests |
| Web | Linux | Release web bundle, analyze, tests |
| Windows | Windows | Windows release build |
| Linux | Ubuntu | Linux release build |
| macOS | macOS | macOS release build |
| iOS | macOS | iOS build validation |

## Rules

- Production artifacts must be generated only by CI after tests and static analysis pass.
- Signing credentials must never be committed to the repository.
- Release signing is a separate controlled step from ordinary CI.
- iOS/macOS signing requires the appropriate Apple credentials and certificates in protected CI secrets.
- Platform-specific security implementations must remain behind stable interfaces.
- A failed platform build blocks the corresponding release artifact.

## Current limitation

The repository currently contains the Flutter application source and CI definition, but not every generated platform directory. These directories must be generated with the pinned Flutter toolchain before platform artifacts can be claimed as buildable.

Local hardware availability does not change this rule: a platform is considered buildable only after an actual reproducible build/validation has passed.
