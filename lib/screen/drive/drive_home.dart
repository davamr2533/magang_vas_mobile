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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //Navigasi kembali ke halaman sebelumnya
            },
            icon: Icon(Icons.arrow_back_ios_new), color: Colors.black,
          ),
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
                      onPressed: () => Navigator.pop(context),
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
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.tune),
                      onSelected: (value) {
                        if (value == 'date') {
                          // TODO: filter by date
                          print("Filter by Date");
                        } else if (value == 'name') {
                          // TODO: filter by name
                          print("Filter by Name");
                        } else if (value == 'type') {
                          // TODO: filter by type
                          print("Filter by Type");
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'date',
                          child: Text("Sort by Date"),
                        ),
                        const PopupMenuItem(
                          value: 'name',
                          child: Text("Sort by Name"),
                        ),
                        const PopupMenuItem(
                          value: 'type',
                          child: Text("Sort by File Type"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
                  _buildDriveGrid(context, filtered),
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

  Widget _buildDriveGrid(BuildContext context, List<String> items) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: items
            .map((title) => _buildFolderCard(context, title))
            .toList(),
      ),
    );
  }

  Widget _buildFolderCard(BuildContext context, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.folder, size: 40, color: Colors.deepOrange),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.drive_file_rename_outline),
                          title: const Text("Rename"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_outline),
                          title: const Text("Delete"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
