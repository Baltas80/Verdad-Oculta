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

  QuarantineDecision evaluate(
    Map<String, int> values, {
    QuarantineLimits policy = limits,
  }) {
    return evaluateQuarantineLimits(
      objectBytes: values['objectBytes']!,
      totalRequestBytes: values['totalRequestBytes']!,
      objectCount: values['objectCount']!,
      archiveDepth: values['archiveDepth']!,
      expansionRatio: values['expansionRatio']!,
      expandedArchiveBytes: values['expandedArchiveBytes']!,
      objectAnalysisSeconds: values['objectAnalysisSeconds']!,
      caseAnalysisSeconds: values['caseAnalysisSeconds']!,
      analyzerMemoryBytes: values['analyzerMemoryBytes']!,
      limits: policy,
    );
  }

  test('accepts values inside the documented baseline', () {
    expect(evaluate(validValues()), QuarantineDecision.acceptForProcessing);
  });

  test('accepts exact documented boundaries', () {
    expect(
      evaluate({
        'objectBytes': limits.maxObjectBytes,
        'totalRequestBytes': limits.maxRequestBytes,
        'objectCount': limits.maxObjectsPerCase,
        'archiveDepth': limits.maxArchiveDepth,
        'expansionRatio': limits.maxExpansionRatio,
        'expandedArchiveBytes': limits.maxExpandedArchiveBytes,
        'objectAnalysisSeconds': limits.maxObjectAnalysisSeconds,
        'caseAnalysisSeconds': limits.maxCaseAnalysisSeconds,
        'analyzerMemoryBytes': limits.maxAnalyzerMemoryBytes,
      }),
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
        evaluate(candidate),
        QuarantineDecision.reject,
        reason: 'Expected $field to fail closed',
      );
    }
  });

  test('rejects negative input values instead of treating them as valid', () {
    final fields = validValues();
    for (final field in fields.keys) {
      final candidate = Map<String, int>.from(fields)..[field] = -1;
      expect(
        evaluate(candidate),
        QuarantineDecision.reject,
        reason: 'Expected negative $field to fail closed',
      );
    }
  });

  test('rejects invalid policy configuration', () {
    const invalidPolicy = QuarantineLimits(maxObjectBytes: -1);
    expect(invalidPolicy.isValid, isFalse);
    expect(
      evaluate(validValues(), policy: invalidPolicy),
      QuarantineDecision.reject,
    );
  });
}
