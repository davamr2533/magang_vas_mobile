import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/base/base_paths.dart';
import 'package:vas_reporting/screen/drive/pages/detail_page.dart';
import 'package:vas_reporting/screen/drive/tools/delete_item.dart';
import 'package:vas_reporting/screen/drive/tools/drive_routing.dart';
import 'package:vas_reporting/screen/drive/tools/recovery_item.dart';

import '../../../tools/popup.dart';
import '../../../utllis/app_shared_prefs.dart';
import '../drive_item_model.dart';
import '../tools/drive_controller.dart';
import '../tools/pdf_thumbnail.dart';

// =============================================================
// ============= WIDGET: DRIVE ITEM CARD =======================
// Widget ini digunakan untuk menampilkan 1 item di Drive (file/folder)
// Bisa ditampilkan dalam dua mode: List View atau Grid View
// =============================================================
class DriveItemCard extends StatelessWidget {
  final String title;
  final String parentName;
  final DriveItemModel item;
  final bool isList; // true = mode daftar, false = mode grid
  final bool isStarred; // menandai apakah item diberi bintang
  final DriveItemType type; // tipe item (folder/file)
  final void Function(String)? onTap; // aksi ketika diklik
  final VoidCallback? onUpdateChanged; // callback untuk refresh

  const DriveItemCard({
    super.key,
    required this.title,
    required this.parentName,
    required this.item,
    required this.type,
    this.isList = false,
    this.isStarred = false,
    this.onTap,
    this.onUpdateChanged,
  });

