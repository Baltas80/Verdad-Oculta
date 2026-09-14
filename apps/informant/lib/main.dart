import 'package:flutter/material.dart';
import 'attachment_selection.dart';
import 'intake_validation.dart';

const _obsidian = Color(0xFF0B0C0E);
const _graphite = Color(0xFF17191D);
const _ivory = Color(0xFFF1EFEA);
const _gold = Color(0xFFC6A76A);
const _bronze = Color(0xFF8E7650);

void main() => runApp(const VerdadOcultaApp());

class VerdadOcultaApp extends StatelessWidget {
  const VerdadOcultaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Verdad Oculta',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: _obsidian,
          colorScheme: const ColorScheme.dark(
            surface: _obsidian,
            primary: _gold,
            secondary: _bronze,
            onSurface: _ivory,
          ),
          fontFamily: 'sans-serif',
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: _graphite,
            labelStyle: const TextStyle(color: _bronze),
            hintStyle: const TextStyle(color: _bronze),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _bronze.withValues(alpha: .35)),
              borderRadius: BorderRadius.zero,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: _gold),
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        home: const AppShell(),
      );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  final pages = const [
    HomeScreen(),
    RevealScreen(),
    SubmissionsScreen(),
    InboxScreen(),
    SecurityScreen(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: pages[index]),
        bottomNavigationBar: NavigationBar(
          backgroundColor: _obsidian,
          indicatorColor: _graphite,
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Revelar'),
            NavigationDestination(icon: Icon(Icons.folder_outlined), label: 'Mis envíos'),
            NavigationDestination(icon: Icon(Icons.mail_outline), label: 'Buzón'),
            NavigationDestination(icon: Icon(Icons.shield_outlined), label: 'Seguridad'),
          ],
        ),
      );
}

class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: _ivory, fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w500)),
              const SizedBox(height: 36),
              Expanded(child: child),
            ]),
          ),
        ),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'VERDAD OCULTA',
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            const Text('HAY HISTORIAS QUE\nNO PUEDEN SEGUIR OCULTAS', style: TextStyle(color: _ivory, fontSize: 30, height: 1.18, letterSpacing: 1.2, fontWeight: FontWeight.w300)),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 58, child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _gold, foregroundColor: _obsidian, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RevealScreen())),
              child: const Text('REVELAR INFORMACIÓN', style: TextStyle(fontSize: 13, letterSpacing: 2.2, fontWeight: FontWeight.w600)),
            )),
            const SizedBox(height: 24),
            const _QuietTile(label: 'MIS ENVÍOS'),
            const _QuietTile(label: 'BUZÓN SEGURO'),
            const _QuietTile(label: 'SEGURIDAD'),
            const SizedBox(height: 24),
            const Text('REVELAR LA VERDAD. PROTEGER A QUIEN LA REVELA.', style: TextStyle(color: _bronze, fontSize: 10, letterSpacing: 1.4)),
          ]),
        ),
      );
}

class _QuietTile extends StatelessWidget {
  const _QuietTile({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: _graphite, border: Border.all(color: _bronze.withValues(alpha: .28))),
        child: ListTile(
          dense: true,
          title: Text(label, style: const TextStyle(color: _ivory, fontSize: 12, letterSpacing: 1.8)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 13, color: _bronze),
        ),
      );
}

class RevealScreen extends StatefulWidget {
  const RevealScreen({super.key});
  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  int step = 0;
  String type = 'Documento';
  String confidentiality = 'Máximo anonimato';
  final description = TextEditingController();
  List<SelectedAttachment> attachments = const [];
  bool picking = false;

  @override
  void dispose() { description.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'REVELAR INFORMACIÓN',
        child: AnimatedSwitcher(duration: const Duration(milliseconds: 180), child: _content()),
      );

  Widget _content() {
    if (step == 0) return _types();
    if (step == 1) return _describe();
    if (step == 2) return _privacy();
    return _sent();
  }

