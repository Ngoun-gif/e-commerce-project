import 'package:flutter_ecom/config/api_config.dart';

class ImageFixer {
  static String fixImagePhoto(String? raw) {
    if (raw == null || raw.isEmpty) return "";

    String url = raw.trim();

    // If already full URL → fix host
    if (url.startsWith("http")) {
      return url
          .replaceAll("localhost:8081", ApiConfig.fileBase.replaceAll("http://", ""))
          .replaceAll("127.0.0.1:8081", ApiConfig.fileBase.replaceAll("http://", ""));
    }

    // Relative path
    if (!url.startsWith("/")) url = "/$url";
    if (!url.startsWith("/api")) url = "/api$url";

    return "${ApiConfig.fileBase}$url";
  }
}