  // Tentukan ikon sesuai tipe file (tanpa ubah struktur utama)
  IconData getFileIcon(String? mimeType, bool isFolder, bool isStarred) {
    if (isFolder) return isStarred ? Icons.folder_special : Icons.folder;
    if (mimeType == null) return Icons.insert_drive_file;

    final ext = mimeType.toLowerCase();

    if (ext.contains('jpeg') ||
        ext.contains('jpg') ||
        ext.contains('png') ||
        ext.contains('gif') ||
        ext.contains('svg')) {
      return Icons.image_rounded;
    } else if (ext.contains('pdf')) {
      return Icons.picture_as_pdf_rounded;
    } else if (ext.contains('doc') || ext.contains('docx')) {
      return Icons.description_rounded;
    } else if (ext.contains('xls')) {
      return Icons.table_chart_rounded;
    } else {
      return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ============= Tentukan ikon & subtitle berdasarkan tipe item ============
    final bool isFolder = type == DriveItemType.folder;
    final IconData mainIcon = getFileIcon(item.mimeType, isFolder, isStarred);

    final String diubah = DateFormat('d MMM yyyy').format(item.updateAt);
    final String dibuat = DateFormat('d MMM yyyy').format(item.createdAt);
    final String subtitleText = item.createdAt == item.updateAt
        ? "Dibuat pada $dibuat"
        : "Diubah pada $diubah";

    // =============================================================
    // ============= MODE LIST VIEW ===============================
    // Tampilan berbentuk baris (seperti daftar file)
    // =============================================================
    if (isList) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.2),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.orange.withAlpha(50),
            highlightColor: Colors.orange.withAlpha(20),
            onTap: () async {
              if (isFolder) {
                // Folder → masuk folder
                onTap?.call(title);
              } else {
                // File → download dulu kalau URL remote, lalu buka
                if (item.url != null && item.url!.isNotEmpty) {
                  try {
                    // Download file ke temporary directory
                    final tempDir = await getTemporaryDirectory();
                    final filePath =
                        "${tempDir.path}/${item.nama}.${item.mimeType}";
                    final response = await http.get(
                      Uri.parse("$url${item.url!}"),
                    );
                    final file = await File(
                      filePath,
                    ).writeAsBytes(response.bodyBytes);

                    // Buka file
                    await OpenFilex.open(file.path);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal membuka file: $e")),
                    );
                    print("Gagal membuka file: $e");
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("File tidak ditemukan")),
                  );
                }
              }
            },

            child: ListTile(
              leading: Icon(mainIcon, color: orangeNewAmikom),
              title: Text(title, overflow: TextOverflow.ellipsis),
              subtitle: Text(subtitleText, style: TextStyle(fontSize: 12)),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showOptions(context,mainIcon), // buka menu opsi
              ),
            ),
          ),
        ),
      );
    }
    // =============================================================
    // ============= MODE GRID VIEW ================================
    // Tampilan berbentuk kotak (seperti grid folder/file)
    // =============================================================
    else {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          splashColor: Colors.orange.withAlpha(50),
          highlightColor: Colors.orange.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            if (isFolder) {
              // Folder → masuk folder
              onTap?.call(title);
            } else {
              // File → download dulu kalau URL remote, lalu buka
              if (item.url != null && item.url!.isNotEmpty) {
                try {
                  // Download file ke temporary directory
                  final tempDir = await getTemporaryDirectory();
                  final filePath =
                      "${tempDir.path}/${item.nama}.${item.mimeType}";
                  final response = await http.get(
                    Uri.parse("$url${item.url!}"),
                  );
                  final file = await File(
                    filePath,
                  ).writeAsBytes(response.bodyBytes);

                  // Buka file
                  await OpenFilex.open(file.path);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal membuka file: $e")),
                  );
                  print("Gagal membuka file: $e");
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("File tidak ditemukan")),
                );
              }
            }
          },

          child: Ink(
            decoration: BoxDecoration(
              color: pinkNewAmikom,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ============= Header (judul + tombol opsi) ============
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(mainIcon, color: orangeNewAmikom),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _showOptions(context,mainIcon),
                    ),
                  ],
                ),

                // ============= Ikon Utama File / Folder ============
                if (!isFolder &&
                    item.mimeType != null &&
                    (item.mimeType!.contains('jpeg') ||
                        item.mimeType!.contains('jpg') ||
                        item.mimeType!.contains('png') ||
                        item.mimeType!.contains('gif') ||
                        item.mimeType!.contains('svg')))
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "$url${item.url!}",
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (_, __, ___) =>
                            Icon(mainIcon, size: 100, color: orangeNewAmikom),
                      ),
                    ),
                  )
                else if (!isFolder && item.mimeType!.contains('pdf'))
                  SizedBox(
                    height: 83,
                    width: double.infinity,
                    child: PdfThumbnail(url: "$url${item.url!}"),
                  )
                else
                  Flexible(
                    child: Icon(mainIcon, size: 100, color: orangeNewAmikom),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // =============================================================
  // ============= BOTTOM SHEET MENU OPSI ========================
  // Ditampilkan saat user menekan tombol "more" (3 titik)
  // Berisi aksi seperti: Rename, Download, Tambah Bintang, Detail, Hapus
  // =============================================================
  void _showOptions(BuildContext context, IconData mainIcon) {
    final rootContext = context;

    final bool isFolder = type == DriveItemType.folder;
    final String itemTypeText = isFolder ? "Folder" : "File";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        final popup = PopUpWidget(rootContext);
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            SharedPref.getToken(),
            SharedPref.getUsername(),
          ]),
          builder: (tokenContext, tokenSnapshot) {
            if (!tokenSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final token = tokenSnapshot.data![0] as String?;
            final username = tokenSnapshot.data![1] as String?;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ============= Header BottomSheet =============
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(mainIcon, color: orangeNewAmikom, size: 28),
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

                // ============= Opsi: Ganti Nama (jika belum dihapus) ============
                if (!item.isTrashed)
                  ListTile(
                    leading: const Icon(
                      Icons.drive_file_rename_outline,
                      color: orangeNewAmikom,
                    ),
                    title: Text("Ganti nama", style: GoogleFonts.urbanist()),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      print((item.userId != username));
                      if (item.userId != username) {
                         ScaffoldMessenger.of(rootContext).showSnackBar(
                          const SnackBar(
                            content: Text("Anda tidak memiliki izin untuk mengubah item ini."),
                          ),
                        );
                         return;
                      }
                      await renameAction(
                        rootContext,
                        token!,
                        item.id,
                        item.type == DriveItemType.folder ? 'folder' : 'file',
                        item.nama,
                      );
                      onUpdateChanged?.call();
                    },
                  ),

                // ============= Opsi: Download (khusus file) ============
                if (!isFolder)
                  ListTile(
                    leading: const Icon(
                      Icons.download_outlined,
                      color: orangeNewAmikom,
                    ),
                    title: Text("Download", style: GoogleFonts.urbanist()),
                    onTap: () async {
                      Navigator.pop(sheetContext);

                      if (item.url == null || item.url!.isEmpty) {
                        ScaffoldMessenger.of(rootContext).showSnackBar(
                          const SnackBar(content: Text("File tidak ditemukan")),
                        );
                        return;
                      }

                      try {
                        final response = await http.get(
                          Uri.parse("$url${item.url!}"),
                        );

                        final directory =
                            await getDownloadsDirectory(); // Android
                        final filePath = "${directory!.path}/${item.nama}.${item.mimeType}";
                        final file = await File(
                          filePath,
                        ).writeAsBytes(response.bodyBytes);

                        ScaffoldMessenger.of(rootContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              "File berhasil disimpan di ${file.path}",
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(rootContext).showSnackBar(
                          SnackBar(content: Text("Gagal mengunduh file: $e")),
                        );
                        print("Gagal mengunduh file: $e");
                      }
                    },
                  ),

                // ============= Opsi: Tambah ke Berbintang ============
                if (!item.isTrashed)
                  ListTile(
                    leading: const Icon(
                      Icons.star_border,
                      color: orangeNewAmikom,
                    ),
                    title: item.isStarred
                        ? Text(
                            "Hapus dari Berbintang",
                            style: GoogleFonts.urbanist(),
                          )
                        : Text(
                            "Tambahkan ke Berbintang",
                            style: GoogleFonts.urbanist(),
                          ),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      await toggleStarAction(
                        rootContext,
                        token!,
                        item.id,
                        item.userId!,
                        item.nama,
                        !item.isStarred,
                        item.type == DriveItemType.folder ? 'folder' : 'file',
                      );
                      onUpdateChanged?.call();
                    },
                  ),

                // ============= Opsi: Lihat Detail Informasi ============
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: orangeNewAmikom,
                  ),
                  title: Text(
                    "Detail informasi",
                    style: GoogleFonts.urbanist(),
                  ),
                  onTap: () {
                    // Debug log informasi item
                    print({
                      'title': item.nama,
                      'jenis': itemTypeText,
                      'ukuran': item.size,
                      'mimeType': item.mimeType,
                      'lokasi': parentName,
                      'dibuat': item.createdAt,
                      'diubah': item.updateAt,
                    });

                    Navigator.pop(sheetContext);
                    Navigator.of(rootContext).push(
                      DriveRouting(
                        page: DetailPage(
                          title: isFolder
                              ? item.nama
                              : "${item.nama}.${item.mimeType}",
                          item: item,
                          lokasi: parentName,
                          icon: mainIcon
                        ),
                        transitionType: RoutingTransitionType.slide,
                      ),
                    );
                  },
                ),

                // ============= Opsi: Hapus / Pulihkan ============
                _deleteButton(sheetContext, rootContext, item, token!, username!),

                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }

  // =============================================================
  // ============= BUILDER TOMBOL HAPUS / PULIHKAN ===============
  // Menampilkan tombol "Hapus", atau jika item sudah dihapus,
  // menampilkan dua tombol: "Pulihkan" & "Hapus Permanen"
  // =============================================================
  Widget _deleteButton(
    BuildContext sheetContext,
    BuildContext rootContext,
    DriveItemModel item,
    String token,
      String username
  ) {
    // Remove the FutureBuilder from here since we're now passing the token directly
    if (!item.isTrashed) {
      // ============= Tombol: Hapus (pindah ke Trash) ============
      return ListTile(
        leading: const Icon(Icons.delete_outline, color: orangeNewAmikom),
        title: Text("Hapus", style: GoogleFonts.urbanist()),
        onTap: () async {
          Navigator.pop(sheetContext);
          if (item.userId != username) {
            ScaffoldMessenger.of(rootContext).showSnackBar(
              const SnackBar(
                content: Text("Anda tidak memiliki izin untuk mengubah item ini."),
              ),
            );
            return;
          }
          await addToTrash(
            rootContext,
            token,
            item.id,
            item.nama,
            item.userId!,
            item.type,
          );
          onUpdateChanged?.call();
        },
      );
    } else {
      // ============= Tombol: Pulihkan dan Hapus Permanen ============
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulihkan item dari Trash
          ListTile(
            leading: const Icon(Icons.restore_outlined, color: orangeNewAmikom),
            title: Text("Pulihkan", style: GoogleFonts.urbanist()),
            onTap: () async {
              Navigator.pop(sheetContext);
              await recoveryDrive(
                rootContext,
                token,
                item.id,
                item.nama,
                item.type,
              );
              onUpdateChanged?.call();
            },
          ),
          // Hapus permanen
          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
              color: orangeNewAmikom,
            ),
            title: Text("Hapus Permanen", style: GoogleFonts.urbanist()),
            onTap: () async {
              Navigator.pop(sheetContext);
              await deleteDrive(
                rootContext,
                token,
                item.id,
                item.nama,
                item.type,
              );
              onUpdateChanged?.call();
            },
          ),
        ],
      );
    }
  }
}
