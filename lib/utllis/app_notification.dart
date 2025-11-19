import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_filex/open_filex.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          openPath(response.payload!);
        }
      },
    );

    final platform = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.requestNotificationsPermission();
  }

  static String _formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.bitLength - 1) ~/ 10;
    if (i >= suffixes.length) i = suffixes.length - 1;
    double size = bytes / (1 << (i * 10));
    return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  static Future<void> showProgress({
    required int received,
    required int total,
    required String speed,
  }) async {
    final int progress = total > 0 ? ((received / total) * 100).toInt() : 0;
    final String progressText =
        "${_formatBytes(received)} / ${_formatBytes(total)} • $speed";

    final android = AndroidNotificationDetails(
      'download_channel',
      'Download',
      channelDescription: 'Download progress',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true,
      styleInformation: BigTextStyleInformation(
        progressText,
        contentTitle: 'Mengunduh... $progress%',
        htmlFormatContent: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      1001,
      'Mengunduh... $progress%',
      progressText,
      NotificationDetails(android: android),
    );
  }

  static Future<void> showCompleted(String fileName, String filePath) async {
    final android = AndroidNotificationDetails(
      'download_channel',
      'Download',
      channelDescription: 'Download selesai',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        'File tersimpan di $filePath',
        contentTitle: "Berhasil mengunduh '$fileName'",
        htmlFormatContent: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      1002,
      "Berhasil mengunduh '$fileName'",
      'Tap untuk membuka file',
      NotificationDetails(android: android),
      payload: filePath,
    );
  }

  static Future<void> cancelProgress() async {
    await flutterLocalNotificationsPlugin.cancel(1001);
  }

  static Future<void> showUploadProgress({
    required int sent,
    required int total,
    required String speed,
  }) async {
    final int progress = total > 0 ? ((sent / total) * 100).toInt() : 0;
    final String progressText =
        "${_formatBytes(sent)} / ${_formatBytes(total)} • $speed";

    final android = AndroidNotificationDetails(
      'upload_channel',
      'Upload',
      channelDescription: 'Upload progress',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true,
      styleInformation: BigTextStyleInformation(
        progressText,
        contentTitle: 'Mengunggah... $progress%',
        htmlFormatContent: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      2001,
      'Mengunggah... $progress%',
      progressText,
      NotificationDetails(android: android),
    );
  }

  static Future<void> showUploadCompleted() async {
    final android = AndroidNotificationDetails(
      'upload_channel',
      'Upload',
      channelDescription: 'Upload selesai',
      importance: Importance.high,
      priority: Priority.high,
    );

    await flutterLocalNotificationsPlugin.show(
      2002,
      "Upload Selesai",
      'File berhasil diunggah',
      NotificationDetails(android: android),
    );
  }

  static Future<void> cancelUploadProgress() async {
    await flutterLocalNotificationsPlugin.cancel(2001);
  }

  static void openPath(String filePath) {
    OpenFilex.open(filePath);
  }
}