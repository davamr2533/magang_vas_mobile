import 'package:flutter/material.dart';

// <<====== ENUM UNTUK SORT DAN VIEW ======>>
enum SortOption { nameAsc, nameDesc, date } // opsi urutkan
enum ViewOption { grid, list }              // opsi tampilan

// <<====== WIDGET SORT & VIEW OPTION ======>>
class SortAndViewOption extends StatelessWidget {
  final SortOption currentSort;                     // sort yang aktif
  final ViewOption currentView;                     // tampilan yang aktif
  final TextStyle style;                            // gaya teks
  final ValueChanged<SortOption> onSortChanged;     // callback ubah sort
  final ValueChanged<ViewOption> onViewChanged;     // callback ubah view

  const SortAndViewOption({
    super.key,
    required this.currentSort,
    required this.currentView,
    required this.onSortChanged,
    required this.onViewChanged,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // <<====== DROPDOWN SORT ======>>
          PopupMenuButton<SortOption>(
            onSelected: onSortChanged,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortOption.nameAsc,
                child: Text("Nama ↑", style: style),
              ),
              PopupMenuItem(
                value: SortOption.nameDesc,
                child: Text("Nama ↓", style: style),
              ),
              PopupMenuItem(
                value: SortOption.date,
                child: Text("Tanggal", style: style),
              ),
            ],
            child: Row(
              children: [
                Text("Nama", style: style),
                Icon(
                  currentSort == SortOption.nameAsc
                      ? Icons.arrow_upward   // kalau urut naik
                      : Icons.arrow_downward, // kalau urut turun
                  size: 16,
                ),
              ],
            ),
          ),

          // <<====== TOGGLE VIEW (GRID / LIST) ======>>
          IconButton(
            icon: Icon(
              currentView == ViewOption.grid
                  ? Icons.grid_view  // tampilan grid
                  : Icons.list,      // tampilan list
            ),
            onPressed: () {
              // ubah state view
              onViewChanged(
                currentView == ViewOption.grid
                    ? ViewOption.list
                    : ViewOption.grid,
              );
            },
          ),
        ],
      ),
    );
  }
}
