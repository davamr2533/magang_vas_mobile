import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/data/cubit/get_data/get_data_cubit.dart';
import 'package:vas_reporting/data/model/body/approval_body.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart' as GetDataResponse;
import 'package:vas_reporting/base/base_colors.dart' as baseColors;
import 'package:vas_reporting/screen/ajuan/form_ajuan_vas.dart';
import 'package:vas_reporting/screen/ajuan/vas_home.dart';
import 'package:vas_reporting/screen/home/home_page.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/popup.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';

class ApprovalManager extends StatefulWidget {
  const ApprovalManager({super.key});

  @override
  State<ApprovalManager> createState() => _ApprovalManagerState();
}

class _ApprovalManagerState extends State<ApprovalManager> {
  String? token;
  String? nama;
  bool _isLoading = false;
  List<GetDataResponse.Data> getDataList = [];

  late GetDataCubit _getDataCubit;
  late PopUpWidget popUpWidget;

  @override
  void initState() {
    super.initState();
    _getDataCubit = context.read<GetDataCubit>();
    popUpWidget = PopUpWidget(context);
    fetchData();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    nama = await SharedPref.getName();
    _getDataCubit.getAllData(token: 'Bearer $token');
    
  }

  Widget informationPopup(String key, String value, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth,
            child: Text(
              '${key}',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              ': ${value}',
              style: GoogleFonts.urbanist(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<GetDataCubit, GetDataHasState>(
      listener: (context, state) {
        if (state is GetDataLoading) {
          setState(() {
            _isLoading = true;
          });
        }
        if (state is ApprovalLoading) {
          setState(() {
            _isLoading = true;
          });
        }
        if (state is ApprovalSuucess) {
          setState(() {
            _isLoading = false;
          });
            Navigator.pop(context);
            popUpWidget.showAlert('Success', '${state.response.message}', true, 'OK', ApprovalManager());
        }
        if (state is ApprovalFailure) {
          setState(() {
            _isLoading = false;
          });
            popUpWidget.showAlert('Failed', '${state.message}', true, 'OK', ApprovalManager());
        }
        if (state is GetDataFailure) {
          setState(() {
            _isLoading = false;
          });
            Navigator.pop(context);
            popUpWidget.showAlert('Failed', '${state.message}', true, 'OK', ApprovalManager());
        }
        if (state is GetDataSuccess) {
          setState(() {
            _isLoading = false;
          });
          getDataList = state.response.data
          ?.where((item) => item.statusAjuan == 'Submitted')
          .toList() ?? [];
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(routingPage(HomePage()));
          }, 
          icon: Icon(Icons.arrow_back_ios_new), color: Colors.black,),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text("Approval Submission"),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: 
          _isLoading
            ?  AppWidget().LoadingWidget()
            : (getDataList == null || getDataList.isEmpty)
                ? Center(
            child: Text(
              'No data available',
              style: GoogleFonts.urbanist(fontSize: 14, color: Colors.black),
            ),
          )
        : ListView.builder(
            itemCount: getDataList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timelapse_outlined, color: baseColors.primaryColor, size: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${getDataList[index].sistem ?? 'Unknown System'}',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 1, 46, 82),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${getDataList[index].divisi ?? 'Unknown System'}',
                                style: GoogleFonts.urbanist(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {
                        popUpWidget.showAlertWidgetApproval(
                          'Detail Submission',
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              informationPopup('Tanggal Pengajuan', getDataList[index].createdAt ?? '-', screenWidth/4),
                              informationPopup('Nomor Pengajuan', getDataList[index].nomorPengajuan ?? '-', screenWidth/4),
                              informationPopup('Nama Pemohon', getDataList[index].namaPemohon ?? '-',screenWidth/4),
                              informationPopup('Divisi', getDataList[index].divisi ?? '-',screenWidth/4),
                              informationPopup('Sistem', getDataList[index].sistem ?? '-',screenWidth/4),
                              informationPopup('Jenis', getDataList[index].jenis ?? '-',screenWidth/4),
                              informationPopup('Rencana Anggaran', getDataList[index].rencanaAnggaran ?? '-',screenWidth/4),
                              informationPopup('Masalah', getDataList[index].masalah ?? '-',screenWidth/4),
                              informationPopup('Output', getDataList[index].output ?? '-',screenWidth/4),
                              SizedBox(height: 10),
                              Text(
                                'Apakah anda menyetujui pengajuan ini?',
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red,
                                ),
                              ),
                            ]),
                            CupertinoDialogAction(
                            child: Text('Tolak',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w500
                            ),
                            ),
                            onPressed: ()  async {
                              _getDataCubit.approval(
                                token: 'Bearer $token',
                                body: ApprovalBody(
                                  id: getDataList[index].id.toString(),
                                  status: 'Declined',
                                  nama: nama
                                )
                              );
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text('Setujui',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500
                            ),
                            ),
                            onPressed: () async {
                              _getDataCubit.approval(
                                token: 'Bearer $token',
                                body: ApprovalBody(
                                  id: getDataList[index].id.toString(),
                                  status: 'Approve',
                                  nama: nama
                                )
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: baseColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Details',
                          style: GoogleFonts.urbanist(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
