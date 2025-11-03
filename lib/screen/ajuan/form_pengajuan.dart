import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;
import 'package:vas_reporting/data/cubit/form/form_cubit.dart';
import 'package:vas_reporting/data/model/body/form_ajuan_body.dart';
import 'package:vas_reporting/screen/home/home_page.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/popup.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';

class FormAjuanUser extends StatefulWidget {
  const FormAjuanUser({super.key});

  @override
  State<FormAjuanUser> createState() => _FormAjuanUserState();
}

class _FormAjuanUserState extends State<FormAjuanUser> {

  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController _sistemController = TextEditingController();
  final TextEditingController _masalahController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  String? _jenis;
  String? _rencanaAnggaran;
  String? nama;
  String? divisi;
  String? token;
  String? formattedDate;
  bool _isLoading = false;

  late FormCubit formCubit;
  late PopUpWidget popUpWidget;
  
  @override
  void initState() {
    super.initState();
    formCubit = context.read<FormCubit>();
    popUpWidget = PopUpWidget(context);
    getData();
    formattedDate =
        DateFormat("d MMMM yyyy").format(DateTime.now());
        print(formattedDate);
  }

  void getData() async {
    print('test');
    nama = await SharedPref.getName();
    token = await SharedPref.getToken();
    divisi = await SharedPref.getDivisi();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 90, left: 20, right: 16, bottom: 10),
              height: screenHeight/2,
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
                            ).pushReplacement(routingPage(HomePage()));
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
                            fontWeight: FontWeight.bold
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
                    margin: EdgeInsets.only(top: screenHeight/7),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                          "Diisi Oleh Pemohon",
                          style: GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 16),
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
                          controller: _sistemController,
                          style: GoogleFonts.urbanist( 
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: _inputDecoration("Sistem"),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _jenis,
                          items:  [
                            DropdownMenuItem(
                              value: "Sistem Baru",
                              child: Text("Sistem Baru",
                              style: GoogleFonts.urbanist(color: Colors.black, fontSize: 16),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Pengembangan",
                              child: Text("Pengembangan",
                              style: GoogleFonts.urbanist(color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() => _jenis = val),
                          decoration: InputDecoration(
                            labelText: "Jenis",
                            labelStyle: GoogleFonts.urbanist(color: Colors.black, fontSize: 16),
                            filled: true,
                            fillColor: baseColors.secondaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20), 
                              borderSide: BorderSide.none, 
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          dropdownColor: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),     
                        ),
                        const SizedBox(height: 16),
                        
                        DropdownButtonFormField<String>(
                          value: _rencanaAnggaran,
                          items:  [
                            DropdownMenuItem(
                              value: "Termasuk dalam perencanaan",
                              child: Text("Termasuk dalam perencanaan",
                              style: GoogleFonts.urbanist(color: Colors.black, fontSize: 16),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Diluar perencanaan",
                              child: Text("Diluar perencanaan", 
                              style: GoogleFonts.urbanist(color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() => _rencanaAnggaran = val),
                          decoration: InputDecoration(
                            labelText: "Rencana Anggaran",
                            labelStyle: GoogleFonts.urbanist(color: Colors.black, fontSize: 16),
                            filled: true,
                            fillColor: baseColors.secondaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20), 
                              borderSide: BorderSide.none, 
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          dropdownColor: Colors.white,
                          focusColor: baseColors.secondaryColor,
                          borderRadius: BorderRadius.circular(20),     
                        ),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _masalahController,
                          maxLines: 5,
                          style: GoogleFonts.urbanist( 
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: _inputDecoration("Masalah"),
                        ),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _outputController,
                          maxLines: 5,
                          style: GoogleFonts.urbanist( 
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: _inputDecoration("Output"),
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<FormCubit, FormHasState>(
                          builder: (context, state) {
                            if (state is FormLoading) {
                              return AppWidget().LoadingWidget();
                            } 
                            if (state is FormFailure) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                return popUpWidget.showAlert('Failed', state.message, false,'', FormAjuanUser());
                              });
                            } if (state is FormResponseSuccess) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                 popUpWidget.showAlert('Success', state.response.message ?? "", false,'', HomePage());
                                Future.delayed(Duration(seconds: 3), () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    routingPage(HomePage() ),
                                    (Route<dynamic> route) => false,
                                  );
                                });
                              });
                            }
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: baseColors.primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  if ( _jenis == null || _sistemController.text.isEmpty || _masalahController.text.isEmpty || _outputController.text.isEmpty || _rencanaAnggaran == null ) {
                                    popUpWidget.showAlert('Failed', 'Form tidak boleh kosong', true, '', FormAjuanUser());
                                    return;
                                  }
                                  formCubit.form(
                                    token : 'Bearer $token',
                                    formBody: FormAjuanBody(
                                      nama: nama,
                                      divisi: divisi,
                                      sistem: _jenis,
                                      jenis: _sistemController.text,
                                      anggaran: _rencanaAnggaran,
                                      masalah: _masalahController.text,
                                      output: _outputController.text, 
                                    ),
                                  );
                                },
                                child: _isLoading
                                ? const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 235, 121, 97),
                                )
                                : Text(
                                  "Submit",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.urbanist( 
        fontSize: 16,
        color: Colors.black,
      ),
      filled: true,
      fillColor: baseColors.secondaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }
}