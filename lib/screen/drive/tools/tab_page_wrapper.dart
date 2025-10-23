import 'package:flutter/cupertino.dart';

import '../drive_home.dart';
import '../drive_item_model.dart';
import '../pages/folder_page.dart';
import '../template/sort_and_layout_option.dart';

class TabPageWrapper extends StatefulWidget {
  final DriveItemModel rootFolder;
  final ViewOption initialView;
  final VoidCallback onRootPop;

  const TabPageWrapper({
    super.key,
    required this.rootFolder,
    required this.initialView,
    required this.onRootPop,
  });

  @override
  State<TabPageWrapper> createState() => _TabPageWrapperState();
}

class _TabPageWrapperState extends State<TabPageWrapper>
    with AutomaticKeepAliveClientMixin {
  // Kunci #1: Jaga state tetap hidup
  @override
  bool get wantKeepAlive => true;

  // key untuk akses FolderPage state
  final GlobalKey<FolderPageState> _folderKey = GlobalKey();

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
        key: _folderKey,
        initialFolder: widget.rootFolder,
        initialView: widget.initialView,
        onRootPop: widget.onRootPop,
      ),
    );
  }
}
