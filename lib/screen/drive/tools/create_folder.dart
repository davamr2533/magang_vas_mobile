import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/screen/drive/data/cubit/add_folder_cubit.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_folder_body.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';
import 'package:vas_reporting/tools/popup.dart';
Future<void> createNewFolder(
    BuildContext context,
    String token,
    int parentId,
    String userId,
    ) async {
  if (!context.mounted) return;

  final popup = PopUpWidget(context);

  // ✅ Tampilkan dialog input nama folder
  final newName = await popup.showTextInputDialog(
    title: "Folder baru",
    hintText: "Folder tanpa nama",
    confirmText: "Buat",
  );

  if (!context.mounted) return;

  if (newName == null || newName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nama folder tidak boleh kosong.")),
    );
    return;
  }


  // 🪵 Tambahkan print debug di sini
  print("🛰️ [DEBUG] Data folder yang dikirim ke server:");
  print("Token: $token");
  print("Body JSON: ${AddFolderBody(
    parentId: parentId,
    userId: userId,
    nameFolder: newName,
  ).toJson()}");

  final cubit = context.read<AddFolderCubit>();

  // Jalankan proses tambah folder
  await cubit.addFolder(token: token, body: AddFolderBody(
    parentId: parentId,
    userId: userId,
    nameFolder: newName,
  ));

  if (!context.mounted) return;

  final currentState = cubit.state;

  print("DEBUG: membuat folder di parentId = $parentId");
  if (currentState is AddFolderSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(currentState.message)),
    );
  } else if (currentState is AddFolderFailure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal: ${currentState.message}")),
    );
  }
}
