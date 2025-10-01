import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  //import untuk edit tampilan status bar
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';
import 'package:vas_reporting/tools/loading.dart';

class TrackUserPage extends StatefulWidget {
  const TrackUserPage({super.key});

  @override
  State<TrackUserPage> createState() => _TrackUserPage();
}


class _TrackUserPage extends State<TrackUserPage> {


  List<bool> expandedList = [];

  @override
  void initState() {
    super.initState();
    context.read<TaskTrackCubit>().fetchTask();
  }

  @override
  Widget build(BuildContext context) {

    int persentase = 0;
    String image = "assets/wawancara.png"; // bawaan UI android
    String divisi = "NOC"; //menunggu API baru
    String jenis = "Dompet Duafa"; //menunggu API baru


    return Scaffold(
      appBar: AppBar(

        //icon back
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); //Navigasi kembali ke halaman sebelumnya
          },

          icon: Icon(Icons.arrow_back_ios_new), color: Colors.black,
        ),

        //judul halaman
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text("Task Tracker"),
        ),

        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,

        //agar status bar terlihat
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // warna status bar
          statusBarIconBrightness: Brightness.dark, // warna icon
        ),

      ),

      body: BlocBuilder<TaskTrackCubit, TaskTrackState>(
        builder: (context, state) {

          //Kelola State
          if (state is TaskTrackLoading) {
            return Center(child: AppWidget().LoadingWidget());
          } else if (state is TaskTrackFailure) {
            return Center(child: Text(state.message));
          } else if (state is TaskTrackSuccess) {

            final tasks = state.tasks;

            //variabel untuk expand
            if (expandedList.length != tasks.length) {
              expandedList = List.generate(tasks.length, (_) => false);
            }


            //Hasil jika ambil data berhasil
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final isExpanded = expandedList[index];

                if (task.currentProgress == "Wawancara") {
                  persentase = 0;
                  image = "assets/wawancara.png";

                } else if (task.currentProgress == "Konfirmasi Desain") {
                  persentase = 14;
                  image = "assets/konfirm_desain.png";

                } else if (task.currentProgress == "Perancangan Database") {
                  persentase = 29;
                  image = "assets/rancang_db.png";

                } else if (task.currentProgress == "Pengembangan Software") {
                  persentase = 42;
                  image = "assets/pengembangan_software.png";

                } else if (task.currentProgress == "Debugging") {
                  persentase = 57;
                  image = "assets/debugging.png";

                } else if (task.currentProgress == "Testing") {
                  persentase = 71;
                  image = "assets/testing.png";

                } else if (task.currentProgress == "Trial") {
                  persentase = 85;
                  image = "assets/trial.png";

                } else if (task.currentProgress == "Production") {
                  persentase = 100;
                  image = "assets/production.png";

                }







                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
                  width: double.infinity,
                  height: isExpanded ? 445 : 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
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
                      //Gambar Tahapan Task
                      Container(
                        width: double.infinity,
                        height: 160,
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                            color: Colors.black.withValues(alpha: 0.25),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                      ),

                      // Tahap Pengajuan
                      Container(
                        width: 160,
                        height: 35,
                        decoration: BoxDecoration(
                          color: pinkNewAmikom,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            task.currentProgress,
                            style: GoogleFonts.urbanist(
                              color: blackNewAmikom,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      // Nomor Pengajuan
                      Positioned(
                        right: 20,
                        top: 15,
                        child: Text(
                          task.nomorPengajuan,
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      // Divisi
                      Positioned(
                        left: 25,
                        top: 95,
                        child: Text(
                          divisi,
                          style: GoogleFonts.urbanist(
                            color: yellowNewAmikom,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Jenis
                      Positioned(
                        left: 25,
                        top: 115,
                        child: Text(
                          jenis,
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Tombol expand
                      Positioned(
                        left: 15,
                        top: 180,
                        child: SizedBox(
                          width: 270,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                expandedList[index] = !expandedList[index];
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenNewAmikom,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isExpanded ? "Tutup" : "Detail Progress",
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Persentase Progress
                      Positioned(
                        right: 0,
                        top: 150,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: CircularPercentIndicator(
                              radius: 60,
                              percent: persentase / 100,
                              lineWidth: 8,
                              backgroundColor: softGrayNewAmikom,
                              progressColor: blueNewAmikom,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(
                                "$persentase%",
                                style: GoogleFonts.urbanist(
                                  color: blackNewAmikom,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Timeline Expand
                      Positioned(
                        left: 20,
                        right: 20,
                        top: 230,
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: creamNewAmikom,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  ...task.timeline.map((t) {
                                    final bool isDone = t.isDone == "TRUE";
                                    final bool isProcess = t.isDone == "PROCESS";

                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Judul tahap
                                            Text(
                                              t.tahap,
                                              style: GoogleFonts.urbanist(
                                                color: isDone ? blackNewAmikom : (isProcess ? Colors.orange : grayNewAmikom),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),

                                            // Bagian kanan: tanggal + icon status
                                            Row(
                                              children: [
                                                Text(
                                                  t.updatedAt != null
                                                    ? t.updatedAt!.split(" ").first
                                                    : "Pending",
                                                  style: GoogleFonts.urbanist(
                                                    color: isDone ? blackNewAmikom : (isProcess ? Colors.orange : grayNewAmikom),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  isProcess
                                                      ? Icons.timelapse
                                                      : Icons.check_circle,
                                                  color: isDone
                                                      ? Colors.green
                                                      : (isProcess ? Colors.orange : grayNewAmikom),
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(color: grayNewAmikom, thickness: 1),
                                      ],
                                    );

                                  }
                                  ),
                                ],
                              ),
                            ),


                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            );
          }
          return SizedBox();
        }
      ),
    );
  }
}
