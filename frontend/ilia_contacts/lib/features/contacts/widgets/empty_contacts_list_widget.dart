import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyContactsListWidget extends StatelessWidget {
  const EmptyContactsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contacts, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'no_contacts_found'.tr(),
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
