import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/task_tracker/taks_tracker_vas/tracker_vas_card.dart';
import 'package:vas_reporting/screen/task_tracker/tracker_model.dart';

class TrackerVas extends StatelessWidget {

  TrackerVas({super.key});

  //simulasi dummy API etok-etok untuk Card
  final List<Map<String, dynamic>> dummyApi = [

    { // sampel data satu
      "idPengajuan" : "SIMS-VAS-35026",
      "tahapPengajuan" : "Perancangan DB",
      "divisi" : "NOC",
      "namaPengajuan" : "Stock Toko",
      "tanggal" : "12 Sep 2025",
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
      ],
      "diupdateOleh" : "Fais",
    },

    { // sampel data dua
      "idPengajuan" : "SIMS-VAS-35027",
      "tahapPengajuan" : "Wawancara",
      "divisi" : "Sales",
      "namaPengajuan" : "Dompet Duafa",
      "tanggal" : "12 Sep 2025",
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
      ],
      "diupdateOleh" : "Fais",
    },

    { // sampel data tiga
      "idPengajuan" : "SIMS-VAS-35028",
      "tahapPengajuan" : "Pengembangan",
      "divisi" : "Wiko",
      "namaPengajuan" : "Web Wifi Coin",
      "tanggal" : "13 Sep 2025",
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
      ],
      "diupdateOleh" : "Fais",
    },

  ];

  @override
  Widget build(BuildContext context) {


    final tasks = dummyApi.map((e) => Task.fromJson(e)).toList();



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

      //isi halaman
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
                        hintStyle: GoogleFonts.urbanist(fontSize: 14),
                        filled: true,
                        fillColor: Colors.red[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
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
                    color: blueNewAmikom,
                    size: 30,
                  ),
                  onPressed: () {

                  },
                ),
              ),


            ],
          ),
          //Search bar


          SizedBox(height: 20),

          //Daftar task
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: tasks.length + 1,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return const SizedBox(height: 80);
                }
                return TaskVasCard(task: tasks[index]);
              },
            ),
          ),
        ],
      ),


    );
  }




}