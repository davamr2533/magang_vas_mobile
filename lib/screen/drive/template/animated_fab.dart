import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/drive/data/service/base_paths.dart';
import '../../../utllis/app_notification.dart';
import '../../../utllis/app_shared_prefs.dart';
import '../data/cubit/get_drive_cubit.dart';
import '../tools/create_folder.dart';
import '../tools/upload_file.dart';

// ============= Widget FAB Animasi dengan Menu Upload & Folder ============
class AnimatedFabMenu extends StatefulWidget {
  final int parentId;
  final VoidCallback? onFolderCreated; // callback agar DriveHome bisa refresh

  const AnimatedFabMenu({
    super.key,
    required this.parentId,
    this.onFolderCreated,
  });

  @override
  State<AnimatedFabMenu> createState() => _AnimatedFabMenuState();
}

// ============= State Class untuk Animasi dan Aksi FAB ============
class _AnimatedFabMenuState extends State<AnimatedFabMenu>
    with SingleTickerProviderStateMixin {
  bool isOpen = false; // status apakah menu terbuka
  late AnimationController _controller; // controller animasi FAB
  String? token;
  String? userId;
  late int parentId;

  @override
  void initState() {
    super.initState();
    // ============= Inisialisasi animasi ============
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // ============= Ambil data user/token dari SharedPref ============
    fetchData();
  }

  // ============= Ambil token dan userId secara async ============
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

  // ============= Fungsi untuk buka/tutup menu FAB ============
  void _toggleMenu() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _controller.forward(); // buka animasi
      } else {
        _controller.reverse(); // tutup animasi
      }
    });
  }

  // ============= Bangun UI FAB dan Sub-Menu ============
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // ============= Tombol Upload File ============
        _buildAnimatedFab(
          offsetY: 140,
          icon: Icons.upload_file,
          label: "Upload",
          onTap: () async {
            if (!mounted || token == null || userId == null) return;

            int lastSent = 0;
            DateTime lastTime = DateTime.now();

            await NotificationService.showUploadProgress(
              sent: 0,
              total: 0,
              speed: "0 KB/s",
            );

            try {
              final success = await uploadNewFile(
                context,
                'Bearer $token',
                widget.parentId,
                userId!,
                onProgress: (sent, total) {
                  if (total != -1) {
                    final now = DateTime.now();
                    final diff = now.difference(lastTime).inMilliseconds;

                    if (diff > 800) {
                      double speedBytesPerSec =
                          (sent - lastSent) / (diff / 1000);
                      String speedText = "";

                      if (speedBytesPerSec >= 1048576) {
                        speedText =
                        "${(speedBytesPerSec / 1048576).toStringAsFixed(1)} MB/s";
                      } else {
                        speedText =
                        "${(speedBytesPerSec / 1024).toStringAsFixed(1)} KB/s";
                      }

                      NotificationService.showUploadProgress(
                        sent: sent,
                        total: total,
                        speed: speedText,
                      );

                      lastSent = sent;
                      lastTime = now;
                    }
                  }
                },
              );

              await NotificationService.cancelUploadProgress();

              if (success) {
                await NotificationService.showUploadCompleted();

                if (mounted) {
                  final driveCubit = context.read<DriveCubit>();
                  await driveCubit.getDriveData(token: 'Bearer $token');

                  widget.onFolderCreated?.call();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File berhasil diupload')),
                  );
                  _toggleMenu();
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal mengupload file')),
                );
              }
            } catch (e) {
              await NotificationService.cancelUploadProgress();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
          },
        ),

        // ============= Tombol Buat Folder ============
        _buildAnimatedFab(
          offsetY: 70,
          icon: Icons.create_new_folder,
          label: "Folder",
          onTap: () async {
            if (!mounted || token == null || userId == null) return;

            final success = await createNewFolder(
              context,
              'Bearer $token',
              widget.parentId,
              userId!,
            );

            if (mounted) {
              // refresh data drive setelah folder dibuat
              final driveCubit = context.read<DriveCubit>();
              await driveCubit.getDriveData(token: 'Bearer $token');

              // panggil callback agar DriveHome ikut refresh
              widget.onFolderCreated?.call();

              // tampilkan notifikasi ke user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Folder berhasil dibuat')),
              );
              _toggleMenu();
            }
          },
        ),

        // ============= Tombol Utama (ikon +) ============
        FloatingActionButton(
          heroTag: "mainFab",
          onPressed: _toggleMenu,
          backgroundColor: pinkNewAmikom,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: isOpen ? 0.125 : 0, // 0.125 = rotasi 45°
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

  // ============= Builder untuk FAB dengan animasi geser dan fade ============
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

  // ============= Builder untuk tampilan FAB kecil + label teks ============
  Widget _buildFabWithLabel({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label teks di samping FAB
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

        // Tombol aksi kecil
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
}
