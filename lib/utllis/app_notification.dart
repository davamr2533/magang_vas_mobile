import 'dart:io';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:open_filex/open_filex.dart';

class NotificationService {
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, // gunakan ikon default atau ganti dengan path custom
      [
        NotificationChannel(
          channelKey: 'download_channel',
          channelName: 'Download',
          channelDescription: 'Download progress dan selesai',
          defaultColor: const Color(0xFF2196F3),
          ledColor: const Color(0xFFFFFFFF),
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'upload_channel',
          channelName: 'Upload',
          channelDescription: 'Upload progress dan selesai',
          defaultColor: const Color(0xFF4CAF50),
          ledColor: const Color(0xFFFFFFFF),
          importance: NotificationImportance.High,
        ),
      ],

    );

    // Request permission notifikasi
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Listener untuk payload saat notifikasi ditekan
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        final payload = receivedAction.payload?['filePath'];
        if (payload != null) {
          await openDownloadedFile(payload);
        }
      },
    );

  }

  static String _formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.bitLength - 1) ~/ 10;
    if (i >= suffixes.length) i = suffixes.length - 1;
    double size = bytes / (1 << (i * 10));
    return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  // ----------------- DOWNLOAD -----------------
  static Future<void> showDownloadProgress({
    required int received,
    required int total,
    required String speed,
  }) async {
    final double progress = total > 0 ? (received / total) * 100.0 : 0.0;
    final String progressText =
        "${_formatBytes(received)} / ${_formatBytes(total)} • $speed";

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1001,
        channelKey: 'download_channel',
        title: 'Mengunduh... $progress%',
        body: progressText,
        notificationLayout: NotificationLayout.ProgressBar,
        payload: {'filePath': ''}, // kosong dulu, nanti diisi saat selesai
        locked: true,
        progress: progress,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
    );
  }

  static Future<void> showDownloadCompleted(String fileName, String filePath) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1002,
        channelKey: 'download_channel',
        title: 'Berhasil mengunduh',
        body: "File '$fileName' tersimpan di $filePath",
        payload: {'filePath': filePath},
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> cancelDownloadProgress() async {
    await AwesomeNotifications().cancel(1001);
  }

  // ----------------- UPLOAD -----------------
  static Future<void> showUploadProgress({
    required int sent,
    required int total,
    required String speed,
  }) async {
    final double progress = total > 0 ? (sent / total) * 100.0 : 0.0;
    final String progressText =
        "${_formatBytes(sent)} / ${_formatBytes(total)} • $speed";

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2001,
        channelKey: 'upload_channel',
        title: 'Mengunggah... $progress%',
        body: progressText,
        notificationLayout: NotificationLayout.ProgressBar,
        locked: true,
        progress: progress,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
    );
  }

  static Future<void> showUploadCompleted() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2002,
        channelKey: 'upload_channel',
        title: 'Upload Selesai',
        body: 'File berhasil diunggah',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> cancelUploadProgress() async {
    await AwesomeNotifications().cancel(2001);
  }

  // ----------------- OPEN FILE -----------------
  static Future<void> openDownloadedFile(String payload) async {
    if (payload.startsWith('content://')) {
      await OpenFilex.open(payload);
    } else {
      final file = File(payload);
      if (await file.exists()) {
        await OpenFilex.open(file.path);
      }
    }
  }
}
