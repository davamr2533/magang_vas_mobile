import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_page.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';
import 'package:vas_reporting/tools/routing.dart';

class TrackVasHistory extends StatefulWidget {
  const TrackVasHistory({super.key});

  @override
  State<TrackVasHistory> createState() => _TrackVasHistoryState();
}

class _TrackVasHistoryState extends State<TrackVasHistory> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacement(
          routingPage(const TrackVasPage()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                routingPage(
                  BlocProvider(
                    create: (context) => TaskTrackCubit(TaskTrackService()),
                    child: const TrackVasPage(),
                  ),
                ),
              );
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

        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                            // Baris atas: ID & kategori
                            Row(
                              children: [
                                Text(
                                  "SIMS-VAS-35026",
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
                                  "Sales",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Judul besar
                            Text(
                              "Stock Toko",
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

                // TANGGAL (pojok kanan atas)
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
                      "12 Sep 2025",
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
        ),
      ),
    );
  }
}
