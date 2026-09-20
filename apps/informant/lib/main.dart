import 'dart:async';

import 'package:flutter/material.dart';
import 'attachment_selection.dart';
import 'demo_submission.dart';
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
        home: const SplashGate(),
      );
}

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1100), () {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      (_timer?.isActive ?? false) ? const _SplashScreen() : const AppShell();
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _obsidian,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 118,
                height: 118,
                child: CustomPaint(painter: _EclipseMarkPainter()),
              ),
              SizedBox(height: 30),
              Text(
                'VERDAD OCULTA',
                style: TextStyle(
                  color: _ivory,
                  fontSize: 18,
                  letterSpacing: 5.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'LA INFORMACIÓN QUE MERECE SER CONOCIDA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _bronze,
                  fontSize: 9,
                  letterSpacing: 1.6,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'PROTEGER LA VERDAD TAMBIÉN ES REVELARLA.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _bronze,
                  fontSize: 9,
                  letterSpacing: 1.2,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
}

class _EclipseMarkPainter extends CustomPainter {
  const _EclipseMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * .36;

    final bronze = Paint()
      ..color = _bronze
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final ivory = Paint()
      ..color = _ivory
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    canvas.drawCircle(center, radius, bronze);
    canvas.drawCircle(center.translate(-5, 0), radius * .72, ivory);
    canvas.drawLine(
      Offset(center.dx, center.dy - radius - 18),
      Offset(center.dx, center.dy + radius + 18),
      ivory,
    );
    canvas.drawLine(
      Offset(center.dx - 22, center.dy),
      Offset(center.dx + 22, center.dy),
      bronze,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle),
              label: 'Revelar',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder),
              label: 'Mis envíos',
            ),
            NavigationDestination(
              icon: Icon(Icons.mail_outline),
              selectedIcon: Icon(Icons.mail),
              label: 'Buzón',
            ),
            NavigationDestination(
              icon: Icon(Icons.shield_outlined),
              selectedIcon: Icon(Icons.shield),
              label: 'Seguridad',
            ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ivory,
                    fontSize: 18,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(child: child),
              ],
            ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MountainHero(),
              const SizedBox(height: 24),
              const Text(
                'HAY HISTORIAS QUE\nNO PUEDEN SEGUIR OCULTAS',
                style: TextStyle(
                  color: _ivory,
                  fontSize: 30,
                  height: 1.18,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: _obsidian,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RevealScreen()),
                  ),
                  child: const Text(
                    'REVELAR INFORMACIÓN',
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 2.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              _QuietTile(
                label: 'MIS ENVÍOS',
                icon: Icons.folder_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SubmissionsScreen()),
                ),
              ),
              _QuietTile(
                label: 'BUZÓN SEGURO',
                icon: Icons.mail_outline,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InboxScreen()),
                ),
              ),
              _QuietTile(
                label: 'SEGURIDAD',
                icon: Icons.shield_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SecurityScreen()),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'REVELAR LA VERDAD. PROTEGER A QUIEN LA REVELA.',
                style: TextStyle(
                  color: _bronze,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
}

class _MountainHero extends StatelessWidget {
  const _MountainHero();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 180,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: _graphite),
          child: CustomPaint(painter: _MountainPainter()),
        ),
      );
}

