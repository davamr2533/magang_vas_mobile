import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_page.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_widget/track_vas_pop_up.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import 'package:photo_view/photo_view.dart';


class TrackVasCard extends StatefulWidget {
  final dynamic task;
  final String nextProgress;
  final TextEditingController catatanController;



  const TrackVasCard({
    super.key,
    required this.task,
    required this.nextProgress,
    required this.catatanController,
  });

  @override
  State<TrackVasCard> createState() => _TrackVasCardState();

}

class _TrackVasCardState extends State<TrackVasCard> {
  List<XFile> updateImages = [];
  final ImagePicker _picker = ImagePicker();

  String? buildImageURL(String? path) {
    const String baseURL = "http://202.169.224.27:8081";

    if (path == null || path.isEmpty) return null;

    if (path.startsWith("http")) return path;
    return "$baseURL$path";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return _buildUpdateHistory(context);
          },
        );


      },
      borderRadius: BorderRadius.circular(12),
      splashColor: blueNewAmikom.withValues(alpha: 0.2),
      child: Container(
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
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    widget.task.nomorPengajuan,
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
                  Text(
                    widget.task.divisi,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: blackNewAmikom,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
                    widget.task.updatedAt.split(" ")[0],
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 45,
              child: Text(
                widget.task.jenis,
                style: GoogleFonts.urbanist(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 10,
              bottom: 10,
              child: Row(
                children: [
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
                          widget.task.currentProgress,
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
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return _buildUpdateDialog(context);
                        },
                      );
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
            ),
          ],
        ),
      ),
    );


  }

  Widget _buildUpdateDialog(BuildContext context) {
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
      contentPadding:
      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // === Upload Foto ===
                  const SizedBox(height: 12),
                  _labelForm("Lampiran Foto (Opsional)"),
                  GestureDetector(
                    onTap: () => _pickImageOptions(context, setStateDialog),

                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: yellowNewAmikom.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: grayNewAmikom),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_a_photo_outlined),
                          const SizedBox(width: 10),
                          Text(
                            "Tambah Foto (maks 3)",
                            style: GoogleFonts.urbanist(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (updateImages.isNotEmpty) ...[
                    const SizedBox(height: 8),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: updateImages.asMap().entries.map((entry) {
                          final i = entry.key;
                          final img = entry.value;
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(img.path),
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setStateDialog(() {
                                      updateImages.removeAt(i);
                                    });

                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    )

                  ],

                  const SizedBox(height: 8),

                  Divider(height: 1, color: grayNewAmikom),
                  const SizedBox(height: 8),
                  _labelForm("ID Pengajuan"),
                  _isiForm(widget.task.nomorPengajuan),
                  const SizedBox(height: 12),
                  _labelForm("Nama Sistem"),
                  _isiForm(widget.task.jenis),
                  const SizedBox(height: 12),
                  _labelForm("Next Progress"),
                  _isiForm(widget.nextProgress),
                  const SizedBox(height: 12),
                  _labelForm("Diupdate oleh"),
                  FutureBuilder<String?>(
                    future: SharedPref.getName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _isiForm("Loading...");
                      } else if (snapshot.hasError) {
                        return _isiForm("Error");
                      } else {
                        return _isiForm(snapshot.data ?? "_");
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _labelForm("Catatan"),
                  SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: TextField(
                      controller: widget.catatanController,
                      maxLines: null,
                      minLines: 5,
                      style: GoogleFonts.urbanist(fontSize: 14),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
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
                  const SizedBox(height: 12),
                  Divider(height: 1, color: grayNewAmikom),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.catatanController.clear();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenNewAmikom,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Back",
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (widget.task.currentProgress == "Production") {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                const TrackVasPopUpProduction(),
                              );
                              Future.delayed(const Duration(seconds: 2), () {
                                if (context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    routingPage(
                                      BlocProvider(
                                        create: (context) =>
                                            TaskTrackCubit(TaskTrackService()),
                                        child: const TrackVasPage(),
                                      ),
                                    ),
                                  );
                                }
                              });
                              return;
                            } else {

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  child: AppWidget().LoadingWidget(),
                                ),
                              );

                              final service = TaskTrackService();
                              final success = await service.updateTaskTracker(
                                nomorPengajuan: widget.task.nomorPengajuan,
                                taskClosed: widget.task.currentProgress,
                                taskProgress: widget.nextProgress,
                                updatedBy: await SharedPref.getName() ?? '_',
                                catatan: widget.catatanController.text,

                                // 🔥 NEW: kirim foto
                                foto1: updateImages.isNotEmpty ? File(updateImages[0].path) : null,
                                foto2: updateImages.length > 1 ? File(updateImages[1].path) : null,
                                foto3: updateImages.length > 2 ? File(updateImages[2].path) : null,
                              );

                              if (success && context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) =>
                                  const TrackVasPopUpSuccess(),
                                );
                                await Future.delayed(const Duration(seconds: 2));

                                if (context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    routingPage(
                                      BlocProvider(
                                        create: (context) => TaskTrackCubit(TaskTrackService()),
                                        child: const TrackVasPage(),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blueNewAmikom,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Update",
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
      )


    );
  }

  Widget _buildUpdateHistory(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      title: Text(
        "Update History",
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      contentPadding:
      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // === FOTO DARI TIMELINE ===
            const SizedBox(height: 12),
            _labelForm("Lampiran Foto Tahap Sebelumnya"),

            Column(
              children: widget.task.timeline
                  .where((item) => item.tahap == widget.task.currentProgress)
                  .map<Widget>((item) {

                final List<String> fotos = [
                  item.foto1,
                  item.foto2,
                  item.foto3,
                ].where((f) => f != null && f!.isNotEmpty).cast<String>().toList();

                if (fotos.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 6, bottom: 12),
                    decoration: BoxDecoration(
                      color: yellowNewAmikom,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Tidak ada foto",
                      style: GoogleFonts.urbanist(fontSize: 14),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 8),

                    Center(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: fotos.map((fotoUrl) {
                          final fixedUrl = buildImageURL(fotoUrl)!;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullImageView(imageUrl: fixedUrl),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withValues(alpha: 0.2),
                                  BlendMode.darken,
                                ),
                                child: Image.network(
                                  fixedUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      color: Colors.black12,
                                      child: const Icon(Icons.broken_image, size: 30),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )



                  ],
                );
              }).toList(),
            ),


            const SizedBox(height: 12),
            Divider(height: 1, color: grayNewAmikom),
            const SizedBox(height: 8),
            _labelForm("ID Pengajuan"),
            _isiForm(widget.task.nomorPengajuan),
            const SizedBox(height: 12),
            _labelForm("Nama Sistem"),
            _isiForm(widget.task.jenis),
            const SizedBox(height: 12),
            _labelForm("Current Progress"),
            _isiForm(widget.task.currentProgress),
            const SizedBox(height: 12),
            _labelForm("Terakhir Update"),
            _isiForm(widget.task.updatedAt.split(" ")[0]),
            const SizedBox(height: 12),
            _labelForm("Diupdate oleh"),
            _isiForm(widget.task.updatedBy),
            const SizedBox(height: 12),
            _labelForm("Catatan"),




            if (widget.task.catatan != null)
              Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: yellowNewAmikom,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: SelectableLinkify(
                    text: widget.task.catatan,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    linkStyle: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    onOpen: (link) async {
                      final uri = Uri.parse(link.url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                ),
              )


            else
              Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: yellowNewAmikom,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Tidak ada catatan",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                  ),

                ),
              ),



            const SizedBox(height: 20),


            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.catatanController.clear();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenNewAmikom,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _labelForm(String text) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _isiForm(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: yellowNewAmikom,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.urbanist(fontSize: 14),
      ),
    );
  }

  Future<void> _pickImageOptions(
      BuildContext context,
      void Function(void Function()) setStateDialog,
      ) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [

              // Kamera
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text("Ambil Foto dari Kamera",
                    style: GoogleFonts.urbanist()),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 100,
                  );
                  if (photo != null && updateImages.length < 3) {
                    setStateDialog(() {
                      updateImages.add(photo);
                    });
                  }
                },
              ),

              // Galeri
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text("Pilih dari Galeri",
                    style: GoogleFonts.urbanist()),
                onTap: () async {
                  Navigator.pop(context);
                  final List<XFile> imgs = await _picker.pickMultiImage(
                    imageQuality: 100,
                  );
                  if (imgs.isNotEmpty) {
                    setStateDialog(() {
                      updateImages.addAll(imgs.take(3 - updateImages.length));
                    });

                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageUrl;

  const FullImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: PhotoViewComputedScale.covered * 3,
      ),
    );
  }
}
