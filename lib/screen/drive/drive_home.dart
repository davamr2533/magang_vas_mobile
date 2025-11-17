import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/drive/pages/folder_page.dart';
import 'package:vas_reporting/screen/drive/template/custom_search_bar.dart';
import 'package:vas_reporting/screen/drive/template/drive_layout.dart';
import 'package:vas_reporting/screen/drive/template/animated_fab.dart';
import 'package:vas_reporting/screen/drive/template/sort_and_layout_option.dart';
import 'package:vas_reporting/screen/drive/tools/drive_routing.dart';
import 'package:vas_reporting/screen/drive/tools/tab_page_wrapper.dart';

import '../../tools/loading.dart';
import '../../utllis/app_shared_prefs.dart';
import 'data/cubit/get_drive_cubit.dart';
import 'data/model/response/get_data_drive_response.dart';
import 'drive_item_model.dart';

class DriveHome extends StatefulWidget {
  const DriveHome({super.key});

  @override
  State<DriveHome> createState() => _DriveHomeState();
}

class _DriveHomeState extends State<DriveHome>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  SortBy currentSortBy = SortBy.name;
  SortOrder currentSortOrder = SortOrder.asc;

  ViewOption currentView = ViewOption.grid;
  String query = "";
  String? selectedFileType;
  int _selectedIndex = 0;
  String? token;
  String? username;
  late TabController _tabController;
  int? parentId;
  int myDriveRootId = 1; // Default
  int sharedDriveRootId = 2; // Default
  final GlobalKey<CustomSearchBarState> _searchBarKey =
      GlobalKey<CustomSearchBarState>();

  late DriveCubit getDriveData;

  @override
  void initState() {
    super.initState();
    getDriveData = context.read<DriveCubit>();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          parentId = _tabController.index == 0
              ? myDriveRootId
              : sharedDriveRootId;
        });
      }
    });

    fetchData();
  }

  Future<void> fetchData() async {
    token = await SharedPref.getToken();
    username = await SharedPref.getUsername();
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

  void _navigateToFolder(DriveItemModel folder) async {
    if (!mounted) return;

    final result = await Navigator.of(context).push<ViewOption>(
      DriveRouting(
        page: FolderPage(
          key: ValueKey(folder.id),
          username: username!,
          initialFolder: folder,
          initialView: currentView,
          onUpdateChanged: fetchData,
          onRefresh: fetchData,
        ),
      ),
    );

    if (!mounted) return;
    if (result != null && result != currentView) {
      setState(() {
        currentView = result;
      });
    }
  }

  List<DriveItemModel> _getAllItemsRecursive(List<DriveItemModel> folders) {
    List<DriveItemModel> allItems = [];
    for (var folder in folders) {
      allItems.add(folder);
      if (folder.children.isNotEmpty) {
        allItems.addAll(_getAllItemsRecursive(folder.children));
      }
    }
    return allItems;
  }

  Widget buildDriveGrid(List<DriveItemModel> items) {
    return DriveGrid(
      items: items,
      username: username!,
      isList: currentView == ViewOption.list,
      onItemTap: (tapped) {
        _navigateToFolder(tapped);
      },
      onUpdateChanged: fetchData,
    );
  }

  Widget _buildDriveHomePage(
    List<DriveItemModel> myDriveFolders,
    List<DriveItemModel> sharedDriveFolders,
  ) {
    final myDriveItems = _getFilteredAndSortedFolders(myDriveFolders);
    final sharedDriveItems = _getFilteredAndSortedFolders(sharedDriveFolders);

    final bool isMyDriveEmpty = myDriveItems.isEmpty;
    final bool isSharedDriveEmpty = sharedDriveItems.isEmpty;

    return Scaffold(
      backgroundColor: magnoliaWhiteNewAmikom,
      appBar: AppBar(
        backgroundColor: magnoliaWhiteNewAmikom,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            _searchBarKey.currentState?.unfocus();
            if (mounted) Navigator.pop(context);
          },
        ),

        title: CustomSearchBar(
          key: _searchBarKey,
          onQueryChanged: (val) {
            setState(() => query = val);
          },
          onFilterChanged: (filter) {
            setState(() {
              selectedFileType = filter;
            });
          },
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
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: "My Drive"),
            Tab(text: "Shared Drive"),
          ],
        ),
      ),
      body: Column(
        children: [
          if (!((_tabController.index == 0 && isMyDriveEmpty) ||
              (_tabController.index == 1 && isSharedDriveEmpty)))
            SortAndViewOption(
              selectedSortBy: currentSortBy,
              selectedSortOrder: currentSortOrder,
              selectedView: currentView,
              onSortByChanged: (sortBy) =>
                  setState(() => currentSortBy = sortBy),
              onSortOrderChanged: (order) =>
                  setState(() => currentSortOrder = order),
              onViewChanged: (view) => setState(() => currentView = view),
            ),

          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                // MY DRIVE
                RefreshIndicator(
                  onRefresh: () async {
                    await fetchData();
                  },
                  child: isMyDriveEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada apa-apa di sini",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : buildDriveGrid(myDriveItems),
                ),

                // SHARED DRIVE
                RefreshIndicator(
                  onRefresh: () async {
                    await fetchData();
                  },
                  child: isSharedDriveEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada apa-apa di sini",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : buildDriveGrid(sharedDriveItems),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFabMenu(
        parentId: parentId!,
        onFolderCreated: () async {
          await fetchData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriveCubit, DriveState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildDriveHomeContent(state),
              _buildRecentPage(state),
              _buildStarredPage(state),
              _buildTrashPage(state),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  // Method untuk Drive Home
  Widget _buildDriveHomeContent(DriveState state) {
    if (state is DriveInitial || state is DriveLoading) {
      return _buildDriveHomeWithLoading();
    }

    if (state is DriveDataFailure) {
      return _buildDriveHomeWithError(state.message);
    }

    if (state is DriveDataSuccess) {
      final apiData = state.driveData.data ?? [];
      final filteredData = filterNonTrashedFolderItems(apiData);

      final driveRoot = filteredData.firstWhere(
        (i) => i.name == 'My Drive',
        orElse: () => FolderItem(),
      );

      final sharedDriveRoot = filteredData.firstWhere(
        (i) => i.name == 'Shared Drive',
        orElse: () => FolderItem(),
      );

      final userDriveFolders = (driveRoot.children ?? [])
          .where((child) => child.userId == username)
          .toList();

      final userDriveFiles = (driveRoot.files ?? [])
          .where((file) => file.userId == username)
          .toList();

      final allMyDriveItems = [...userDriveFolders, ...userDriveFiles];

      myDriveRootId = driveRoot.id ?? 1;
      sharedDriveRootId = sharedDriveRoot.id ?? 2;
      parentId ??= myDriveRootId;

      final sharedFolders = (sharedDriveRoot.children ?? []);
      final sharedFiles = (sharedDriveRoot.files ?? []);
      final allSharedDriveItems = [...sharedFolders, ...sharedFiles];

      final myDriveItems = _mapApiItemsToUiModel(allMyDriveItems);
      final sharedDriveItems = _mapApiItemsToUiModel(allSharedDriveItems);

      return _buildDriveHomePage(myDriveItems, sharedDriveItems);
    }

    return _buildDriveHomeWithError("State tidak valid");
  }

  // Method untuk halaman Recent
  Widget _buildRecentPage(DriveState state) {
    if (state is DriveDataSuccess) {
      final recentFolder = _createRecentFolder(state);
      return TabPageWrapper(
        rootFolder: recentFolder,
        username: username!,
        initialView: currentView,
        onRootPop: () {
          if (mounted) setState(() => _selectedIndex = 0);
        },
        onRefresh: fetchData,
      );
    }
    return _buildGenericLoadingPage("Berkas Terbaru");
  }

  // Method untuk halaman Starred
  Widget _buildStarredPage(DriveState state) {
    if (state is DriveDataSuccess) {
      final starredFolder = _createStarredFolder(state);
      return TabPageWrapper(
        rootFolder: starredFolder,
        username: username!,
        initialView: currentView,
        onRootPop: () {
          if (mounted) setState(() => _selectedIndex = 0);
        },
        onRefresh: fetchData,
      );
    }
    return _buildGenericLoadingPage("Berbintang");
  }

  // Method untuk halaman Trash
  Widget _buildTrashPage(DriveState state) {
    if (state is DriveDataSuccess) {
      final trashFolder = _createTrashFolder(state);
      return TabPageWrapper(
        rootFolder: trashFolder,
        username: username!,
        initialView: currentView,
        onRootPop: () {
          if (mounted) setState(() => _selectedIndex = 0);
        },
        onRefresh: fetchData,
      );
    }
    return _buildGenericLoadingPage("Sampah");
  }

  // Helper methods untuk membuat special folders
  DriveItemModel _createRecentFolder(DriveDataSuccess state) {
    final apiData = state.driveData.data ?? [];

    final driveRoot = apiData.firstWhere(
      (i) => i.name == 'My Drive',
      orElse: () => FolderItem(),
    );

    final sharedDriveRoot = apiData.firstWhere(
      (i) => i.name == 'Shared Drive',
      orElse: () => FolderItem(),
    );

    final myFolders = driveRoot.children ?? [];
    final myFiles = driveRoot.files ?? [];
    final allSharedFolders = sharedDriveRoot.children ?? [];
    final allSharedFiles = sharedDriveRoot.files ?? [];

    final myItems = [...myFolders, ...myFiles];
    final sharedItems = [...allSharedFolders, ...allSharedFiles];

    final allMyDriveItem = _mapApiItemsToUiModel(myItems);
    final allSharedItem = _mapApiItemsToUiModel(sharedItems);

    final allFolders = [...allMyDriveItem, ...allSharedItem];
    final allItems = _getAllItemsRecursive(allFolders);

    // Urutkan berdasarkan tanggal terbaru
    allItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return DriveItemModel(
      id: -1,
      nama: "Berkas Terbaru",
      createdAt: DateTime.now(),
      updateAt: DateTime.now(),
      children: allItems
          .where((f) => f.isTrashed == false && f.type == DriveItemType.file)
          .toList(),
      type: DriveItemType.folder,
      isSpecial: true,
    );
  }

  DriveItemModel _createStarredFolder(DriveDataSuccess state) {
    final apiData = state.driveData.data ?? [];
    final filteredData = filterNonTrashedFolderItems(apiData);

    final driveRoot = filteredData.firstWhere(
      (i) => i.name == 'My Drive',
      orElse: () => FolderItem(),
    );

    final sharedDriveRoot = filteredData.firstWhere(
      (i) => i.name == 'Shared Drive',
      orElse: () => FolderItem(),
    );

    final myItems = [...?driveRoot.children, ...?driveRoot.files];
    final sharedItems = [
      ...?sharedDriveRoot.children,
      ...?sharedDriveRoot.files,
    ];

    final allMyDriveItems = _mapApiItemsToUiModel(myItems);
    final allSharedItems = _mapApiItemsToUiModel(sharedItems);

    final allFolders = [...allMyDriveItems, ...allSharedItems];
    final allItems = _getAllItemsRecursive(allFolders);

    final starredItems = allItems.where(
      (f) => f.isStarred && !f.isTrashed && f.userId == username,
    );

    return DriveItemModel(
      id: -2,
      nama: "Berbintang",
      createdAt: DateTime.now(),
      updateAt: DateTime.now(),
      children: starredItems.toList(),
      type: DriveItemType.folder,
      isSpecial: true,
    );
  }

  DriveItemModel _createTrashFolder(DriveDataSuccess state) {
    final apiData = state.driveData.data ?? [];

    final driveRoot = apiData.firstWhere(
      (i) => i.name == 'My Drive',
      orElse: () => FolderItem(),
    );

    final sharedDriveRoot = apiData.firstWhere(
      (i) => i.name == 'Shared Drive',
      orElse: () => FolderItem(),
    );

    final myFolders = driveRoot.children ?? [];
    final myFiles = driveRoot.files ?? [];
    final allSharedFolders = sharedDriveRoot.children ?? [];
    final allSharedFiles = sharedDriveRoot.files ?? [];

    final myItems = [...myFolders, ...myFiles];
    final sharedItems = [...allSharedFolders, ...allSharedFiles];

    final allMyDriveItem = _mapApiItemsToUiModel(myItems);
    final allSharedItem = _mapApiItemsToUiModel(sharedItems);

    final allFolders = [...allMyDriveItem, ...allSharedItem];
    final allItems = _getAllItemsRecursive(allFolders);

    return DriveItemModel(
      id: -3,
      nama: "Sampah",
      createdAt: DateTime.now(),
      updateAt: DateTime.now(),
      children: allItems
          .where((f) => f.isTrashed && f.userId == username)
          .toList(),
      type: DriveItemType.folder,
      isSpecial: true,
    );
  }

  // Method untuk loading page generic
  Widget _buildGenericLoadingPage(String pageName) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: magnoliaWhiteNewAmikom,
        foregroundColor: Colors.black,
        leading: null,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(child: AppWidget().LoadingWidget()),
    );
  }

  // Method untuk Drive Home dengan loading
  Widget _buildDriveHomeWithLoading() {
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
        title: CustomSearchBar(
          onQueryChanged: (val) {
            setState(() => query = val);
          },
          onFilterChanged: (filter) {
            setState(() {
              selectedFileType = filter;
            });
          },
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
      body: Center(child: AppWidget().LoadingWidget()),
    );
  }

  // Method untuk Drive Home dengan error
  Widget _buildDriveHomeWithError(String message) {
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
        title: CustomSearchBar(
          onQueryChanged: (val) {
            setState(() => query = val);
          },
          onFilterChanged: (filter) {
            setState(() {
              selectedFileType = filter;
            });
          },
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
      body: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }

  // Bottom Navigation Bar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: mistyRoseNewAmikom,
      selectedItemColor: orangeNewAmikom,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.black54,
      selectedLabelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
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
    );
  }

  List<FolderItem> filterNonTrashedFolderItems(List<FolderItem> folders) {
    return folders.where((folder) => folder.isTrashed == 'FALSE').map((folder) {
      final filteredChildren = filterNonTrashedFolderItems(
        folder.children ?? [],
      );
      final filteredFiles = (folder.files ?? [])
          .where((file) => file.isTrashed == 'FALSE')
          .toList();

      return FolderItem(
        id: folder.id,
        parentId: folder.parentId,
        userId: folder.userId,
        name: folder.name,
        isStarred: folder.isStarred,
        isTrashed: folder.isTrashed,
        createdAt: folder.createdAt,
        updatedAt: folder.updatedAt,
        children: filteredChildren,
        files: filteredFiles,
      );
    }).toList();
  }

  List<DriveItemModel> _mapApiItemsToUiModel(dynamic apiInput) {
    final List<DriveItemModel> combinedList = [];

    if (apiInput == null) return combinedList;

    // 1) Kalau input adalah sebuah FolderItem tunggal
    if (apiInput is FolderItem) {
      final FolderItem apiFolder = apiInput;

      // proses sub-folder (children)
      if (apiFolder.children != null && apiFolder.children!.isNotEmpty) {
        for (var subFolder in apiFolder.children!) {
          combinedList.add(
            DriveItemModel(
              id: subFolder.id ?? 0,
              parentId: subFolder.parentId,
              parentName: apiFolder.name,
              userId: subFolder.userId,
              type: DriveItemType.folder,
              nama: subFolder.name ?? 'Folder Tanpa Nama',
              createdAt: subFolder.createdAtAsDate ?? DateTime.now(),
              isStarred: subFolder.isStarred == 'TRUE',
              isTrashed: subFolder.isTrashed == 'TRUE',
              // rekursif: subFolder bisa punya children/files
              children: _mapApiItemsToUiModel(subFolder),
              updateAt: subFolder.updatedAtAsDate ?? DateTime.now(),
            ),
          );
        }
      }

      // proses file di dalam folder ini
      if (apiFolder.files != null && apiFolder.files!.isNotEmpty) {
        for (var file in apiFolder.files!) {
          combinedList.add(
            DriveItemModel(
              id: file.id ?? 0,
              parentId: file.parentId,
              parentName: apiFolder.name,
              userId: file.userId,
              type: DriveItemType.file,
              nama: file.name!,
              createdAt: file.createdAtAsDate ?? DateTime.now(),
              isStarred: file.isStarred == 'TRUE',
              isTrashed: file.isTrashed == 'TRUE',
              mimeType: file.mimeType,
              size: file.size,
              url: file.urlFile,
              updateAt: file.updatedAtAsDate ?? DateTime.now(),
            ),
          );
        }
      }

      return combinedList;
    }

    // 2) Kalau input adalah List (campuran FolderItem & FileItem)
    if (apiInput is List) {
      for (var item in apiInput) {
        if (item == null) continue;

        if (item is FolderItem) {
          // Tambahkan folder level ini dulu
          combinedList.add(
            DriveItemModel(
              id: item.id ?? 0,
              parentId: item.parentId,
              userId: item.userId,
              parentName: item.parentId == 1 ? 'My Drive' : 'Shared Drive',
              type: DriveItemType.folder,
              nama: item.name ?? 'Folder Tanpa Nama',
              createdAt: item.createdAtAsDate ?? DateTime.now(),
              isStarred: item.isStarred == 'TRUE',
              isTrashed: item.isTrashed == 'TRUE',
              updateAt: item.updatedAtAsDate ?? DateTime.now(),
              // rekursif untuk isi folder
              children: _mapApiItemsToUiModel(item),
            ),
          );
        } else if (item is FileItem) {
          // file tetap sama
          combinedList.add(
            DriveItemModel(
              id: item.id ?? 0,
              parentId: item.parentId,
              parentName: item.parentId == 1 ? 'My Drive' : 'Shared Drive',
              userId: item.userId,
              type: DriveItemType.file,
              nama: item.name!,
              createdAt: item.createdAtAsDate ?? DateTime.now(),
              isStarred: item.isStarred == 'TRUE',
              isTrashed: item.isTrashed == 'TRUE',
              mimeType: item.mimeType,
              size: item.size,
              url: item.urlFile,
              updateAt: item.updatedAtAsDate ?? DateTime.now(),
            ),
          );
        }
      }
      return combinedList;
    }

    // 3) Kalau input adalah FileItem tunggal
    if (apiInput is FileItem) {
      combinedList.add(
        DriveItemModel(
          id: apiInput.id ?? 0,
          parentId: apiInput.parentId,
          userId: apiInput.userId,
          parentName: 'cek: drive_home line 703',
          type: DriveItemType.file,
          nama: apiInput.name!,
          createdAt: apiInput.createdAtAsDate ?? DateTime.now(),
          isStarred: apiInput.isStarred == 'TRUE',
          isTrashed: apiInput.isTrashed == 'TRUE',
          mimeType: apiInput.mimeType,
          size: apiInput.size,
          url: apiInput.urlFile,
          updateAt: apiInput.updatedAtAsDate ?? DateTime.now(),
        ),
      );
      return combinedList;
    }

    // default: kembalikan list kosong
    return combinedList;
  }

  List<DriveItemModel> _getFilteredAndSortedFolders(
    List<DriveItemModel> sourceFolders,
  ) {
    final filtered = sourceFolders.where((f) {
      final fileName = f.nama.toLowerCase();
      final mimeType = f.mimeType?.toLowerCase() ?? "";
      final queryLower = query.toLowerCase();

      // Filter berdasarkan teks pencarian (nama atau mime type)
      final matchesQuery =
          fileName.contains(queryLower) || mimeType.contains(queryLower);

      // Default: semua cocok jika tidak ada filter
      bool matchesType = true;

      if (selectedFileType != null) {
        switch (selectedFileType) {
          case "Folders":
            matchesType = f.type == DriveItemType.folder;
            break;

          case "Word":
            matchesType = mimeType.endsWith("doc") || mimeType.endsWith("docx");
            break;

          case "Excel":
            matchesType = mimeType.endsWith("xls") || mimeType.endsWith("xlsx");
            break;

          case "PDFs":
            matchesType = mimeType.endsWith("pdf");
            break;

          case "Photos & Images":
            matchesType =
                mimeType.endsWith("png") ||
                mimeType.endsWith("jpg") ||
                mimeType.endsWith("jpeg") ||
                mimeType.endsWith("gif") ||
                mimeType.endsWith("svg");
            break;

          default:
            matchesType = true;
        }
      }
      return matchesQuery && matchesType;
    }).toList();

    // Fungsi pembanding untuk teks (A–Z, Z–A)
    int compareText<T extends Comparable>(T a, T b) {
      return currentSortOrder == SortOrder.desc
          ? b.compareTo(a)
          : a.compareTo(b);
    }

    // Fungsi pembanding untuk tanggal (Terbaru, Terlama)
    int compareDate<T extends Comparable>(T a, T b) {
      return currentSortOrder == SortOrder.asc
          ? b.compareTo(a)
          : a.compareTo(b);
    }

    // mengurutkan sesuai enum SortBy
    switch (currentSortBy) {
      case SortBy.name:
        filtered.sort(
          (a, b) => compareText(a.nama.toLowerCase(), b.nama.toLowerCase()),
        );
        break;

      case SortBy.modifiedDate:
        filtered.sort((a, b) => compareDate(a.updateAt, b.updateAt));
        break;

      case SortBy.createdDate:
        filtered.sort((a, b) => compareDate(a.createdAt, b.createdAt));
        break;
    }

    return filtered;
  }
}
