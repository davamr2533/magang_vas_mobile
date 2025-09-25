import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/template/DriveGrid.dart';
import 'package:vas_reporting/screen/drive/template/sortAndViewBar.dart';

import '../../tools/routing.dart';
import 'folder_model.dart';

class FolderPage extends StatefulWidget {
  final String folderName;


  const FolderPage({super.key, required this.folderName});

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
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: Text(widget.folderName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SortAndViewBar(
            currentSort: currentSort,
            currentView: currentView,
            style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold),
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
                      Navigator.of(context).push(
                        routingPage(FolderPage(folderName: folderName)),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final folder = items[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.folder,
                          color: Colors.orange,
                        ),
                        title: Text(folder.namaFolder),
                        subtitle: Text("Created: ${folder.createdAt}"),
                        onTap: () {
                          Navigator.of(context).push(
                            routingPage(
                              FolderPage(folderName: folder.namaFolder),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            folders.add(
              FolderModel(
                id: folders.length + 1,
                namaFolder: "Folder Baru ${folders.length + 1}",
                createdAt: DateTime.now().toIso8601String(),
              ),
            );
          });
        },
        child: const Icon(Icons.add),
      ),
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

