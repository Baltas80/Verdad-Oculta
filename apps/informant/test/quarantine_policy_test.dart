import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/quarantine_policy.dart';

void main() {
  const limits = QuarantineLimits();

  int megabytes(int value) => value * 1024 * 1024;

  Map<String, int> validValues() => {
        'objectBytes': megabytes(1),
        'totalRequestBytes': megabytes(2),
        'objectCount': 1,
        'archiveDepth': 1,
        'expansionRatio': 1,
        'expandedArchiveBytes': megabytes(2),
        'objectAnalysisSeconds': 1,
        'caseAnalysisSeconds': 1,
        'analyzerMemoryBytes': megabytes(1),
      };

  test('accepts values inside the documented baseline', () {
    expect(
      evaluateQuarantineLimits(
        ...validValues(),
        limits: limits,
      ),
      QuarantineDecision.acceptForProcessing,
    );
  });

  test('accepts exact documented boundaries', () {
    expect(
      evaluateQuarantineLimits(
        objectBytes: limits.maxObjectBytes,
        totalRequestBytes: limits.maxRequestBytes,
        objectCount: limits.maxObjectsPerCase,
        archiveDepth: limits.maxArchiveDepth,
        expansionRatio: limits.maxExpansionRatio,
        expandedArchiveBytes: limits.maxExpandedArchiveBytes,
        objectAnalysisSeconds: limits.maxObjectAnalysisSeconds,
        caseAnalysisSeconds: limits.maxCaseAnalysisSeconds,
        analyzerMemoryBytes: limits.maxAnalyzerMemoryBytes,
        limits: limits,
      ),
      QuarantineDecision.acceptForProcessing,
    );
  });

  test('rejects a violation of every documented boundary', () {
    final fields = validValues();
    for (final field in fields.keys) {
      final candidate = Map<String, int>.from(fields);
      candidate[field] = switch (field) {
        'objectBytes' => limits.maxObjectBytes + 1,
        'totalRequestBytes' => limits.maxRequestBytes + 1,
        'objectCount' => limits.maxObjectsPerCase + 1,
        'archiveDepth' => limits.maxArchiveDepth + 1,
        'expansionRatio' => limits.maxExpansionRatio + 1,
        'expandedArchiveBytes' => limits.maxExpandedArchiveBytes + 1,
        'objectAnalysisSeconds' => limits.maxObjectAnalysisSeconds + 1,
        'caseAnalysisSeconds' => limits.maxCaseAnalysisSeconds + 1,
        'analyzerMemoryBytes' => limits.maxAnalyzerMemoryBytes + 1,
        _ => throw StateError('unexpected field'),
      };

      expect(
        evaluateQuarantineLimits(
          ...candidate,
          limits: limits,
        ),
        QuarantineDecision.reject,
        reason: 'Expected $field to fail closed',
      );
    }
  });

  test('rejects negative values instead of treating them as valid', () {
    final candidate = validValues()..['objectBytes'] = -1;

    expect(
      evaluateQuarantineLimits(
        ...candidate,
        limits: limits,
      ),
      QuarantineDecision.reject,
    );
  });
}
