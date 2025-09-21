import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;
import 'package:vas_reporting/screen/home/home_page.dart';

import '../../data/cubit/get_data/get_data_cubit.dart';
import '../../data/model/response/get_data_response.dart' as GetDataResponse;
import '../../tools/popup.dart';
import '../../tools/routing.dart';
import '../../utllis/app_shared_prefs.dart';
import '../ajuan/uji_home.dart';
import '../ajuan/vas_home.dart';
import '../login_page.dart';

class DrivePage extends StatefulWidget {
  const DrivePage({super.key});

  @override
  State<DrivePage> createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;
  String? name;
  String? divisi;
  String? jabatan;
  String? token;
  bool isLoading = false;

  List<GetDataResponse.Data> getData = [];
  List<GetDataResponse.Data> getDeadline = [];
  GetDataResponse.Data? deadline;

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

    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  List<String> folders = ["Daftar pengajuan", "Data VAS", "File approve"];
  String query = "";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final filtered = folders
        .where((f) => f.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                            name ?? "-",
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${jabatan ?? '-'} | ${divisi ?? '-'}",
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
                        divisi == 'VAS' && jabatan == 'Staff'
                            ?
                        ListTile(
                          leading: const Icon(IconlyLight.home),
                          title: Text(
                            "Home",
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushReplacement(routingPage(HomePage()));
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
                                  Navigator.of(
                                    context,
                                  ).pushReplacement(routingPage(DrivePage()));
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
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) {
                                setState(() {
                                  query = val;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "Search document",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () {
                        /*showModalBottomSheet(
                          context: context,
                          builder: (_) =>
                              const Center(child: Text("Filter Options")),
                        );*/
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 TabBar
            const TabBar(
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: "My Drive"),
                Tab(text: "Shared Drive"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildDriveGrid(filtered),
                  const Center(child: Text("Shared Drive Content")),
                ],
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              folders.add("Folder Baru ${folders.length + 1}");
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  static Widget _buildDriveGrid(List<String> items) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: items.map((title) => _buildFolderCard(title)).toList(),
      ),
    );
  }

  static Widget _buildFolderCard(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.folder, size: 40, color: Colors.deepOrange),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
