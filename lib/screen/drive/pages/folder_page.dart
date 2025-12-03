import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/screen/drive/template/folder_app_bar.dart';
import '../data/cubit/get_drive_cubit.dart';
import '../data/model/response/get_data_drive_response.dart';
import '../drive_item_model.dart';
import '../template/drive_layout.dart';
import '../template/sort_and_layout_option.dart';
import '../template/animated_fab.dart';

class FolderPage extends StatefulWidget {
  // =========== Properti awal yang dibutuhkan untuk halaman folder ===========
  final DriveItemModel initialFolder;
  final String username;
  final ViewOption initialView;
  final VoidCallback? onRootPop;
  final VoidCallback? onUpdateChanged;
  final Future<void> Function()? onRefresh;

  const FolderPage({
    super.key,
    required this.initialFolder,
    required this.username,
    this.initialView = ViewOption.grid,
    this.onRootPop,
    this.onUpdateChanged,
    this.onRefresh,
  });

  @override
  State<FolderPage> createState() => FolderPageState();
}

class FolderPageState extends State<FolderPage>
    with SingleTickerProviderStateMixin {
  // =========== Variabel utama untuk navigasi dan tampilan ===========
  late List<DriveItemModel> navigationStack;
  SortOrder currentSort = SortOrder.asc;
  late ViewOption currentView;
  SortBy currentSortBy = SortBy.name;
  SortOrder currentSortOrder = SortOrder.asc;

  String query = '';
  String? selectedFileType;

  // =========== Variabel untuk halaman detail ===========
  bool showDetail = false;
  DriveItemModel? selectedFolder;

  // =========== Variabel animasi untuk transisi detail ===========
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  // =========== Lifecycle init ===========
  @override
  void initState() {
    super.initState();
    navigationStack = [widget.initialFolder];
    currentView = widget.initialView;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  // =========== Lifecycle dispose ===========
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // =========== Getter bantu untuk navigasi folder ===========
  DriveItemModel get currentFolder => navigationStack.last;
  List<DriveItemModel> get currentItems => currentFolder.children;
  bool canGoBack() => navigationStack.length > 1;
  void goBack() => popFolder();

  // =========== Navigasi antar folder ===========
  void pushFolder(DriveItemModel folder) {
    setState(() => navigationStack.add(folder));
  }

  void popFolder() {
    if (navigationStack.length > 1) {
      setState(() => navigationStack.removeLast());
    } else {
      if (widget.onRootPop != null) {
        widget.onRootPop!();
      } else {
        if (widget.initialFolder.isSpecial) {
          debugPrint("Back di tab spesial, tetap di root");
        } else {
          Navigator.pop(context, currentView);
        }
      }
    }
  }

  Future<void> refreshData() async {
    await _refreshData();
  }

  // =========== FUNGSI REFRESH  ===========
  Future<void> _refreshData() async {
    if (widget.onRefresh != null) {
      await widget.onRefresh!();

      final driveState = context.read<DriveCubit>().state;

      if (driveState is DriveDataSuccess) {
        final currentId = currentFolder.id;
        final updated = _findFolderById(driveState.driveData.data ?? [], currentId);

        if (updated != null) {
          setState(() {
            navigationStack.removeLast();
            navigationStack.add(updated);
          });
        }
      }

      return;
    }
    setState(() {});
  }


  // =========== Helper function untuk mencari folder by ID ===========
  DriveItemModel? _findFolderById(List<FolderItem> apiData, int folderId) {
    // Handle special folders (Recent, Starred, Trash)
    if (folderId < 0) {
      return _recreateSpecialFolder(apiData, folderId);
    }

    for (var folder in apiData) {
      final found = _searchFolderRecursive(folder, folderId);
      if (found != null) return found;
    }
    return null;
  }

  DriveItemModel? _searchFolderRecursive(FolderItem folder, int targetId) {
    // Cek folder saat ini
    if (folder.id == targetId) {
      return _mapFolderItemToDriveItemModel(folder);
    }

    // Cek di children
    if (folder.children != null) {
      for (var child in folder.children!) {
        final found = _searchFolderRecursive(child, targetId);
        if (found != null) return found;
      }
    }
    return null;
  }

  // =========== Recreate special folders dengan data terbaru ===========
  DriveItemModel _recreateSpecialFolder(
    List<FolderItem> apiData,
    int folderId,
  ) {
    final driveRoot = apiData.firstWhere(
      (i) => i.name == 'My Drive',
      orElse: () => FolderItem(),
    );

    final sharedDriveRoot = apiData.firstWhere(
      (i) => i.name == 'Shared Drive',
      orElse: () => FolderItem(),
    );

    final myFolders = driveRoot.children ?? [];
    final myFiles = (driveRoot.files ?? [])
        .where((f) => f.userId == widget.username)
        .toList();

    final allSharedFolders = sharedDriveRoot.children ?? [];
    final allSharedFiles = sharedDriveRoot.files ?? [];

    final myItems = [...myFolders, ...myFiles];
    final sharedItems = [...allSharedFolders, ...allSharedFiles];

    final allMyDriveItem = _mapApiListToUiModel(myItems);
    final allSharedItem = _mapApiListToUiModel(sharedItems);
    final allMyItems = allMyDriveItem
        .where((f) => f.userId == widget.username)
        .toList();

    final allFolders = [...allMyItems, ...allSharedItem];
    final allItems = _getAllItemsRecursive(allFolders);

    switch (folderId) {
      case -1: // Recent
        return DriveItemModel(
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

      case -2: // Starred
        return DriveItemModel(
          id: -2,
          nama: "Berbintang",
          createdAt: DateTime.now(),
          updateAt: DateTime.now(),
          children: allItems
              .where(
                (f) =>
                    f.isStarred &&
                    f.userId == widget.initialFolder.userId &&
                    f.isTrashed == false,
              )
              .toList(),
          type: DriveItemType.folder,
          isSpecial: true,
        );

      case -3: // Trash
        return DriveItemModel(
          id: -3,
          nama: "Sampah",
          createdAt: DateTime.now(),
          updateAt: DateTime.now(),
          children: allItems
              .where(
                (f) => f.isTrashed && f.userId == widget.initialFolder.userId,
              )
              .toList(),
          type: DriveItemType.folder,
          isSpecial: true,
        );

      default:
        return widget.initialFolder;
    }
  }

  // =========== Mapping functions ===========
  DriveItemModel _mapFolderItemToDriveItemModel(FolderItem folder) {
    return DriveItemModel(
      id: folder.id ?? 0,
      parentId: folder.parentId,
      userId: folder.userId,
      parentName: folder.parentId == 1 ? 'My Drive' : 'Shared Drive',
      type: DriveItemType.folder,
      nama: folder.name ?? 'Folder Tanpa Nama',
      createdAt: folder.createdAtAsDate ?? DateTime.now(),
      isStarred: folder.isStarred == 'TRUE',
      isTrashed: folder.isTrashed == 'TRUE',
      updateAt: folder.updatedAtAsDate ?? DateTime.now(),
      children: _mapApiFolderToUiModel(folder),
    );
  }

  // Method untuk mapping FolderItem ke List<DriveItemModel>
  List<DriveItemModel> _mapApiFolderToUiModel(FolderItem apiFolder) {
    final List<DriveItemModel> combinedList = [];

    // Process sub-folders
    if (apiFolder.children != null && apiFolder.children!.isNotEmpty) {
      for (var subFolder in apiFolder.children!) {
       if(subFolder.isTrashed == 'TRUE'){
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
             children: _mapApiFolderToUiModel(subFolder),
             updateAt: subFolder.updatedAtAsDate ?? DateTime.now(),
           ),
         );
       }
      }
    }

    // Process files
    if (apiFolder.files != null && apiFolder.files!.isNotEmpty) {
      for (var file in apiFolder.files!) {
        if (file.isTrashed!= 'TRUE') {
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
    }

    return combinedList;
  }

  // Method untuk mapping List<dynamic> ke List<DriveItemModel>
  List<DriveItemModel> _mapApiListToUiModel(List<dynamic> apiInput) {
    final List<DriveItemModel> combinedList = [];

    if (apiInput.isEmpty) return combinedList;

    for (var item in apiInput) {
      if (item is FolderItem) {
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
            children: _mapApiFolderToUiModel(item),
          ),
        );
      } else if (item is FileItem) {
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

  // =========== Bagian utama UI ===========
  @override
  Widget build(BuildContext context) {
    final items = _getFilteredAndSortedFolders(currentItems);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          popFolder();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: FolderAppBar(
          onQueryChanged: (val) {
            setState(() => query = val);
          },
          popFolder: popFolder,
          folderId: currentFolder.id,
          isTrashed: currentFolder.isTrashed,
          title: currentFolder.nama,
        ),

        // =========== Body dengan RefreshIndicator ===========
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder:
              (
                Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  fillColor: Colors.white,
                  child: child,
                );
              },
          child: Container(
            key: ValueKey(currentFolder.id),
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: _buildBodyContent(items),
            ),
          ),
        ),

        // =========== Tombol tambah folder / upload file (FAB) ===========
        floatingActionButton: !widget.initialFolder.isSpecial
            ? AnimatedFabMenu(
                parentId: currentFolder.id,
                onFolderCreated: () async {
                  await _refreshData();
                },
              )
            : null,
      ),
    );
  }

  // =========== Membuat isi halaman utama (daftar folder dan sort option) ===========
  Widget _buildBodyContent(List<DriveItemModel> items) {
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 200),
          Center(child: emptyPageText(currentFolder.id)),
        ],
      );
    }

    return Column(
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
          child: DriveGrid(
            items: List.from(items),
            isList: currentView == ViewOption.list,
            onItemTap: pushFolder,
            onUpdateChanged:() async {
              await _refreshData();
            },
            username: widget.username,
          ),
        ),
      ],
    );
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

  Widget emptyPageText(int id) {
    switch (id) {
      case -1:
        return Text(
          "Tidak ada berkas terbaru",
          style: TextStyle(color: Colors.grey),
        );
      case -2:
        return Text(
          "Tidak ada file berbintang",
          style: TextStyle(color: Colors.grey),
        );
      case -3:
        return Text("Sampah kosong", style: TextStyle(color: Colors.grey));
      default:
        return Text("Folder kosong", style: TextStyle(color: Colors.grey));
    }
  }
}
