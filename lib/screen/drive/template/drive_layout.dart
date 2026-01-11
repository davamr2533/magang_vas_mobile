import 'package:flutter/material.dart';
import '../drive_item_model.dart';
import 'drive_item_card.dart';


class DriveGrid extends StatelessWidget {
  final List<DriveItemModel> items;
  final String username;
  final bool isList;
  final void Function(DriveItemModel)? onItemTap;
  final VoidCallback? onUpdateChanged;

  const DriveGrid({
    super.key,
    required this.items,
    required this.username,
    this.isList = false,
    this.onItemTap,
    this.onUpdateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 0, right: 12),
      child: isList
          ? ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: false,
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final bool isFolder = item.type == DriveItemType.folder;
          return DriveItemCard(
            title: isFolder ? item.nama : "${item.nama}.${item.mimeType}",
            isList: true,
            isStarred: item.isStarred,
            type: item.type,
            onTap: (_) => onItemTap?.call(item),
            parentName: item.parentName ?? '',
            item: item,
            username: username,
            onUpdateChanged: onUpdateChanged,
          );
        },
      )
          : GridView.count(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: false,
        padding: const EdgeInsets.only(bottom: 100),
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool isFolder = item.type == DriveItemType.folder;
          return DriveItemCard(
            title: isFolder ? item.nama : "${item.nama}.${item.mimeType}",
            isList: false,
            isStarred: item.isStarred,
            type: item.type,
            onTap: (_) => onItemTap?.call(item),
            parentName: item.parentName ?? '',
            item: item,
            username: username,
            onUpdateChanged: onUpdateChanged,
          );
        }),
      ),
    );
  }
}
