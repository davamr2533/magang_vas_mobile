import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/template/drive_layout.dart';
import 'package:vas_reporting/screen/drive/template/animated_fab.dart';
import 'package:vas_reporting/screen/drive/template/sort_and_layout_option.dart';

import '../../../../tools/routing.dart';
import '../folder_model.dart';

class FolderPage extends StatefulWidget {
  final String folderName;
  final bool canBack;
  final bool canUpload;

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
  SortOption currentSort = SortOption.nameAsc;
  ViewOption currentView = ViewOption.grid;

  // int _selectedIndex = 0;
  // String? name;
  // String? divisi;
  // String? jabatan;
  // String? token;
  String query = "";
  bool isLoading = false;
  TextStyle style = GoogleFonts.urbanist(fontSize: 14);

  List<FolderModel> folders = [];

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
    final fetchedFolders = jsonData
        .map((e) => FolderModel.fromJson(e))
        .toList();

    setState(() {
      folders = fetchedFolders;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        leading: widget.canBack
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: Colors.black,
              )
            : null,

        title: Text(widget.folderName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SortAndViewOption(
            currentSort: currentSort,
            currentView: currentView,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            onSortChanged: (sort) {
              setState(() => currentSort = sort);
            },
            onViewChanged: (view) {
              setState(() => currentView = view);
            },
          ),

          Expanded(
            child: Builder(
              builder: (context) {
                final items = getFilteredAndSortedFolders();
                if (currentView == ViewOption.grid) {
                  return DriveGrid(
                    items: items.map((f) => f.namaFolder).toList(),
                    isList: false,
                    onFolderTap: (folderName) {
                      Navigator.of(
                        context,
                      ).push(routingPage(FolderPage(folderName: folderName)));
                    },
                  );
                } else {
                  return DriveGrid(
                    items: items.map((f) => f.namaFolder).toList(),
                    isList: true,
                    onFolderTap: (folderName) {
                      Navigator.of(
                        context,
                      ).push(routingPage(FolderPage(folderName: folderName)));
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.canUpload ? AnimatedFabMenu() : null,
    );
  }

  List<FolderModel> getFilteredAndSortedFolders() {
    // Filter dulu
    List<FolderModel> filtered = folders
        .where((f) => f.namaFolder.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Sort sesuai pilihan
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
