
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// Sesuaikan path import dengan struktur proyekmu
import 'base_paths.dart' as basePaths;
import 'package:vas_reporting/screen/drive/data/model/response/get_data_drive_response.dart';

part 'drive_service.g.dart';


@RestApi()
abstract class DriveService {
  factory DriveService(Dio dio, {String baseUrl}) = _DriveService;

  @GET(basePaths.urlGetAllDrive)
  Future<GetDataDriveResponse> getAllDrive(
      @Header("Authorization") String token,
      );
}