import 'package:flutter/material.dart';

class ListErrorWidget extends StatelessWidget {
  final String message;
  const ListErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
