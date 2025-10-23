import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/drive/pages/folder_page.dart';
import 'package:vas_reporting/screen/drive/template/drive_layout.dart';
import 'package:vas_reporting/screen/drive/template/animated_fab.dart';
import 'package:vas_reporting/screen/drive/template/sort_and_layout_option.dart';
import 'package:vas_reporting/screen/drive/tools/drive_routing.dart';
import 'package:vas_reporting/screen/drive/tools/tab_page_wrapper.dart';

import '../../tools/loading.dart';
import '../../utllis/app_shared_prefs.dart';
import 'data/cubit/get_drive_cubit.dart';
import 'data/model/response/get_data_drive_response.dart';
import 'folder_model.dart';

class DriveHome extends StatefulWidget {
  const DriveHome({super.key});

  @override
  State<DriveHome> createState() => _DriveHomeState();
}

class _DriveHomeState extends State<DriveHome>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  SortOption currentSort = SortOption.nameAsc;
  ViewOption currentView = ViewOption.grid;
  String query = "";
  int _selectedIndex = 0;
  String? token;
  String? userId;

  late TabController _tabController;
  int parentId = 1; // Default ke My Drive

  late DriveCubit getDriveData;

  @override
  void initState() {
    super.initState();
    getDriveData = context.read<DriveCubit>();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {
        parentId = _tabController.index == 0 ? 1 : 2;
      });
    });

    fetchData();
  }

  Future<void> fetchData() async {
    token = await SharedPref.getToken();
    userId = await SharedPref.getUsername();
    if (!mounted) return;
    await getDriveData.getDriveData(token: 'Bearer $token');
    if (!mounted) return;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<FolderModel> getFilteredAndSortedFolders(
      List<FolderModel> sourceFolders,
      ) {
    List<FolderModel> filtered = sourceFolders
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
    if (!mounted) return;
    final result = await Navigator.of(context).push<ViewOption>(
      DriveRouting(
        page: FolderPage(initialFolder: folder, initialView: currentView),
      ),
    );

    if (!mounted) return;
    if (result != null && result != currentView) {
      setState(() {
        currentView = result;
      });
    }
  }

  List<FolderModel> _getAllItemsRecursive(List<FolderModel> folders) {
    List<FolderModel> allItems = [];
    for (var folder in folders) {
      allItems.add(folder);
      if (folder.children.isNotEmpty) {
        allItems.addAll(_getAllItemsRecursive(folder.children));
      }
    }
    return allItems;
  }

  Widget buildDriveGrid(List<FolderModel> items) {
    return DriveGrid(
      items: items.map((f) => f.namaFolder).toList(),
      token: token!,
      userId: userId!,
      itemId: items.map((f) => f.id).toList(),
      isList: currentView == ViewOption.list,
      isStarred: items.map((f) => f.isStarred).toList(),
      onFolderTap: (folderName) {
        final tapped = items.firstWhere((f) => f.namaFolder == folderName);
        _navigateToFolder(tapped);
      }, name: ,
    );
  }

  Widget _buildDriveHomePage(
      List<FolderModel> myDriveFolders,
      List<FolderModel> sharedDriveFolders,
      ) {
    final myDriveItems = getFilteredAndSortedFolders(myDriveFolders);

    return Scaffold(
      backgroundColor: magnoliaWhiteNewAmikom,
      appBar: AppBar(
        backgroundColor: magnoliaWhiteNewAmikom,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (mounted) Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    if (mounted) setState(() => query = val);
                  },
                  style: GoogleFonts.urbanist(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Search Document",
                    hintStyle: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: pinkNewAmikom,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon:
                    const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: pinkNewAmikom,
                borderRadius: BorderRadius.circular(8),
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(IconlyBold.filter, color: orangeNewAmikom),
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: orangeNewAmikom,
          indicatorColor: orangeNewAmikom,
          unselectedLabelColor: Colors.black,
          labelStyle: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
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
            onSortChanged: (sort) {
              if (mounted) setState(() => currentSort = sort);
            },
            onViewChanged: (view) {
              if (mounted) setState(() => currentView = view);
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildDriveGrid(myDriveItems),
                buildDriveGrid(sharedDriveFolders),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFabMenu(
        parentId: parentId,
        onFolderCreated: () async {
          await fetchData(); // auto refresh folder list
        },
      ),

    );
  }

  List<FolderModel> _mapApiDataToUiModel(List<FolderItem> apiItems) {
    return apiItems.map((item) {
      return FolderModel(
        id: item.id ?? 0,
        namaFolder: item.name ?? 'Folder Tanpa Nama',
        createdAt: item.createdAt != null
            ? DateTime.parse(item.createdAt!)
            : DateTime.now(),
        isStarred: item.isStarred == 'TRUE',
        children:
        item.children != null ? _mapApiDataToUiModel(item.children!) : [],
        isSpecial: false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriveCubit, DriveState>(
      builder: (context, state) {
        if (state is DriveInitial || state is DriveLoading) {
          return Center(child: AppWidget().LoadingWidget());
        }

        if (state is DriveDataFailure) {
          return Center(
            child: Text(
              'Gagal memuat data: ${state.message}',
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state is DriveDataSuccess) {
          final apiData = state.driveData.data ?? [];

          final myDriveApiItems = apiData
              .firstWhere(
                (i) => i.name == 'My Drive',
            orElse: () => FolderItem(),
          )
              .children ??
              [];
          final sharedDriveApiItems = apiData
              .firstWhere(
                (i) => i.name == 'Shared Drive',
            orElse: () => FolderItem(),
          )
              .children ??
              [];

          final myDriveFolders = _mapApiDataToUiModel(myDriveApiItems);
          final sharedDriveFolders = _mapApiDataToUiModel(sharedDriveApiItems);
          final allFolders = [...myDriveFolders, ...sharedDriveFolders];

          final allItems = _getAllItemsRecursive(allFolders);
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
            children: allItems.where((f) => f.isStarred).toList(),
            isSpecial: true,
          );

          final trashFolder = FolderModel(
            id: -3,
            namaFolder: "Sampah",
            createdAt: DateTime.now(),
            children: allItems.where((f) => f.isSpecial).toList(),
            isSpecial: true,
          );

          final pages = [
            _buildDriveHomePage(myDriveFolders, sharedDriveFolders),
            TabPageWrapper(
              rootFolder: recentFolder,
              initialView: currentView,
              onRootPop: () {
                if (mounted) setState(() => _selectedIndex = 0);
              },
            ),
            TabPageWrapper(
              rootFolder: starredFolder,
              initialView: currentView,
              onRootPop: () {
                if (mounted) setState(() => _selectedIndex = 0);
              },
            ),
            TabPageWrapper(
              rootFolder: trashFolder,
              initialView: currentView,
              onRootPop: () {
                if (mounted) setState(() => _selectedIndex = 0);
              },
            ),
          ];

          return Scaffold(
            body: IndexedStack(index: _selectedIndex, children: pages),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              backgroundColor: mistyRoseNewAmikom,
              selectedItemColor: orangeNewAmikom,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.black54,
              selectedLabelStyle: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.urbanist(),
              onTap: (index) {
                if (mounted) setState(() => _selectedIndex = index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "Drive Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_time),
                  label: "Terbaru",
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

        return const Scaffold(
          body: Center(child: Text("State tidak valid")),
        );
      },
    );
  }
}
