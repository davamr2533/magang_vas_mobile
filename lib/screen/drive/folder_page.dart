import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget {
  final String folderName;

  const FolderPage({super.key, required this.folderName});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: Text(widget.folderName),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Isi dari folder: ${widget.folderName}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
