import 'package:flutter/material.dart';
import 'folder_card.dart';

// <<====== WIDGET DRIVE GRID / LIST VIEW ======>>
class DriveGrid extends StatelessWidget {
  final List<String> items;              // daftar nama folder/file
  final List<int> itemId;
  final String userId;
  final String token;
  final bool name;
  final bool isList;                     // mode tampilan: true = list, false = grid
  final List<bool> isStarred;            // <── ubah dari bool ke List<bool>
  final void Function(String)? onFolderTap; // callback saat folder diklik

  const DriveGrid({
    super.key,
    required this.items,
    required this.userId,
    required this.token,
    required this.name,
    required this.itemId,
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
          itemId: itemId[index],
          token: token,
          userId: userId,
          itemName: name,
          isList: true,
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
            itemId: itemId[index],
            token: token,
            itemName: name,
            userId: userId,
            isList: false,
            isStarred: isStarred[index],
            onTap: onFolderTap,
          );
        }),
      ),
    );
  }
}
