import 'package:flutter/material.dart';

import 'FolderCard.dart';

class DriveGrid extends StatelessWidget {
  final List<String> items;
  final bool isList;
  final void Function(String)? onFolderTap;

  const DriveGrid({
    super.key,
    required this.items,
    this.isList = false,
    this.onFolderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: isList
          ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) =>
            FolderCard(title: items[index], onTap: onFolderTap),
      )
          : GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: items
            .map((title) => FolderCard(title: title, onTap: onFolderTap))
            .toList(),
      ),
    );
  }
}
