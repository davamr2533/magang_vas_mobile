import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_page.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_history_cubit.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/routing.dart';

class TrackVasHistory extends StatefulWidget {
  const TrackVasHistory({super.key});

  @override
  State<TrackVasHistory> createState() => _TrackVasHistoryState();
}

class _TrackVasHistoryState extends State<TrackVasHistory> {

  // panggil API saat halaman pertama kali muncul
  @override
  void initState() {
    super.initState();
    context.read<TaskHistoryCubit>().fetchHistory();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goToTrackVasPage(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              goToTrackVasPage(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("History"),
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
        backgroundColor: const Color(0xFFFDF8FF),

        body: BlocBuilder<TaskHistoryCubit, TaskHistoryState>(

          builder: (context, state) {
            if (state is TaskHistoryLoading) {
              return Center(child: AppWidget().LoadingWidget());
            }else if (state is TaskHistoryFailure) {
              return Center(child: Text(state.message));
            } else if (state is TaskHistorySuccess) {

              final histories = state.histories;

              //Handle jika tidak ada history
              if (histories.isEmpty) {
                return Center(
                  child: Text(
                    "Tidak ada Riwayat dalam 1 bulan terakhir",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TaskHistoryCubit>().fetchHistory();
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [


                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Data akan dihapus otomatis setelah 30 hari",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),


                    ...histories.map((task) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
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
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // ICON RIWAYAT
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.history_rounded,
                                        color: Colors.green.shade400,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // TEKS UTAMA
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                task.historyNomorPengajuan,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 13,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "|",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                task.historyDivisi,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8),

                                          Text(
                                            task.historyJenis,
                                            style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 22,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFE6C5),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    task.historyFinishedAt.split(' ')[0],
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );

            }
            return SizedBox();
          }
        )
      ),
    );
  }

  void goToTrackVasPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      routingPage(
        BlocProvider(
          create: (_) => TaskTrackCubit(TaskTrackService()),
          child: const TrackVasPage(),
        ),
      ),
    );
  }


}
