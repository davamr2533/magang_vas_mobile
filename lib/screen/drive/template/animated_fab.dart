import 'package:flutter/material.dart';

class AnimatedFabMenu extends StatefulWidget {
  const AnimatedFabMenu({super.key});

  @override
  State<AnimatedFabMenu> createState() => _AnimatedFabMenuState();
}

class _AnimatedFabMenuState extends State<AnimatedFabMenu> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (isOpen)
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: _buildFabWithLabel(
              icon: Icons.create_new_folder,
              label: "Folder",
              onTap: () => print("Tambah Folder diklik"),
            ),
          ),

        if (isOpen)
          Padding(
            padding: const EdgeInsets.only(bottom: 140.0),
            child: _buildFabWithLabel(
              icon: Icons.upload_file,
              label: "Upload",
              onTap: () => print("Upload diklik"),
            ),
          ),

        FloatingActionButton(
          heroTag: "mainFab",
          onPressed: () => setState(() => isOpen = !isOpen),
          child: Icon(isOpen ? Icons.close : Icons.add),
        ),
      ],
    );
  }

  Widget _buildFabWithLabel({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        FloatingActionButton(
          heroTag: label,
          mini: true,
          onPressed: onTap,
          child: Icon(icon),
        ),
      ],
    );
  }
}
