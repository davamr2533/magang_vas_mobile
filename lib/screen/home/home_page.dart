import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vas_reporting/data/cubit/get_data/get_data_cubit.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart'
    as GetDataResponse;
import 'package:vas_reporting/data/model/response/get_data_vas_response.dart'
    as GetDataVasResponse;
import 'package:vas_reporting/screen/ajuan/approval_manager.dart';
import 'package:vas_reporting/screen/ajuan/form_pengajuan.dart';
import 'package:vas_reporting/screen/ajuan/uji_home.dart';
import 'package:vas_reporting/screen/ajuan/vas_home.dart';
import 'package:vas_reporting/screen/drive/drive_home.dart';
import 'package:vas_reporting/screen/home/reporting.dart';
import 'package:vas_reporting/screen/login_page.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/task_track_user/track_user_page.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_page.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';
import 'package:vas_reporting/tools/popup.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import 'list_ajuan.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? name;
  String? divisi;
  String? jabatan;
  String? token;
  bool isLoading = false;

  List<GetDataResponse.Data> getData = [];
  List<GetDataVasResponse.Data> getDeadline = [];
  GetDataVasResponse.Data? deadline;

  late GetDataCubit getDataCubit;
  late PopUpWidget popUpWidget;

  @override
  void initState() {
    super.initState();
    getDataCubit = context.read<GetDataCubit>();
    fetchData();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    name = await SharedPref.getName();
    divisi = await SharedPref.getDivisi();
    jabatan = await SharedPref.getPosition();
    await getDataCubit.getAllData(token: 'Bearer ${token}');
    await getDataCubit.getDataVas(token: 'Bearer ${token}');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final List<Widget> pages = [
      _homeContent(),
      const MyTaskPage(),
      const AttendancePage(),
    ];

    return Scaffold(
      drawer: Drawer(
        width: screenWidth / 1.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            Container(
              padding: EdgeInsets.only(top: screenHeight / 11),
              child: Row(
                children: [
                  CircleAvatar(radius: 30, child: Icon(IconlyBold.user2)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${name}",
                          style: GoogleFonts.urbanist(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${jabatan} | ${divisi}",
                          style: GoogleFonts.urbanist(
                            color: baseColors.primaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 10),
              height: 1,
              color: Colors.grey,
            ),
            Container(
              height: screenHeight / 1.35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      divisi != 'VAS'
                          ? ListTile(
                              leading: const Icon(IconlyLight.paperUpload),
                              title: Text(
                                "Form Pengajuan",
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormAjuanUser(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            )
                          : SizedBox(),
                      divisi == 'VAS' && jabatan == 'Staff'
                          ? ListTile(
                              leading: const Icon(IconlyLight.edit),
                              title: Text(
                                "Pengajuan VAS",
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushReplacement(routingPage(VasHome()));
                              },
                            )
                          : SizedBox(),

                      //Task Tracker VAS navigation
                      divisi == 'VAS' && jabatan == 'Staff'
                          ? ListTile(
                        leading: const Icon(IconlyLight.document),
                        title: Text(
                          "Task Tracker",
                          style: GoogleFonts.urbanist(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            routingPage(
                              BlocProvider(
                                create: (context) => TaskTrackCubit(TaskTrackService()),
                                child: TrackVasPage(),
                              ),
                            )
                          );
                        },
                      )
                          : SizedBox(),

                      divisi == 'VAS' && jabatan == 'Staff'
                          ? ListTile(
                              leading: const Icon(IconlyLight.folder),
                              title: Text(
                                "VAS Drive",
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  routingPage(DriveHome()),
                                );
                              },
                            )
                          : SizedBox(),



                      jabatan != 'Manager' && divisi != 'VAS'
                          ? ListTile(
                              leading: const Icon(IconlyLight.activity),
                              title: Text(
                                "Pengujian",
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushReplacement(routingPage(UjiHome()));
                              },
                            )
                          : SizedBox(),


                      //Task Tracker User Navigation
                      jabatan != 'Manager' && divisi != 'VAS'
                          ? ListTile(
                        leading: const Icon(IconlyLight.document),
                        title: Text(
                          "Task Tracker",
                          style: GoogleFonts.urbanist(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),

                        onTap: () {
                          Navigator.of(context).push(
                            routingPage(
                              BlocProvider(
                                create: (context) => TaskTrackCubit(TaskTrackService()),
                                child: TrackUserPage(),
                              ),

                            ),
                          );
                        },
                      )



                          : SizedBox(),
                      divisi == 'VAS' && jabatan == 'Manager'
                          ? ListTile(
                              leading: const Icon(IconlyLight.shieldDone),
                              title: Text(
                                "Approval Submission",
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  routingPage(ApprovalManager()),
                                );
                              },
                            )
                          : SizedBox(),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(IconlyLight.logout),
                    title: Text(
                      "Logout",
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () async {
                      await SharedPref.clearLastLogin();
                      Navigator.of(
                        context,
                      ).pushReplacement(routingPage(LoginPage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedLabelStyle: GoogleFonts.urbanist(
          color: baseColors.primaryColor,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.urbanist(
          color: Colors.grey,
          fontSize: 10,
        ),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: baseColors.primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(IconlyLight.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.chart),
            label: "Summary",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.document),
            label: "Reporting",
          ),
        ],
      ),
    );
  }

  Widget _homeContent() {
    return BlocListener<GetDataCubit, GetDataHasState>(
      listener: (context, state) {
        if (state is GetDataLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is GetDataFailure) {
          setState(() {
            isLoading = false;
          });
        }
        if (state is GetDataVasSuccess) {
          getDeadline = state.response.data!;
          if (getDeadline.isEmpty) {
            getDeadline = [];
            print("Item terdekat: kosong");
          } else {
            final nearestIdx = getNearestIndex(getDeadline);
            if (nearestIdx != null) {
              deadline = getDeadline[nearestIdx];

            }
          }
        }

        if (state is GetDataSuccess) {
          // Parsing aman
          final List<GetDataResponse.Data> dataList = state.response.data ?? [];
          // debug log untuk verifikasi
          print("GetDataSuccess: total items from API = ${dataList.length}");

          // safe sort
          dataList.sort((a, b) {
            final dateA = tryParseDate(a.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
            final dateB = tryParseDate(b.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
            return dateB.compareTo(dateA);
          });

          setState(() {
            isLoading = false;
            getData = dataList;
            print("getData updated: length = ${getData.length}");
          });
        }


      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, size: 28),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Hi, ${name ?? ''}!",
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome!",
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("Let’s schedule your project."),
                          ],
                        ),
                      ),
                      Image.asset(
                        "assets/Home.png",
                        width: 140,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Summary",
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children:
                      [
                        gridView(
                          const Color.fromARGB(255, 186, 201, 255),
                          IconlyLight.timeCircle,
                          'Submitted',
                          'Menunggu Approval',
                          getData
                              .where((item) => item.statusAjuan == 'Submitted')
                              .length
                              .toString(),
                        ),
                        gridView(
                          const Color.fromARGB(255, 255, 228, 188),
                          IconlyLight.shieldDone,
                          'Approve',
                          'Pengajuan disetujui',
                          getData
                              .where((item) => item.statusAjuan == 'Approve')
                              .length
                              .toString(),
                        ),
                        gridView(
                          const Color.fromARGB(255, 181, 221, 154),
                          IconlyLight.activity,
                          'Progress',
                          'Progress oleh VAS',
                          getData
                              .where((item) => item.statusAjuan == 'Progress')
                              .length
                              .toString(),
                        ),
                        gridView(
                          const Color.fromARGB(255, 218, 196, 255),
                          IconlyLight.notification,
                          'Production',
                          'Tahap perilisan',
                          getData
                              .where((item) => item.statusAjuan == 'Production')
                              .length
                              .toString(),
                        ),
                        gridView(
                          const Color.fromARGB(255, 255, 201, 201),
                          IconlyLight.dangerCircle,
                          'Decline',
                          'Pengajuan ditolak',
                          getData
                              .where((item) => item.statusAjuan == 'Decline')
                              .length
                              .toString(),
                        ),
                      ].map((child) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        return SizedBox(
                          width:
                              (screenWidth - 45) /
                              3.2, // bagi 2, dikurangi spacing
                          child: child,
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Approaching deadline",
                //       style: GoogleFonts.urbanist(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16,
                //       ),
                //     ),
                //     Text(
                //       "See More",
                //       style: GoogleFonts.urbanist(color: baseColors.primaryColor),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 8),
                // Container(
                //   padding: const EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.1),
                //         blurRadius: 6,
                //         offset: Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "${deadline?.nomorPengajuan}",
                //         style: GoogleFonts.urbanist(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 14,
                //         ),
                //       ),
                //       SizedBox(height: 4),
                //       Row(
                //         children: [
                //           Icon(
                //             Icons.calendar_today,
                //             size: 14,
                //             color: Colors.blue,
                //           ),
                //           SizedBox(width: 4),
                //           Text("${getDeadline.length}"),
                //         ],
                //       ),
                //       SizedBox(height: 4),
                //       Text(
                //         "To take care every customer To Evening",
                //         style: GoogleFonts.urbanist(
                //           fontSize: 12,
                //           color: Colors.black54,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Submission",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: getData.take(3).map((item) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.sistem ?? 'Unknown',
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    item.jenis ?? 'Unknown',
                                    style: GoogleFonts.urbanist(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item.divisi ?? 'Unknown',
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item.nomorPengajuan ?? 'Unknown',
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
          ),
        ),
      ),
    );
  }

  Widget gridView(
    Color color,
    IconData icon,
    String status,
    String details,
    String count,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  details,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              count,
              style: GoogleFonts.urbanist(fontSize: 35, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  DateTime? tryParseDate(String? input) {
    if (input == null || input.isEmpty) return null;

    try {
      if (input.contains("-") && input.contains(":")) {
        return DateTime.parse(input);
      }
      if (input.contains("/")) {
        return DateFormat("dd/MM/yyyy").parse(input);
      }
      if (RegExp(r'^\d{1,2}-\d{1,2}-\d{4}$').hasMatch(input)) {
        return DateFormat("d-M-yyyy").parse(input);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  int? getNearestIndex(List<GetDataVasResponse.Data> getData) {
    final now = DateTime.now();
    int? nearestIndex;
    Duration? nearestDiff;

    for (var i = 0; i < getData.length; i++) {
      final item = getData[i];
      final tanggalStrings = [
        item.wawancara,
        item.konfirmasiDesain,
        item.perancanganDatabase,
        item.pengembanganSoftware,
        item.debugging,
        item.testing,
        item.trial,
        item.production,
        item.createdAt,
      ];

      for (var tglStr in tanggalStrings) {
        final date = tryParseDate(tglStr);
        if (date != null && date.isAfter(now)) {
          final diff = date.difference(now);
          if (nearestDiff == null || diff < nearestDiff) {
            nearestDiff = diff;
            nearestIndex = i;
          }
        }
      }
    }
    return nearestIndex;
  }
}
