import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/data/cubit/add_to_trash_cubit.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_to_trash_body.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';
import '../../../tools/popup.dart';
import '../data/cubit/delete_drive_cubit.dart';
import '../data/model/body/delete_drive_body.dart';

Future<void> addToTrash(
  BuildContext context,
  String token,
  int id,
  String title,
  String userId,
  DriveItemType itemType,
) async {
  if (!context.mounted) return;

  final popup = PopUpWidget(context);

  // Tampilkan dialog konfirmasi
  final confirm = await popup.showConfirmDialog(
    title: "Pindahkan ke Sampah?",
    message: "\"$title\" akan dihapus selamanya setelah 30 hari.",
    confirmText: "Pindahkan ke Sampah",
    cancelText: "Batal",
  );

  if (confirm != true) return; // batal

  print("==========DEBUG-ADD-TO-TRASH============");
  print("Body JSON: ${AddToTrashBody(
    id: id,
    userId: userId,
    itemType: itemType == DriveItemType.folder ? 'folder' : 'files',
  ).toJson()}");

  final cubit = context.read<AddToTrashCubit>();
  await cubit.addToTrash(
    token: "Bearer $token",
    body: AddToTrashBody(
      id: id,
      userId: userId,
      itemType: itemType == DriveItemType.folder ? 'folder' : 'files',
    ),
  );

  if (!context.mounted) return;

  // Tampilkan pesan sukses
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Berhasil memindahkan \"$title\" ke Sampah.",
        style: GoogleFonts.urbanist(),
      ),
    ),
  );
}



Future<void> deleteDrive(
    BuildContext context,
    String token,
    int id,
    String title,
    DriveItemType itemType,
    ) async {
  if (!context.mounted) return;


  final popup = PopUpWidget(context);

  // Tampilkan dialog konfirmasi
  final confirm = await popup.showConfirmDialog(
    title: "Hapus Selamanya?",
    message: "Item \"$title\" akan dihapus selamanya. Tindakan ini tidak dapat diurungkan.",
    confirmText: "Hapus Permanen",
    cancelText: "Batalkan",
  );

  if (confirm != true) return; // batal


  print("==========DEBUG-PERMANENT-DELETE============");
  print("Body JSON: ${DeleteDriveBody(
    id: id,
    name: title,
    itemType: itemType == DriveItemType.folder ? 'folder' : 'files',
  ).toJson()}");

  final cubit = context.read<DeleteDriveCubit>();
  await cubit.deleteDrive(
    token: "Bearer $token",
    body: DeleteDriveBody(
      id: id,
      name: title,
      itemType: itemType == DriveItemType.folder ? 'folder' : 'files',
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "\"$title\" dihapus selamanya",
        style: GoogleFonts.urbanist(),
      ),
    ),
  );
}
