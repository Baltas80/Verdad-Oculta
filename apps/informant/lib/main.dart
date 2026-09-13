import 'package:flutter/material.dart';

const _obsidian = Color(0xFF0B0C0E);
const _graphite = Color(0xFF17191D);
const _ivory = Color(0xFFF1EFEA);
const _gold = Color(0xFFC6A76A);
const _bronze = Color(0xFF8E7650);

void main() => runApp(const VerdadOcultaApp());

class VerdadOcultaApp extends StatelessWidget {
  const VerdadOcultaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VERDAD OCULTA',
                    style: TextStyle(
                      color: _ivory,
                      fontSize: 18,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 56),
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
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: _gold,
                        foregroundColor: _obsidian,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onPressed: () {},
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
                  const SizedBox(height: 24),
                  const _QuietTile(label: 'MIS ENVÍOS'),
                  const _QuietTile(label: 'BUZÓN SEGURO'),
                  const _QuietTile(label: 'SEGURIDAD'),
                  const Spacer(),
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
          ),
        ),
      ),
    );
  }
}

class _QuietTile extends StatelessWidget {
  const _QuietTile({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _graphite,
        border: Border.all(color: _bronze.withValues(alpha: .28)),
      ),
      child: ListTile(
        dense: true,
        title: Text(
          label,
          style: const TextStyle(
            color: _ivory,
            fontSize: 12,
            letterSpacing: 1.8,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 13, color: _bronze),
      ),
    );
  }
}
