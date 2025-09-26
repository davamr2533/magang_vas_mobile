import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';
import 'package:vas_reporting/tools/popup.dart';

class AnimatedFabMenu extends StatefulWidget {
  const AnimatedFabMenu({super.key});

  @override
  State<AnimatedFabMenu> createState() => _AnimatedFabMenuState();
}

class _AnimatedFabMenuState extends State<AnimatedFabMenu> {
  bool isOpen = false;


  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (isOpen)
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: _buildFabWithLabel(
              icon: Icons.create_new_folder,
              label: "Folder",
                onTap: () async {// tutup bottomsheet dulu
                  final popup = PopUpWidget(context);
                  final newName = await popup.showTextInputDialog(
                    title: "Folder baru",
                    hintText: "Folder tanpa nama",
                    confirmText: "Buat"
                  );
                  if (newName != null && newName.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(
                          "Folder \"$newName\" berhasil dibuat")),
                    );
                  };
                }
            ),
          ),

        if (isOpen)
          Padding(
            padding: const EdgeInsets.only(bottom: 140.0),
            child: _buildFabWithLabel(
              icon: Icons.upload_file,
              label: "Upload",
              onTap: () => _pickFile(),
            ),
          ),

        FloatingActionButton(
          heroTag: "mainFab",
          onPressed: () => setState(() => isOpen = !isOpen),
          child: Icon(isOpen ? Icons.close : Icons.add),
        ),
      ],
    );
  }

  Widget _buildFabWithLabel({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        FloatingActionButton(
          heroTag: label,
          mini: true,
          onPressed: onTap,
          child: Icon(icon),
        ),
      ],
    );
  }

  /// 🔹 Dialog Tambah Folder
  void _showAddFolderDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Folder"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nama folder"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final folderName = controller.text.trim();
              if (folderName.isNotEmpty) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Folder '$folderName' ditambahkan")),
                );
              }
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  /// 🔹 File Picker untuk Upload
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File dipilih: ${file.name}")),
      );
    }
  }
}
