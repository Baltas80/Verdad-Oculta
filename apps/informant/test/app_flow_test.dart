import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/main.dart';

void main() {
  testWidgets('boots to the locked home shell', (tester) async {
    await tester.pumpWidget(const VerdadOcultaApp());
    expect(find.text('VERDAD OCULTA'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump();

    expect(find.text('HAY HISTORIAS QUE\nNO PUEDEN SEGUIR OCULTAS'), findsOneWidget);
    expect(find.text('REVELAR INFORMACIÓN'), findsOneWidget);
  });

  testWidgets('local reveal flow never presents itself as a real transmission',
      (tester) async {
    // Exercise the flow at a phone-like viewport rather than the small
    // desktop-oriented default test surface.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const VerdadOcultaApp());
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump();

    await tester.tap(find.text('Revelar'));
    await tester.pump();

    expect(find.text('¿QUÉ QUIERES REVELAR?'), findsOneWidget);
    await tester.tap(find.text('Texto'));
    await tester.tap(find.widgetWithText(FilledButton, 'CONTINUAR'));
    await tester.pump();

    expect(find.text('DESCRIBE LA INFORMACIÓN'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'CONTINUAR'));
    await tester.pump();

    expect(find.text('NIVEL DE CONFIDENCIALIDAD'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'PROTEGER Y CONTINUAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));

    expect(find.text('PREPARACIÓN LOCAL COMPLETADA'), findsOneWidget);
    expect(find.text('NO SE HA ENVIADO INFORMACIÓN REAL.'), findsOneWidget);
    expect(find.textContaining('REFERENCIA DEMO'), findsOneWidget);
  });
}
