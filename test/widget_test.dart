import 'package:flutter_test/flutter_test.dart';
import 'package:noon_admin/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const NoonAdminApp());
    expect(find.textContaining('Noon'), findsWidgets);
  });
}
