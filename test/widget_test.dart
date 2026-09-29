import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('admin can login and open dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const FokusUjianApp());

    expect(find.text('Login Pengawas'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('username')), 'guru');
    await tester.enterText(find.byKey(const ValueKey('password')), 'admin123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Guru'), findsOneWidget);
    expect(find.text('Bank Soal'), findsOneWidget);
  });
}