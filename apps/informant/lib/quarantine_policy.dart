/// Reviewable, non-operational quarantine policy contract.
///
/// This model does not inspect, extract, execute, store or transmit files. It
/// exists to make the documented server-side limits explicit and testable
/// without opening a production intake path.
class QuarantineLimits {
  const QuarantineLimits({
    this.maxObjectBytes = 50 * 1024 * 1024,
    this.maxRequestBytes = 100 * 1024 * 1024,
    this.maxObjectsPerCase = 20,
    this.maxArchiveDepth = 3,
    this.maxExpansionRatio = 20,
    this.maxExpandedArchiveBytes = 100 * 1024 * 1024,
    this.maxObjectAnalysisSeconds = 30,
    this.maxCaseAnalysisSeconds = 5 * 60,
    this.maxAnalyzerMemoryBytes = 512 * 1024 * 1024,
  });

  final int maxObjectBytes;
  final int maxRequestBytes;
  final int maxObjectsPerCase;
  final int maxArchiveDepth;
  final int maxExpansionRatio;
  final int maxExpandedArchiveBytes;
  final int maxObjectAnalysisSeconds;
  final int maxCaseAnalysisSeconds;
  final int maxAnalyzerMemoryBytes;

  bool get isValid =>
      maxObjectBytes >= 0 &&
      maxRequestBytes >= 0 &&
      maxObjectsPerCase >= 0 &&
      maxArchiveDepth >= 0 &&
      maxExpansionRatio >= 0 &&
      maxExpandedArchiveBytes >= 0 &&
      maxObjectAnalysisSeconds >= 0 &&
      maxCaseAnalysisSeconds >= 0 &&
      maxAnalyzerMemoryBytes >= 0;
}

enum QuarantineDecision {
  acceptForProcessing,
  reject,
}

/// Metadata-only preflight for the documented resource limits.
///
/// The server must independently enforce these constraints. This helper is
/// deliberately fail-closed: invalid values, invalid policy configuration and
/// boundary violations reject.
QuarantineDecision evaluateQuarantineLimits({
  required int objectBytes,
  required int totalRequestBytes,
  required int objectCount,
  required int archiveDepth,
  required int expansionRatio,
  required int expandedArchiveBytes,
  required int objectAnalysisSeconds,
  required int caseAnalysisSeconds,
  required int analyzerMemoryBytes,
  QuarantineLimits limits = const QuarantineLimits(),
}) {
  if (!limits.isValid) {
    return QuarantineDecision.reject;
  }

  if (objectBytes < 0 ||
      totalRequestBytes < 0 ||
      objectCount < 0 ||
      archiveDepth < 0 ||
      expansionRatio < 0 ||
      expandedArchiveBytes < 0 ||
      objectAnalysisSeconds < 0 ||
      caseAnalysisSeconds < 0 ||
      analyzerMemoryBytes < 0) {
    return QuarantineDecision.reject;
  }

  if (objectBytes > limits.maxObjectBytes ||
      totalRequestBytes > limits.maxRequestBytes ||
      objectCount > limits.maxObjectsPerCase ||
      archiveDepth > limits.maxArchiveDepth ||
      expansionRatio > limits.maxExpansionRatio ||
      expandedArchiveBytes > limits.maxExpandedArchiveBytes ||
      objectAnalysisSeconds > limits.maxObjectAnalysisSeconds ||
      caseAnalysisSeconds > limits.maxCaseAnalysisSeconds ||
      analyzerMemoryBytes > limits.maxAnalyzerMemoryBytes) {
    return QuarantineDecision.reject;
  }

  return QuarantineDecision.acceptForProcessing;
}
