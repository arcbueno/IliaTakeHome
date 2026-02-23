import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_page.dart';
import 'package:ilia_contacts/features/contacts/create_contact/create_contact_page.dart';
import '../../features/splash/splash_page.dart';

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
      path: ContactsListPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return const ContactsListPage();
      },
    ),
    GoRoute(
      path: CreateContactPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return const CreateContactPage();
      },
    ),
  ],
);
