import 'package:flutter/cupertino.dart';
import '../drive_home.dart';
import '../drive_item_model.dart';
import '../pages/folder_page.dart';
import '../template/sort_and_layout_option.dart';

class TabPageWrapper extends StatefulWidget {
  final DriveItemModel rootFolder;
  final String username;
  final ViewOption initialView;
  final VoidCallback onRootPop;
  final Future<void> Function()? onRefresh;

  const TabPageWrapper({
    super.key,
    required this.rootFolder,
    required this.username,
    required this.initialView,
    required this.onRootPop,
    this.onRefresh,
  });

  @override
  State<TabPageWrapper> createState() => _TabPageWrapperState();
}

class _TabPageWrapperState extends State<TabPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // key untuk akses FolderPage state
  final GlobalKey<FolderPageState> _folderKey = GlobalKey();

  // Key untuk force rebuild ketika data berubah
  late UniqueKey _folderPageKey;

  @override
  void initState() {
    super.initState();
    _folderPageKey = UniqueKey();
  }

  // Method untuk handle refresh dari luar
  void refreshFolderPage() {
    if (_folderKey.currentState != null) {
      _folderKey.currentState!.refreshData();
    } else {
      // Force rebuild dengan key baru
      setState(() {
        _folderPageKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return WillPopScope(
      onWillPop: () async {
        // cek apakah folder masih bisa back
        if (_folderKey.currentState != null &&
            _folderKey.currentState!.canGoBack()) {
          _folderKey.currentState!.goBack();
          return false; // cegah langsung keluar
        }
        return true; // biarkan system back keluar (misal ke DriveHome)
      },
      child: FolderPage(
        key: _folderKey, // GlobalKey untuk akses state
        initialFolder: widget.rootFolder,
        username: widget.username,
        initialView: widget.initialView,
        onRootPop: widget.onRootPop,
        onRefresh: () async {
          // Ketika refresh dipicu di FolderPage, panggil onRefresh dari parent
          if (widget.onRefresh != null) {
            await widget.onRefresh!();
            // Setelah data ter-refresh, force rebuild FolderPage
            setState(() {
              _folderPageKey = UniqueKey();
            });
          }
        },
      ),
    );
  }
}