import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/data/service/form_service.dart';
import 'package:vas_reporting/data/service/get_data_service.dart';
import 'package:vas_reporting/data/service/login_service.dart';

class AppServices {
  final Dio dio;

  AppServices(this.dio);

  final get = GetIt.I;

  registerAppServices(String url) async {
    dio.interceptors.clear();

    dio.options.receiveTimeout = Duration(milliseconds: 35000);
    dio.options.connectTimeout = Duration(milliseconds: 30000);
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true, requestHeader: true, error: true));
    // dio.interceptors.add(DioInterceptor());

    if (!get.isRegistered<LoginService>()) {
      get.registerFactory(() => LoginService(dio, baseUrl: url));
    } else {
      get.unregister<LoginService>();
      get.registerFactory(() => LoginService(dio, baseUrl: url));
    }
    if (!get.isRegistered<FormService>()) {
      get.registerFactory(() => FormService(dio, baseUrl: url));
    } else {
      get.unregister<FormService>();
      get.registerFactory(() => FormService(dio, baseUrl: url));
    }
    if (!get.isRegistered<GetDataService>()) {
      get.registerFactory(() => GetDataService(dio, baseUrl: url));
    } else {
      get.unregister<GetDataService>();
      get.registerFactory(() => GetDataService(dio, baseUrl: url));
    }
  }
}