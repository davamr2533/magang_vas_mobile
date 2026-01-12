import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/screen/drive/data/cubit/upload_file_cubit.dart';
import '../../../utllis/app_notification.dart';

Future<bool> uploadNewFile(
  BuildContext context,
  String token,
  int parentId,
  String userId,
  List<String> existingFileNames, {
  Function(int, int)? onProgress,
}) async {
  if (!context.mounted) return false;

  final result = await FilePicker.platform.pickFiles(allowMultiple: false);

  if (result == null || result.files.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tidak ada file yang dipilih.")),
    );
    return false;
  }

  final platformFile = result.files.single;
  final file = File(platformFile.path!);
  final fileName = platformFile.name;

  const int maxMB = 2;
  final int maxBytes = maxMB * 1024 * 1024;

  if (platformFile.size > maxBytes) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ukuran file terlalu besar! Maksimal 2 MB."),
      ),
    );
    return false;
  }

  bool isDuplicate = existingFileNames.any((existingName) {
    final existingLower = existingName.trim().toLowerCase();
    final newNameLower = fileName.trim().toLowerCase();

    String newNameNoExt = newNameLower;
    if (newNameLower.contains('.')) {
      newNameNoExt = newNameLower.substring(0, newNameLower.lastIndexOf('.'));
    }

    return existingLower == newNameLower || existingLower == newNameNoExt;
  });

  if (isDuplicate) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("File dengan nama '$fileName' sudah ada."),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }

  final cubit = context.read<UploadFileCubit>();

  await cubit.uploadFile(
    userId: userId,
    token: token,
    filePath: file.path,
    fileName: fileName,
    id: parentId,
    onSendProgress: onProgress,
  );

  if (!context.mounted) return false;

  final state = cubit.state;

  if (state is UploadFileSuccess) {
    NotificationService.showUploadProgress(sent: 0, total: 0, speed: "0 KB/s");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(state.message)));
    return true;
  } else if (state is UploadFileFailure) {
    NotificationService.showUploadProgress(sent: 0, total: 0, speed: "0 KB/s");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Gagal upload: ${state.message}")));
    return false;
  }

  return false;
}
