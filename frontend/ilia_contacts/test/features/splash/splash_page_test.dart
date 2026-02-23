import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_page.dart';
import 'package:ilia_contacts/features/splash/splash_page.dart';

void main() {
  testWidgets(
    'SplashPage should render circular progress indicator and navigate to contacts list',
    (tester) async {
      // Arrange
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const SplashPage()),
          GoRoute(
            path: ContactsListPage.routeName,
            builder: (context, state) =>
                const Scaffold(body: Text('Contacts List Screen')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // Assert Initial State
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Act - Advance Time to trigger navigation
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Assert Navigation
      expect(find.text('Contacts List Screen'), findsOneWidget);
    },
  );
}
