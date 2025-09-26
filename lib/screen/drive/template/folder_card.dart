import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vas_reporting/screen/drive/pages/detail_page.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';

import '../../../tools/popup.dart';
import '../../../tools/routing.dart';

// <<====== WIDGET FOLDER CARD ======>>
// Menampilkan folder dalam bentuk card (ListView atau GridView)
class FolderCard extends StatelessWidget {
  final String title;                     // nama folder
  final bool isList;                      // mode tampilan
  final void Function(String)? onTap;     // callback klik folder

  const FolderCard({
    super.key,
    required this.title,
    this.isList = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isList) {
      // <<====== MODE LIST VIEW ======>>
      return ListTile(
        leading: const Icon(Icons.folder, color: Colors.orange),
        title: Text(title, overflow: TextOverflow.ellipsis),
        subtitle: const Text("Folder"),
        onTap: () => onTap?.call(title),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showOptions(context),
        ),
      );
    } else {
      // <<====== MODE GRID VIEW ======>>
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onTap?.call(title),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // <<====== HEADER (Judul + Tombol Opsi) ======>>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _showOptions(context),
                  ),
                ],
              ),

              // <<====== ICON FOLDER ======>>
              const Flexible(
                child: Icon(Icons.folder, size: 100, color: Colors.deepOrange),
              ),
            ],
          ),
        ),
      );
    }
  }

  // <<====== BOTTOM SHEET MENU OPSI ======>>
  void _showOptions(BuildContext context) {
    final rootContext = context;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        final popup = PopUpWidget(rootContext);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header folder di bottomsheet
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.folder, color: Colors.deepOrange, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // <<====== OPSI: Ganti Nama ======>>
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline, color: Colors.deepOrange),
              title: const Text("Ganti nama"),
              onTap: () async {
                Navigator.pop(sheetContext); // tutup bottomsheet
                final newName = await popup.showTextInputDialog(
                  title: "Ganti nama",
                  initialValue: title,
                );
                if (newName != null && newName.isNotEmpty) {
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(content: Text("Folder \"$title\" diganti menjadi \"$newName\"")),
                  );
                }
              },
            ),

            // <<====== OPSI: Tambah ke Berbintang ======>>
            ListTile(
              leading: const Icon(Icons.star_border, color: Colors.deepOrange),
              title: const Text("Tambahkan ke Berbintang"),
              onTap: () {
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  SnackBar(content: Text("Folder \"$title\" ditambahkan ke Berbintang")),
                );
              },
            ),

            // <<====== OPSI: Detail Informasi ======>>
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.deepOrange),
              title: const Text("Detail informasi"),
              onTap: () {
                Navigator.pop(sheetContext);
                Navigator.of(rootContext).push(
                  routingPage(
                    DetailPage(
                      title: title,
                      jenis: "Folder",
                      lokasi: "VAS Drive",
                      dibuat: "15 Sep 2025",
                      diubah: "15 Sep 2025 oleh Fais",
                      icon: Icons.folder_rounded,
                    ),
                  ),
                );
              },
            ),

            // <<====== OPSI: Hapus ======>>
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.deepOrange),
              title: const Text("Hapus"),
              onTap: () async {
                Navigator.pop(sheetContext);
                final confirm = await popup.showConfirmDialog(
                  title: "Pindahkan ke Sampah?",
                  message: "Folder \"$title\" akan dihapus selamanya setelah 30 hari",
                  confirmText: "Pindahkan ke Sampah",
                  cancelText: "Batal",
                );
                if (confirm == true) {
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(content: Text("Berhasil memindahkan Folder \"$title\" ke Sampah.")),
                  );
                }
              },
            ),

            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
