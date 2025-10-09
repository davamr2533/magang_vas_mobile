import 'package:vas_reporting/base/base_paths.dart' as basePaths;

const String url = basePaths.url;

//get all drive
const String urlGetAllDrive = "${url}api/v1/vas/get-drive";

//add folder
const String urAddFolder = "${url}api/v1/vas/insert-folder-drive";

//upload file
const String urlUploadFile = "${url}api/v1/vas/upload-drive";

//rename
const String urlRenameDrive = "${url}api/v1/vas/rename-drive";

//starred
const String urlStarred = "${url}api/v1/vas/starred-drive";
const String urlUnstarred = "${url}api/v1/vas/unstarred-drive";

//trashed
const String urlTrashed = "${url}api/v1/vas/trashed-drive";
const String urlRecovery = "${url}api/v1/vas/recovery-drive";
const String urlDelete = "${url}api/v1/vas/delete-drive";


