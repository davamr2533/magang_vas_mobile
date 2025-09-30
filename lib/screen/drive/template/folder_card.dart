import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/pages/detail_page.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';
import 'package:vas_reporting/screen/drive/tools/drive_routing.dart';

import '../../../tools/popup.dart';

// <<====== WIDGET FOLDER CARD ======>>
// Menampilkan folder dalam bentuk card (ListView atau GridView)
class FolderCard extends StatelessWidget {
  final String title; // nama folder
  final bool isList; // mode tampilan
  final void Function(String)? onTap; // callback klik folder

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
      return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.orange.withValues(alpha: 0.5),
          highlightColor: Colors.orange.withValues(
            alpha: 0.2,
          ), // warna saat ditekan
          splashFactory: InkRipple.splashFactory,
          onTap: () => onTap?.call(title),
          child: ListTile(
            leading: const Icon(Icons.folder, color: Colors.orange),
            title: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontSize: 16
              ),
            ),
            subtitle: Text(
              "Folder",
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showOptions(context),
            ),
          ),
        ),
      );
    } else {
      // <<====== MODE GRID VIEW ======>>
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          splashColor: Colors.orange.withValues(alpha: 0.5),
          highlightColor: Colors.orange.withValues(
            alpha: 0.2,
          ), // warna saat ditekan
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(16),
          onTap: () => onTap?.call(title),
          child: Ink(
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
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                        ),
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
                  child: Icon(
                    Icons.folder,
                    size: 100,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
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
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
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
              leading: const Icon(
                Icons.drive_file_rename_outline,
                color: Colors.deepOrange,
              ),
              title: Text("Ganti nama", style: GoogleFonts.urbanist()),
              onTap: () async {
                Navigator.pop(sheetContext); // tutup bottomsheet
                final newName = await popup.showTextInputDialog(
                  title: "Ganti nama",
                  initialValue: title,
                );
                if (newName != null && newName.isNotEmpty) {
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Folder \"$title\" diganti menjadi \"$newName\"",
                        style: GoogleFonts.urbanist(),
                      ),
                    ),
                  );
                }
              },
            ),

            // <<====== OPSI: Tambah ke Berbintang ======>>
            ListTile(
              leading: const Icon(Icons.star_border, color: Colors.deepOrange),
              title: Text(
                "Tambahkan ke Berbintang",
                style: GoogleFonts.urbanist(),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Folder \"$title\" ditambahkan ke Berbintang",
                      style: GoogleFonts.urbanist(),
                    ),
                  ),
                );
              },
            ),

            // <<====== OPSI: Detail Informasi ======>>
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.deepOrange),
              title: Text("Detail informasi", style: GoogleFonts.urbanist()),
              onTap: () {
                Navigator.pop(sheetContext);
                Navigator.of(rootContext).push(
                  DriveRouting(
                    page: DetailPage(
                      title: title,
                      jenis: "Folder",
                      lokasi: "VAS Drive",
                      dibuat: "15 Sep 2025",
                      diubah: "15 Sep 2025 oleh Fais",
                      icon: Icons.folder_rounded,
                    ),
                    transitionType: RoutingTransitionType.slide,
                  ),
                );
              },
            ),

            // <<====== OPSI: Hapus ======>>
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.deepOrange,
              ),
              title: Text("Hapus", style: GoogleFonts.urbanist()),
              onTap: () async {
                Navigator.pop(sheetContext);
                final confirm = await popup.showConfirmDialog(
                  title: "Pindahkan ke Sampah?",
                  message:
                      "Folder \"$title\" akan dihapus selamanya setelah 30 hari",
                  confirmText: "Pindahkan ke Sampah",
                  cancelText: "Batal",
                );
                if (confirm == true) {
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Berhasil memindahkan Folder \"$title\" ke Sampah.",
                        style: GoogleFonts.urbanist(),
                      ),
                    ),
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
