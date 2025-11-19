import 'package:flutter/material.dart';
import '../../../base/amikom_color.dart';

class FolderAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback popFolder;
  final Function(String) onQueryChanged;
  final int folderId;
  final bool isTrashed;
  final String title;

  const FolderAppBar({
    super.key,
    required this.onQueryChanged,
    required this.popFolder,
    required this.folderId,
    required this.isTrashed,
    required this.title,
  });

  @override
  State<FolderAppBar> createState() => _FolderAppBarState();

  @override
  Size get preferredSize {
    double baseHeight = kToolbarHeight;
    double extraHeight = 0.0;

    if (folderId == -3 || isTrashed) {
      extraHeight += 36.0;
    }
    return Size.fromHeight(baseHeight + extraHeight);
  }
}

class _FolderAppBarState extends State<FolderAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      widget.onQueryChanged('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final folderId = widget.folderId;
    final isTrashed = widget.isTrashed;

    return AppBar(
      backgroundColor: magnoliaWhiteNewAmikom,
      automaticallyImplyLeading: false,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () {
          if (_isSearching) {
            _stopSearch();
          } else {
            widget.popFolder();
          }
        },
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _isSearching
            ? TextField(
                key: const ValueKey('searchField'),
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  widget.onQueryChanged(value);
                  setState(() {});
                },
              )
            : Text(
                key: const ValueKey('titleText'),
                title,
                style: const TextStyle(color: Colors.black),
              ),
      ),
      centerTitle: true,
      actionsPadding: const EdgeInsets.only(right: 12),
      actions: [
        if (_isSearching)
          if (_searchController.text.isNotEmpty)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 1.0),
              duration: const Duration(milliseconds: 150),
              builder: (context, scale, child) {
                return AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 150),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      setState(() {});

                      Future.delayed(const Duration(milliseconds: 100), () {
                        _searchController.clear();
                        widget.onQueryChanged('');
                        setState(() {});
                      });
                    },
                  ),
                );
              },
            )
          else
            const SizedBox(width: 48),
        if (!_isSearching)
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              _startSearch();
            },
          ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(
          (folderId == -3 || isTrashed == true) ? 37.0 : 1.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(color: Colors.grey.shade300, height: 1.0),
            if (folderId == -3 || isTrashed == true)
              Container(
                width: double.infinity,
                color: Colors.red.shade100,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Item dihapus selamanya setelah 30 hari.',
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
