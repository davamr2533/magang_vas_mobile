import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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
  int _selectedIndex = 0;
  String? token;
  String? username;
  late TabController _tabController;
  int? parentId;
  int myDriveRootId = 1; // Default
  int sharedDriveRootId = 2; // Default

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

          print(
            "Tab changed to index: ${_tabController.index}, parentId: $parentId",
          );
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
          initialFolder: folder,
          initialView: currentView,
          onUpdateChanged: fetchData,
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
        title: const CustomSearchBar(),
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
            selectedSortBy: currentSortBy,
            selectedSortOrder: currentSortOrder,
            selectedView: currentView,
            onSortByChanged: (sortBy) => setState(() => currentSortBy = sortBy),
            onSortOrderChanged: (order) =>
                setState(() => currentSortOrder = order),
            onViewChanged: (view) => setState(() => currentView = view),
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
        parentId: parentId!,
        onFolderCreated: () async {
          await fetchData(); // auto refresh folder list
        },
      ),
    );
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

          // Ambil root "My Drive" dan "Shared Drive"
          final driveRoot = apiData.firstWhere(
            (i) => i.name == 'My Drive',
            orElse: () => FolderItem(),
          );

          final sharedDriveRoot = apiData.firstWhere(
            (i) => i.name == 'Shared Drive',
            orElse: () => FolderItem(),
          );

          // Ambil semua folder My Drive milik user login
          final userDriveFolders = (driveRoot.children ?? [])
              .where(
                (child) =>
                    child.userId == username && child.isTrashed == 'FALSE',
              )
              .toList();

          // Ambil semua file My Drive milik user login (bisa di root)
          final userDriveFiles = (driveRoot.files ?? [])
              .where(
                (file) => file.userId == username && file.isTrashed == 'FALSE',
              )
              .toList();

          // Kalau userDriveFolders kosong, berarti user belum punya folder khusus
          // Maka tetap ambil file yang sesuai user
          final allMyDriveItems = [...userDriveFolders, ...userDriveFiles];
          print('DEBUG username = "$username"');
          for (var c in (driveRoot.children ?? [])) {
            print('child ${c.name} -> userId: "${c.userId}"');
          }

          // Set ID root
          myDriveRootId = driveRoot.id ?? 1;
          sharedDriveRootId = sharedDriveRoot.id ?? 2;
          parentId ??= myDriveRootId;

          // --- Shared Drive tetap ambil semua---
          final sharedFolders = (sharedDriveRoot.children ?? [])
              .where((child) => child.isTrashed == 'FALSE')
              .toList();
          final sharedFiles = (sharedDriveRoot.files ?? [])
              .where((file) => file.isTrashed == 'FALSE')
              .toList();

          final allSharedDriveItems = [...sharedFolders, ...sharedFiles];

          // --- Mapping ke model UI ---
          final myDriveItems = _mapApiItemsToUiModel(allMyDriveItems);
          final sharedDriveItems = _mapApiItemsToUiModel(allSharedDriveItems);

          //-----------------------------------------DEBUG---------------------------------------------
          final files = myDriveItems.where(
            (item) => item.type == DriveItemType.file,
          );
          final folders = myDriveItems.where(
            (item) => item.type == DriveItemType.folder,
          );

          print(
            "======================DEBUG-FILE-MY-DRIVE======================================",
          );
          for (var file in files) {
            // Warna menggunakan ANSI escape code
            const red = '\x1B[31m';
            const green = '\x1B[32m';
            const yellow = '\x1B[33m';
            const blue = '\x1B[34m';
            const magenta = '\x1B[35m';
            const cyan = '\x1B[36m';
            const reset = '\x1B[0m'; // reset warna ke default

            print(
              '${green}FILE${reset} parent: ${file.parentId}, '
              '${cyan}Nama:${reset} ${file.nama} (${file.id}), '
              '${yellow}Ukuran:${reset} ${file.size}, '
              '${yellow}Waktu:${reset} ${file.updateAt}, '
              '${magenta}Tipe:${reset} ${file.mimeType}',
            );
          }

          print(
            "======================END-DEBUG-FILE-MY-DRIVE======================================",
          );
          print(
            "======================DEBUG-FOLDER======================================",
          );
          for (var folder in folders) {
            print(
              'FOLDER parent : ${folder.parentId}, Folder: ${folder.nama} (${folder.id}) , waktu: ${folder.createdAt}, username: ${folder.userId}',
            );
          }
          print(
            "======================END-DEBUG-FOLDER======================================",
          );
          //--------------------------------------END-DEBUG-------------------------------------

          final myFolders = driveRoot.children ?? [];
          final myFiles = driveRoot.files ?? [];

          final allSharedFolders = sharedDriveRoot.children ?? [];
          final allSharedFiles = sharedDriveRoot.files ?? [];

          final myItems = [...myFolders, ...myFiles];
          final sharedItems = [...allSharedFolders, ...allSharedFiles];

          final allMyDriveItem = _mapApiItemsToUiModel(myItems);
          final allSharedItem = _mapApiItemsToUiModel(sharedItems);

          // --- Gabungkan semua drive ---
          final allFolders = [...allMyDriveItem, ...allSharedItem];

          // --- Dapatkan semua item rekursif ---
          final allItems = _getAllItemsRecursive(allFolders);

          // --- Urutkan berdasarkan tanggal terbaru ---
          allItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          final recentFolder = DriveItemModel(
            id: -1,
            nama: "Berkas Terbaru",
            createdAt: DateTime.now(),
            updateAt: DateTime.now(),
            children: allItems
                .where(
                  (f) => f.isTrashed == false && f.type == DriveItemType.file,
                )
                .toList(),
            type: DriveItemType.folder,
            isSpecial: true,
          );

          final starredFolder = DriveItemModel(
            id: -2,
            nama: "Berbintang",
            createdAt: DateTime.now(),
            updateAt: DateTime.now(),
            children: allItems
                .where(
                  (f) =>
                      f.isStarred &&
                      f.userId == username &&
                      f.isTrashed == false,
                )
                .toList(),
            type: DriveItemType.folder,
            isSpecial: true,
          );

          final trashFolder = DriveItemModel(
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

          final pages = [
            _buildDriveHomePage(myDriveItems, sharedDriveItems),
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

        return const Scaffold(body: Center(child: Text("State tidak valid")));
      },
    );
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
              nama: '${file.name!}.${file.mimeType}',
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
          // ⬇️ Tambahkan folder level ini dulu
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
              nama: '${item.name!}.${item.mimeType}',
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
          parentName: 'cek: drive_home line 613',
          type: DriveItemType.file,
          nama: '${apiInput.name!}.${apiInput.mimeType}',
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

    // default: kembalikan list kosong kalau tidak dikenali
    return combinedList;
  }

  List<DriveItemModel> getFilteredAndSortedFolders(
    List<DriveItemModel> sourceFolders,
  ) {
    // 🔍 Filter berdasarkan pencarian
    final filtered = sourceFolders
        .where((f) => f.nama.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // 🔢 Urutkan berdasarkan currentSortBy & currentSortOrder
    int compare<T extends Comparable>(T a, T b) {
      // Fungsi bantu agar bisa balik urutan jika desc
      return currentSortOrder == SortOrder.desc
          ? b.compareTo(a)
          : a.compareTo(b);
    }

    switch (currentSortBy) {
      case SortBy.name:
        filtered.sort(
          (a, b) => compare(a.nama.toLowerCase(), b.nama.toLowerCase()),
        );
        break;

      case SortBy.modifiedDate:
        filtered.sort((a, b) => compare(a.updateAt, b.updateAt));
        break;

      case SortBy.modifiedByMe:
        filtered.sort((a, b) => compare(a.updateAt, b.updateAt));
        break;

      case SortBy.openedByMe:
        filtered.sort((a, b) => compare(a.updateAt, b.updateAt));
        break;
    }

    return filtered;
  }
}
