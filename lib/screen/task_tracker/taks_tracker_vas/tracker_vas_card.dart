import 'package:flutter/material.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart';

class TaskVasCard extends StatefulWidget {
  final Data task;

  const TaskVasCard({
    super.key,
    required this.task,
  });

  @override
  TaskVasCardState createState() => TaskVasCardState();
}

class TaskVasCardState extends State<TaskVasCard> {
  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    // Tentukan next progress berdasarkan statusAjuan
    String nextProgress = "Progress";
    switch (task.statusAjuan) {
      case "Wawancara":
        nextProgress = "Konfirmasi Desain";
        break;
      case "Konfirmasi Desain":
        nextProgress = "Perancangan DB";
        break;
      case "Perancangan DB":
        nextProgress = "Pengembangan Software";
        break;
      case "Pengembangan Software":
        nextProgress = "Debugging";
        break;
      case "Debugging":
        nextProgress = "Testing";
        break;
      case "Testing":
        nextProgress = "Trial";
        break;
      case "Trial":
        nextProgress = "Production";
        break;
      default:
        nextProgress = "Progress berikutnya belum ditentukan";
    }

    return Container(
      width: double.infinity,
      height: 150,
      margin: const EdgeInsets.only(bottom: 20),
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

          // Baris divisi dan ID pengajuan
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [

                //Nomor Pengajuan
                Text(
                  task.nomorPengajuan ?? '_',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: blackNewAmikom,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "|",
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: blackNewAmikom,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),

                //Divisi
                Text(
                  task.divisi ?? '_',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: blackNewAmikom,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          //tanggal update
          Positioned(
            right: 0,
            child: Container(
              width: 120,
              height: 35,
              decoration: BoxDecoration(
                color: yellowNewAmikom,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  "12 Sep 2025",
                  // task.statusAjuan ?? '-', //Sementara asal karena belum ada kolom last update nya, nanti mintak bikinin ya mash
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          // Nama pengajuan (Jenis)
          Positioned(
            left: 10,
            top: 45,
            child: Text(
              task.jenis ?? '_',
              style: GoogleFonts.urbanist(
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          // Tahap current progress + tombol edit
          Positioned(
            left: 0,
            right: 10,
            bottom: 10,
            child: Row(
              children: [

                //Current Progress
                Expanded(
                  child: Container(
                    height: 35,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: blueNewAmikom,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        task.statusAjuan ?? '_', // Sementara asal karena belum ada tabelnya, mintak bikinin nanti
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),


                const SizedBox(width: 15),

                // Tombol update progress
                ElevatedButton(
                  onPressed: () {
                    _showUpdateDialog(context, task, nextProgress);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenNewAmikom,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    fixedSize: const Size(70, 35),
                  ),
                  child: Icon(
                    Icons.edit_calendar_sharp,
                    color: brownNewAmikom,
                    size: 25,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, Data task, String nextProgress) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Update Progress",
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          contentPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 12),
                Divider(height: 1,color: grayNewAmikom),
                SizedBox(height: 8),

                _labelForm("ID Pengajuan"),
                _isiForm(task.nomorPengajuan ?? '_'), //Nomor Pengajuan
                const SizedBox(height: 12),

                _labelForm("Nama Sistem"),
                _isiForm(task.jenis ?? '_'), //Nama Sistem
                const SizedBox(height: 12),

                _labelForm("Next Progress"),
                _isiForm(nextProgress), //Next Progress
                const SizedBox(height: 12),

                _labelForm("Diupdate oleh"),
                _isiForm(task.namaPemohon ?? '_'), //Nama yang melakukan Update
                const SizedBox(height: 12),

                _labelForm("Catatan"),
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: TextField( //Text field untuk input catatan
                    maxLines: null,
                    minLines: 5,
                    style: GoogleFonts.urbanist(fontSize: 14),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Opsional",
                      filled: true,
                      fillColor: yellowNewAmikom,

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: greenNewAmikom,
                          width: 1.5,
                        ),
                      ),






                    ),

                  ),
                ),

                SizedBox(height: 12),

                Divider(height: 1,color: grayNewAmikom),

                SizedBox(height: 8),

                Row(
                  children: [

                    //Tombol Back
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenNewAmikom,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8)
                            )
                          ),
                          child: Text(
                            "Back",
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                    ),


                    SizedBox(width: 8),


                    //Tombol Update
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showSuccessDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueNewAmikom,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8)
                          )
                        ),

                        child: Text(
                          "Update",
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )

                  ],
                )
              ],
            ),
          ),

        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {

        final navigator = Navigator.of(dialogContext);

        Future.delayed(const Duration(seconds: 2), () {
          if (navigator.canPop()) {
            navigator.pop();
          }
        });

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 100),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: softestGrayNewAmikom,
                        borderRadius: BorderRadiusGeometry.circular(100)
                    ),
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadiusGeometry.circular(100)
                              ),
                            ),
                          ),

                          Center(
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: greenNewAmikom,
                                size: 75,
                              )
                          )



                        ],
                      ),


                    ),
                  ),
                ),







                const SizedBox(height: 8),


                Center(
                  child: Text(
                      "Success!",
                      style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold, fontSize: 20
                      )
                  ),
                ),



                Center(
                  child: Text(
                      "Progress berhasil diupdate!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                          fontSize: 14, color: darkGrayNewAmikom,
                      )
                  ),
                )


              ],
            ),
          ),
        );
      },
    );
  }

  Widget _labelForm(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      )
    );
  }

  Widget _isiForm(String value) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: yellowNewAmikom,
      ),
      padding: const EdgeInsets.only(left: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: GoogleFonts.urbanist(fontSize: 14),
      ),
    );
  }
}
