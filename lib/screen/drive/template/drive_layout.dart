import 'package:flutter/material.dart';
import 'folder_card.dart';

// <<====== WIDGET DRIVE GRID / LIST VIEW ======>>
class DriveGrid extends StatelessWidget {
  final List<String> items; // daftar nama folder/file
  final bool isList;        // mode tampilan: true = list, false = grid
  final void Function(String)? onFolderTap; // callback saat folder diklik

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

      // <<====== MODE LIST ======>>
      child: isList
          ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => FolderCard(
          title: items[index], // judul folder
          isList: true,        // tampil dalam mode list
          onTap: onFolderTap,  // aksi saat diklik
        ),
      )

      // <<====== MODE GRID ======>>
          : GridView.count(
        crossAxisCount: 2,      // jumlah kolom
        childAspectRatio: 1.1,  // rasio lebar:tinggi item
        mainAxisSpacing: 12,    // jarak antar baris
        crossAxisSpacing: 12,   // jarak antar kolom
        children: items
            .map((title) => FolderCard(
          title: title,
          isList: false,      // tampil dalam mode grid
          onTap: onFolderTap, // aksi saat diklik
        ))
            .toList(),
      ),
    );
  }
}
