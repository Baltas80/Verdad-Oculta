/// Production disclosure submission gate.
///
/// This gate is deliberately closed in every build. Backend health checks,
/// staging configuration, or environment variables must never enable real
/// disclosure submission. Opening this gate requires a separate reviewed
/// change after all security and integration acceptance criteria are proven.
class ProductionSubmissionGate {
  const ProductionSubmissionGate._();

  static const bool isEnabled = false;

  static void requireEnabled() {
    if (!isEnabled) {
      throw const ProductionSubmissionBlocked();
    }
  }
}

/// Raised whenever code attempts a production submission while the gate is shut.
class ProductionSubmissionBlocked implements Exception {
  const ProductionSubmissionBlocked();

  @override
  String toString() =>
      'Production disclosure submission is disabled pending security approval.';
}
