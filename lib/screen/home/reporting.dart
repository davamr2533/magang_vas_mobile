import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/data/cubit/form/form_cubit.dart';
import 'package:vas_reporting/data/cubit/get_data/get_data_cubit.dart';
import 'package:vas_reporting/data/model/response/get_data_uji_response.dart'
    as GetDataUjiResponse;
import 'package:vas_reporting/data/model/response/get_data_response.dart'
    as GetDataResponse;
import 'package:vas_reporting/data/model/response/get_data_vas_response.dart'
    as GetDataVasResponse;
import 'package:vas_reporting/screen/ajuan/vas_home.dart';
import 'package:vas_reporting/tools/loading.dart';
import 'package:vas_reporting/tools/popup.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      final token = await SharedPref.getToken();
      if (token != null) {
        context.read<GetDataCubit>().getAllData(token: 'Bearer $token');
      }
    });
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Reporting"),
          bottom: TabBar(
            indicatorColor: baseColors.primaryColor,
            labelColor: baseColors.primaryColor,
            labelStyle: GoogleFonts.urbanist(fontSize: 14),
            tabs: [
              Tab(text: "Pengajuan"),
              Tab(text: "VAS"),
              Tab(text: "Pengujian"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Weekly
            ReportingPengajuan(),
            // Monthly
            ReportingProgress(),
            // Yearly
            ReportingPengujian(),
          ],
        ),
      ),
    );
  }
}

class ReportingPengajuan extends StatefulWidget {
  const ReportingPengajuan({super.key});

  @override
  State<ReportingPengajuan> createState() => _ReportingPengajuanState();
}

