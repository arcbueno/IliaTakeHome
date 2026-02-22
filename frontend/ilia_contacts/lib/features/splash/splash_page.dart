import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simulate initialization or check auth status
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Navigate to home after splash
        context.go(ContactsListPage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
