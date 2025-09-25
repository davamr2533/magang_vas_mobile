import 'package:flutter/material.dart';

enum SortOption { nameAsc, nameDesc, date }
enum ViewOption { grid, list }

class SortAndViewBar extends StatelessWidget {
  final SortOption currentSort;
  final ViewOption currentView;
  final TextStyle style;
  final ValueChanged<SortOption> onSortChanged;
  final ValueChanged<ViewOption> onViewChanged;

  const SortAndViewBar({
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
          // Dropdown Sort
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
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                ),
              ],
            ),
          ),

          // Toggle View
          IconButton(
            icon: Icon(
              currentView == ViewOption.grid
                  ? Icons.grid_view
                  : Icons.list,
            ),
            onPressed: () {
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


