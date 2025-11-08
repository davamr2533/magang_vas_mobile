import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../base/amikom_color.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onQueryChanged;
  final Function(String?) onFilterChanged;
  final VoidCallback? onUnfocus;

  const CustomSearchBar({
    super.key,
    required this.onQueryChanged,
    required this.onFilterChanged,
    this.onUnfocus
  });

  @override
  State<CustomSearchBar> createState() => CustomSearchBarState();
}

class CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // update icon search ↔ clear secara dinamis
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Future<bool> _handleWillPop() async {
  //   if (_focusNode.hasFocus) {
  //     _focusNode.unfocus();
  //     return false;
  //   }
  //   return true;
  // }

  void unfocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      FocusScope.of(context).requestFocus(FocusNode()); // node dummy
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
          return;
        }
        Navigator.of(context).maybePop();
      },
      child: Row(
        children: [
          // Search field
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                onChanged: widget.onQueryChanged,
                style: GoogleFonts.urbanist(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search document",
                  hintStyle: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: pinkNewAmikom,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  // Ganti icon dinamis
                  suffixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return RotationTransition(
                            turns: child.key == const ValueKey('search')
                                ? Tween<double>(
                                    begin: 0.75,
                                    end: 1,
                                  ).animate(animation)
                                : Tween<double>(
                                    begin: 1.25,
                                    end: 1,
                                  ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                    child: _searchController.text.isEmpty
                        ? const Icon(
                            Icons.search,
                            key: ValueKey('search'),
                            color: Colors.grey,
                          )
                        : IconButton(
                            key: const ValueKey('clear'),
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              widget.onQueryChanged('');
                              setState(() {});
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Filter button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: pinkNewAmikom,
              borderRadius: BorderRadius.circular(8),
            ),
            child: PopupMenuButton<String>(
              color: const Color(0xFFFFC1B6),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: selectedFilter != null
                    ? Icon(
                        IconlyBold.closeSquare,
                        key: const ValueKey('close'),
                        color: orangeNewAmikom,
                      )
                    : Icon(
                        IconlyBold.filter,
                        key: const ValueKey('filter'),
                        color: orangeNewAmikom,
                      ),
              ),
              itemBuilder: (context) => [
                if (selectedFilter != null)
                  PopupMenuItem<String>(
                    value: "CLEAR_FILTER",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Clear Filter",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const PopupMenuDivider(),
                _buildMenuItem(Icons.folder, "Folders"),
                _buildMenuItemSvg("assets/word.svg", "Word"),
                _buildMenuItemSvg("assets/excel.svg", "Excel"),
                _buildMenuItemSvg("assets/pdf.svg", "PDFs"),
                _buildMenuItem(Icons.image, "Photos & Images"),
              ],
              onSelected: (value) {
                if (value == "CLEAR_FILTER") {
                  setState(() => selectedFilter = null);
                  widget.onFilterChanged(null);
                } else {
                  setState(() => selectedFilter = value);
                  widget.onFilterChanged(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Menu item with IconData
  PopupMenuItem<String> _buildMenuItem(IconData icon, String title) {
    final bool isSelected = selectedFilter == title;

    return PopupMenuItem<String>(
      value: title,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: orangeNewAmikom),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: isSelected ? orangeNewAmikom : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (isSelected) Icon(Icons.check, color: orangeNewAmikom, size: 18),
        ],
      ),
    );
  }

  /// Menu item with SVG icon
  PopupMenuItem<String> _buildMenuItemSvg(String assetPath, String title) {
    final bool isSelected = selectedFilter == title;

    return PopupMenuItem<String>(
      value: title,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(assetPath, height: 23, width: 23),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: isSelected ? orangeNewAmikom : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (isSelected) Icon(Icons.check, color: orangeNewAmikom, size: 18),
        ],
      ),
    );
  }
}
