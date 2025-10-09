import 'package:flutter/material.dart';
import 'folder_card.dart';

// <<====== WIDGET DRIVE GRID / LIST VIEW ======>>
class DriveGrid extends StatelessWidget {
  final List<String> items;              // daftar nama folder/file
  final bool isList;                     // mode tampilan: true = list, false = grid
  final List<bool> isStarred;            // <── ubah dari bool ke List<bool>
  final void Function(String)? onFolderTap; // callback saat folder diklik

  const DriveGrid({
    super.key,
    required this.items,
    this.isList = false,
    required this.isStarred,
    this.onFolderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),

      // <<====== MODE LIST ======>>
      child: isList
          ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => FolderCard(
          title: items[index],
          isList: true,
          isStarred: isStarred[index],
          onTap: onFolderTap,
          // isStarred: isStarred[index],
        ),
      )

      // <<====== MODE GRID ======>>
          : GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(items.length, (index) {
          return FolderCard(
            title: items[index],
            isList: false,
            isStarred: isStarred[index],
            onTap: onFolderTap,
          );
        }),
      ),
    );
  }
}
