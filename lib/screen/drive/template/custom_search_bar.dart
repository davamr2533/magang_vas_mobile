import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';

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
                setState(() => query = val);
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

        // Custom filter menu
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
            icon: Icon(IconlyBold.filter, color: orangeNewAmikom),
            itemBuilder: (context) => [
              _buildMenuItem(Icons.folder, "Folders"),
              _buildMenuItem(Icons.description, "Word"),
              _buildMenuItem(Icons.grid_on, "Excel"),
              _buildMenuItem(Icons.slideshow, "Presentation"),
              _buildMenuItem(Icons.list_alt, "Forms"),
              _buildMenuItem(Icons.image, "Photos & Image"),
              _buildMenuItem(Icons.video_library, "Videos"),
              _buildMenuItem(Icons.music_note, "Audio"),
              _buildMenuItem(Icons.archive, "ZIP"),
            ],
            onSelected: (value) {
              // handle selection
              print("Selected: $value");
            },
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String title) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.urbanist(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
