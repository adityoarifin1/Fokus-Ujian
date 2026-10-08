import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });
  testWidgets('admin can login and open dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const FokusUjianApp());

    expect(find.text('Login Pengawas'), findsOneWidget);
    await tester.tap(find.text('Login Pengawas'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('username')), 'admin');
    await tester.enterText(find.byKey(const Key('password')), 'admin123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Admin'), findsOneWidget);
  });
}