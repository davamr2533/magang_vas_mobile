import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/screen/drive/data/cubit/starred_cubit.dart';
import 'package:vas_reporting/screen/drive/data/cubit/rename_drive_cubit.dart';
import 'package:vas_reporting/screen/drive/data/model/body/starred_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/rename_drive_body.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';
import 'package:vas_reporting/tools/popup.dart';

// ⭐ Tambah atau hapus berbintang
Future<void> toggleStarAction(
    BuildContext context,
    String token,
    int itemId,
    String userId,
    String name,
    bool isStarred,
    String itemType
    ) async {
  final cubit = context.read<StarredCubit>();
  await cubit.toggleStar(
    token: 'Bearer $token',
    body: StarredBody(id: itemId, userId: userId, starred: isStarred, name: name, itemType: itemType),
  );

  final state = cubit.state;
  if (state is StarredSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message)),
    );
  } else if (state is StarredFailure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal: ${state.message}")),
    );
  }
}

Future<void> renameAction(
    BuildContext context,
    String token,
    int id,
    String itemType,
    String currentName,
    ) async {
  final popup = PopUpWidget(context);
  final newName = await popup.showTextInputDialog(
    title: "Ubah nama",
    initialValue: currentName,
    confirmText: "Simpan",
  );

  if (newName == null || newName.isEmpty) return;

  final cubit = context.read<RenameDriveCubit>();
  await cubit.renameDrive(
    token: 'Bearer $token',
    body: RenameDriveBody(id: id, name: newName, itemType: itemType),
  );

  final state = cubit.state;
  if (state is RenameDriveSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message)),
    );
  } else if (state is RenameDriveFailure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal: ${state.message}")),
    );
  }
}
