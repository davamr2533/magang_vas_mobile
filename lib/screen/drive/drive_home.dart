import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/drive/folder_page.dart';
import 'package:vas_reporting/screen/drive/template/DriveGrid.dart';
import 'package:vas_reporting/tools/routing.dart';

import '../../data/cubit/get_data/get_data_cubit.dart';
import '../../data/model/response/get_data_response.dart' as GetDataResponse;
import '../../tools/popup.dart';
import '../../utllis/app_shared_prefs.dart';
import 'folder_model.dart';

class DriveHome extends StatefulWidget {
  const DriveHome({super.key});

  @override
  State<DriveHome> createState() => _DriveHomeState();
}

class _DriveHomeState extends State<DriveHome> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;
  String? name;
  String? divisi;
  String? jabatan;
  String? token;
  String query ="";
  bool isLoading = false;

  List<GetDataResponse.Data> getData = [];
  List<GetDataResponse.Data> getDeadline = [];
  List<FolderModel> folders =[];
  GetDataResponse.Data? deadline;

  late GetDataCubit getDataCubit;
  late PopUpWidget popUpWidget;

  @override
  void initState() {
    super.initState();
    fetchDummyData();
  }

  Future<void> fetchDummyData() async {

    // Dummy JSON
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

  @override
  Widget build(BuildContext context) {
    final filtered = folders
        .where((f) =>
        f.namaFolder.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //Navigasi kembali ke halaman sebelumnya
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),

          title: Row(
            children: [
              //Text field search document
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    style: GoogleFonts.urbanist(fontSize: 14),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),

                      hintText: "Search Document",
                      hintStyle: GoogleFonts.urbanist(fontSize: 14),
                      filled: true,
                      fillColor: Colors.red[100],

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),

                      //suffixIcon : Icon(IconlyLight.search)
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12),

              //Button untuk Settings filter
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
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'date', child: Text("Sort by Date")),
                      PopupMenuItem(value: 'name', child: Text("Sort by Name")),
                      PopupMenuItem(
                        value: 'type',
                        child: Text("Sort by File Type"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Expanded(
          //
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          //     padding: const EdgeInsets.symmetric(horizontal: 12),
          //     decoration: BoxDecoration(
          //       color: Colors.red[100],
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Row(
          //       children: [
          //
          //         //Text Field untuk Search Document
          //         const Icon(Icons.search, color: Colors.black54),
          //         Expanded(
          //           child: TextField(
          //             controller: _searchController,
          //             onChanged: (val) {
          //               setState(() {
          //                 query = val;
          //               });
          //             },
          //             decoration: const InputDecoration(
          //               hintText: "Search document",
          //               border: InputBorder.none,
          //             ),
          //           ),
          //         ),
          //
          //
          //
          //         SizedBox(width: 8),
          //
          //         Container(
          //           width: 50,
          //           decoration: BoxDecoration(
          //             color: greenNewAmikom
          //           ),
          //         )
          //
          //
          //         //Filter
          //         // Container(
          //         //   width: 50,
          //         //   decoration: BoxDecoration(
          //         //     color: Colors.red[100],
          //         //     borderRadius: BorderRadius.circular(12),
          //         //   ),
        ),
        body: Column(
          children: [
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
                  DriveGrid(
                    items: filtered.map((f) => f.namaFolder).toList(),
                    isList: false,
                    onFolderTap: (folderName) {
                      Navigator.of(context).push(
                        routingPage(FolderPage(folderName: folderName)),
                      );
                    },
                  ),
                  const Center(child: Text("Shared Drive Content")),
                ],
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              folders.add(FolderModel(
                id: folders.length + 1,
                namaFolder: "Folder Baru ${folders.length + 1}",
                createdAt: DateTime.now().toIso8601String(),
              ));
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
