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
  List<String> existingFolderNames,
) async {
  if (!context.mounted) return;

  final popup = PopUpWidget(context);

  final newName = await popup.showTextInputDialog(
    title: "Folder baru",
    hintText: "Masukkan Nama Folder",
    confirmText: "Buat",
  );

  if (!context.mounted) return;

  if (newName == null || newName.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nama folder tidak boleh kosong."),duration: Duration(seconds: 2),),
    );
    return;
  }

  if (existingFolderNames.any(
    (name) => name.toLowerCase() == newName.trim().toLowerCase(),
  )) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Folder dengan nama '$newName' sudah ada.")),
    );
    return;
  }

  final cubit = context.read<AddFolderCubit>();

  await cubit.addFolder(
    token: token,
    body: AddFolderBody(
      parentId: parentId,
      userId: userId,
      nameFolder: newName.trim(),
    ),
  );

  if (!context.mounted) return;

  final currentState = cubit.state;

  if (currentState is AddFolderSuccess) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(currentState.message)));
  } else if (currentState is AddFolderFailure) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Gagal: ${currentState.message}")));
  }
}
