// lib/.../tracker_vas.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart';
import 'package:vas_reporting/screen/task_tracker/taks_tracker_vas/tracker_vas_card.dart';
import 'package:vas_reporting/screen/task_tracker/task_service.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';

class TrackerVas extends StatefulWidget {
  const TrackerVas({super.key});

  @override
  State<TrackerVas> createState() => _TrackerVasState();
}

class _TrackerVasState extends State<TrackerVas> {
  late Future<List<Data>> futureTasks;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final token = await SharedPref.getToken(); // ambil token dari shared prefs
      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Token tidak ditemukan. Silakan login ulang.';
          _loading = false;
        });
        return;
      }

      setState(() {
        futureTasks = TaskService.fetchTasks(token); // pass raw token (tanpa "Bearer ")
      });

      // optional: wait for completion to update loading state nicely
      futureTasks.then((_) {
        if (mounted) setState(() => _loading = false);
      }).catchError((e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString();
            _loading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // icon back
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
      body: Column(
        children: [

          Row(

            children: [

              //Search Bar
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
                  child: TextField(
                    style: GoogleFonts.urbanist(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Cari task...",
                      hintStyle: GoogleFonts.urbanist(fontSize: 14, color: darkGrayNewAmikom),
                      filled: true,
                      fillColor: Colors.red[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide( color: Colors.red, width: 2,
                        ),
                      ),
                      suffixIcon: Icon( Icons.search, color: darkGrayNewAmikom ),
                    ),
                  ),
                ),
              ),

              //Tombol filter
              Container(
                width: 45,
                height: 45,
                margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: yellowNewAmikom,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_alt_rounded,
                    color: blueNewAmikom, size: 30,
                  ),
                  onPressed: () {

                  },
                ),
              ),


            ],

          ),




          const SizedBox(height: 20),

          //Daftar Pengajuan
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : (_errorMessage != null)
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error: $_errorMessage',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _loadTasks(),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            )
                : FutureBuilder<List<Data>>(
              future: futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _loadTasks(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada task"));
                }

                final tasks = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: tasks.length + 1,
                  itemBuilder: (context, index) {
                    if (index == tasks.length) return const SizedBox(height: 80);
                    return TaskVasCard(task: tasks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
