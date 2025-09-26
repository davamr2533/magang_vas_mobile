import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/drive/pages/folder_page.dart';
import 'package:vas_reporting/screen/drive/template/drive_layout.dart';
import 'package:vas_reporting/screen/drive/template/animated_fab.dart';
import 'package:vas_reporting/screen/drive/template/sort_and_layout_option.dart';
import 'package:vas_reporting/tools/routing.dart';

import '../../data/cubit/get_data/get_data_cubit.dart';
import '../../data/model/response/get_data_response.dart' as GetDataResponse;
import '../../tools/popup.dart';
import '../../utllis/app_shared_prefs.dart';
import '../home/list_ajuan.dart';
import '../home/reporting.dart';
import 'folder_model.dart';

/// Halaman utama Drive (berisi daftar folder, navigasi bawah, dan tab My Drive/Shared Drive).
class DriveHome extends StatefulWidget {
  const DriveHome({super.key});

  @override
  State<DriveHome> createState() => _DriveHomeState();
}

class _DriveHomeState extends State<DriveHome> {
  // <<====== CONTROLLER ======>>
  final TextEditingController _searchController = TextEditingController();

  // <<====== SORT & VIEW OPTION ======>>
  SortOption currentSort = SortOption.nameAsc;
  ViewOption currentView = ViewOption.grid;

  // <<====== NAVIGATION & STATUS ======>>
  int _selectedIndex = 0; // index bottom nav
  String query = ""; // pencarian
  bool isLoading = false; // loading state

  // <<====== STYLE ======>>
  TextStyle style = GoogleFonts.urbanist(fontSize: 14);

  // <<====== DATA ======>>
  List<GetDataResponse.Data> getData = [];
  List<GetDataResponse.Data> getDeadline = [];
  List<FolderModel> folders = [];
  GetDataResponse.Data? deadline;

  late GetDataCubit getDataCubit;
  late PopUpWidget popUpWidget;

  // <<====== INIT STATE ======>>
  @override
  void initState() {
    super.initState();
    fetchDummyData(); // load data dummy saat pertama kali dibuka
  }

  // <<====== FETCH DATA DUMMY ======>>
  Future<void> fetchDummyData() async {
    const dummyJson = '''
    [
      {"id": 1, "namaFolder": "Daftar pengajuan VAS", "createdAt": "2025-09-01"},
      {"id": 2, "namaFolder": "Data VAS", "createdAt": "2025-09-10"},
      {"id": 3, "namaFolder": "File Approve", "createdAt": "2025-09-15"},
      {"id": 4, "namaFolder": "Dokumen HR", "createdAt": "2025-09-20"}
    ]
    ''';

    final List<dynamic> jsonData = jsonDecode(dummyJson);
    final fetchedFolders =
    jsonData.map((e) => FolderModel.fromJson(e)).toList();

    setState(() {
      folders = fetchedFolders;
      isLoading = false;
    });
  }

  // <<====== BUILD UI ======>>
  @override
  Widget build(BuildContext context) {
    // Daftar halaman bottom navigation
    final List<Widget> pages = [
      _driveContent(),
      const FolderPage(folderName: "Berkas Terbaru", canBack: false, canUpload: false),
      const FolderPage(folderName: "Berbintang", canBack: false, canUpload: false),
      const FolderPage(folderName: "Sampah", canBack: false, canUpload: false),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),

      // <<====== BOTTOM NAVIGATION ======>>
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Debug print saat pindah menu
          if (index == 0) {
            print("Buka Drive Home");
          } else if (index == 1) {
            print("Buka Berkas Terbaru");
          } else if (index == 2) {
            print("Buka Berbintang");
          } else if (index == 3) {
            print("Buka Sampah");
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Drive Home"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Berkas Terbaru"),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: "Berbintang"),
          BottomNavigationBarItem(icon: Icon(Icons.delete_outline), label: "Sampah"),
        ],
      ),
    );
  }

  // <<====== DRIVE CONTENT (UI) ======>>
  Widget _driveContent() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () => Navigator.pop(context), // kembali ke halaman sebelumnya
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),

        // <<====== APPBAR: SEARCH + FILTER ======>>
        title: Row(
          children: [
            // Search bar
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  style: GoogleFonts.urbanist(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Search Document",
                    hintStyle: GoogleFonts.urbanist(fontSize: 14),
                    filled: true,
                    fillColor: Colors.red[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Tombol filter (popup menu)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: PopupMenuButton<String>(
                  icon: const Icon(IconlyBold.filter, color: orangeNewAmikom),
                  onSelected: (value) {
                    if (value == 'date') {
                      print("Filter by Date");
                    } else if (value == 'name') {
                      print("Filter by Name");
                    } else if (value == 'type') {
                      print("Filter by Type");
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'date', child: Text("Sort by Date", style: GoogleFonts.urbanist(fontSize: 14))),
                    PopupMenuItem(value: 'name', child: Text("Sort by Name", style: GoogleFonts.urbanist(fontSize: 14))),
                    PopupMenuItem(value: 'type', child: Text("Sort by File Type", style: GoogleFonts.urbanist(fontSize: 14))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // <<====== TAB MENU ======>>
            const TabBar(
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: "My Drive"),
                Tab(text: "Shared Drive"),
              ],
            ),

            // <<====== SORT & VIEW OPTION ======>>
            SortAndViewOption(
              currentSort: currentSort,
              currentView: currentView,
              style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold),
              onSortChanged: (sort) => setState(() => currentSort = sort),
              onViewChanged: (view) => setState(() => currentView = view),
            ),

            // <<====== TAB CONTENT ======>>
            Expanded(
              child: TabBarView(
                children: [
                  Builder(
                    builder: (context) {
                      final items = getFilteredAndSortedFolders();

                      // Grid view
                      if (currentView == ViewOption.grid) {
                        return DriveGrid(
                          items: items.map((f) => f.namaFolder).toList(),
                          isList: false,
                          onFolderTap: (folderName) {
                            Navigator.of(context).push(routingPage(FolderPage(folderName: folderName)));
                          },
                        );
                      }
                      // List view
                      else {
                        return DriveGrid(
                          items: items.map((f) => f.namaFolder).toList(),
                          isList: true,
                          onFolderTap: (folderName) {
                            Navigator.of(context).push(routingPage(FolderPage(folderName: folderName)));
                          },
                        );
                      }
                    },
                  ),
                  const Center(child: Text("Shared Drive Content")),
                ],
              ),
            ),
          ],
        ),
      ),

      // <<====== FLOATING ACTION BUTTON ======>>
      floatingActionButton: AnimatedFabMenu(),
    );
  }

  // <<====== FILTER & SORT FOLDER ======>>
  List<FolderModel> getFilteredAndSortedFolders() {
    // Filter
    List<FolderModel> filtered = folders
        .where((f) => f.namaFolder.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Sort
    switch (currentSort) {
      case SortOption.nameAsc:
        filtered.sort((a, b) => a.namaFolder.compareTo(b.namaFolder));
        break;
      case SortOption.nameDesc:
        filtered.sort((a, b) => b.namaFolder.compareTo(a.namaFolder));
        break;
      case SortOption.date:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return filtered;
  }
}
