import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/screen/drive/drive_home.dart';
import '../../../utllis/app_shared_prefs.dart';
import '../data/cubit/get_drive_cubit.dart';
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

  const FolderPage({
    super.key,
    required this.initialFolder,
    this.initialView = ViewOption.grid,
    this.onRootPop,
    this.onUpdateChanged,
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
    if (token == null || userId == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Kalau sudah siap, lanjut render konten
    final items = getFilteredAndSortedFolders(currentItems);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Jika tombol back ditekan, navigasi kembali ke folder sebelumnya
          popFolder();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),

        // =========== Bagian body dengan transisi animasi ===========
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
          ],
        ),

        // =========== Tombol tambah folder / upload file (FAB) ===========
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
            onUpdateChanged: widget.onUpdateChanged,
          ),
        ),
      ],
    );
  }
}
