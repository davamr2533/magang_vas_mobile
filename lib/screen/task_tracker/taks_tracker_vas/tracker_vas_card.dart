  import 'package:flutter/material.dart';
  import 'package:vas_reporting/base/amikom_color.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:vas_reporting/screen/task_tracker/tracker_model.dart';

  class TaskVasCard extends StatefulWidget {
    final Task task;

    const TaskVasCard({super.key, required this.task});

    @override
    TaskVasCardState createState() => TaskVasCardState();

  }


  class TaskVasCardState extends State<TaskVasCard> {

    @override
    Widget build(BuildContext context) {

      final task = widget.task;
      String nextProgress;

      nextProgress = "Progress";

      if (task.tahapPengajuan == "Wawancara") {
        nextProgress = "Konfirmasi Desain";
      }else if (task.tahapPengajuan == "Konfirmasi Desain"){
        nextProgress = "Perancangan DB";
      }else if (task.tahapPengajuan == "Perancangan DB") {
        nextProgress = "Pengembangan Software";
      }else if (task.tahapPengajuan == "Pengembangan Software") {
        nextProgress = "Debugging";
      }else if (task.tahapPengajuan == "Debugging") {
        nextProgress = "Testing";
      }else if (task.tahapPengajuan == "Testing") {
        nextProgress = "Trial";
      }else if (task.tahapPengajuan == "Trial") {
        nextProgress = "Production";
      }

      return Container(
        width: double.infinity,
        height: 150,
        margin: EdgeInsets.only(bottom: 20),
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

            //Baris divisi dan Id pengajuan
            Container(
              margin: EdgeInsets.all(10),
              height: 20,
              child: Row(
                children: [
                  //ID pengajuan
                  Text(
                    task.idPengajuan,
                    style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: blackNewAmikom
                    ),
                  ),

                  SizedBox(width: 4),

                  Text(
                    "|",
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: blackNewAmikom,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(width: 4),

                  //Divisi yang melakukan pengajuan
                  Text(
                    task.divisi,
                    style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: blackNewAmikom,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),

            ),

            //Tanggal terakhir di update
            Positioned(
              right: 0,
                child: Container(
                  width: 110,
                  height: 30,
                  decoration: BoxDecoration(
                    color: yellowNewAmikom,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0) ,
                      bottomLeft: Radius.circular(10) ,
                      topRight: Radius.circular(12) ,
                      bottomRight: Radius.circular(0)
                    )
                  ),
                  child: Center(
                    child: Text(
                      task.tanggal,
                      style: GoogleFonts.urbanist(
                        fontSize: 14
                      ),
                    ),
                  ),
                )
            ),

            //Nama Pengajuan
            Positioned(
              left: 10,
              top: 45,
                child: Text(
                  task.namaPengajuan,
                  style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
            ),

            //Tahap Pengajuan
            Positioned(
              left: 0,
              right: 10,
              top: 90,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        height: 35,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: blueNewAmikom,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(
                          child: Text(
                            task.tahapPengajuan,
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                          )
                        ),
                      ),
                  ),

                  SizedBox(width: 15),

                  //Tombol untuk update progress
                  ElevatedButton(
                      onPressed: (){

                        //Pop Up untuk Update Progress
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)
                                ),

                                backgroundColor: Colors.white,

                                title: Text(
                                  "Update Progress",
                                  style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                  ),
                                ),

                                contentPadding: EdgeInsets.only(left: 12, right: 12),

                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    height: 505,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        SizedBox(height: 10),

                                        Divider(
                                          color: grayNewAmikom,
                                          height: 1,
                                        ),

                                        SizedBox(height: 10),

                                        //ID Pengajuan
                                        Text(
                                          "ID Pengajuan",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        SizedBox(height: 4),

                                        Container(
                                          width: double.infinity,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: yellowNewAmikom,
                                          ),
                                          padding: EdgeInsets.only(left: 8),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            task.idPengajuan,
                                            style: GoogleFonts.urbanist(
                                                fontSize: 14
                                            ),
                                          ),

                                        ),

                                        SizedBox(height: 12),

                                        //Nama Sistem
                                        Text(
                                          "Nama Sistem",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        SizedBox(height: 4),

                                        Container(
                                          width: double.infinity,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: yellowNewAmikom,
                                          ),
                                          padding: EdgeInsets.only(left: 8),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            task.namaPengajuan,
                                            style: GoogleFonts.urbanist(
                                                fontSize: 14
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 12),

                                        //Next Progress
                                        Text(
                                          "Next Progress",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        SizedBox(height: 4),

                                        Container(
                                          width: double.infinity,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: yellowNewAmikom,
                                          ),
                                          padding: EdgeInsets.only(left: 8),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            nextProgress,
                                            style: GoogleFonts.urbanist(
                                                fontSize: 14
                                            ),
                                          ),

                                        ),

                                        SizedBox(height: 12),

                                        //Diupdate oleh
                                        Text(
                                          "Diupdate oleh",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        SizedBox(height: 4),

                                        Container(
                                          width: double.infinity,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: yellowNewAmikom,
                                          ),
                                          padding: EdgeInsets.only(left: 8),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            task.diupdateOleh,
                                            style: GoogleFonts.urbanist(
                                                fontSize: 14
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 12),

                                        //Catatan
                                        Text(
                                          "Catatan",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                          ),

                                        ),

                                        SizedBox(height: 4),

                                        //Text field untuk catatan
                                        SizedBox(
                                          width: double.infinity,
                                          height: 100,
                                          child: TextField(
                                            maxLines: null,
                                            minLines: 5,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14
                                            ),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),

                                              hintText: "Opsional",
                                              hintStyle: GoogleFonts.urbanist(
                                                  fontSize: 14
                                              ),
                                              filled: true,
                                              fillColor: yellowNewAmikom,

                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: greenNewAmikom,
                                                    width: 2
                                                ),
                                              ),
                                            ),
                                          ),

                                        ),


                                        SizedBox(height: 12),

                                        Divider(
                                          color: grayNewAmikom,
                                          height: 1,
                                        ),

                                        SizedBox(height: 8),

                                        Row(
                                          children: [

                                            //Button untuk menutup Pop Up
                                            ElevatedButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: greenNewAmikom,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    elevation: 0,
                                                    fixedSize: const Size(120, 25)
                                                ),
                                                child: Text(
                                                  "Back",
                                                  style: GoogleFonts.urbanist(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18
                                                  ),

                                                )
                                            ),

                                            Spacer(),

                                            //Button untuk update progress
                                            ElevatedButton(
                                                onPressed: (){

                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: blueNewAmikom,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    elevation: 0,
                                                    fixedSize: const Size(120, 25)
                                                ),
                                                child: Text(
                                                  "Update",
                                                  style: GoogleFonts.urbanist(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18
                                                  ),
                                                )
                                            ),
                                          ],
                                        )

                                      ],
                                    ),
                                  ),
                                )
                              );
                            }
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenNewAmikom,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        fixedSize: const Size(70, 35)
                      ),
                      child: Icon(
                        Icons.edit_calendar_sharp,
                        color: brownNewAmikom,
                        size: 25,
                      )
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }