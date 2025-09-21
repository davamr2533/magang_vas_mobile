import 'package:flutter/material.dart';
import 'package:vas_reporting/screen/task_tracker_user/tracker_user_card.dart';
import 'package:vas_reporting/screen/task_tracker_user/tracker_user_model.dart';
import 'package:flutter/services.dart';

class TrackerUser extends StatelessWidget {

  TrackerUser({super.key});


  //simulasi dummy API etok-etok untuk Card
  final List<Map<String, dynamic>> dummyApi = [

    { // sampel data satu
      "idPengajuan" : "SIMS-VAS-35026",
      "tahapPengajuan" : "Perancangan DB",
      "divisi" : "NOC",
      "namaPengajuan" : "Stock Toko",
      "tanggal" : "2025-09-12",
      "persentase" : 38,
      "image" : "assets/rancang_db.png",
      "isDone" : false,
      "timeline" : [
        {"title" : "Wawancara", "date" : "12-09-2025", "isDone" : true},
        {"title" : "Konfirmasi Desain", "date" : "14-09-2025", "isDone" : true},
        {"title" : "Perancangan DB", "date" : "15-09-2025", "isDone" : true},
        {"title" : "Pengembangan Software", "date" : "16-09-2025", "isDone" : false},
        {"title" : "Debugging", "date" : "18-09-2025", "isDone" : false},
        {"title" : "Testing", "date" : "19-09-2025", "isDone" : false},
        {"title" : "Trial", "date" : "21-09-2025", "isDone" : false},
        {"title" : "Production", "date" : "22-09-2025", "isDone" : false},
      ]
    },

    { // sampel data dua
      "idPengajuan" : "SIMS-VAS-35027",
      "tahapPengajuan" : "Wawancara",
      "divisi" : "Sales",
      "namaPengajuan" : "Dompet Duafa",
      "tanggal" : "2025-09-12",
      "persentase" : 13,
      "image" : "assets/wawancara.png",
      "isDone" : false,
      "timeline" : [
        {"title" : "Wawancara", "date" : "01-10-2025", "isDone" : true},
        {"title" : "Konfirmasi Desain", "date" : "02-10-2025", "isDone" : false},
        {"title" : "Perancangan DB", "date" : "04-10-2025", "isDone" : false},
        {"title" : "Pengembangan Software", "date" : "10-10-2025", "isDone" : false},
        {"title" : "Debugging", "date" : "15-10-2025", "isDone" : false},
        {"title" : "Testing", "date" : "16-10-2025", "isDone" : false},
        {"title" : "Trial", "date" : "17-10-2025", "isDone" : false},
        {"title" : "Production", "date" : "19-10-2025", "isDone" : false},
      ]
    },

    { // sampel data tiga
      "idPengajuan" : "SIMS-VAS-35028",
      "tahapPengajuan" : "Pengembangan",
      "divisi" : "Wiko",
      "namaPengajuan" : "Web Wifi Coin",
      "tanggal" : "2025-09-12",
      "persentase" : 50,
      "image" : "assets/pengembangan_software.png",
      "isDone" : false,
      "timeline" : [
        {"title" : "Wawancara", "date" : "01-10-2025", "isDone" : true},
        {"title" : "Konfirmasi Desain", "date" : "02-10-2025", "isDone" : true},
        {"title" : "Perancangan DB", "date" : "04-10-2025", "isDone" : true},
        {"title" : "Pengembangan Software", "date" : "10-10-2025", "isDone" : true},
        {"title" : "Debugging", "date" : "15-10-2025", "isDone" : false},
        {"title" : "Testing", "date" : "16-10-2025", "isDone" : false},
        {"title" : "Trial", "date" : "17-10-2025", "isDone" : false},
        {"title" : "Production", "date" : "19-10-2025", "isDone" : false},
      ]
    },

  ];


  @override
  Widget build(BuildContext context) {

    final tasks = dummyApi.map((e) => Task.fromJson(e)).toList();

    return Scaffold(

      appBar: AppBar(
        title: const Text("Task Tracker"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,

        //agar status bar terlihat
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // warna status bar
          statusBarIconBrightness: Brightness.dark, // warna icon
        ),

      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length + 1,
        itemBuilder: (context, index) {
          if (index == tasks.length) {
            return const SizedBox(height: 80);
          }
          return TaskUserCard(task: tasks[index]);
        },
      ),



    );


  }
}