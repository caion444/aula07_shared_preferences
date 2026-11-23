import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aula07_shared_preferences/main.dart';

void main() {
  testWidgets('Carrega e exibe preferencias locais', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const Aula07PreferenciasApp());
    await tester.pumpAndSettle();

    expect(find.text('Preferências Locais - Aula 07'), findsOneWidget);
    expect(find.text('Receber Notificações'), findsOneWidget);
    expect(find.text('Limpar Configurações'), findsOneWidget);
  });
}
