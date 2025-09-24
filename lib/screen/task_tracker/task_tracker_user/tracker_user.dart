import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart' as apps;
import 'package:vas_reporting/data/model/response/get_data_vas_response.dart' as vas;
import 'package:vas_reporting/screen/task_tracker/task_service.dart';
import 'package:vas_reporting/screen/task_tracker/task_tracker_user/tracker_user_card.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';




class TrackerUser extends StatefulWidget {

  const TrackerUser({super.key});

  @override
  State<TrackerUser> createState() => _TrackerUserState();

}

class _TrackerUserState extends State<TrackerUser> {
  late Future<Map<String, dynamic>> futureData;
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
        futureData = Future.wait([
          TaskService.fetchTasks(token),
          TaskService.fetchTimelines(token),
        ]).then((results) {
          return {
            "tasks" : results[0] as List<apps.Data>,
            "timelines" : results[1] as List<vas.Data>
          };
        });
      });

      // optional: wait for completion to update loading state nicely
      futureData.then((_) {
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

      body: Expanded(
          child: _loading
              ?
          const Center(child: CircularProgressIndicator())
              :
          (_errorMessage != null)


              ?
          Center(
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
              :
          FutureBuilder(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }else if (snapshot.hasError) {
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
              }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Tidak ada task"));
              }

              final data = snapshot.data as Map<String, dynamic>;
              final tasks = data["tasks"] as List<apps.Data>;
              final timelines = data["timelines"] as List<vas.Data>;


              return ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  // cari timeline berdasarkan nomorPengajuan
                  final timeline = timelines.firstWhere(
                        (t) => t.nomorPengajuan == task.nomorPengajuan,
                    orElse: () => vas.Data(), // kalau ga ketemu bikin empty
                  );

                  return TaskUserCard(
                    task: task,
                    timeline: timeline,
                  );

                },
              );

            }
          )
      ),









    );


  }
}