class _ReportingPengajuanState extends State<ReportingPengajuan> {
  late GetDataCubit getDataCubit;
  late PopUpWidget popUpWidget;
  String? token;
  @override
  void initState() {
    super.initState();
    getDataCubit = context.read<GetDataCubit>();
    popUpWidget = PopUpWidget(context);
    fetchData();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    getDataCubit.getAllData(token: 'Bearer ${token ?? ""}');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<GetDataCubit, GetDataHasState>(
      builder: (context, state) {
        if (state is GetDataFailure) {
          return Text(state.message);
        }
        if (state is GetDataLoading) {
          return Center(child: AppWidget().LoadingWidget());
        }
        if (state is GetDataSuccess) {
          if (state.response.data == null || state.response.data!.isEmpty) {
            return Text('No data available');
          } else {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: baseColors.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Pengajuan",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${state.response.data?.length}",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.response.data?.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          popUpWidget.showAlertWidget(
                            'Detail Submission',
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                informationPopup(
                                  'Tanggal Pengajuan',
                                  state.response.data?[index].createdAt ?? '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Nomor Pengajuan',
                                  state.response.data?[index].nomorPengajuan ??
                                      '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Nama Pemohon',
                                  state.response.data?[index].namaPemohon ??
                                      '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Divisi',
                                  state.response.data?[index].divisi ?? '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Sistem',
                                  state.response.data?[index].sistem ?? '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Jenis',
                                  state.response.data?[index].jenis ?? '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Rencana Anggaran',
                                  state.response.data?[index].rencanaAnggaran ??
                                      '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Masalah',
                                  state.response.data?[index].masalah ?? '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Output',
                                  state.response.data?[index].output ?? '-',
                                  screenWidth / 4,
                                ),
                                informationPopup(
                                  'Approved by',
                                  state.response.data?[index].approvedBy ?? '-',
                                  screenWidth / 4,
                                ),
                              ],
                            ),
                            'OK',
                            '',
                            AttendancePage(),
                            SizedBox(),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: baseColors.primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.response.data?[index].sistem ??
                                            'Unknown',
                                        style: GoogleFonts.urbanist(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        state.response.data?[index].jenis ??
                                            'Unknown',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    state.response.data?[index].divisi ??
                                        'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    state
                                            .response
                                            .data?[index]
                                            .nomorPengajuan ??
                                        'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
        return SizedBox();
      },
    );
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
}

class ReportingProgress extends StatefulWidget {
  const ReportingProgress({super.key});

  @override
  State<ReportingProgress> createState() => _ReportingProgressState();
}

class _ReportingProgressState extends State<ReportingProgress> { //#############################################################################################
  late GetDataCubit getDataCubit;
  late PopUpWidget popUpWidget;
  String? token;
  List<GetDataResponse.Data> dataStatus = [];
  @override
  void initState() {
    getDataCubit = context.read<GetDataCubit>();
    popUpWidget = PopUpWidget(context);
    fetchData();
    super.initState();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    await getDataCubit.getAllData(token: 'Bearer ${token ?? ""}');
    await getDataCubit.getDataVas(token: 'Bearer ${token ?? ""}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDataCubit, GetDataHasState>(
      builder: (context, state) {
        if (state is GetDataVasFailure) {
          return Text(state.message);
        }
        if (state is GetDataLoading) {
          return Center(child: AppWidget().LoadingWidget());
        }
        if (state is GetDataVasSuccess) {
          if (state.response.data == null || state.response.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<GetDataVasResponse.Data> progressData = state.response.data!;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: baseColors.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Pengajuan yang diterima VAS",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${progressData.length}',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: progressData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: baseColors.primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nomor Pengajuan',
                                        style: GoogleFonts.urbanist(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Wawancara',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Konfirmasi desain',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Perancangan Database',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Pengembangan Software',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Debugging',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Testing',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Trial',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Production',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    state
                                            .response
                                            .data?[index]
                                            .nomorPengajuan ??
                                        'Unknown',
                                    style: GoogleFonts.urbanist(fontSize: 14),
                                  ),
                                  Text(
                                    progressData[index].wawancara ?? 'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    progressData[index].konfirmasiDesain ??
                                        'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    progressData[index].perancanganDatabase ??
                                        'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    progressData[index].pengembanganSoftware ??
                                        'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    progressData[index].debugging ?? 'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    progressData[index].perancanganDatabase ??
                                        'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    progressData[index].testing ?? 'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    progressData[index].trial ?? 'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    progressData[index].production ?? 'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: baseColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
        return SizedBox();
      },
    );
  }
}

class ReportingPengujian extends StatefulWidget {
  const ReportingPengujian({super.key});

  @override
  State<ReportingPengujian> createState() => _ReportingPengujianState();
}

class _ReportingPengujianState extends State<ReportingPengujian> {
  late GetDataCubit getDataCubit;
  String? token;
  List<GetDataResponse.Data> dataStatus = [];
  @override
  void initState() {
    getDataCubit = context.read<GetDataCubit>();
    fetchData();
    super.initState();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    getDataCubit.getDataUji(token: 'Bearer ${token ?? ""}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDataCubit, GetDataHasState>(
      builder: (context, state) {
        if (state is GetDataUjiFailure) {
          return Text(state.message);
        }
        if (state is GetDataLoading) {
          return Center(child: AppWidget().LoadingWidget());
        }
        if (state is GetDataUjiSuccess) {
          if (state.response.data == null || state.response.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: baseColors.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Aplikasi Pengujian",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${state.response.data!.length}',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.response.data!.length,
                    itemBuilder: (context, index) {
                      final pengajuan = state.response.data![index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nomor Pengujian',
                                  style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(color: Colors.black, height: 1),
                                Text(
                                  state.response.data?[index].nomorPengajuan ??
                                      'Unknown',
                                  style: GoogleFonts.urbanist(fontSize: 12),
                                ),
                              ],
                            ),
                            Column(
                              children: pengajuan.detail!.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Text(
                                              'Perangkat Lunak',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            e.perangkatLunak ?? 'Unknown',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: baseColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Text(
                                              'Versi',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            e.versi ?? 'Unknown',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: baseColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Text(
                                              'Metode',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            e.metode ?? 'Unknown',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: baseColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Text(
                                              'Hasil',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            e.hasilUji ?? 'Unknown',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: baseColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
        return SizedBox();
      },
    );
  }
}
