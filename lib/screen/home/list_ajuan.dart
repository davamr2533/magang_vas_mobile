import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/data/cubit/get_data/get_data_cubit.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart' as GetDataResponse;
import 'package:vas_reporting/base/base_colors.dart' as baseColors;

class MyTaskPage extends StatefulWidget {
  const MyTaskPage({super.key});

  @override
  State<MyTaskPage> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends State<MyTaskPage> {
  String selectedFilter = "All";
  bool _isLoading = false;
  List<GetDataResponse.Data> getDataList = [];
  final Map<String, Color>
  statusColors = {
    "Submitted": const Color.fromARGB(255, 172, 189, 249),
    "Approve": const Color.fromARGB(255, 252, 212, 153),
    "Progress": const Color.fromARGB(255, 186, 234, 154),
    "Production": const Color.fromARGB(255, 218, 196, 255),
    "Decline": const Color.fromARGB(255, 255, 184, 184), 
  };
  Map<String, int> taskCounts = {
  "Submitted": 0,
  "Approve": 0,
  "Progress": 0,
  "Production": 0,
  "Decline": 0,
};

@override
Widget build(BuildContext context) {
  final filteredTasks = selectedFilter == "All"
      ? getDataList
      : getDataList.where((t) => t.statusAjuan == selectedFilter).toList();

  return BlocListener<GetDataCubit, GetDataHasState>(
    listener: (context, state) {
      if (state is GetDataLoading) {
        setState(() {
          _isLoading = true;
        });
      }
      if (state is GetDataFailure) {
        setState(() {
          _isLoading = false;
        });
      }
      if (state is GetDataSuccess) {
        setState(() {
          _isLoading = false;
          if (state.response.data != null &&
              state.response.data!.isNotEmpty) {
            getDataList = state.response.data!;
            taskCounts = {
              "Submitted": getDataList.where((t) => t.statusAjuan == "Submitted").length,
              "Approve": getDataList.where((t) => t.statusAjuan == "Approve").length,
              "Progress": getDataList.where((t) => t.statusAjuan == "Progress").length,
              "Production": getDataList.where((t) => t.statusAjuan == "Production").length,
              "Decline": getDataList.where((t) => t.statusAjuan == "Decline").length,
            };
          }
        });
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Task"),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", ...statusColors.keys].map((status) {
                  final isSelected = selectedFilter == status;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      selectedColor: status == "All"
                          ? baseColors.primaryColor
                          : statusColors[status],
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = status;
                        });
                      },
                      labelStyle: GoogleFonts.urbanist(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sections: taskCounts.entries.map((entry) {
                    final status = entry.key;
                    final count = entry.value;
                    final total = getDataList.length == 0
                        ? 1 
                        : getDataList.length;
                    final percent = (count / total) * 100;
                    return PieChartSectionData(
                      color: statusColors[status],
                      value: count.toDouble(),
                      title: "${percent.toStringAsFixed(0)}%",
                      titleStyle: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      radius: 50,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: statusColors[task.statusAjuan] ?? Colors.grey,
                          width: 6,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.sistem ?? '-',
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 1, 46, 82),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.jenis ?? '-',
                              style:
                                  GoogleFonts.urbanist(color: Colors.grey),
                            ),
                            Text(
                              task.divisi ?? '-',
                              style:
                                  GoogleFonts.urbanist(color: Colors.grey),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColors[task.statusAjuan],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            task.statusAjuan ?? '',
                            style:
                                GoogleFonts.urbanist(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}