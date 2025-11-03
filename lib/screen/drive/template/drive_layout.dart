// Di file drive_layout.dart

import 'package:flutter/material.dart';
// Impor model UI Anda dan Card baru Anda
import '../drive_home.dart';
import '../drive_item_model.dart';
import 'drive_item_card.dart';

class DriveGrid extends StatelessWidget {
  final List<DriveItemModel> items;
  final bool isList;
  final void Function(DriveItemModel)? onItemTap;
  final VoidCallback? onUpdateChanged;

  const DriveGrid({
    super.key,
    required this.items,
    this.isList = false,
    this.onItemTap,
    this.onUpdateChanged
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: isList
          ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final bool isFolder = item.type==DriveItemType.folder;
          return DriveItemCard(
            title: isFolder ? item.nama : "${item.nama}.${item.mimeType}",
            isList: true,
            isStarred: item.isStarred,
            type: item.type, // <-- Kirim tipenya
            onTap: (_) => onItemTap?.call(item),
            parentName: item.parentName!,
            item: item,
            onUpdateChanged: onUpdateChanged,
          );
        },
      )
          : GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool isFolder = item.type==DriveItemType.folder;
          return DriveItemCard(
            title: isFolder ? item.nama : "${item.nama}.${item.mimeType}",
            isList: false,
            isStarred: item.isStarred,
            type: item.type, // <-- Kirim tipenya
            onTap: (_) => onItemTap?.call(item),
            parentName: item.parentName!,
            item: item,
            onUpdateChanged: onUpdateChanged,
          );
        }),
      ),
    );
  }
}