import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/main.dart';

void main() {
  testWidgets('renders the approved Verdad Oculta home', (tester) async {
    await tester.pumpWidget(const VerdadOcultaApp());

    expect(find.text('VERDAD OCULTA'), findsOneWidget);
    expect(find.text('REVELAR INFORMACIÓN'), findsOneWidget);
    expect(find.text('MIS ENVÍOS'), findsOneWidget);
    expect(find.text('BUZÓN SEGURO'), findsOneWidget);
    expect(find.text('SEGURIDAD'), findsOneWidget);
  });

  testWidgets('does not present the local demo as a real submission', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RevealScreen()),
      ),
    );

    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField),
      'Fixture local sin información sensible.',
    );
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PROTEGER Y CONTINUAR'));
    await tester.pumpAndSettle();

    expect(find.text('PREPARACIÓN LOCAL COMPLETADA'), findsOneWidget);
    expect(find.text('INFORMACIÓN ENVIADA'), findsNothing);
    expect(
      find.textContaining('No se ha creado ninguna transmisión'),
      findsOneWidget,
    );
  });
}
