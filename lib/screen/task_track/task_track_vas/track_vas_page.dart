import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/home/home_page.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';

class TrackVasPage extends StatefulWidget {
  const TrackVasPage({super.key});

  @override
  State<TrackVasPage> createState() => _TrackVasPage();
}

class _TrackVasPage extends State<TrackVasPage> {
  final TextEditingController _catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TaskTrackCubit>().fetchTask();
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String divisi = "NOC"; //menunggu API baru
    String jenis = "Dompet Duafa"; //menunggu API baru

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacement(
          routingPage(const HomePage()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          // icon back
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                routingPage(const HomePage()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Task Tracker"),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: BlocBuilder<TaskTrackCubit, TaskTrackState>(
          builder: (context, state) {
            if (state is TaskTrackLoading) {
              return Center(child: AppWidget().LoadingWidget());
            } else if (state is TaskTrackFailure) {
              return Center(child: Text(state.message));
            } else if (state is TaskTrackSuccess) {
              final tasks = state.tasks;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: tasks.length + 1,
                itemBuilder: (context, index) {
                  if (index == tasks.length) return const SizedBox(height: 80);

                  final task = tasks[index];

                  // mapping progress flow
                  final Map<String, String> progressFlow = {
                    "Wawancara": "Konfirmasi Desain",
                    "Konfirmasi Desain": "Perancangan Database",
                    "Perancangan Database": "Pengembangan Software",
                    "Pengembangan Software": "Debugging",
                    "Debugging": "Testing",
                    "Testing": "Trial",
                    "Trial": "Production",
                    "Production": "Wawancara",
                  };

                  final String nextProgress =
                      progressFlow[task.currentProgress] ?? "-";

                  return Container(
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
                        // Baris divisi dan ID pengajuan
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              //Nomor Pengajuan
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
                                divisi,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: blackNewAmikom,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //tanggal update
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

                        // Nama pengajuan (Jenis)
                        Positioned(
                          left: 10,
                          top: 45,
                          child: Text(
                            jenis,
                            style: GoogleFonts.urbanist(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),

                        // Tahap current progress + tombol edit
                        Positioned(
                          left: 0,
                          right: 10,
                          bottom: 10,
                          child: Row(
                            children: [
                              //Current Progress
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
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          "Update Progress",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            left: 12, right: 12, bottom: 12),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 12),
                                              Divider(
                                                  height: 1,
                                                  color: grayNewAmikom),
                                              const SizedBox(height: 8),
                                              _labelForm("ID Pengajuan"),
                                              _isiForm(task.nomorPengajuan),
                                              const SizedBox(height: 12),
                                              _labelForm("Nama Sistem"),
                                              _isiForm(jenis),
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
                                                  maxLines: null,
                                                  minLines: 5,
                                                  style:
                                                  GoogleFonts.urbanist(
                                                      fontSize: 14),
                                                  decoration:
                                                  InputDecoration(
                                                    border:
                                                    const OutlineInputBorder(),
                                                    hintText: "Opsional",
                                                    filled: true,
                                                    fillColor:
                                                    yellowNewAmikom,
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(12),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Colors
                                                            .transparent,
                                                        width: 0,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(12),
                                                      borderSide:
                                                      const BorderSide(
                                                        color:
                                                        greenNewAmikom,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Divider(
                                                  height: 1,
                                                  color: grayNewAmikom),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                        greenNewAmikom,
                                                        elevation: 0,
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              8),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Back",
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        final service =
                                                        TaskTrackService();
                                                        final success =
                                                        await service.updateTaskTracker(
                                                          nomorPengajuan: task.nomorPengajuan,
                                                          taskClosed: task.currentProgress,
                                                          taskProgress: nextProgress,
                                                          updatedBy: await SharedPref.getName() ?? '_',
                                                          catatan: _catatanController.text,
                                                        );




                                                        if (success && context.mounted) {

                                                          //Menampilkan pesan sukses

                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (BuildContext dialogContext) {

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
                                                                              borderRadius: BorderRadiusGeometry.circular(100)
                                                                          ),
                                                                          child: Center(
                                                                            child: Stack(
                                                                              children: [
                                                                                Center(
                                                                                  child: Container(
                                                                                    width: 60,
                                                                                    height: 60,
                                                                                    decoration: BoxDecoration(
                                                                                        color: Colors.white,
                                                                                        borderRadius: BorderRadiusGeometry.circular(100)
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Center(
                                                                                    child: Icon(
                                                                                      Icons.check_circle_rounded,
                                                                                      color: greenNewAmikom,
                                                                                      size: 75,
                                                                                    )
                                                                                )



                                                                              ],
                                                                            ),


                                                                          ),
                                                                        ),
                                                                      ),

                                                                      const SizedBox(height: 8),

                                                                      Center(
                                                                        child: Text(
                                                                            "Success!",
                                                                            style: GoogleFonts.urbanist(
                                                                                fontWeight: FontWeight.bold, fontSize: 20
                                                                            )
                                                                        ),
                                                                      ),



                                                                      Center(
                                                                        child: Text(
                                                                            "Progress berhasil diupdate!",
                                                                            textAlign: TextAlign.center,
                                                                            style: GoogleFonts.urbanist(
                                                                              fontSize: 14, color: darkGrayNewAmikom,
                                                                            )
                                                                        ),
                                                                      )


                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );

                                                          Future.delayed(const Duration(seconds: 2), () {
                                                            if (context.mounted) {
                                                              Navigator.of(context).pushReplacement(
                                                                routingPage(
                                                                  BlocProvider(
                                                                    create: (context) => TaskTrackCubit(TaskTrackService()),
                                                                    child: const TrackVasPage(),
                                                                  ),
                                                                ),
                                                              );
                                                            }

                                                          });


                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                        blueNewAmikom,
                                                        elevation: 0,
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              8),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Update",
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
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
                        )
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _labelForm(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _isiForm(String value) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: yellowNewAmikom,
      ),
      padding: const EdgeInsets.only(left: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: GoogleFonts.urbanist(fontSize: 14),
      ),
    );
  }
}
