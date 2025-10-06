import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';

//class untuk pop up success
class TrackVasPopUpSuccess extends StatelessWidget {
  const TrackVasPopUpSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 100),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: softestGrayNewAmikom,
                  borderRadius: BorderRadiusGeometry.circular(100),
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: greenNewAmikom,
                    size: 75,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Success!",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Center(
              child: Text(
                "Progress berhasil diupdate!",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: darkGrayNewAmikom,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//class untuk pop up task sudah selesai (currentProgress = production)
class TrackVasPopUpProduction extends StatelessWidget {
  const TrackVasPopUpProduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 100),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: softestGrayNewAmikom,
                  borderRadius: BorderRadiusGeometry.circular(100),
                ),
                child: Center(
                  child: Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                    size: 75,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Progress selesai!",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Center(
              child: Text(
                "Silahkan lakukan pengujian",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: darkGrayNewAmikom,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}


