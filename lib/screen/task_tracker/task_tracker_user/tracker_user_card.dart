import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/base_colors.dart';
import 'package:vas_reporting/data/cubit/get_data/get_data_cubit.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart' as task_model;
import 'package:vas_reporting/data/model/response/get_data_vas_response.dart' as timeline_model;
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/popup.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';

class TimelineStep {
  final String title;
  final String date;
  final bool isDone;

  TimelineStep({required this.title, required this.date, required this.isDone});
}

class TaskUserCard extends StatefulWidget {
  final task_model.Data task;
  final timeline_model.Data timeline;

  const TaskUserCard({super.key, required this.task, required this.timeline});

  @override
  TaskUserCardState createState() => TaskUserCardState();
}

class TaskUserCardState extends State<TaskUserCard> {
  late GetDataCubit getDataCubit;
  late PopUpWidget popUpWidget;
  String? token;
  List<task_model.Data> dataStatus = [];

  @override
  void initState() {
    getDataCubit = context.read<GetDataCubit>();
    popUpWidget = PopUpWidget(context);
    fetchData();
    super.initState();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    await getDataCubit.getAllData(token: 'Bearer ${token ?? ""}');
    await getDataCubit.getDataVas(token: 'Bearer ${token ?? ""}');
  }

  //variable
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    int persentase = 0;
    String tahap = "Konfirmasi Desain";
    String image = "assets/wawancara.png";

    if (tahap == "Wawancara") {
      persentase = 13;
      image = "assets/wawancara.png";
    } else if (tahap == "Konfirmasi Desain") {
      persentase = 25;
      image = "assets/konfirm_desain.png";
    } else if (tahap == "Perancangan Database") {
      persentase = 38;
      image = "assets/rancang_db.png";
    } else if (tahap == "Pengembangan Software") {
      persentase = 50;
      image = "assets/pengembangan_software.png";
    } else if (tahap == "Debugging") {
      persentase = 63;
      image = "assets/debugging.png";
    } else if (tahap == "Testing") {
      persentase = 75;
      image = "assets/testing.png";
    } else if (tahap == "Trial") {
      persentase = 88;
      image = "assets/trial.png";
    } else if (tahap == "Production") {
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
                tahap,
                style: GoogleFonts.urbanist(
                  color: blackNewAmikom,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // ID Pengajuan
          Positioned(
            right: 20,
            top: 15,
            child: Text(
              task.nomorPengajuan ?? '_',
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
              task.divisi ?? '_',
              style: GoogleFonts.urbanist(
                color: yellowNewAmikom,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Nama Pengajuan
          Positioned(
            left: 25,
            top: 115,
            child: Text(
              task.jenis ?? '_',
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
                    isExpanded = !isExpanded;
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

          // Timeline expand
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
                decoration: BoxDecoration(
                  color: creamNewAmikom,
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<GetDataCubit, GetDataHasState>(
                        builder: (context, state) {
                          if (state is GetDataVasFailure) {
                            return Text(state.message);
                          }
                          if (state is GetDataLoading) {
                            return Center(child: AppWidget().LoadingWidget());
                          }
                          if (state is GetDataVasSuccess) {
                            if (state.response.data == null ||
                                state.response.data!.isEmpty) {
                              return const Center(
                                  child: Text('No data available'));
                            } else {
                              List<timeline_model.Data> progressData =
                              state.response.data!;
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(16),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: creamNewAmikom,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Pengajuan yang diterima VAS",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${progressData.length}',
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: progressData.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 5,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    color: pinkNewAmikom,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Nomor Pengajuan',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Wawancara',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Konfirmasi desain',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Perancangan Database',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Pengembangan Software',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Debugging',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Testing',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Trial',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Production',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    state.response.data?[index]
                                                        .nomorPengajuan ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    progressData[index]
                                                        .wawancara ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    progressData[index]
                                                        .konfirmasiDesain ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    progressData[index]
                                                        .perancanganDatabase ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    progressData[index]
                                                        .pengembanganSoftware ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    progressData[index]
                                                        .debugging ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    progressData[index].testing ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    progressData[index].trial ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    progressData[index]
                                                        .production ??
                                                        'Unknown',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          }
                          return SizedBox();
                        },
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

  //Widget timeline progress task tracker
  Widget timelineRow(String title, String date, bool isDone) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.urbanist(
                color: isDone ? blackNewAmikom : grayNewAmikom,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Text(
                  date,
                  style: GoogleFonts.urbanist(
                    color: isDone ? blackNewAmikom : grayNewAmikom,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.check_circle,
                  color: isDone ? Colors.green : grayNewAmikom,
                  size: 18,
                ),
              ],
            )
          ],
        ),
        const Divider(color: grayNewAmikom, thickness: 1)
      ],
    );
  }
}
