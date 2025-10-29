import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/drive_home.dart';
import '../../../utllis/app_shared_prefs.dart';
import '../data/cubit/get_drive_cubit.dart';
import '../data/model/response/get_data_drive_response.dart';
import '../drive_item_model.dart';
import '../template/drive_layout.dart';
import '../template/sort_and_layout_option.dart';
import '../template/animated_fab.dart';
import 'detail_page.dart';

class FolderPage extends StatefulWidget {
  // =========== Properti awal yang dibutuhkan untuk halaman folder ===========
  final DriveItemModel initialFolder;
  final ViewOption initialView;
  final VoidCallback? onRootPop;
  final VoidCallback? onUpdateChanged;
  final Future<void> Function()? onRefresh;

  const FolderPage({
    super.key,
    required this.initialFolder,
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
      // 1. Fetch data terbaru dari server
      await widget.onRefresh!();

      // 2. Tunggu sebentar untuk memastikan data sudah ter-update
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Dapatkan data terbaru dari Cubit/Bloc
      final driveState = context.read<DriveCubit>().state;
      if (driveState is DriveDataSuccess) {
        // 4. Cari folder yang sama dengan ID yang sedang dibuka
        final currentFolderId = currentFolder.id;
        final updatedFolder = _findFolderById(driveState.driveData.data ?? [], currentFolderId);

        if (updatedFolder != null) {
          // 5. Update navigation stack dengan data terbaru
          setState(() {
            navigationStack.removeLast();
            navigationStack.add(updatedFolder);
          });
        } else {
          // Jika folder tidak ditemukan (mungkin dihapus), refresh UI lokal
          setState(() {});
        }
      } else {
        // Fallback: refresh UI lokal
        setState(() {});
      }
    } else if (widget.onUpdateChanged != null) {
      widget.onUpdateChanged!();
      setState(() {});
    } else {
      // Final fallback
      setState(() {});
    }
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
  DriveItemModel _recreateSpecialFolder(List<FolderItem> apiData, int folderId) {
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

    final allMyDriveItem = _mapApiListToUiModel(myItems);
    final allSharedItem = _mapApiListToUiModel(sharedItems);

    final allFolders = [...allMyDriveItem, ...allSharedItem];
    final allItems = _getAllItemsRecursive(allFolders);

    switch (folderId) {
      case -1: // Recent
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

      case -2: // Starred
        return DriveItemModel(
          id: -2,
          nama: "Berbintang",
          createdAt: DateTime.now(),
          updateAt: DateTime.now(),
          children: allItems
              .where((f) => f.isStarred && f.userId == widget.initialFolder.userId && f.isTrashed == false)
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
              .where((f) => f.isTrashed && f.userId == widget.initialFolder.userId)
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

  // FIXED: Method untuk mapping FolderItem ke List<DriveItemModel>
  List<DriveItemModel> _mapApiFolderToUiModel(FolderItem apiFolder) {
    final List<DriveItemModel> combinedList = [];

    // Process sub-folders
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
            children: _mapApiFolderToUiModel(subFolder),
            updateAt: subFolder.updatedAtAsDate ?? DateTime.now(),
          ),
        );
      }
    }

    // Process files
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

  // FIXED: Method untuk mapping List<dynamic> ke List<DriveItemModel>
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

  // =========== Fungsi untuk membuka dan menutup detail folder ===========
  void openDetail(DriveItemModel folder) {
    setState(() {
      selectedFolder = folder;
      showDetail = true;
    });
    _controller.forward(from: 0);
  }

  void closeDetail() {
    _controller.reverse().then((_) {
      setState(() {
        showDetail = false;
        selectedFolder = null;
      });
    });
  }

  // =========== Fungsi sorting untuk mengurutkan isi folder ===========
  List<DriveItemModel> getFilteredAndSortedFolders(List<DriveItemModel> input) {
    final filtered = List<DriveItemModel>.from(input);
    switch (currentSort) {
      case SortOrder.asc:
        filtered.sort((a, b) => a.nama.compareTo(b.nama));
        break;
      case SortOrder.desc:
        filtered.sort((a, b) => b.nama.compareTo(a.nama));
        break;
      case SortOrder.date:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return filtered;
  }

  // =========== Bagian utama UI ===========
  @override
  Widget build(BuildContext context) {
    final items = getFilteredAndSortedFolders(currentItems);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          popFolder();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),

        // =========== Body dengan RefreshIndicator ===========
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refreshData,
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation, secondaryAnimation) {
                  return SharedAxisTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.scaled,
                    fillColor: Colors.white,
                    child: child,
                  );
                },
                child: _buildBody(items),
              ),
            ),
          ],
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

  // =========== Membuat AppBar sesuai kondisi folder ===========
  AppBar _buildAppBar() {
    final isRoot = navigationStack.length == 1;
    final isSpecial = widget.initialFolder.isSpecial;

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: !isSpecial
          ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: popFolder,
      )
          : null,
      title: Text(currentFolder.nama),
      centerTitle: true,
    );
  }

  // =========== Membuat isi halaman utama (daftar folder dan sort option) ===========
  Widget _buildBody(List<DriveItemModel> items) {
    return Column(
      key: ValueKey(currentFolder.id),
      children: [
        if (items.isNotEmpty)
          SortAndViewOption(
            selectedSortBy: currentSortBy,
            selectedSortOrder: currentSortOrder,
            selectedView: currentView,
            onSortByChanged: (sortBy) => setState(() => currentSortBy = sortBy),
            onSortOrderChanged: (order) =>
                setState(() => currentSortOrder = order),
            onViewChanged: (view) => setState(() => currentView = view),
          ),

        // =========== Daftar isi folder atau tampilan kosong ===========
        Expanded(
          child: items.isEmpty
              ? Center(
            child: Text(
              "Folder Kosong",
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          )
              : DriveGrid(
            items: items,
            isList: currentView == ViewOption.list,
            onItemTap: (tapped) {
              pushFolder(tapped);
            },
            onUpdateChanged: _refreshData,
          ),
        ),
      ],
    );
  }
}