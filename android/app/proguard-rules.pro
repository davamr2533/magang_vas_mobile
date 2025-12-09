# Keep Flutter local notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep FileProvider for OpenFilex
-keep class androidx.core.content.FileProvider { *; }

# Keep DocumentFile / MediaStore classes
-keep class androidx.documentfile.** { *; }
-keep class android.provider.** { *; }

# Gson generics
-keepattributes Signature
-keepattributes *Annotation*

# Keep model classes yang dipakai Gson (contoh jika kamu punya class model)
-keep class com.example.vas_reporting.** { *; }
