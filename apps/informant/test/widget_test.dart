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
}
