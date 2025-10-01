import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/screen/UjicobaApiBaru/cubit/uji_cubit.dart';

class UjiPage extends StatefulWidget {
  const UjiPage({super.key});

  @override
  State<UjiPage> createState() => _UjiPageState();
}

class _UjiPageState extends State<UjiPage> {
  @override
  void initState() {
    super.initState();
    context.read<UjiCubit>().fetchUji();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Tracker")),
      body: BlocBuilder<UjiCubit, UjiState>(
        builder: (context, state) {
          if (state is UjiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UjiFailure) {
            return Center(child: Text(state.message));
          } else if (state is UjiSuccess) {
            final tasks = state.tasks;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nomor Pengajuan: ${task.nomorPengajuan}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Progress: ${task.currentProgress}"),
                        Text("Updated By: ${task.updatedBy ?? '-'}"),
                      ],
                    ),
                    children: [
                        const Divider(),
                        const Text("Timeline:"),
                        ...task.timeline.map((t) => ListTile(
                          leading: Icon(
                            t.isDone == "PROCESS"
                                ? Icons.timelapse
                                : t.isDone == "TRUE"
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: t.isDone == "PROCESS"
                                ? Colors.orange
                                : t.isDone == "TRUE"
                                ? Colors.green
                                : Colors.grey,
                          ),
                          title: Text(t.tahap),
                          subtitle: Text(t.updatedAt ?? "Belum tereksekusi"),
                        )),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
