import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/drive/pages/detail_page.dart';
import 'package:vas_reporting/screen/drive/tools/drive_controller.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';
import 'package:vas_reporting/screen/drive/tools/drive_routing.dart';

import '../../../tools/popup.dart';

// <<====== WIDGET FOLDER CARD ======>>
// Menampilkan folder dalam bentuk card (ListView atau GridView)
class FolderCard extends StatelessWidget {
  final String title; // nama folder
  final int itemId;
  final String token;
  final String userId;
  final bool isList; // mode tampilan
  final bool itemName;
  final bool isStarred;
  final void Function(String)? onTap; // callback klik folder

  const FolderCard({
    super.key,
    required this.title,
    required this.itemId,
    required this.userId,
    required this.token,
    required this.itemName,
    this.isList = false,
    this.isStarred = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // <<====== MODE LIST VIEW ======>>
    if (isList) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3), // warna outline
            width: 1.2, // ketebalan outline
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.orange.withValues(alpha: 0.5),
            highlightColor: Colors.orange.withValues(alpha: 0.2),
            splashFactory: InkRipple.splashFactory,
            onTap: () => onTap?.call(title),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // === ICON FOLDER ===
                  const Icon(
                    Icons.folder,
                    color: orangeNewAmikom,
                    size: 40,
                  ),
                  const SizedBox(width: 12),

                  // === TEKS BAGIAN TENGAH ===
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama folder
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // bintang + Tanggal + ukuran
                        Row(
                          children: [
                            if (isStarred)
                              const Padding(
                                padding: EdgeInsets.only(left: 2),
                                child: Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            Text(
                              "15 Sep 2025 | 2.4 GB", // harusnya diisi "$date | $size",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),

                  // === TITIK TIGA ===
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 22),
                    onPressed: () => _showOptions(context),
                  ),
                ],
              ),
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
              color: pinkNewAmikom,
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
                    Icon(Icons.folder, color: orangeNewAmikom),
                    Padding(padding: EdgeInsetsGeometry.only(right: 10)),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
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
                Flexible(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.folder,
                        size: 100,
                        color: orangeNewAmikom,
                      ),
                      if (isStarred)
                        const Positioned(
                          right: 15, // posisi bintang di kanan
                          bottom: 22, // bisa disesuaikan
                          child: Icon(
                            Icons.star,
                            size: 15, // <<< ubah ukuran bintang di sini
                            color: Colors.white, // warna bintang),
                          ),
                        ),
                    ],
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
                  const Icon(Icons.folder, color: orangeNewAmikom, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.urbanist(fontSize: 16),
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
                color: orangeNewAmikom,
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
              leading: Icon(
                isStarred ? Icons.star : Icons.star_border,
                color: isStarred ? Colors.amber : orangeNewAmikom,
              ),
              title: Text(
                isStarred ? "Hapus dari Berbintang" : "Tambahkan ke Berbintang",
                style: GoogleFonts.urbanist(),
              ),
              onTap: () async {
                await toggleStarAction(context, token, itemId, userId, isStarred as String, itemName);
                Navigator.pop(context); // tutup popup
              },
            ),


            // <<====== OPSI: Detail Informasi ======>>
            ListTile(
              leading: const Icon(Icons.info_outline, color: orangeNewAmikom),
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
              leading: const Icon(Icons.delete_outline, color: orangeNewAmikom),
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
