import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/amikom_color.dart';
import 'package:vas_reporting/screen/drive/folder_page.dart';
import 'package:vas_reporting/tools/routing.dart';

import '../../data/cubit/get_data/get_data_cubit.dart';
import '../../data/model/response/get_data_response.dart' as GetDataResponse;
import '../../tools/popup.dart';
import '../../utllis/app_shared_prefs.dart';

class DriveHome extends StatefulWidget {
  const DriveHome({super.key});

  @override
  State<DriveHome> createState() => _DriveHomeState();
}

class _DriveHomeState extends State<DriveHome> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;
  String? name;
  String? divisi;
  String? jabatan;
  String? token;
  bool isLoading = false;

  List<GetDataResponse.Data> getData = [];
  List<GetDataResponse.Data> getDeadline = [];
  GetDataResponse.Data? deadline;

  late GetDataCubit getDataCubit;
  late PopUpWidget popUpWidget;

  @override
  void initState() {
    super.initState();
    getDataCubit = context.read<GetDataCubit>();
    fetchData();
  }

  void fetchData() async {
    token = await SharedPref.getToken();
    name = await SharedPref.getName();
    divisi = await SharedPref.getDivisi();
    jabatan = await SharedPref.getPosition();

    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> folders = [
    "Daftar pengajuan yang di terima oleh VAS",
    "Data VAS",
    "File approve",
  ];
  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = folders
        .where((f) => f.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //Navigasi kembali ke halaman sebelumnya
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),

          title: Row(
            children: [
              //Text field search document
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    style: GoogleFonts.urbanist(fontSize: 14),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),

                      hintText: "Search Document",
                      hintStyle: GoogleFonts.urbanist(fontSize: 14),
                      filled: true,
                      fillColor: Colors.red[100],

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),

                      //suffixIcon : Icon(IconlyLight.search)
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12),

              //Button untuk Settings filter
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: PopupMenuButton<String>(
                    icon: const Icon(IconlyBold.filter, color: orangeNewAmikom),
                    onSelected: (value) {
                      if (value == 'date') {
                        // TODO: filter by date
                        print("Filter by Date");
                      } else if (value == 'name') {
                        // TODO: filter by name
                        print("Filter by Name");
                      } else if (value == 'type') {
                        // TODO: filter by type
                        print("Filter by Type");
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'date', child: Text("Sort by Date")),
                      PopupMenuItem(value: 'name', child: Text("Sort by Name")),
                      PopupMenuItem(
                        value: 'type',
                        child: Text("Sort by File Type"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Expanded(
          //
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          //     padding: const EdgeInsets.symmetric(horizontal: 12),
          //     decoration: BoxDecoration(
          //       color: Colors.red[100],
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Row(
          //       children: [
          //
          //         //Text Field untuk Search Document
          //         const Icon(Icons.search, color: Colors.black54),
          //         Expanded(
          //           child: TextField(
          //             controller: _searchController,
          //             onChanged: (val) {
          //               setState(() {
          //                 query = val;
          //               });
          //             },
          //             decoration: const InputDecoration(
          //               hintText: "Search document",
          //               border: InputBorder.none,
          //             ),
          //           ),
          //         ),
          //
          //
          //
          //         SizedBox(width: 8),
          //
          //         Container(
          //           width: 50,
          //           decoration: BoxDecoration(
          //             color: greenNewAmikom
          //           ),
          //         )
          //
          //
          //         //Filter
          //         // Container(
          //         //   width: 50,
          //         //   decoration: BoxDecoration(
          //         //     color: Colors.red[100],
          //         //     borderRadius: BorderRadius.circular(12),
          //         //   ),
        ),
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: "My Drive"),
                Tab(text: "Shared Drive"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildDrive(context, filtered, false),
                  const Center(child: Text("Shared Drive Content")),
                ],
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              folders.add("Folder Baru ${folders.length + 1}");
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDrive(BuildContext context, List<String> items, bool isList) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child:
          //isList
          //     ? ListView.builder(
          //         itemCount: items.length,
          //         itemBuilder: (context, index) =>
          //             _buildFolderCard(context, items[index], true),
          //       )
          //     :
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: items
                .map((title) => _buildFolderCard(context, title, true))
                .toList(),
          ),
    );
  }

  Widget _buildFolderCard(BuildContext context, String title, bool isFolder) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (isFolder) {
          Navigator.of(context).pushReplacement(routingPage(FolderPage()));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    title,
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
                      builder: (_) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.folder,
                                  color: Colors.deepOrange,
                                  size: 28,
                                ),
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
                            leading: const Icon(
                              Icons.drive_file_rename_outline,
                              color: Colors.deepOrange,
                            ),
                            title: const Text("Ganti nama"),
                            onTap: () => Navigator.pop(context),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.info_outline,
                              color: Colors.deepOrange,
                            ),
                            title: const Text("Detail informasi"),
                            onTap: () => Navigator.pop(context),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.star_border,
                              color: Colors.deepOrange,
                            ),
                            title: const Text("Hapus dari berbintang"),
                            onTap: () => Navigator.pop(context),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.delete_outline,
                              color: Colors.deepOrange,
                            ),
                            title: const Text("Hapus"),
                            onTap: () => Navigator.pop(context),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Flexible(
              child: Icon(Icons.folder, size: 100, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}
