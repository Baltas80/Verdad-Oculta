import 'membership_entitlement.dart';

class ArchiveItem {
  const ArchiveItem({
    required this.id,
    required this.title,
    required this.classification,
    required this.summary,
  });

  final String id;
  final String title;
  final ArchiveClassification classification;
  final String summary;
}

/// Presentation/domain boundary for the member archive.
/// Protected originals are deliberately not represented as downloadable data.
class MemberArchive {
  const MemberArchive._();

  static const items = <ArchiveItem>[
    ArchiveItem(
      id: 'sample-public-001',
      title: 'Archivo público de demostración',
      classification: ArchiveClassification.public,
      summary: 'Contenido sintético utilizado para probar la aplicación.',
    ),
    ArchiveItem(
      id: 'sample-member-001',
      title: 'Dossier seleccionado para miembros',
      classification: ArchiveClassification.memberArchive,
      summary: 'Contenido sintético reservado al nivel de membresía.',
    ),
  ];

  static List<ArchiveItem> visibleFor(MembershipTier tier) =>
      items.where((item) => MembershipEntitlement.canAccess(
            tier,
            item.classification,
          )).toList(growable: false);
}
