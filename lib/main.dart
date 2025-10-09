import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/screen/home/home_page.dart';
import 'package:vas_reporting/screen/splash_page.dart';
import 'package:vas_reporting/utllis/app_cubit.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import 'package:vas_reporting/utllis/app_utlis.dart';
import 'package:vas_reporting/base/base_paths.dart' as basePaths;

import 'utllis/app_services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final appCubit = AppCubit();
  bool isLogin = await SharedPref.getToken() == null ? false : true;
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent, 
      systemNavigationBarIconBrightness: Brightness.dark, 
    ),
  );
  await registerAppServices();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(appCubit.initCubit(MyApp(isLogin: isLogin,))));
}

Future<void> registerAppServices() async {
  final appUtil = AppUtils();
  appUtil.initNetwork();
  final appServices = AppServices(GetIt.I.get<Dio>());
  final url = basePaths.url;
  await appServices.registerAppServices(url);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLogin});
  final bool isLogin;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAS Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLogin ? HomePage() : SplashscreenPage()
    );
  }
}
