/// Safe local model for the disclosure lifecycle.
///
/// This model only defines legal state transitions. It does not perform
/// transmission, persistence, encryption or authorization.
enum DisclosureStage {
  draft,
  prepared,
  protected,
  readyForTransmission,
  transmitted,
  received,
  underReview,
  published,
  restricted,
  withheld,
  closed,
}

class DisclosureLifecycle {
  const DisclosureLifecycle(this.stage);

  final DisclosureStage stage;

  bool canTransitionTo(DisclosureStage next) {
    if (stage == next) return true;
    return switch (stage) {
      DisclosureStage.draft =>
        next == DisclosureStage.prepared ||
        next == DisclosureStage.closed,
      DisclosureStage.prepared =>
        next == DisclosureStage.protected ||
        next == DisclosureStage.draft ||
        next == DisclosureStage.closed,
      DisclosureStage.protected =>
        next == DisclosureStage.readyForTransmission ||
        next == DisclosureStage.prepared ||
        next == DisclosureStage.closed,
      DisclosureStage.readyForTransmission =>
        next == DisclosureStage.transmitted ||
        next == DisclosureStage.protected ||
        next == DisclosureStage.closed,
      DisclosureStage.transmitted =>
        next == DisclosureStage.received ||
        next == DisclosureStage.closed,
      DisclosureStage.received =>
        next == DisclosureStage.underReview ||
        next == DisclosureStage.closed,
      DisclosureStage.underReview =>
        next == DisclosureStage.published ||
        next == DisclosureStage.restricted ||
        next == DisclosureStage.withheld ||
        next == DisclosureStage.closed,
      DisclosureStage.published ||
      DisclosureStage.restricted ||
      DisclosureStage.withheld =>
        next == DisclosureStage.closed,
      DisclosureStage.closed => false,
    };
  }

  DisclosureLifecycle transitionTo(DisclosureStage next) {
    if (!canTransitionTo(next)) {
      throw StateError(
        'Invalid disclosure transition: ${stage.name} -> ${next.name}',
      );
    }
    return DisclosureLifecycle(next);
  }
}
