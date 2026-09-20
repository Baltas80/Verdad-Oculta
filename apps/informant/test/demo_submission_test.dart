import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/demo_submission.dart';

void main() {
  setUp(() => DemoSubmissionStore.instance.clear());

  test('adds non-persistent presentation metadata only', () {
    final reference = DemoSubmissionStore.instance.add(
      type: 'Texto',
      confidentiality: 'Máximo anonimato',
      attachmentCount: 0,
    );

    expect(reference, 'DEMO-001');
    expect(DemoSubmissionStore.instance.items, hasLength(1));
    expect(DemoSubmissionStore.instance.items.single.type, 'Texto');
    expect(
      DemoSubmissionStore.instance.items.single.confidentiality,
      'Máximo anonimato',
    );
  });

  test('new demo entries are ordered newest first', () {
    final store = DemoSubmissionStore.instance;

    store.add(
      type: 'Documento',
      confidentiality: 'Confidencial',
      attachmentCount: 1,
    );
    store.add(
      type: 'Fotografía',
      confidentiality: 'Máximo anonimato',
      attachmentCount: 2,
    );

    expect(store.items.map((item) => item.reference), [
      'DEMO-002',
      'DEMO-001',
    ]);
  });

  test('clear removes all demo state', () {
    final store = DemoSubmissionStore.instance;

    store.add(
      type: 'Audio',
      confidentiality: 'Máximo anonimato',
      attachmentCount: 1,
    );
    store.clear();

    expect(store.items, isEmpty);
    expect(
      store.add(
        type: 'Texto',
        confidentiality: 'Máximo anonimato',
        attachmentCount: 0,
      ),
      'DEMO-001',
    );
  });
}
