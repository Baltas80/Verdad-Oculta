import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/disclosure_lifecycle.dart';

void main() {
  test('valid disclosure path advances in order', () {
    var lifecycle = const DisclosureLifecycle(DisclosureStage.draft);

    for (final stage in [
      DisclosureStage.prepared,
      DisclosureStage.protected,
      DisclosureStage.readyForTransmission,
      DisclosureStage.transmitted,
      DisclosureStage.received,
      DisclosureStage.underReview,
      DisclosureStage.published,
      DisclosureStage.closed,
    ]) {
      expect(lifecycle.canTransitionTo(stage), isTrue);
      lifecycle = lifecycle.transitionTo(stage);
    }
  });

  test('closed disclosures cannot be reopened', () {
    const lifecycle = DisclosureLifecycle(DisclosureStage.closed);

    expect(lifecycle.canTransitionTo(DisclosureStage.draft), isFalse);
    expect(lifecycle.canTransitionTo(DisclosureStage.published), isFalse);
  });

  test('protected originals cannot jump directly to publication', () {
    const lifecycle = DisclosureLifecycle(DisclosureStage.protected);

    expect(lifecycle.canTransitionTo(DisclosureStage.published), isFalse);
    expect(lifecycle.canTransitionTo(DisclosureStage.readyForTransmission), isTrue);
  });

  test('review decides a publication outcome', () {
    const lifecycle = DisclosureLifecycle(DisclosureStage.underReview);

    expect(lifecycle.canTransitionTo(DisclosureStage.published), isTrue);
    expect(lifecycle.canTransitionTo(DisclosureStage.restricted), isTrue);
    expect(lifecycle.canTransitionTo(DisclosureStage.withheld), isTrue);
  });

  test('invalid transition throws', () {
    const lifecycle = DisclosureLifecycle(DisclosureStage.draft);

    expect(
      () => lifecycle.transitionTo(DisclosureStage.published),
      throwsStateError,
    );
  });
}
