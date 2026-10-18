import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/production_submission_gate.dart';

void main() {
  test('production submissions are disabled in every build by default', () {
    expect(ProductionSubmissionGate.isEnabled, isFalse);
    expect(
      ProductionSubmissionGate.requireEnabled,
      throwsA(isA<ProductionSubmissionBlocked>()),
    );
  });

  test('attempting a production submission fails closed', () {
    expect(
      () => ProductionSubmissionGate.requireEnabled(),
      throwsA(isA<ProductionSubmissionBlocked>()),
    );
  });
}
