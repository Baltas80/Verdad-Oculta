import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/main.dart';

void main() {
  testWidgets('security screen keeps staging disabled by default',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SecurityScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('BACKEND DE STAGING'), findsOneWidget);
    expect(find.text('STAGING NO CONFIGURADO'), findsOneWidget);
    expect(find.text('COMPROBAR'), findsNothing);
  });
}
