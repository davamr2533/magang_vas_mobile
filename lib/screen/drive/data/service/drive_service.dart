import 'package:dio/dio.dart';
import 'package:vas_reporting/screen/drive/data/model/body/rename_drive_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/starred_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_to_trash_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/delete_drive_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/recovery_drive_body.dart';
import '../model/body/add_folder_body.dart';
import '../model/response/drive_response.dart';
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
  Future<DriveResponse> addFolder(
    @Header("Authorization") String token,
    @Body() AddFolderBody body,
  );

  @MultiPart()
  @POST(basePaths.urlUploadFile)
  Future<DriveResponse> uploadFile(
      @Header("Authorization") String token,
      @Part(name: "file") MultipartFile file,
      @Part(name: "id") int id,
      @Part(name: "user_id") String userId,
      );

  @PATCH(basePaths.urlRenameDrive)
  Future<HttpResponse> renameItem(
      @Header("Authorization") String token,
      @Body() RenameDriveBody body,
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
      @Body() StarredBody body,
      );

  @POST(basePaths.urlTrashed)
  Future<DriveResponse> addToTrash(
      @Header("Authorization") String token,
      @Body() AddToTrashBody body,
      );

  @POST(basePaths.urlRecovery)
  Future<DriveResponse> recoveryDrive(
      @Header("Authorization") String token,
      @Body() RecoveryDriveBody body,
      );

  @DELETE(basePaths.urlDelete)
  Future<DriveResponse> deleteDrive(
      @Header("Authorization") String token,
      @Body() DeleteDriveBody body,
      );
}
