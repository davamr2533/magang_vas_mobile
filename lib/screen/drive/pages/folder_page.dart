import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/template/drive_layout.dart';
import 'package:vas_reporting/screen/drive/template/animated_fab.dart';
import 'package:vas_reporting/screen/drive/template/sort_and_layout_option.dart';

import '../../../../tools/routing.dart';
import '../folder_model.dart';

// <<====== FOLDER PAGE ======>>
class FolderPage extends StatefulWidget {
  final String folderName; // Nama folder yang sedang dibuka
  final bool canBack;      // Apakah tombol back ditampilkan
  final bool canUpload;    // Apakah tombol upload ditampilkan

  const FolderPage({
    super.key,
    required this.folderName,
    this.canBack = true,
    this.canUpload = true,
  });

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  // <<====== STATE ======>>
  SortOption currentSort = SortOption.nameAsc; // default sort: nama A-Z
  ViewOption currentView = ViewOption.grid;    // default view: grid

  String query = ""; // teks pencarian
  bool isLoading = false; // status loading
  TextStyle style = GoogleFonts.urbanist(fontSize: 14);

  // Data folder
  List<FolderModel> folders = [];

  // <<====== INIT STATE ======>>
  @override
  void initState() {
    super.initState();
    fetchDummyData(); // ambil data dummy
  }

  // <<====== FETCH DUMMY DATA ======>>
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
    return Scaffold(
      // <<====== APP BAR ======>>
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        leading: widget.canBack
            ? IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        )
            : null,
        title: Text(widget.folderName),
        centerTitle: true,
      ),

      // <<====== BODY ======>>
      body: Column(
        children: [
          // Sort & View Option (grid/list)
          SortAndViewOption(
            currentSort: currentSort,
            currentView: currentView,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            onSortChanged: (sort) => setState(() => currentSort = sort),
            onViewChanged: (view) => setState(() => currentView = view),
          ),

          // Daftar folder/file
          Expanded(
            child: Builder(
              builder: (context) {
                final items = getFilteredAndSortedFolders();

                // Grid view
                if (currentView == ViewOption.grid) {
                  return DriveGrid(
                    items: items.map((f) => f.namaFolder).toList(),
                    isList: false,
                    onFolderTap: (folderName) {
                      Navigator.of(context)
                          .push(routingPage(FolderPage(folderName: folderName)));
                    },
                  );
                }

                // List view
                else {
                  return DriveGrid(
                    items: items.map((f) => f.namaFolder).toList(),
                    isList: true,
                    onFolderTap: (folderName) {
                      Navigator.of(context)
                          .push(routingPage(FolderPage(folderName: folderName)));
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),

      // Floating Action Button (upload/tambah folder/file)
      floatingActionButton: widget.canUpload ? AnimatedFabMenu() : null,
    );
  }

  // <<====== FILTER & SORT ======>>
  List<FolderModel> getFilteredAndSortedFolders() {
    // Filter by query
    List<FolderModel> filtered = folders
        .where((f) => f.namaFolder.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Sorting
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
