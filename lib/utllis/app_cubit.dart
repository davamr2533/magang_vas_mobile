import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/data/cubit/form/form_cubit.dart';
import 'package:vas_reporting/data/cubit/get_data/get_data_cubit.dart';
import 'package:vas_reporting/data/cubit/login/login_cubit.dart';
import 'package:vas_reporting/screen/drive/data/cubit/add_folder_cubit.dart';
import 'package:vas_reporting/screen/drive/data/cubit/get_drive_cubit.dart';

class AppCubit {
  Widget initCubit(Widget widget) {
    return MultiBlocProvider(providers: [
      BlocProvider<LoginCubit>(
        create: (BuildContext context) => LoginCubit(),
      ),
      BlocProvider< FormCubit>(
        create: (BuildContext context) => FormCubit(),
      ),
      BlocProvider< GetDataCubit>(
        create: (BuildContext context) => GetDataCubit(),
      ),
      BlocProvider<DriveCubit>(
        create: (BuildContext context) => DriveCubit(),
      ),
      BlocProvider<AddFolderCubit>(
        create: (BuildContext context) => AddFolderCubit(),
      ),
    ], child: widget);
  }
}