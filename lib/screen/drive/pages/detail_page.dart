import 'package:flutter/material.dart';

// <<====== DETAIL PAGE ======>>
class DetailPage extends StatelessWidget {
  // <<====== PROPERTIES ======>>
  final String title;   // Judul file/folder
  final String jenis;   // Jenis file (PDF, Folder, dll)
  final String lokasi;  // Lokasi penyimpanan
  final String? ukuran; // Ukuran file (opsional)
  final String dibuat;  // Tanggal dibuat
  final String diubah;  // Tanggal terakhir diubah
  final IconData icon;  // Ikon file/folder

  const DetailPage({
    super.key,
    required this.title,
    required this.jenis,
    required this.lokasi,
    this.ukuran,
    required this.dibuat,
    required this.diubah,
    required this.icon,
  });

  // <<====== BUILD UI ======>>
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3F6), // warna pink muda

      // <<====== APP BAR ======>>
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
      ),

      // <<====== BODY ======>>
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // Ikon utama
            Icon(
              icon,
              size: 100,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 24),

            // Garis pemisah
            Container(
              height: 2,
              color: Colors.red.shade100,
            ),

            const SizedBox(height: 24),

            // <<====== DETAIL INFO ======>>
            _buildRow("Jenis", jenis),
            _buildRow("Lokasi", lokasi),
            if (ukuran != null) _buildRow("Ukuran", ukuran!), // tampil hanya jika ada ukuran
            _buildRow("Dibuat", dibuat),
            _buildRow("Diubah", diubah),
          ],
        ),
      ),
    );
  }

  // <<====== WIDGET ROW (LABEL & VALUE) ======>>
  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label (tebal)
          SizedBox(
            width: 80,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),

          // Nilai (isi detail)
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
