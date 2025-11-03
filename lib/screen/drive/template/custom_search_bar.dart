import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onQueryChanged;
  final Function(String?) onFilterChanged;

  const CustomSearchBar({
    super.key,
    required this.onQueryChanged,
    required this.onFilterChanged,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedFilter;

  final Color pinkNewAmikom = const Color(0xFFFFD1CC);
  final Color orangeNewAmikom = const Color(0xFFFF6F3C);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search field
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                widget.onQueryChanged(val);
              },
              style: GoogleFonts.urbanist(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Search document",
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: pinkNewAmikom,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
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
            icon: selectedFilter != null
                ? Icon(IconlyBold.closeSquare, color: orangeNewAmikom)
                : Icon(IconlyBold.filter, color: orangeNewAmikom),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: "CLEAR_FILTER",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.close, color: Colors.black54, size: 18),
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
              _buildMenuItem(FontAwesomeIcons.fileWord, "Word"),
              _buildMenuItem(FontAwesomeIcons.fileExcel, "Excel"),
              _buildMenuItem(Icons.picture_as_pdf, "PDF"),
              _buildMenuItem(Icons.image, "Photos & Image"),
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
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String title) {
    final bool isSelected = selectedFilter == title;

    return PopupMenuItem<String>(
      value: title,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.redAccent),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: isSelected ? Colors.deepOrange : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (isSelected)
            const Icon(Icons.check, color: Colors.deepOrange, size: 18),
        ],
      ),
    );
  }
}
