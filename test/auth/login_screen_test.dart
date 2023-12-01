import 'package:accessflow/auth/presentation/login_screen.dart';
import 'package:accessflow/main_navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:accessflow/utils/strings.dart';

void loginTest() {
  testWidgets('Login screen displays UI elements', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(LoginScreen());

    // Verify that the login screen displays the expected UI elements.
    expect(find.text(GlobalAssets.ktpText), findsOneWidget);
    expect(find.text(GlobalAssets.passwordText), findsOneWidget);
    expect(find.text(LoginAssets.loginText), findsOneWidget);
    expect(find.text(LoginAssets.forgotPasswordText), findsOneWidget);
  });

  testWidgets('Entering valid credentials triggers login',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(LoginScreen());

    // Enter valid credentials and tap the login button.
    await tester.enterText(
        find.byType(TextField).first, 'validemail@example.com');
    await tester.enterText(find.byType(TextField).last, 'validpassword');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify that the loading dialog is displayed.
    expect(find.text('Loading...'), findsOneWidget);

    // Verify that the main navigation screen is eventually displayed.
    await tester.pump(const Duration(seconds: 3)); // Adjust duration as needed
    expect(find.byType(MainNavigation), findsOneWidget);
  });

  testWidgets('Entering invalid credentials shows error message',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(LoginScreen());

    // Enter invalid credentials and tap the login button.
    await tester.enterText(
        find.byType(TextField).first, 'invalidemail@example.com');
    await tester.enterText(find.byType(TextField).last, 'invalidpassword');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify that the error flash message is displayed.
    expect(find.text('Error'), findsOneWidget);
    expect(find.text('Authentication failed'), findsOneWidget);
  });
}
