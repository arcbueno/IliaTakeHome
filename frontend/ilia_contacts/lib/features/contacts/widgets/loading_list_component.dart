import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingListComponent extends StatelessWidget {
  const LoadingListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            title: Container(
              height: 8,
              color: Theme.of(context).colorScheme.surface,
            ),
            subtitle: Container(
              height: 8,
              color: Theme.of(context).colorScheme.surface,
              margin: EdgeInsets.only(top: 8),
            ),
          ),
        );
      },
    );
  }
}
