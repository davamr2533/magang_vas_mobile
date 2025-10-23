import 'package:flutter/material.dart';

// ENUM untuk opsi
enum SortBy { name, modifiedDate, modifiedByMe, openedByMe }
enum SortOrder { asc, desc, date }
enum ViewOption { grid, list }

class SortAndViewOption extends StatelessWidget {
  final SortBy selectedSortBy;
  final SortOrder selectedSortOrder;
  final ViewOption selectedView;
  final ValueChanged<SortBy> onSortByChanged;
  final ValueChanged<SortOrder> onSortOrderChanged;
  final ValueChanged<ViewOption> onViewChanged;

  const SortAndViewOption({
    super.key,
    required this.selectedSortBy,
    required this.selectedSortOrder,
    required this.selectedView,
    required this.onSortByChanged,
    required this.onSortOrderChanged,
    required this.onViewChanged,
  });

  // 🔤 Label dinamis berdasarkan pilihan sort
  String _getSortLabel(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.name:
        return "Nama";
      case SortBy.modifiedDate:
        return "Tanggal diubah";
      case SortBy.modifiedByMe:
        return "Tanggal diubah oleh saya";
      case SortBy.openedByMe:
        return "Tanggal dibuka oleh saya";
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.bodyMedium!;

    // 🔼 Icon arah sort dinamis
    final sortDirectionIcon = selectedSortOrder == SortOrder.asc
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ========== Popup untuk Sort ==========
          PopupMenuButton<int>(
            tooltip: "Urutkan berdasarkan",
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.pink[50],
            onSelected: (value) {
              if (value == 1) onSortByChanged(SortBy.name);
              if (value == 2) onSortByChanged(SortBy.modifiedDate);
              if (value == 3) onSortByChanged(SortBy.modifiedByMe);
              if (value == 4) onSortByChanged(SortBy.openedByMe);
              if (value == 5) onSortOrderChanged(SortOrder.asc);
              if (value == 6) onSortOrderChanged(SortOrder.desc);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(
                  "Urutkan berdasarkan",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const PopupMenuDivider(),
              ...[
                MapEntry(1, "Nama"),
                MapEntry(2, "Tanggal diubah"),
                MapEntry(3, "Tanggal diubah oleh saya"),
                MapEntry(4, "Tanggal dibuka oleh saya"),
              ].map(
                    (entry) => PopupMenuItem(
                  value: entry.key,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.value, style: style),
                      _isSortSelected(entry.key)
                          ? const Icon(Icons.check, color: Colors.black)
                          : const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("A ke Z", style: style),
                    if (selectedSortOrder == SortOrder.asc)
                      const Icon(Icons.check, color: Colors.black),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Z ke A", style: style),
                    if (selectedSortOrder == SortOrder.desc)
                      const Icon(Icons.check, color: Colors.black),
                  ],
                ),
              ),
            ],
            // ==== Teks & ikon utama berubah dinamis ====
            child: Row(
              children: [
                Icon(sortDirectionIcon, size: 18, color: Colors.black87),
                const SizedBox(width: 6),
                Text(
                  _getSortLabel(selectedSortBy),
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),

          // ========== Toggle View ==========
          IconButton(
            tooltip: "Ubah tampilan",
            icon: Icon(
              selectedView == ViewOption.grid
                  ? Icons.grid_view_rounded
                  : Icons.list_rounded,
              color: Colors.black87,
            ),
            onPressed: () {
              onViewChanged(
                selectedView == ViewOption.grid
                    ? ViewOption.list
                    : ViewOption.grid,
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isSortSelected(int value) {
    switch (value) {
      case 1:
        return selectedSortBy == SortBy.name;
      case 2:
        return selectedSortBy == SortBy.modifiedDate;
      case 3:
        return selectedSortBy == SortBy.modifiedByMe;
      case 4:
        return selectedSortBy == SortBy.openedByMe;
      default:
        return false;
    }
  }
}
