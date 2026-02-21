import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_page.dart';
import '../../features/contacts/contacts_page.dart'; // Placeholder, I'll create this next

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: '/contacts',
      builder: (BuildContext context, GoRouterState state) {
        return const ContactsPage();
      },
    ),
  ],
);
