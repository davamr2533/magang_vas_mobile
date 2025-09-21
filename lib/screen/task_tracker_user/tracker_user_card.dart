import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/task_tracker_user/tracker_user_model.dart';
import 'package:google_fonts/google_fonts.dart';


class TaskUserCard extends StatefulWidget {
  final Task task;

  const TaskUserCard({super.key, required this.task});

  @override
  TaskUserCardState createState() => TaskUserCardState();

}

class TaskUserCardState extends State<TaskUserCard> {

  //variable
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    final task = widget.task;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
      width: double.infinity,
      height: isExpanded ? 445 : 230, // panjang card jika di expand
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
                task.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
                color: Colors.black.withValues(alpha: 0.25), // FIX
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
                task.tahapPengajuan,
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
              task.idPengajuan,
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
              task.divisi,
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
              task.namaPengajuan,
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
                  percent: task.persentase / 100,
                  lineWidth: 8,
                  backgroundColor: softGrayNewAmikom,
                  progressColor: blueNewAmikom,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    "${task.persentase}%",
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
                    children: task.timeline.map((step) {
                      return timelineRow(step.title, step.date, step.isDone);
                    }).toList(),
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