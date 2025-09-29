import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/pages/folder_page.dart';
import 'package:vas_reporting/screen/drive/template/drive_layout.dart';
import 'package:vas_reporting/screen/drive/template/animated_fab.dart';
import 'package:vas_reporting/screen/drive/template/sort_and_layout_option.dart';
import 'package:vas_reporting/screen/drive/tools/drive_routing.dart';
import 'package:vas_reporting/screen/drive/tools/tab_page_wrapper.dart';

import 'folder_model.dart';

class DriveHome extends StatefulWidget {
  const DriveHome({super.key});

  @override
  State<DriveHome> createState() => _DriveHomeState();
}

class _DriveHomeState extends State<DriveHome> {
  final TextEditingController _searchController = TextEditingController();
  SortOption currentSort = SortOption.nameAsc;
  ViewOption currentView = ViewOption.grid;
  String query = "";
  int _selectedIndex = 0;
  List<FolderModel> folders = [];
  bool isLoading = false;

  Future<void> fetchDummyData() async {
    final String response = await rootBundle.loadString(
      'assets/dummy_folders.json',
    );
    final List<dynamic> jsonData = jsonDecode(response);
    final fetchedFolders = jsonData
        .map((e) => FolderModel.fromJson(e))
        .toList();
    setState(() => folders = fetchedFolders);
  }

  @override
  void initState() {
    super.initState();
    fetchDummyData();
  }

  List<FolderModel> getFilteredAndSortedFolders() {
    List<FolderModel> filtered = folders
        .where((f) => f.namaFolder.toLowerCase().contains(query.toLowerCase()))
        .toList();
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

  void _navigateToFolder(FolderModel folder) async {
    // Tunggu hasil yang dikembalikan oleh FolderPage, yang tipenya adalah ViewOption
    final result = await Navigator.of(context).push<ViewOption>(
      DriveRouting(
        page: FolderPage(initialFolder: folder, initialView: currentView),
      ),
    );

    // Jika ada hasil yang dikembalikan dan berbeda dari state saat ini, perbarui UI
    if (result != null && result != currentView) {
      setState(() {
        currentView = result;
      });
    }
  }

  List<FolderModel> _getAllItemsRecursive(List<FolderModel> folders) {
    List<FolderModel> allItems = [];
    for (var folder in folders) {
      // Tambahkan folder itu sendiri
      allItems.add(folder);
      // Jika punya anak, tambahkan juga semua anaknya secara rekursif
      if (folder.children.isNotEmpty) {
        allItems.addAll(_getAllItemsRecursive(folder.children));
      }
    }
    return allItems;
  }

  Widget buildDriveGrid(List<FolderModel> items) {
    return DriveGrid(
      items: items.map((f) => f.namaFolder).toList(),
      isList: currentView == ViewOption.list,
      onFolderTap: (folderName) {
        final tapped = items.firstWhere((f) => f.namaFolder == folderName);
        // Panggil fungsi baru di sini
        _navigateToFolder(tapped);
      },
    );
  }

  Widget _buildDriveHomePage() {
    final items = getFilteredAndSortedFolders();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // AppBar Anda yang sudah ada sebelumnya
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => query = val),
                    style: GoogleFonts.urbanist(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Search Document",
                      filled: true,
                      fillColor: Colors.red[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(Icons.search, color: Colors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(IconlyBold.filter, color: Colors.orange),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'date',
                      child: Text(
                        "Sort by Date",
                        style: GoogleFonts.urbanist(fontSize: 14),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'name',
                      child: Text(
                        "Sort by Name",
                        style: GoogleFonts.urbanist(fontSize: 14),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'type',
                      child: Text(
                        "Sort by Type",
                        style: GoogleFonts.urbanist(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Pindahkan TabBar ke bottom properti dari AppBar
          bottom: const TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: "My Drive"),
              Tab(text: "Shared Drive"),
            ],
          ),
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
              onSortChanged: (sort) => setState(() => currentSort = sort),
              onViewChanged: (view) => setState(() => currentView = view),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildDriveGrid(items),
                  const Center(child: Text("Shared Drive Content")),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: AnimatedFabMenu(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allItems = _getAllItemsRecursive(folders);
    allItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final recentFolder = FolderModel(
      id: -1,
      namaFolder: "Berkas Terbaru",
      createdAt: DateTime.now(),
      children: allItems,
      isSpecial: true,
    );
    final starredFolder = FolderModel(
      id: -2,
      namaFolder: "Berbintang",
      createdAt: DateTime.now(),
      children: allItems.take(5).toList(),
      isSpecial: true,
    );
    final trashFolder = FolderModel(
      id: -3,
      namaFolder: "Sampah",
      createdAt: DateTime.now(),
      children: allItems.skip(5).toList(),
      isSpecial: true,
    );

    final pages = [
      _buildDriveHomePage(), // ini akan rebuild sesuai currentView
      TabPageWrapper(
        rootFolder: recentFolder,
        initialView: currentView,
        onRootPop: () => setState(() => _selectedIndex = 0),
      ),
      TabPageWrapper(
        rootFolder: starredFolder,
        initialView: currentView,
        onRootPop: () => setState(() => _selectedIndex = 0),
      ),
      TabPageWrapper(
        rootFolder: trashFolder,
        initialView: currentView,
        onRootPop: () => setState(() => _selectedIndex = 0),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black54,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Drive Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Berkas Terbaru",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: "Berbintang",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline),
            label: "Sampah",
          ),
        ],
      ),
    );
  }
}
