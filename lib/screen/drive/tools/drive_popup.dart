import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;

import '../../../tools/popup.dart';

extension PopUpInput on PopUpWidget {
  Future<String?> showTextInputDialog({
    required String title,
    String? initialValue,
    String hintText = "Masukkan nama",
    String confirmText = "Simpan",
    String cancelText = "Batal",
  }) async {
    final controller = TextEditingController(text: initialValue);

    return showCupertinoDialog<String>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoTextField(
                  controller: controller,
                  placeholder: hintText,
                  autofocus: true,
                ),
              ],
            ),
          ),


          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, null),
              child: Text(
                cancelText,
                style: GoogleFonts.urbanist(color: Colors.red),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(
                confirmText,
                style: GoogleFonts.urbanist(color: baseColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String cancelText = "Batal",
    String confirmText = "Hapus",
    Color confirmColor = Colors.red,
  }) async {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: Text(message, style: GoogleFonts.urbanist(fontSize: 14)),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                confirmText,
                style: GoogleFonts.urbanist(
                  color: confirmColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                cancelText,
                style: GoogleFonts.urbanist(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
