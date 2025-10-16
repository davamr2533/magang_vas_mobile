import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utllis/app_shared_prefs.dart';
import '../data/cubit/get_drive_cubit.dart';
import '../folder_model.dart';
import '../template/drive_layout.dart';
import '../template/sort_and_layout_option.dart';
import '../template/animated_fab.dart';
import 'detail_page.dart';

class FolderPage extends StatefulWidget {
  final FolderModel initialFolder;
  final ViewOption initialView;
  final VoidCallback? onRootPop;

  const FolderPage({
    super.key,
    required this.initialFolder,
    this.initialView = ViewOption.grid,
    this.onRootPop,
  });

  @override
  State<FolderPage> createState() => FolderPageState();
}

class FolderPageState extends State<FolderPage>
    with SingleTickerProviderStateMixin {
  // ----------------- State utama -----------------
  late List<FolderModel> navigationStack;
  SortOption currentSort = SortOption.nameAsc;
  late ViewOption currentView;

  // ----------------- Detail Page -----------------
  bool showDetail = false;
  FolderModel? selectedFolder;

  // ----------------- Animasi -----------------
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  // ----------------- Lifecycle -----------------
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


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ----------------- Getter -----------------
  /// Folder yang sedang aktif ditampilkan.
  FolderModel get currentFolder => navigationStack.last;

  /// Item (sub-folder) di dalam folder aktif.
  List<FolderModel> get currentItems => currentFolder.children;

  /// Apakah bisa kembali ke folder sebelumnya.
  bool canGoBack() => navigationStack.length > 1;
  void goBack() => popFolder();

  // ----------------- Navigasi Folder -----------------
  /// Masuk ke dalam folder baru.
  void pushFolder(FolderModel folder) {
    setState(() => navigationStack.add(folder));
  }

  /// Kembali ke folder sebelumnya, atau keluar dari root.
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

  // ----------------- Detail Page -----------------
  /// Buka halaman detail folder.
  void openDetail(FolderModel folder) {
    setState(() {
      selectedFolder = folder;
      showDetail = true;
    });
    _controller.forward(from: 0);
  }

  /// Tutup halaman detail folder.
  void closeDetail() {
    _controller.reverse().then((_) {
      setState(() {
        showDetail = false;
        selectedFolder = null;
      });
    });
  }

  // ----------------- Sorting -----------------
  /// Mengurutkan folder sesuai pilihan sort.
  List<FolderModel> getFilteredAndSortedFolders(List<FolderModel> input) {
    final filtered = List<FolderModel>.from(input);
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

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    final items = getFilteredAndSortedFolders(currentItems);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // debugPrint("Tombol kembali ditekan!");
          // debugPrint("Jumlah folder di stack: ${navigationStack.length}");
          // debugPrint(
          //   "Nama folder di stack: ${navigationStack.map((f) => f.namaFolder).toList()}",
          // );
          popFolder();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            PageTransitionSwitcher(
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
            if (showDetail && selectedFolder != null)
              SlideTransition(
                position: _slideAnimation,
                child: DetailPage(
                  title: selectedFolder!.namaFolder,
                  jenis: "Folder",
                  lokasi: "VAS Drive",
                  dibuat: "15 Sep 2025",
                  diubah: "15 Sep 2025 oleh Fais",
                  icon: Icons.folder_rounded,
                ),
              ),
          ],
        ),
        floatingActionButton: !widget.initialFolder.isSpecial
            ? AnimatedFabMenu(
                parentId: currentFolder.id,
                onFolderCreated: () async {
                  setState(() {});

                },
              )
            : null,
      ),
    );
  }

  /// Membuat AppBar dengan tombol back sesuai kondisi folder.
  AppBar _buildAppBar() {
    final isRoot = navigationStack.length == 1;
    final isSpecial = widget.initialFolder.isSpecial;

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: (!isRoot || !isSpecial)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: popFolder,
            )
          : null,
      title: Text(currentFolder.namaFolder),
      centerTitle: true,
    );
  }

  /// Membuat body utama, menampilkan sort option + daftar folder.
  Widget _buildBody(List<FolderModel> items) {
    return Column(
      key: ValueKey(currentFolder.id),
      children: [
        if (items.isNotEmpty)
          SortAndViewOption(
            currentSort: currentSort,
            currentView: currentView,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            onSortChanged: (sort) => setState(() => currentSort = sort),
            onViewChanged: (view) => setState(() => currentView = view),
          ),
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
                  items: items.map((f) => f.namaFolder).toList(),
                  isList: currentView == ViewOption.list,
                  isStarred: items.map((f) => f.isStarred).toList(),
                  onFolderTap: (folderName) {
                    final tapped = items.firstWhere(
                      (f) => f.namaFolder == folderName,
                    );
                    pushFolder(tapped);
                  },
                ),
        ),
      ],
    );
  }
}
