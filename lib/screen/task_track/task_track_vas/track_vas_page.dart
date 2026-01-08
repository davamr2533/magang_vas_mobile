import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/home/home_page.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_widget/track_vas_card.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_widget/track_vas_history.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_history_cubit.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/routing.dart';

class TrackVasPage extends StatefulWidget {
  const TrackVasPage({super.key});

  @override
  State<TrackVasPage> createState() => _TrackVasPage();
}

class _TrackVasPage extends State<TrackVasPage> {
  final TextEditingController _catatanController = TextEditingController();

  //Variable untuk filter pencarian
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<TaskTrackCubit>().fetchTask();
  }

  //Membersihkan memori dari catatan sebelumnya
  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return PopScope( //untuk navigasi tombol back android supaya bisa di kustom rute nya
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacement(
          routingPage(const HomePage()),
        );
      },

      child: Scaffold(
        appBar: AppBar(
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

              //Filter task berdasarkan ketikkan di text field
              final filteredTasks = tasks.where((task) {
                return task.jenis.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<TaskTrackCubit>().fetchTask();
                },
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [

                        // Search Bar
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16, right: 8),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              style: GoogleFonts.urbanist(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: pinkNewAmikom,
                                hintText: 'Cari Task...',
                                hintStyle: GoogleFonts.urbanist(
                                  color: darkGrayNewAmikom,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: darkGrayNewAmikom,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // History Button
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: yellowNewAmikom,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.history_rounded,
                              color: Colors.blue,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  routingPage(
                                    BlocProvider(
                                      create: (context) => TaskHistoryCubit(TaskTrackService()),
                                      child: TrackVasHistory(),
                                    ),
                                  )
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Jika hasil filter kosong, tetap tampilkan search bar & tombol tapi halamannya kosong
                    if (filteredTasks.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            "Tidak ada Task",
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];

                            final Map<String, String> progressFlow = {
                              "Wawancara": "Konfirmasi Desain",
                              "Konfirmasi Desain": "Perancangan Database",
                              "Perancangan Database": "Pengembangan Software",
                              "Pengembangan Software": "Debugging",
                              "Debugging": "Testing",
                              "Testing": "Trial",
                              "Trial": "Production",
                              "Production": "-",
                              "-": "Wawancara",
                            };

                            final String nextProgress = progressFlow[task.currentProgress] ?? "-";

                            return TrackVasCard(
                              task: task,
                              nextProgress: nextProgress,
                              catatanController: _catatanController,
                            );
                          },
                        ),

                      ),
                  ],
                )
              );


            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
