import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';

class DetailPage extends StatelessWidget {
  // =========== Deklarasi properti yang dibutuhkan ===========
  final String title;
  final String lokasi;
  final DriveItemModel item;
  final IconData icon;

  const DetailPage({
    super.key,
    required this.lokasi,
    required this.title,
    required this.item,
    required this.icon
  });

  // =========== Fungsi untuk memformat tanggal agar lebih mudah dibaca ===========
  String formatDate(DateTime date) {
    try {
      return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);
    } catch (_) {
      return DateFormat('d MMM yyyy, HH:mm').format(date);
    }
  }

  // =========== Membangun tampilan utama halaman detail ===========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3F6), // Warna dasar halaman (pink muda)

      // =========== AppBar bagian atas ===========
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
      ),

      // =========== Bagian isi konten ===========
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // =========== Icon utama file/folder ===========
            Icon(icon, size: 100, color: Colors.redAccent),

            const SizedBox(height: 24),

            // =========== Garis pemisah ===========
            Container(height: 2, color: Colors.red.shade100),

            const SizedBox(height: 24),

            // =========== Rincian informasi detail ===========
            _buildDetailItem("Jenis", item.mimeType ?? 'Folder'),
            _buildDetailItem("Lokasi", lokasi, icon: Icons.folder_rounded),
            if (item.size != null) _buildDetailItem("Ukuran", item.size!),
            _buildDetailItem("Dibuat", formatDate(item.createdAt)),
            _buildDetailItem(
              "Diubah",
              "${formatDate(item.updateAt)}${item.userId != null ? ' oleh $item.userId' : ''}",
            ),
            if (item.userId != null) _buildDetailItem("Pemilik", item.userId!),
          ],
        ),
      ),
    );
  }

  // =========== Widget builder untuk menampilkan setiap baris detail ===========
  Widget _buildDetailItem(String title, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label judul seperti "Jenis", "Ukuran", dll.
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          // Nilai atau isi dari label di atas
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
