import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/base/base_paths.dart';
import 'package:vas_reporting/screen/drive/pages/detail_page.dart';
import 'package:vas_reporting/screen/drive/tools/delete_item.dart';
import 'package:vas_reporting/screen/drive/tools/drive_routing.dart';
import 'package:vas_reporting/screen/drive/tools/recovery_item.dart';
import '../../../tools/popup.dart';
import '../../../utllis/app_notification.dart';
import '../../../utllis/app_shared_prefs.dart';
import '../data/cubit/get_drive_cubit.dart';
import '../drive_item_model.dart';
import '../tools/drive_controller.dart';
import '../tools/pdf_thumbnail.dart';

class DriveItemCard extends StatelessWidget {
  final String title;
  final String parentName;
  final DriveItemModel item;
  final String username;
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
    required this.username,
    required this.type,
    this.isList = false,
    this.isStarred = false,
    this.onTap,
    this.onUpdateChanged,
  });

  dynamic getFileIcon(String? mimeType, bool isFolder, bool isStarred) {
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
      return "assets/pdf.svg";
    } else if (ext.contains('doc') || ext.contains('docx')) {
      return "assets/word.svg";
    } else if (ext.contains('xls')) {
      return "assets/excel.svg";
    } else {
      return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFolder = type == DriveItemType.folder;
    final dynamic mainIcon = getFileIcon(item.mimeType, isFolder, isStarred);

    final String diubah = DateFormat('d MMM yyyy').format(item.updateAt);
    final String dibuat = DateFormat('d MMM yyyy').format(item.createdAt);
    final String subtitleText = item.createdAt == item.updateAt
        ? "Dibuat pada $dibuat"
        : "Diubah pada $diubah";

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
              _handleItemTap(context, isFolder);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildMimeIcon(
                    isFolder: isFolder,
                    mimeType: item.mimeType,
                    mainIcon: mainIcon,
                    color: orangeNewAmikom,
                    size: 28,
                    isStarred: item.isStarred,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        if (item.isStarred == true && item.userId == username)
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(fontSize: 12),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Transform.translate(
                                    offset: const Offset(0, 3.0),
                                    child: const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: orangeNewAmikom,
                                    ),
                                  ),
                                ),
                                const WidgetSpan(child: SizedBox(width: 4)),
                                TextSpan(text: subtitleText),
                              ],
                            ),
                          )
                        else if (item.userId != username)
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(fontSize: 12),
                              children: [
                                TextSpan(text: subtitleText),
                                const WidgetSpan(child: SizedBox(width: 4)),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Transform.translate(
                                    offset: const Offset(0, 3.5),
                                    child: const Icon(
                                      Icons.group,
                                      size: 16,
                                      color: orangeNewAmikom,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            subtitleText,
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 24),
                    onPressed: () => _showOptions(context, mainIcon),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          splashColor: Colors.orange.withAlpha(50),
          highlightColor: Colors.orange.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            _handleItemTap(context, isFolder);
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
                          child: CachedNetworkImage(
                            imageUrl: "$url${Uri.parse(item.url!).path}",
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: magnoliaWhiteNewAmikom,
                              child: Center(
                                child: Icon(
                                  mainIcon,
                                  size: 50,
                                  color: orangeNewAmikom,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              return Container(
                                color: magnoliaWhiteNewAmikom,
                                child: Center(
                                  child: Icon(
                                    mainIcon,
                                    size: 50,
                                    color: orangeNewAmikom,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (item.isStarred && item.userId == username)
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
                          )
                        else if (item.userId != username)
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
                                Icons.group,
                                size: 18,
                                color: orangeNewAmikom,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                else if (!isFolder &&
                    item.mimeType != null &&
                    item.mimeType!.contains('pdf'))
                  SizedBox(
                    height: 83,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PdfThumbnail(url: "$url${item.url!}"),
                        if (item.isStarred && item.userId == username)
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
                          )
                        else if (item.userId != username)
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
                                Icons.group,
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
                              if (item.isStarred && item.userId == username)
                                Positioned(
                                  bottom: 6,
                                  right: 12,
                                  child: Icon(
                                    Icons.star,
                                    size: 20,
                                    color: pinkNewAmikom,
                                  ),
                                )
                              else if (item.userId != username)
                                Positioned(
                                  bottom: 8,
                                  right: 16,
                                  child: Icon(
                                    Icons.group,
                                    size: 18,
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
                            userId: item.userId,
                          ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> _handleItemTap(BuildContext context, bool isFolder) async {
    if (isFolder) {
      onTap?.call(title);
    } else {
      if (item.url != null && item.url!.isNotEmpty) {
        try {
          final tempDir = await getTemporaryDirectory();
          final filePath = "${tempDir.path}/${item.nama}.${item.mimeType}";
          final response = await http.get(
            Uri.parse("$url${Uri.parse(item.url!).path}"),
          );
          final file = await File(filePath).writeAsBytes(response.bodyBytes);
          await OpenFilex.open(file.path);
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gagal membuka file: $e")));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("File tidak ditemukan")));
      }
    }
  }

  Widget buildMimeIcon({
    required bool isFolder,
    required String? mimeType,
    required dynamic mainIcon,
    required Color color,
    required bool isStarred,
    String? userId,
    double size = 28,
  }) {
    final mime = mimeType?.toLowerCase() ?? '';
    Widget fallback;
    if (mainIcon is IconData) {
      fallback = Icon(mainIcon, color: color, size: size);
    } else if (mainIcon is String) {
      fallback = size != 100
          ? SvgPicture.asset(
              mainIcon,
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: size,
                decoration: BoxDecoration(color: magnoliaWhiteNewAmikom),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(mainIcon, width: 50, height: 50),
                ),
              ),
            );
    } else {
      fallback = Icon(
        Icons.insert_drive_file_rounded,
        color: color,
        size: size,
      );
    }

    Widget withStar(Widget child) {
      if (isStarred && size == 100 && userId == username) {
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
                child: const Icon(Icons.star, size: 18, color: orangeNewAmikom),
              ),
            ),
          ],
        );
      } else if (size == 100 && userId != username) {
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
                  Icons.group,
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
          size != 100
              ? SvgPicture.asset(
                  "assets/pdf.svg",
                  width: size,
                  height: size,
                  placeholderBuilder: (_) => fallback,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: size,
                    decoration: BoxDecoration(color: magnoliaWhiteNewAmikom),
                    child: Align(
                      child: SvgPicture.asset(
                        "assets/pdf.svg",
                        width: 50,
                        height: 50,
                        placeholderBuilder: (_) => fallback,
                      ),
                    ),
                  ),
                ),
        );
      } else if (mime.contains('doc') || mime.contains('docx')) {
        return withStar(
          size != 100
              ? SvgPicture.asset(
                  "assets/word.svg",
                  width: size,
                  height: size,
                  placeholderBuilder: (_) => fallback,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: size,
                    decoration: BoxDecoration(color: magnoliaWhiteNewAmikom),
                    child: Align(
                      child: SvgPicture.asset(
                        "assets/word.svg",
                        width: 50,
                        height: 50,
                        placeholderBuilder: (_) => fallback,
                      ),
                    ),
                  ),
                ),
        );
      } else if (mime.contains('xls') || mime.contains('xlsx')) {
        return withStar(
          size != 100
              ? SvgPicture.asset(
                  "assets/excel.svg",
                  width: size,
                  height: size,
                  placeholderBuilder: (_) => fallback,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: size,
                    decoration: BoxDecoration(color: magnoliaWhiteNewAmikom),
                    child: Align(
                      child: SvgPicture.asset(
                        "assets/excel.svg",
                        width: 50,
                        height: 50,
                        placeholderBuilder: (_) => fallback,
                      ),
                    ),
                  ),
                ),
        );
      } else {
        return withStar(fallback);
      }
    } catch (_) {
      return withStar(fallback);
    }
  }

  Widget _buildFlexibleIcon(dynamic icon, {double size = 24, Color? color}) {
    if (icon is IconData) {
      return Icon(icon, size: size, color: color);
    } else if (icon is String) {
      return SvgPicture.asset(icon, width: size, height: size);
    } else {
      return const SizedBox.shrink();
    }
  }

  void _showOptions(BuildContext context, dynamic mainIcon) {
    final rootContext = context;
    final bool isFolder = type == DriveItemType.folder;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
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
            final prefUsername = tokenSnapshot.data![1] as String?;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildFlexibleIcon(
                        mainIcon,
                        size: 28,
                        color: orangeNewAmikom,
                      ),
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
                if (!item.isTrashed)
                  ListTile(
                    leading: const Icon(
                      Icons.drive_file_rename_outline,
                      color: orangeNewAmikom,
                    ),
                    title: Text("Ganti nama", style: GoogleFonts.urbanist()),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      if (item.userId != prefUsername) {
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

                      await Future.delayed(const Duration(milliseconds: 500));

                      if (rootContext.mounted) {
                        rootContext.read<DriveCubit>().getDriveData(
                          token: 'Bearer $token',
                        );
                        onUpdateChanged?.call();
                      }
                    },
                  ),
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
                      downloadFile(context, item, url);
                    },
                  ),
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
                      if (item.userId != prefUsername) {
                        ScaffoldMessenger.of(rootContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Hanya pemilik yang bisa menambahkan ke berbintang.",
                            ),
                          ),
                        );
                        return;
                      }

                      await toggleStarAction(
                        rootContext,
                        token!,
                        isFolder ? item.id : null,
                        isFolder ? null : item.id,
                        item.userId!,
                        !item.isStarred,
                      );

                      await Future.delayed(const Duration(milliseconds: 500));

                      if (rootContext.mounted) {
                        rootContext.read<DriveCubit>().getDriveData(
                          token: 'Bearer $token',
                        );
                        onUpdateChanged?.call();
                      }
                    },
                  ),
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
                _deleteButton(
                  sheetContext,
                  rootContext,
                  item,
                  token!,
                  prefUsername!,
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

  Widget _deleteButton(
    BuildContext sheetContext,
    BuildContext rootContext,
    DriveItemModel item,
    String token,
    String username,
    bool isFolder,
  ) {
    if (!item.isTrashed) {
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
          } else if (item.isStarred) {
            ScaffoldMessenger.of(rootContext).showSnackBar(
              const SnackBar(
                content: Text("Tidak dapat menghapus item berbintang."),
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

          if (rootContext.mounted) {
            rootContext.read<DriveCubit>().getDriveData(token: 'Bearer $token');
            onUpdateChanged?.call();
          }
        },
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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

              if (rootContext.mounted) {
                rootContext.read<DriveCubit>().getDriveData(
                  token: 'Bearer $token',
                );
                onUpdateChanged?.call();
              }
            },
          ),
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

              if (rootContext.mounted) {
                rootContext.read<DriveCubit>().getDriveData(
                  token: 'Bearer $token',
                );
                onUpdateChanged?.call();
              }
            },
          ),
        ],
      );
    }
  }

  Future<void> downloadFile(
    BuildContext context,
    DriveItemModel item,
    String url,
  ) async {
    try {
      if (Platform.isAndroid) {
        await Permission.storage.request();
      }

      final dio = Dio();
      int lastReceived = 0;
      DateTime lastTime = DateTime.now();

      await NotificationService.showDownloadProgress(
        received: 0,
        total: 0,
        speed: "0 KB/s",
      );

      final response = await dio.get<List<int>>(
        "$url${Uri.parse(item.url!).path}",
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final now = DateTime.now();
            final diff = now.difference(lastTime).inMilliseconds;

            if (diff > 800) {
              double speedBytesPerSec =
                  (received - lastReceived) / (diff / 1000);

              String speedText = speedBytesPerSec >= 1048576
                  ? "${(speedBytesPerSec / 1048576).toStringAsFixed(1)} MB/s"
                  : "${(speedBytesPerSec / 1024).toStringAsFixed(1)} KB/s";

              NotificationService.showDownloadProgress(
                received: received,
                total: total,
                speed: speedText,
              );

              lastReceived = received;
              lastTime = now;
            }
          }
        },
      );

      if (Platform.isAndroid &&
          (await Permission.manageExternalStorage.request()).isGranted) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File("${tempDir.path}/${item.nama}.${item.mimeType}");
        await tempFile.writeAsBytes(response.data!);

        final mediaStore = MediaStore();
        await mediaStore.saveFile(
          tempFilePath: tempFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
        );

        await NotificationService.cancelDownloadProgress();
        NotificationService.showDownloadCompleted(
          "${item.nama}.${item.mimeType}",
          "Folder Download",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File berhasil disimpan di folder Download"),
          ),
        );

        try {
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        } catch (_) {}
        return;
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/${item.nama}.${item.mimeType}");
        await file.writeAsBytes(Uint8List.fromList(response.data!));

        await NotificationService.cancelDownloadProgress();
        NotificationService.showDownloadCompleted(
          "${item.nama}.${item.mimeType}",
          file.path,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File tersimpan di ${file.path}")),
        );
      }
    } catch (e) {
      await NotificationService.cancelDownloadProgress();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengunduh file: $e")));
    }
  }
}