class _MountainPainter extends CustomPainter {
  const _MountainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final far = Paint()..color = _bronze.withValues(alpha: .20);
    final near = Paint()..color = _obsidian.withValues(alpha: .95);
    final ridge = Paint()
      ..color = _gold.withValues(alpha: .42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final farPath = Path()
      ..moveTo(0, size.height * .82)
      ..lineTo(size.width * .22, size.height * .36)
      ..lineTo(size.width * .39, size.height * .63)
      ..lineTo(size.width * .59, size.height * .25)
      ..lineTo(size.width * .78, size.height * .56)
      ..lineTo(size.width, size.height * .32)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final nearPath = Path()
      ..moveTo(0, size.height * .93)
      ..lineTo(size.width * .28, size.height * .54)
      ..lineTo(size.width * .46, size.height * .72)
      ..lineTo(size.width * .67, size.height * .39)
      ..lineTo(size.width * .83, size.height * .69)
      ..lineTo(size.width, size.height * .50)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(farPath, far);
    canvas.drawPath(nearPath, near);

    final ridgePath = Path()
      ..moveTo(0, size.height * .82)
      ..lineTo(size.width * .22, size.height * .36)
      ..lineTo(size.width * .39, size.height * .63)
      ..lineTo(size.width * .59, size.height * .25)
      ..lineTo(size.width * .78, size.height * .56)
      ..lineTo(size.width, size.height * .32);

    canvas.drawPath(ridgePath, ridge);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QuietTile extends StatelessWidget {
  const _QuietTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _graphite,
          border: Border.all(color: _bronze.withValues(alpha: .28)),
        ),
        child: Material(
          color: _graphite,
          child: ListTile(
            dense: true,
            onTap: onTap,
            leading: Icon(icon, size: 17, color: _bronze),
            title: Text(
              label,
              style: const TextStyle(
                color: _ivory,
                fontSize: 12,
                letterSpacing: 1.8,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 13,
              color: _bronze,
            ),
          ),
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
  String? demoReference;
  bool picking = false;

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'REVELAR INFORMACIÓN',
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _content(),
        ),
      );

  Widget _content() {
    if (step == 0) return _types();
    if (step == 1) return _describe();
    if (step == 2) return _privacy();
    if (step == 3) return _protection();
    return _completed();
  }

  Widget _progressStep(int current, String label) => Column(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: current <= step ? _gold : _bronze.withValues(alpha: .5),
              ),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$current',
              style: TextStyle(
                color: current <= step ? _gold : _bronze,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              color: current <= step ? _gold : _bronze,
              fontSize: 8,
              letterSpacing: 1,
            ),
          ),
        ],
      );

  Widget _progress() => Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Row(
          children: [
            Expanded(child: _progressStep(1, 'SELECCIÓN')),
            Expanded(child: _progressStep(2, 'DESCRIPCIÓN')),
            Expanded(child: _progressStep(3, 'PRIVACIDAD')),
            Expanded(child: _progressStep(4, 'PROTECCIÓN')),
          ],
        ),
      );

  Widget _types() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progress(),
          const Text(
            '¿QUÉ QUIERES REVELAR?',
            style: TextStyle(
              color: _ivory,
              fontSize: 24,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Documento',
              'Fotografía',
              'Video',
              'Audio',
              'Texto',
              'Varios archivos',
            ]
                .map(
                  (item) => ChoiceChip(
                    label: Text(item),
                    selected: type == item,
                    onSelected: (_) => setState(() => type = item),
                    selectedColor: _gold,
                    labelStyle: TextStyle(
                      color: type == item ? _obsidian : _ivory,
                    ),
                    backgroundColor: _graphite,
                  ),
                )
                .toList(),
          ),
          const Spacer(),
          _goldButton('CONTINUAR', _continueFromType),
        ],
      );

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
        final invalid = selected.any(
          (file) => IntakeValidation.validate(file) != null,
        );

        if (invalid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'El archivo no cumple los controles de admisión.',
              ),
            ),
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

  Widget _describe() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progress(),
          const Text(
            'DESCRIBE LA INFORMACIÓN',
            style: TextStyle(
              color: _ivory,
              fontSize: 24,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 22),
          if (attachments.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: _graphite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ARCHIVOS SELECCIONADOS',
                    style: TextStyle(
                      color: _gold,
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...attachments.map(
                    (file) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        file.name + ' · ' + _formatBytes(file.sizeBytes),
                        style: const TextStyle(
                          color: _ivory,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          TextField(
            controller: description,
            maxLines: 7,
            decoration: const InputDecoration(
              labelText: '¿Qué ocurrió?',
              hintText:
                  'Describe los hechos con el mayor detalle posible.',
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ubicación y fecha son opcionales. No incluyas datos personales innecesarios.',
            style: TextStyle(
              color: _bronze,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const Spacer(),
          _goldButton(
            'CONTINUAR',
            () => setState(() => step = 2),
          ),
        ],
      );

  Widget _privacy() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progress(),
          const Text(
            'NIVEL DE CONFIDENCIALIDAD',
            style: TextStyle(
              color: _ivory,
              fontSize: 24,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 20),
          RadioGroup<String>(
            groupValue: confidentiality,
            onChanged: (v) {
              if (v != null) setState(() => confidentiality = v);
            },
            child: Column(
              children: [
                ...[
                  'Máximo anonimato',
                  'Confidencial',
                  'Puedo ser contactado',
                ].map(
                  (item) => RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: _gold,
                    value: item,
                    title: Text(
                      item,
                      style: const TextStyle(color: _ivory),
                    ),
                    subtitle: Text(
                      _privacyDescription(item),
                      style: const TextStyle(
                        color: _bronze,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _goldButton('PROTEGER Y CONTINUAR', () {
            setState(() => step = 3);
            unawaited(_completeProtection());
          }),
        ],
      );

  Future<void> _completeProtection() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted || step != 3) return;

    final reference = DemoSubmissionStore.instance.add(
      type: type,
      confidentiality: confidentiality,
      attachmentCount: attachments.length,
    );

    setState(() {
      demoReference = reference;
      step = 4;
    });
  }

  Widget _protection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progress(),
          const Icon(
            Icons.shield_moon_outlined,
            color: _gold,
            size: 42,
          ),
          const SizedBox(height: 22),
          const Text(
            'PROTEGIENDO TU INFORMACIÓN',
            style: TextStyle(
              color: _ivory,
              fontSize: 25,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Demostración local de la fase de protección. Esta versión no transmite información a un servidor.',
            style: TextStyle(
              color: _ivory,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),
          const _ProtectionLine('Preparando contenido', true),
          const _ProtectionLine('Validando límites y metadatos', true),
          const _ProtectionLine('Transmisión de red', false),
        ],
      );

  Widget _completed() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progress(),
          const Icon(
            Icons.verified_outlined,
            color: _gold,
            size: 42,
          ),
          const SizedBox(height: 22),
          const Text(
            'PREPARACIÓN LOCAL COMPLETADA',
            style: TextStyle(
              color: _ivory,
              fontSize: 25,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'La demostración local ha completado sus pasos de preparación. No se ha creado ninguna transmisión ni se ha enviado información a un servidor.',
            style: TextStyle(
              color: _ivory,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            color: _graphite,
            child: Column(
              children: [
                const Text(
                  'REFERENCIA DEMO',
                  style: TextStyle(
                    color: _bronze,
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  demoReference ?? 'DEMO',
                  style: const TextStyle(
                    color: _gold,
                    fontSize: 20,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'NO SE HA ENVIADO INFORMACIÓN REAL.',
            style: TextStyle(
              color: _bronze,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      );

  String _privacyDescription(String value) => switch (value) {
        'Máximo anonimato' =>
          'Minimiza identidad y metadatos. Sin canal de contacto directo.',
        'Confidencial' =>
          'La identidad no se publica y solo se conserva lo estrictamente necesario.',
        _ =>
          'Permite establecer un canal de contacto separado del contenido enviado.',
      };

  Widget _goldButton(String label, VoidCallback action) => SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _gold,
            foregroundColor: _obsidian,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: picking ? null : action,
          child: Text(
            picking ? 'SELECCIONANDO…' : label,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  String _formatBytes(int bytes) {
    if (bytes < 1024) return bytes.toString() + ' B';
    if (bytes < 1024 * 1024) {
      return (bytes / 1024).toStringAsFixed(1) + ' KB';
    }
    return (bytes / (1024 * 1024)).toStringAsFixed(1) + ' MB';
  }
}

class _ProtectionLine extends StatelessWidget {
  const _ProtectionLine(this.label, this.done);

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(
              done
                  ? Icons.check_circle_outline
                  : Icons.remove_circle_outline,
              size: 17,
              color: done ? _gold : _bronze,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: done ? _ivory : _bronze,
                  fontSize: 12,
                ),
              ),
            ),
            if (!done)
              const Text(
                'BLOQUEADA',
                style: TextStyle(
                  color: _bronze,
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
          ],
        ),
      );
}

class SubmissionsScreen extends StatelessWidget {
  const SubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'MIS ENVÍOS',
        child: AnimatedBuilder(
          animation: DemoSubmissionStore.instance,
          builder: (context, _) {
            final items = DemoSubmissionStore.instance.items;
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'No hay preparaciones locales en esta demostración.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _bronze,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              );
            }

            return ListView(
              children: [
                ...items.map(
                  (item) => _StatusCard(
                    code: item.reference,
                    status: 'PREPARACIÓN LOCAL',
                    detail:
                        '${item.type} · ${item.attachmentCount} archivo(s) · ${item.confidentiality}',
                  ),
                ),
              ],
            );
          },
        ),
      );}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.code,
    required this.status,
    required this.detail,
  });

  final String code;
  final String status;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _graphite,
          border: Border.all(color: _bronze.withValues(alpha: .25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              code,
              style: const TextStyle(
                color: _gold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              status,
              style: const TextStyle(
                color: _ivory,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              detail,
              style: const TextStyle(
                color: _bronze,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
}

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'BUZÓN SEGURO',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(
              Icons.lock_outline,
              color: _gold,
              size: 36,
            ),
            SizedBox(height: 18),
            Text(
              'CANAL DE COMUNICACIÓN',
              style: TextStyle(
                color: _ivory,
                fontSize: 22,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Las respuestas del equipo se vincularán a tu código de seguimiento. No es necesario utilizar teléfono ni correo electrónico.',
              style: TextStyle(
                color: _ivory,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No hay mensajes nuevos.',
              style: TextStyle(
                color: _bronze,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
}

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'SEGURIDAD',
        child: ListView(
          children: const [
            _SecurityItem(
              title: 'Cifrado',
              detail:
                  'La arquitectura prevé cifrado autenticado antes de almacenar contenido sensible. La demostración actual no realiza transmisión real.',
            ),
            _SecurityItem(
              title: 'Metadatos',
              detail:
                  'La aplicación debe minimizar y eliminar metadatos innecesarios antes de cualquier envío real.',
            ),
            _SecurityItem(
              title: 'Identidad',
              detail:
                  'La identidad del informante y el contenido deben mantenerse en dominios separados.',
            ),
            _SecurityItem(
              title: 'Privacidad',
              detail:
                  'Sin publicidad, analítica ni permisos que no sean necesarios para la función solicitada.',
            ),
            _SecurityItem(
              title: 'Límite importante',
              detail:
                  'Ningún sistema puede garantizar anonimato absoluto si el dispositivo del informante está completamente comprometido.',
            ),
            _SecurityItem(
              title: 'Estado de esta versión',
              detail:
                  'Prototipo local. La recepción real de información permanece bloqueada hasta superar las puertas de seguridad del proyecto.',
            ),
          ],
        ),
      );
}

class _SecurityItem extends StatelessWidget {
  const _SecurityItem({
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _graphite,
          border: Border.all(color: _bronze.withValues(alpha: .25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: _gold,
                fontSize: 11,
                letterSpacing: 1.7,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              style: const TextStyle(
                color: _ivory,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ),
      );
}
