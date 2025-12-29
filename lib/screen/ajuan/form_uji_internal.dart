import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;
import 'package:vas_reporting/data/cubit/form/form_cubit.dart';
import 'package:vas_reporting/data/model/body/form_uji_body.dart';
import 'package:vas_reporting/data/model/body/form_vas_body.dart';
import 'package:vas_reporting/screen/ajuan/uji_home.dart';
import 'package:vas_reporting/screen/home/home_page.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/popup.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';

class FormUjiInternal extends StatefulWidget {
  FormUjiInternal({required this.id, required this.nomor, super.key});
  String nomor = '';
  int id = 0;

  @override
  State<FormUjiInternal> createState() => _FormUjiInternalState();
}

class _FormUjiInternalState extends State<FormUjiInternal> {
  final _formKey = GlobalKey<FormState>();

  String? _statusPengujian;
  String? nama;
  String? token;
  bool isLoading = false;
  String? formattedDate;
  late FormCubit _formCubit;
  late PopUpWidget _popUpWidget;
  
  final TextEditingController _tanggalController = TextEditingController();

  final TextEditingController _perangkatController = TextEditingController();
  final TextEditingController _versiController = TextEditingController();
  final TextEditingController _tujuanController = TextEditingController();
  final TextEditingController _metodeController = TextEditingController();
  final TextEditingController _tglPengujianController = TextEditingController();
  final TextEditingController _namaUjiController = TextEditingController();
  final TextEditingController _kasusController = TextEditingController();
  final TextEditingController _hasilController = TextEditingController();
  final TextEditingController _hasilUjiController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    _formCubit = context.read<FormCubit>();
    _popUpWidget = PopUpWidget(context);
    fetchData();
  }

  void fetchData() async {
    nama = await SharedPref.getName();
    token = await SharedPref.getToken();
    _namaUjiController.text = nama ?? "";
  }

  Widget buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: GoogleFonts.urbanist(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(fontSize: 14, color: Colors.black),
        filled: true,
        fillColor: baseColors.secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7, // atur tinggi field
        ),
      ),

      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        print(_tglPengujianController.text);
        if (pickedDate != null) {
          controller.text =
              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<FormCubit, FormHasState>(
      listener: (context, state) {
        if (state is FormLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is FormFailure) {
          setState(() {
            isLoading = false;
          });
          _popUpWidget.showAlert('Failed', state.message, false, 'true', UjiHome());
        }
        if (state is FormResponseSuccess) {
          setState(() {
            isLoading = false;
          });
          _popUpWidget.showAlert('Success', state.response.message ?? '', true, 'Ok', UjiHome());
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 90,
                  left: 20,
                  right: 16,
                  bottom: 10,
                ),
                height: screenHeight / 2,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: baseColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacement(routingPage(UjiHome()));
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Form Pengujian Internal",
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: screenHeight / 2.5,
                      ),
                      margin: EdgeInsets.only(top: screenHeight / 7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              80,
                              73,
                              73,
                            ).withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            "Diisi oleh QA/QC",
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _perangkatController,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: _inputDecoration("Perangkat Lunak"),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _versiController,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: _inputDecoration("Versi"),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _tujuanController,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: _inputDecoration("Tujuan"),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _metodeController,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: _inputDecoration("Metode"),
                          ),
                          const SizedBox(height: 16),

                          buildDateField(
                            label: "Tanggal",
                            controller: _tglPengujianController,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _namaUjiController,
                            readOnly: true,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: _inputDecoration("Nama Uji"),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _kasusController,
                            maxLines: 2,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: _inputDecoration("Kasus Uji"),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _hasilController,
                            maxLines: 2,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: _inputDecoration(
                              "Hasil yang diharapkan",
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _hasilUjiController,
                            maxLines: 2,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: _inputDecoration("Hasil Uji"),
                          ),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: _statusPengujian,
                            items: [
                              DropdownMenuItem(
                                value: "Progress",
                                child: Text(
                                  "Progress",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Production",
                                child: Text(
                                  "Production",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (val) =>
                                setState(() => _statusPengujian = val),
                            decoration: InputDecoration(
                              labelText: "Status",
                              labelStyle: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: baseColors.secondaryColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            focusColor: baseColors.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _noteController,
                            maxLines: 2,
                            decoration: _inputDecoration("Note"),
                          ),
                          const SizedBox(height: 30),
                          isLoading
                          ? AppWidget().LoadingWidget()
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: baseColors.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                              List<String> kosong = [];
                              if (_perangkatController.text.isEmpty) kosong.add("Perangkat Lunak");
                              if (_versiController.text.isEmpty) kosong.add("Versi");
                              if (_tujuanController.text.isEmpty) kosong.add("Tujuan");
                              if (_metodeController.text.isEmpty) kosong.add("Metode");
                              if (_tglPengujianController.text.isEmpty) kosong.add("Tanggal Pengujian");
                              if (_namaUjiController.text.isEmpty) kosong.add("Nama Uji");
                              if (_kasusController.text.isEmpty) kosong.add("Kasus Uji");
                              if (_hasilController.text.isEmpty) kosong.add("Hasil Harapan");
                              if (_hasilUjiController.text.isEmpty) kosong.add("Hasil Uji");
                              if (_statusPengujian == null || _statusPengujian!.isEmpty) kosong.add("Status Pengujian");
                              if (_noteController.text.isEmpty) kosong.add("Catatan/Keterangan");
                              if (kosong.isEmpty) {
                                await _formCubit.formUji(
                                  token: 'Bearer $token',
                                  formBody: FormUjiBody(
                                    status: _statusPengujian,
                                    nomor: widget.nomor,
                                    perangkatLunak: _perangkatController.text,
                                    versi: _versiController.text,
                                    tujuan: _tujuanController.text,
                                    metode: _metodeController.text,
                                    namaUji: _namaUjiController.text,
                                    kasusUji: _kasusController.text,
                                    hasilHarapan: _hasilController.text,
                                    hasilUji: _hasilUjiController.text,
                                    keterangan: _noteController.text,
                                    jenis: _perangkatController.text,
                                    divisi: "NOC"
                                  ),
                                );
                              } else {
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Form harus diisi semua! Kosong: ${kosong.join(', ')}",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                              child: const Text(
                                "KIRIM",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight / 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.urbanist(color: Colors.black, fontSize: 14),
      filled: true,
      fillColor: baseColors.secondaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7, // atur tinggi field
      ),
    );
  }
}
