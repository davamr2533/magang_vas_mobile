
import 'package:dio/dio.dart';
import 'package:vas_reporting/screen/drive/data/model/body/starred_body.dart';
import '../model/body/add_folder_body.dart';
import '../model/response/add_folder_response.dart';
import 'base_paths.dart' as basePaths;
import 'package:retrofit/retrofit.dart';
import 'package:vas_reporting/screen/drive/data/model/response/get_data_drive_response.dart';

part 'drive_service.g.dart';


@RestApi()
abstract class DriveService {
  factory DriveService(Dio dio, {String baseUrl}) = _DriveService;

  @GET(basePaths.urlGetAllDrive)
  Future<GetDataDriveResponse> getAllDrive(
      @Header("Authorization") String token,
      );

  @POST(basePaths.urlAddFolder)
  Future<AddFolderResponse> addFolder(
      @Header("Authorization") String token,
      @Body() AddFolderBody body
      );

  // 🆕 Ubah nama file atau folder
  @POST(basePaths.urlRenameDrive)
  Future<HttpResponse> renameItem(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> body,
      );

  // 🆕 Tandai file/folder sebagai berbintang
  @POST(basePaths.urlStarred)
  Future<HttpResponse> starItem(
      @Header("Authorization") String token,
      @Body() StarredBody body,
      );

  // 🆕 Hapus tanda bintang
  @POST(basePaths.urlUnstarred)
  Future<HttpResponse> unstarItem(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> body,
      );
}
