

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget{
 const FolderPage({super.key});

  @override
  State<FolderPage> createState()  => _FolderPageState();
}

class _FolderPageState extends State<FolderPage>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); //Navigasi kembali ke halaman sebelumnya
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
      ),
    );
  }
}