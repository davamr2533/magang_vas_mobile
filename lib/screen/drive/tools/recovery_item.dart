import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/data/cubit/add_to_trash_cubit.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_to_trash_body.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';
import 'package:vas_reporting/screen/drive/tools/drive_popup.dart';
import '../../../tools/popup.dart';
import '../data/cubit/recovery_drive_cubit.dart';
import '../data/model/body/recovery_drive_body.dart';

Future<void> recoveryDrive(
    BuildContext context,
    String token,
    int id,
    String title,
    DriveItemType itemType,
    ) async {
  if (!context.mounted) return;

  final popup = PopUpWidget(context);


  final cubit = context.read<RecoveryDriveCubit>();
  await cubit.recoveryDrive(
    token: "Bearer $token",
    body: RecoveryDriveBody(
      id: id,
      name: title,
      itemType: itemType == DriveItemType.folder ? 'folder' : 'file',
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Berhasil memulihkan \"$title\"",
        style: GoogleFonts.urbanist(),
      ),
    ),
  );
}
