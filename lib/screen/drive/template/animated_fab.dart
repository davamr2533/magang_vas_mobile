import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import '../../../utllis/app_shared_prefs.dart';
import '../data/cubit/get_drive_cubit.dart';
import '../tools/create_folder.dart';

class AnimatedFabMenu extends StatefulWidget {
  final int parentId;
  final VoidCallback? onFolderCreated; // ✅ callback untuk refresh di DriveHome

  const AnimatedFabMenu({
    super.key,
    required this.parentId,
    this.onFolderCreated,
  });

  @override
  State<AnimatedFabMenu> createState() => _AnimatedFabMenuState();
}

class _AnimatedFabMenuState extends State<AnimatedFabMenu>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;
  String? token;
  String? userId;
  late int parentId;

  @override
  void initState() {
    super.initState();
    parentId = widget.parentId;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    fetchData();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    userId = await SharedPref.getUsername();
    if (!mounted) return;
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
        // Tombol Upload File
        _buildAnimatedFab(
          offsetY: 140,
          icon: Icons.upload_file,
          label: "Upload",
          onTap: _pickFile,
        ),

        // Tombol Buat Folder
        _buildAnimatedFab(
          offsetY: 70,
          icon: Icons.create_new_folder,
          label: "Folder",
          onTap: () async {
            if (!mounted || token == null || userId == null) return;

            final success = await createNewFolder(
              context,
              'Bearer $token',
              parentId,
              userId!,
            );

            if (mounted) {
              // ✅ Refresh Cubit agar data Drive diperbarui
              final driveCubit = context.read<DriveCubit>();
              await driveCubit.getDriveData(token: 'Bearer $token');

              // ✅ Panggil callback agar DriveHome bisa ikut refresh
              widget.onFolderCreated?.call();

              // ✅ Feedback visual ke user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Folder berhasil dibuat')),
              );
            }
          },
        ),

        // Tombol Utama (+)
        FloatingActionButton(
          heroTag: "mainFab",
          onPressed: _toggleMenu,
          backgroundColor: pinkNewAmikom,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: isOpen ? 0.125 : 0, // 0.125 = 45°
            ),
            duration: const Duration(milliseconds: 250),
            builder: (context, angle, child) {
              return Transform.rotate(
                angle: angle * 3.1416 * 2,
                child: const Icon(Icons.add, color: orangeNewAmikom),
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
          begin: Offset(0, offsetY / 60),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );

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
          backgroundColor: pinkNewAmikom,
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File dipilih: ${file.name}")),
      );
    }
  }
}
