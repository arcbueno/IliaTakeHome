import 'package:flutter/material.dart';

class EmptyContactsListWidget extends StatelessWidget {
  const EmptyContactsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contacts, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No contacts found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
