/// In-memory demo-only submission state.
///
/// This intentionally stores only non-sensitive presentation metadata and is
/// never persisted, transmitted, encrypted, or used as a production case
/// record.
class DemoSubmission {
  const DemoSubmission({
    required this.reference,
    required this.type,
    required this.confidentiality,
    required this.attachmentCount,
  });

  final String reference;
  final String type;
  final String confidentiality;
  final int attachmentCount;
}

class DemoSubmissionStore {
  DemoSubmissionStore._();

  static final DemoSubmissionStore instance = DemoSubmissionStore._();

  final List<DemoSubmission> _items = <DemoSubmission>[];
  int _sequence = 0;

  List<DemoSubmission> get items => List<DemoSubmission>.unmodifiable(_items);

  String add({
    required String type,
    required String confidentiality,
    required int attachmentCount,
  }) {
    _sequence++;
    final reference = 'DEMO-' + _sequence.toString().padLeft(3, '0');
    _items.insert(
      0,
      DemoSubmission(
        reference: reference,
        type: type,
        confidentiality: confidentiality,
        attachmentCount: attachmentCount,
      ),
    );
    return reference;
  }

  void clear() {
    _items.clear();
    _sequence = 0;
  }
}
