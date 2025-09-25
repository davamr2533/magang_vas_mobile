import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderCard extends StatelessWidget {
  final String title;
  final void Function(String)? onTap;

  const FolderCard({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onTap?.call(title),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) => _buildBottomSheet(context),
                    );
                  },
                ),
              ],
            ),

            // icon folder
            const Flexible(
              child: Icon(Icons.folder, size: 100, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.folder, color: Colors.deepOrange, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.drive_file_rename_outline,
              color: Colors.deepOrange),
          title: const Text("Ganti nama"),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline, color: Colors.deepOrange),
          title: const Text("Detail informasi"),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.star_border, color: Colors.deepOrange),
          title: const Text("Hapus dari berbintang"),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline, color: Colors.deepOrange),
          title: const Text("Hapus"),
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
