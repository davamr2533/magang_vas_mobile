import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';
import 'package:vas_reporting/tools/popup.dart';

class AnimatedFabMenu extends StatefulWidget {
  const AnimatedFabMenu({super.key});

  @override
  State<AnimatedFabMenu> createState() => _AnimatedFabMenuState();
}

class _AnimatedFabMenuState extends State<AnimatedFabMenu>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Upload File
        _buildAnimatedFab(
          offsetY: 140,
          icon: Icons.upload_file,
          label: "Upload",
          onTap: _pickFile,
        ),

        // Buat Folder
        _buildAnimatedFab(
          offsetY: 70,
          icon: Icons.create_new_folder,
          label: "Folder",
          onTap: () async {
            final popup = PopUpWidget(context);
            final newName = await popup.showTextInputDialog(
              title: "Folder baru",
              hintText: "Folder tanpa nama",
              confirmText: "Buat",
            );
            if (newName != null && newName.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Folder \"$newName\" berhasil dibuat")),
              );
            }
          },
        ),

        // Main FAB
        FloatingActionButton(
          heroTag: "mainFab",
          onPressed: _toggleMenu,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: isOpen ? 0.125 : 0), // 0.125 = 45°
            duration: const Duration(milliseconds: 250),
            builder: (context, angle, child) {
              return Transform.rotate(
                angle: angle * 3.1416 * 2, // radian
                child: const Icon(Icons.add),
              );
            },
          ),
        ),

      ],
    );
  }

  Widget _buildAnimatedFab({
    required double offsetY,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final slide = Tween<Offset>(
          begin: Offset(0, offsetY / 60), // posisi awal agak ke bawah
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ));

        return Transform.translate(
          offset: Offset(0, slide.value.dy * offsetY),
          child: Opacity(
            opacity: _controller.value,
            child: Padding(
              padding: EdgeInsets.only(bottom: offsetY),
              child: _buildFabWithLabel(
                icon: icon,
                label: label,
                onTap: onTap,
              ),
            ),
          ),
        );
      },
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
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
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
