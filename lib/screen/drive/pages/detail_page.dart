import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';

class DetailPage extends StatelessWidget {
  // =========== Properti utama ===========
  final String title;
  final String lokasi;
  final DriveItemModel item;
  final dynamic icon; // <- bisa IconData atau path SVG

  const DetailPage({
    super.key,
    required this.lokasi,
    required this.title,
    required this.item,
    required this.icon,
  });

  // =========== Format tanggal ke format lokal ===========
  String formatDate(DateTime date) {
    try {
      return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('d MMM yyyy, HH:mm').format(date);
    }
  }

  // =========== Widget pembangun utama ===========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: magnoliaWhiteNewAmikom,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // ======= Icon utama fleksibel (IconData / SVG) =======
            _buildFlexibleIcon(icon, size: 100, color: Colors.redAccent),

            const SizedBox(height: 24),
            Container(height: 2, color: Colors.red.shade100),
            const SizedBox(height: 24),

            // ======= Detail informasi =======
            _buildDetailItem("Jenis", item.mimeType ?? 'Folder'),
            if (item.isTrashed)
              _buildDetailItem(
                "Hapus dari",
                lokasi,
                icon: Icons.folder_rounded,
              ),
            if (!item.isTrashed)
              _buildDetailItem("Lokasi", lokasi, icon: Icons.folder_rounded),
            if (item.size != null) _buildDetailItem("Ukuran", item.size!),
            if (item.isTrashed)
              _buildDetailItem("Lokasi", "Sampah", icon: Icons.delete),
            _buildDetailItem("Dibuat", formatDate(item.createdAt)),
            _buildDetailItem(
              "Diubah",
              "${formatDate(item.updateAt)}${item.userId != null ? ' oleh ${item.userId}' : ''}",
            ),
            if (item.userId != null) _buildDetailItem("Pemilik", item.userId!),
          ],
        ),
      ),
    );
  }

  // =========== Widget ikon fleksibel ===========
  Widget _buildFlexibleIcon(dynamic icon, {double size = 24, Color? color}) {
    if (icon is IconData) {
      return Icon(icon, size: size, color: color);
    } else if (icon is String) {
      return SvgPicture.asset(
        icon,
        width: size,
        height: size,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // =========== Widget setiap baris detail ===========
  Widget _buildDetailItem(String title, String value, {dynamic icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                _buildFlexibleIcon(icon, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
