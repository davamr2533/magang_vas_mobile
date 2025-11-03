import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;
import 'package:vas_reporting/data/cubit/form/form_cubit.dart';
import 'package:vas_reporting/data/model/body/form_vas_body.dart';
import 'package:vas_reporting/screen/ajuan/vas_home.dart';
import 'package:vas_reporting/screen/home/home_page.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/popup.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';

class FormAjuanVas extends StatefulWidget {
  FormAjuanVas({required this.id, required this.nomor,  required this.approve, super.key});
  String nomor = '';
  int id = 0;
  String approve = '';

  @override
  State<FormAjuanVas> createState() => _FormAjuanVasState();
}

class _FormAjuanVasState extends State<FormAjuanVas> {
  late FormCubit _formCubit;
  late PopUpWidget _popUpWidget;

  String? formattedDate;
  String? _pengerjaan;
  String? token;
  String? nama;
  bool isLoading = false;
  // Controllers bagian VA
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _diterimaOlehController = TextEditingController();
  final TextEditingController _disetujuiOlehController =
      TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _wawancaraController = TextEditingController();
  final TextEditingController _konfirmasiDesainController =
      TextEditingController();
  final TextEditingController _dbController = TextEditingController();
  final TextEditingController _devController = TextEditingController();
  final TextEditingController _debugController = TextEditingController();
  final TextEditingController _testingController = TextEditingController();
  final TextEditingController _trialController = TextEditingController();
  final TextEditingController _liveController = TextEditingController();

  @override
  void initState() {
    super.initState();
   _formCubit = context.read<FormCubit>();
    _popUpWidget = PopUpWidget(context);
    formattedDate = DateFormat("d MMMM yyyy").format(DateTime.now());
    fetchData();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    nama = await SharedPref.getName();
    _nomorController.text = widget.nomor;
    _diterimaOlehController.text = nama ?? '';
    _disetujuiOlehController.text = widget.approve ?? '';
  }

  // 🔹 Helper buat input tanggal
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
    final _formKey = GlobalKey<FormState>();
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
          _popUpWidget.showAlert('Failed', state.message, false, 'true', VasHome());
        }
        if (state is FormResponseSuccess) {
          setState(() {
            isLoading = false;
          });
          _popUpWidget.showAlert('Success', state.response.message ?? '', true, 'Ok', VasHome());
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
                            ).pushReplacement(routingPage(VasHome()));
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Form VAS",
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
                            "Diisi Oleh VAS",
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                      
                          TextFormField(
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: formattedDate,
                              filled: true,
                              fillColor: baseColors.secondaryColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                      
                          TextFormField(
                            controller: _nomorController,
                            readOnly: true,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Color.fromARGB(255, 65, 65, 65),
                            ),
                            decoration: _inputDecoration("Nomor"),
                          ),
                          const SizedBox(height: 16),
                      
                          DropdownButtonFormField<String>(
                            value: _pengerjaan,
                            items: [
                              DropdownMenuItem(
                                value: "Sendiri",
                                child: Text(
                                  "Sendiri",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Pihak ketiga",
                                child: Text(
                                  "Pihak ketiga",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (val) =>
                                setState(() => _pengerjaan = val),
                            decoration: InputDecoration(
                              labelText: "Pengerjaan",
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
                            controller: _diterimaOlehController,
                            readOnly: true,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Color.fromARGB(255, 65, 65, 65),
                            ),
                            decoration: _inputDecoration("Diterima Oleh"),
                          ),
                          const SizedBox(height: 16),
                      
                          TextFormField(
                            controller: _disetujuiOlehController,
                            readOnly: true,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 65, 65, 65),
                            ),
                            decoration: _inputDecoration("Disetujui Oleh"),
                          ),
                          const SizedBox(height: 16),
                      
                          TextFormField(
                            controller: _catatanController,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            decoration: _inputDecoration("Catatan Implikasi"),
                          ),
                          const SizedBox(height: 16),
                      
                          buildDateField(
                            label: "Wawancara",
                            controller: _wawancaraController,
                          ),
                          const SizedBox(height: 16),
                      
                          buildDateField(
                            label: "Konfirmasi Desain",
                            controller: _konfirmasiDesainController,
                          ),
                          const SizedBox(height: 16),
                      
                          buildDateField(
                            label: "Perancangan Database",
                            controller: _dbController,
                          ),
                          const SizedBox(height: 16),
                      
                          buildDateField(
                            label: "Software Development",
                            controller: _devController,
                          ),
                          const SizedBox(height: 16),
                      
                          buildDateField(
                            label: "Debugging",
                            controller: _debugController,
                          ),
                          const SizedBox(height: 16),
                      
                          buildDateField(
                            label: "Testing",
                            controller: _testingController,
                          ),
                          const SizedBox(height: 16),
                      
                          buildDateField(
                            label: "Trial",
                            controller: _trialController,
                          ),
                          const SizedBox(height: 16),
                      
                          buildDateField(
                            label: "Live Production",
                            controller: _liveController,
                          ),
                          const SizedBox(height: 30),
                      
                          // ----------------- TOMBOL KIRIM -----------------
                          isLoading
                              ? AppWidget().LoadingWidget()
                              :
                          SizedBox(
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
                              onPressed: () {
                                if (_nomorController.text.isNotEmpty &&
                                    (_pengerjaan != null && _pengerjaan!.isNotEmpty) &&
                                    _diterimaOlehController.text.isNotEmpty &&
                                    _disetujuiOlehController.text.isNotEmpty &&
                                    _catatanController.text.isNotEmpty &&
                                    _wawancaraController.text.isNotEmpty &&
                                    _konfirmasiDesainController.text.isNotEmpty &&
                                    _dbController.text.isNotEmpty &&
                                    _devController.text.isNotEmpty &&
                                    _debugController.text.isNotEmpty &&
                                    _testingController.text.isNotEmpty &&
                                    _trialController.text.isNotEmpty &&
                                    _liveController.text.isNotEmpty) {
                                  
                                  _formCubit.formVas(
                                    token: 'Bearer $token', 
                                    formBody: FormVasBody(
                                      status: 'Progress', 
                                      nomor: _nomorController.text,
                                      pengerjaan: _pengerjaan ?? '',
                                      diterimaOleh: _diterimaOlehController.text,
                                      disetujuiOleh: _disetujuiOlehController.text,
                                      catatan: _catatanController.text,
                                      wawancara: _wawancaraController.text,
                                      konfirmasiDesain: _konfirmasiDesainController.text,
                                      perancanganDatabase: _dbController.text,
                                      pengembanganSoftware: _devController.text,
                                      debugging: _debugController.text,
                                      testing: _testingController.text,
                                      trial: _trialController.text,
                                      production: _liveController.text, 
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(content: Text("Form harus diisi semua!", 
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),),
                                  ));
                                }
                              },

                              child: Text(
                                "KIRIM",
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
      labelStyle: GoogleFonts.urbanist(fontSize: 14, color: Colors.black),
      filled: true,
      fillColor: baseColors.secondaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10, // atur tinggi field
      ),
    );
  }
}
