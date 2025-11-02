import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_page.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_widget/track_vas_pop_up.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';

class TrackVasCard extends StatelessWidget {
  final dynamic task;
  final String nextProgress;
  final TextEditingController catatanController;

  const TrackVasCard({
    super.key,
    required this.task,
    required this.nextProgress,
    required this.catatanController,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return _buildUpdateHistory(context);
          },
        );


      },
      borderRadius: BorderRadius.circular(12),
      splashColor: blueNewAmikom.withValues(alpha: 0.2),
      child: Container(
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    task.nomorPengajuan,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: blackNewAmikom,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "|",
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: blackNewAmikom,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.divisi,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: blackNewAmikom,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                  color: yellowNewAmikom,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    task.updatedAt.split(" ")[0],
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 45,
              child: Text(
                task.jenis,
                style: GoogleFonts.urbanist(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 10,
              bottom: 10,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 35,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: blueNewAmikom,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          task.currentProgress,
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return _buildUpdateDialog(context);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenNewAmikom,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      fixedSize: const Size(70, 35),
                    ),
                    child: Icon(
                      Icons.edit_calendar_sharp,
                      color: brownNewAmikom,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );


  }

  Widget _buildUpdateDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      title: Text(
        "Update Progress",
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      contentPadding:
      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Divider(height: 1, color: grayNewAmikom),
            const SizedBox(height: 8),
            _labelForm("ID Pengajuan"),
            _isiForm(task.nomorPengajuan),
            const SizedBox(height: 12),
            _labelForm("Nama Sistem"),
            _isiForm(task.jenis),
            const SizedBox(height: 12),
            _labelForm("Next Progress"),
            _isiForm(nextProgress),
            const SizedBox(height: 12),
            _labelForm("Diupdate oleh"),
            FutureBuilder<String?>(
              future: SharedPref.getName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _isiForm("Loading...");
                } else if (snapshot.hasError) {
                  return _isiForm("Error");
                } else {
                  return _isiForm(snapshot.data ?? "_");
                }
              },
            ),
            const SizedBox(height: 12),
            _labelForm("Catatan"),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: TextField(
                controller: catatanController,
                maxLines: null,
                minLines: 5,
                style: GoogleFonts.urbanist(fontSize: 14),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Opsional",
                  filled: true,
                  fillColor: yellowNewAmikom,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: greenNewAmikom,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: grayNewAmikom),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      catatanController.clear();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenNewAmikom,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (task.currentProgress == "Production") {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                          const TrackVasPopUpProduction(),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              routingPage(
                                BlocProvider(
                                  create: (context) =>
                                      TaskTrackCubit(TaskTrackService()),
                                  child: const TrackVasPage(),
                                ),
                              ),
                            );
                          }
                        });
                        return;
                      } else {
                        final service = TaskTrackService();
                        final success =
                        await service.updateTaskTracker(
                          nomorPengajuan: task.nomorPengajuan,
                          taskClosed: task.currentProgress,
                          taskProgress: nextProgress,
                          updatedBy:
                          await SharedPref.getName() ?? '_',
                          catatan: catatanController.text,
                        );
                        if (success && context.mounted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                            const TrackVasPopUpSuccess(),
                          );
                          Future.delayed(const Duration(seconds: 2), () {
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                routingPage(
                                  BlocProvider(
                                    create: (context) =>
                                        TaskTrackCubit(TaskTrackService()),
                                    child: const TrackVasPage(),
                                  ),
                                ),
                              );
                            }
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueNewAmikom,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Update",
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateHistory(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      title: Text(
        "Update History",
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      contentPadding:
      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Divider(height: 1, color: grayNewAmikom),
            const SizedBox(height: 8),
            _labelForm("ID Pengajuan"),
            _isiForm(task.nomorPengajuan),
            const SizedBox(height: 12),
            _labelForm("Nama Sistem"),
            _isiForm(task.jenis),
            const SizedBox(height: 12),
            _labelForm("Current Progress"),
            _isiForm(task.currentProgress),
            const SizedBox(height: 12),
            _labelForm("Terakhir Update"),
            _isiForm(task.updatedAt.split(" ")[0]),
            const SizedBox(height: 12),
            _labelForm("Diupdate oleh"),
            _isiForm(task.updatedBy),
            const SizedBox(height: 12),
            _labelForm("Catatan"),




            if (task.catatan != null)
              Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: yellowNewAmikom,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.catatan,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: yellowNewAmikom,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Tidak ada catatan",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                  ),

                ),
              ),



            const SizedBox(height: 20),


            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      catatanController.clear();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenNewAmikom,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _labelForm(String text) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _isiForm(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: yellowNewAmikom,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.urbanist(fontSize: 14),
      ),
    );
  }
}
