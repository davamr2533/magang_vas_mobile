import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class DriveItemCard extends StatelessWidget {
  final String title;
  final String parentName;
  final DriveItemModel item;
  final bool isList;
  final bool isStarred;
  final DriveItemType type;
  final void Function(String)? onTap;
  final VoidCallback? onUpdateChanged;

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

  // Tetap dipakai di logic internal
  IconData getFileIcon(String? mimeType, bool isFolder, bool isStarred) {
    if (isFolder) return Icons.folder;
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
    final bool isFolder = type == DriveItemType.folder;
    final IconData mainIcon = getFileIcon(item.mimeType, isFolder, isStarred);

    final String diubah = DateFormat('d MMM yyyy').format(item.updateAt);
    final String dibuat = DateFormat('d MMM yyyy').format(item.createdAt);
    final String subtitleText = item.createdAt == item.updateAt
        ? "Dibuat pada $dibuat"
        : "Diubah pada $diubah";

    // =============== LIST MODE ===================
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
                onTap?.call(title);
              } else {
                if (item.url != null && item.url!.isNotEmpty) {
                  try {
                    final tempDir = await getTemporaryDirectory();
                    final filePath =
                        "${tempDir.path}/${item.nama}.${item.mimeType}";
                    final response = await http.get(
                      Uri.parse("$url${item.url!}"),
                    );
                    final file = await File(
                      filePath,
                    ).writeAsBytes(response.bodyBytes);
                    await OpenFilex.open(file.path);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal membuka file: $e")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("File tidak ditemukan")),
                  );
                }
              }
            },
            child: ListTile(
              leading: buildMimeIcon(
                isFolder: isFolder,
                mimeType: item.mimeType,
                mainIcon: mainIcon,
                color: orangeNewAmikom,
                size: 26,
                isStarred: item.isStarred,
              ),

              title: Text(title, overflow: TextOverflow.ellipsis),
              subtitle: item.isStarred == true
                  ? RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.0,
                          color: Colors.black,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: Transform.translate(
                              offset: const Offset(0, 1.5),
                              child: const Icon(
                                Icons.star,
                                size: 12,
                                color: orangeNewAmikom,
                              ),
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(text: subtitleText),
                        ],
                      ),
                    )
                  : Text(subtitleText, style: const TextStyle(fontSize: 12)),

              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showOptions(context, mainIcon),
              ),
            ),
          ),
        ),
      );
    }
    // =============== GRID MODE ===================
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
              onTap?.call(title);
            } else {
              if (item.url != null && item.url!.isNotEmpty) {
                try {
                  final tempDir = await getTemporaryDirectory();
                  final filePath =
                      "${tempDir.path}/${item.nama}.${item.mimeType}";
                  final response = await http.get(
                    Uri.parse("$url${item.url!}"),
                  );
                  final file = await File(
                    filePath,
                  ).writeAsBytes(response.bodyBytes);
                  await OpenFilex.open(file.path);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal membuka file: $e")),
                  );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildMimeIcon(
                      isFolder: isFolder,
                      mimeType: item.mimeType,
                      mainIcon: mainIcon,
                      color: orangeNewAmikom,
                      isStarred: item.isStarred,
                    ),
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
                      onPressed: () => _showOptions(context, mainIcon),
                    ),
                  ],
                ),

                // thumbnail
                if (!isFolder &&
                    item.mimeType != null &&
                    (item.mimeType!.contains('jpeg') ||
                        item.mimeType!.contains('jpg') ||
                        item.mimeType!.contains('png') ||
                        item.mimeType!.contains('gif') ||
                        item.mimeType!.contains('svg')))
                  Flexible(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "$url${item.url!}",
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (_, __, ___) => Icon(
                              mainIcon,
                              size: 100,
                              color: orangeNewAmikom,
                            ),
                          ),
                        ),

                        if (item.isStarred)
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.star,
                                size: 18,
                                color: orangeNewAmikom,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                else if (!isFolder && item.mimeType!.contains('pdf'))
                  SizedBox(
                    height: 83,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Pratinjau file PDF
                        PdfThumbnail(url: "$url${item.url!}"),

                        // Ikon bintang di kanan bawah jika item di-star
                        if (item.isStarred)
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.star,
                                size: 18,
                                color: orangeNewAmikom,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  Flexible(
                    child: isFolder
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.folder,
                                size: 100,
                                color: orangeNewAmikom,
                              ),
                              if (item.isStarred)
                                Positioned(
                                  bottom: 6,
                                  right: 12,
                                  child: Icon(
                                    Icons.star,
                                    size: 20,
                                    color: pinkNewAmikom,
                                  ),
                                ),
                            ],
                          )
                        : buildMimeIcon(
                            isFolder: isFolder,
                            mimeType: item.mimeType,
                            mainIcon: mainIcon,
                            color: orangeNewAmikom,
                            size: 100,
                      isStarred: item.isStarred,
                          ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // bottom sheet (tidak diubah, tetap pakai mainIcon)
  void _showOptions(BuildContext context, IconData mainIcon) {
    final rootContext = context;
    final bool isFolder = type == DriveItemType.folder;

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
                            content: Text(
                              "Anda tidak memiliki izin untuk mengubah item ini.",
                            ),
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
                if (!isFolder && !item.isTrashed)
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
                        final filePath =
                            "${directory!.path}/${item.nama}.${item.mimeType}";
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
                          isFolder ? item.id : null,
                          isFolder ? null : item.id,
                          item.userId!,
                          !item.isStarred
                      );

                      onUpdateChanged?.call();
                    },

                  ),

                // ============= Opsi: Lihat Detail Informasi ============
                if (!item.isTrashed)
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
                      Navigator.pop(sheetContext);
                      Navigator.of(rootContext).push(
                        DriveRouting(
                          page: DetailPage(
                            title: isFolder
                                ? item.nama
                                : "${item.nama}.${item.mimeType}",
                            item: item,
                            lokasi: parentName,
                            icon: mainIcon,
                          ),
                          transitionType: RoutingTransitionType.slide,
                        ),
                      );
                    },
                  ),

                // ============= Opsi: Hapus / Pulihkan ============
                _deleteButton(
                  sheetContext,
                  rootContext,
                  item,
                  token!,
                  username!,
                    isFolder,
                ),

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
    String username,
      bool isFolder
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
                content: Text(
                  "Anda tidak memiliki izin untuk mengubah item ini.",
                ),
              ),
            );
            return;
          }
          await addToTrash(
              rootContext,
              token,
              title,
              isFolder ? item.id : null,
              isFolder ? null : item.id,
              item.userId!,
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
                title,
                isFolder ? item.id : null,
                isFolder ? null : item.id,
                item.userId!,
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
                title,
                isFolder ? item.id : null,
                isFolder ? null : item.id,
                item.userId!,
              );
              onUpdateChanged?.call();
            },
          ),
        ],
      );
    }
  }

  // Fungsi reusable di dalam file ini saja
  Widget buildMimeIcon({
    required bool isFolder,
    required String? mimeType,
    required IconData mainIcon,
    required Color color,
    required bool isStarred,
    double size = 28,
  }) {
    final mime = mimeType?.toLowerCase() ?? '';
    Widget fallback = Icon(mainIcon, color: color, size: size);

    // Fungsi pembungkus untuk menambahkan ikon bintang di kanan bawah jika perlu
    Widget withStar(Widget child) {
      if (isStarred && size == 100) {
        return Stack(
          alignment: Alignment.center,
          children: [
            child,
            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.star,
                  size: 18,
                  color: orangeNewAmikom,
                ),
              ),
            ),
          ],
        );
      }
      return child;
    }

    try {
      if (isFolder) {
        return withStar(fallback);
      } else if (mime.contains('pdf')) {
        return withStar(
          SvgPicture.asset(
            'assets/pdf.svg',
            height: size,
            width: size,
            placeholderBuilder: (_) => fallback,
          ),
        );
      } else if (mime.contains('doc') || mime.contains('docx')) {
        return withStar(
          SvgPicture.asset(
            'assets/word.svg',
            height: size,
            width: size,
            placeholderBuilder: (_) => fallback,
          ),
        );
      } else if (mime.contains('xls') || mime.contains('xlsx')) {
        return withStar(
          SvgPicture.asset(
            'assets/excel.svg',
            height: size,
            width: size,
            placeholderBuilder: (_) => fallback,
          ),
        );
      } else {
        return withStar(fallback);
      }
    } catch (_) {
      return withStar(fallback);
    }
  }

}