  Widget _types() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('¿QUÉ QUIERES REVELAR?', style: TextStyle(color: _ivory, fontSize: 24, letterSpacing: 1.2, fontWeight: FontWeight.w300)),
        const SizedBox(height: 24),
        Wrap(spacing: 10, runSpacing: 10, children: ['Documento', 'Fotografía', 'Video', 'Audio', 'Texto', 'Varios archivos'].map((item) => ChoiceChip(
          label: Text(item), selected: type == item, onSelected: (_) => setState(() => type = item), selectedColor: _gold, labelStyle: TextStyle(color: type == item ? _obsidian : _ivory), backgroundColor: _graphite,
        )).toList()),
        const Spacer(),
        _goldButton('CONTINUAR', _continueFromType),
      ]);

  Future<void> _continueFromType() async {
    if (type == 'Texto') {
      setState(() => step = 1);
      return;
    }

    setState(() => picking = true);
    final kind = switch (type) {
      'Documento' => RevealAttachmentKind.document,
      'Fotografía' => RevealAttachmentKind.photograph,
      'Video' => RevealAttachmentKind.video,
      'Audio' => RevealAttachmentKind.audio,
      _ => RevealAttachmentKind.multiple,
    };

    try {
      final selected = await AttachmentSelection.pick(kind);
      if (!mounted) return;
      if (selected.isNotEmpty) {
        final invalid = selected.any((file) => IntakeValidation.validate(file) != null);
        if (invalid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El archivo no cumple los controles de admisión.')),
          );
          return;
        }
        setState(() {
          attachments = selected;
          step = 1;
        });
      }
    } finally {
      if (mounted) setState(() => picking = false);
    }
  }

  Widget _describe() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('DESCRIBE LA INFORMACIÓN', style: TextStyle(color: _ivory, fontSize: 24, letterSpacing: 1.2, fontWeight: FontWeight.w300)),
        const SizedBox(height: 22),
        if (attachments.isNotEmpty) ...[
          Container(width: double.infinity, padding: const EdgeInsets.all(14), color: _graphite, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('ARCHIVOS SELECCIONADOS', style: TextStyle(color: _gold, fontSize: 10, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            ...attachments.map((file) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('${file.name} · ${_formatBytes(file.sizeBytes)}', style: const TextStyle(color: _ivory, fontSize: 11)))),
          ])),
          const SizedBox(height: 14),
        ],
        TextField(controller: description, maxLines: 7, decoration: const InputDecoration(labelText: '¿Qué ocurrió?', hintText: 'Describe los hechos con el mayor detalle posible.')),
        const SizedBox(height: 12),
        const Text('Ubicación y fecha son opcionales. No incluyas datos personales innecesarios.', style: TextStyle(color: _bronze, fontSize: 11, height: 1.4)),
        const Spacer(),
        _goldButton('CONTINUAR', () => setState(() => step = 2)),
      ]);

  Widget _privacy() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('NIVEL DE CONFIDENCIALIDAD', style: TextStyle(color: _ivory, fontSize: 24, letterSpacing: 1.2, fontWeight: FontWeight.w300)),
        const SizedBox(height: 20),
        ...['Máximo anonimato', 'Confidencial', 'Puedo ser contactado'].map((item) => RadioListTile<String>(contentPadding: EdgeInsets.zero, activeColor: _gold, value: item,
          // ignore: deprecated_member_use
          groupValue: confidentiality,
          // ignore: deprecated_member_use
          onChanged: (v) => setState(() => confidentiality = v!), title: Text(item, style: const TextStyle(color: _ivory)), subtitle: Text(_privacyDescription(item), style: const TextStyle(color: _bronze, fontSize: 11)))),
        const Spacer(),
        _goldButton('PROTEGER Y CONTINUAR', () => setState(() => step = 3)),
      ]);

  Widget _sent() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.verified_outlined, color: _gold, size: 42),
        const SizedBox(height: 22),
        const Text('PREPARACIÓN LOCAL COMPLETADA', style: TextStyle(color: _ivory, fontSize: 25, letterSpacing: 1.2, fontWeight: FontWeight.w300)),
        const SizedBox(height: 14),
        const Text('La demostración local ha completado sus pasos de preparación. No se ha creado ninguna transmisión ni se ha enviado información a un servidor.', style: TextStyle(color: _ivory, height: 1.5)),
        const SizedBox(height: 26),
        Container(width: double.infinity, padding: const EdgeInsets.all(18), color: _graphite, child: const Text('DEMO LOCAL', textAlign: TextAlign.center, style: TextStyle(color: _gold, fontSize: 20, letterSpacing: 3))),
        const SizedBox(height: 12),
        const Text('NO SE HA ENVIADO INFORMACIÓN REAL.', style: TextStyle(color: _bronze, fontSize: 10, letterSpacing: 1)),
      ]);

  String _privacyDescription(String value) => switch (value) {
        'Máximo anonimato' => 'Minimiza identidad y metadatos. Sin canal de contacto directo.',
        'Confidencial' => 'La identidad no se publica y solo se conserva lo estrictamente necesario.',
        _ => 'Permite establecer un canal de contacto separado del contenido enviado.',
      };

  Widget _goldButton(String label, VoidCallback action) => SizedBox(width: double.infinity, height: 56, child: FilledButton(style: FilledButton.styleFrom(backgroundColor: _gold, foregroundColor: _obsidian, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)), onPressed: picking ? null : action, child: Text(picking ? 'SELECCIONANDO…' : label, style: const TextStyle(fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w600))));

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class SubmissionsScreen extends StatelessWidget {
  const SubmissionsScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(title: 'MIS ENVÍOS', child: ListView(children: const [
        _StatusCard(code: 'VO-7K4-9M2', status: 'RECIBIDO', detail: 'Pendiente de revisión'),
        _StatusCard(code: 'VO-2P8-L1A', status: 'EN REVISIÓN', detail: 'El equipo está verificando la información'),
      ]));
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.code, required this.status, required this.detail});
  final String code, status, detail;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(18), color: _graphite, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(code, style: const TextStyle(color: _gold, letterSpacing: 2)), const SizedBox(height: 12), Text(status, style: const TextStyle(color: _ivory, fontSize: 12, letterSpacing: 1.5)), const SizedBox(height: 6), Text(detail, style: const TextStyle(color: _bronze, fontSize: 11))]));
}

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(title: 'BUZÓN SEGURO', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Icon(Icons.lock_outline, color: _gold, size: 36),
        SizedBox(height: 18),
        Text('CANAL DE COMUNICACIÓN', style: TextStyle(color: _ivory, fontSize: 22, letterSpacing: 1.2, fontWeight: FontWeight.w300)),
        SizedBox(height: 12),
        Text('Las respuestas del equipo se vincularán a tu código de seguimiento. No es necesario utilizar teléfono ni correo electrónico.', style: TextStyle(color: _ivory, height: 1.5)),
        SizedBox(height: 24),
        Text('No hay mensajes nuevos.', style: TextStyle(color: _bronze, fontSize: 12)),
      ]));
}

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(title: 'SEGURIDAD', child: ListView(children: const [
        _SecurityItem(title: 'Cifrado', detail: 'La arquitectura prevé cifrado de extremo a extremo antes de almacenar contenido sensible.'),
        _SecurityItem(title: 'Metadatos', detail: 'La aplicación debe minimizar y eliminar metadatos innecesarios antes del envío.'),
        _SecurityItem(title: 'Identidad', detail: 'La identidad del informante y el contenido deben mantenerse separados.'),
        _SecurityItem(title: 'Privacidad', detail: 'Sin publicidad, analítica ni permisos que no sean necesarios para la función solicitada.'),
        _SecurityItem(title: 'Límite importante', detail: 'Ningún sistema puede garantizar anonimato absoluto si el dispositivo del informante está completamente comprometido.'),
      ]));
}

class _SecurityItem extends StatelessWidget {
  const _SecurityItem({required this.title, required this.detail});
  final String title, detail;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: _graphite, border: Border.all(color: _bronze.withValues(alpha: .25))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title.toUpperCase(), style: const TextStyle(color: _gold, fontSize: 11, letterSpacing: 1.7)), const SizedBox(height: 8), Text(detail, style: const TextStyle(color: _ivory, fontSize: 12, height: 1.45))]));
}
