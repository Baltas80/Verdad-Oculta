import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/backend_config.dart';

void main() {
  test('default build remains local demo', () {
    expect(BackendConfig.isLocalDemo, isTrue);
    expect(BackendConfig.isStaging, isFalse);
    expect(BackendConfig.stagingUri, isNull);
  });
}
