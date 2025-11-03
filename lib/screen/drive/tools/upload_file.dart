import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/screen/drive/data/cubit/upload_file_cubit.dart';

Future<void> uploadNewFile(
    BuildContext context,
    String token,
    int parentId,
    String userId,
    ) async {
  if (!context.mounted) return;

// Pilih file dari perangkat
  final result = await FilePicker.platform.pickFiles(allowMultiple: false);

  if (result == null || result.files.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tidak ada file yang dipilih.")),
    );
    return;
  }

  final file = File(result.files.single.path!);
  final fileName = result.files.single.name;

// Tampilkan indikator upload
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Mengupload file...")),
  );

  final cubit = context.read<UploadFileCubit>();

// Panggil cubit untuk upload file
  await cubit.uploadFile(
    userId: userId,
    token: token,
    filePath: file.path,
    fileName: fileName,
    id: parentId,
  );

  if (!context.mounted) return;

  final state = cubit.state;

  if (state is UploadFileSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message)),
    );
  } else if (state is UploadFileFailure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal upload: ${state.message}")),
    );
  }
}
