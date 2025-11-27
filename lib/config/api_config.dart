class ApiConfig {


// ==========================================================
// =               ENVIRONMENT / NETWORK SETUP              =
// ==========================================================

  /// Laptop IP for physical Android device (same WiFi / LAN)
  static const String laptopIp = "192.168.0.87:8081";

  /// Phone hotspot IP (when backend runs from phone network or LAN)
  static const String phone = "10.93.7.44:8081";

  /// Android Emulator → maps to your PC localhost
  static const String emulatorHost = "10.0.2.2:8081";



  /// Switch environment:
  /// true  = physical Android device
  /// false = Android emulator
  static const bool usePhysicalDevice = false;

  /// Auto-selected host
  static String get _host => usePhysicalDevice ? phone : laptopIp;

  /// Base API → matches backend `/api/**`
  static String get apiBase => "http://$_host/api";

  /// Static file base → matches `/uploads/**`
  static String get fileBase => "http://$_host";



  // ==========================================================
  // =                       PRODUCTS                         =
  // ==========================================================

  static String get products => "$apiBase/products";
  static String productById(int id) => "$apiBase/products/$id";

  // ==========================================================
  // =                       CATEGORIES                       =
  // ==========================================================

  static String get categories => "$apiBase/categories";

  // ==========================================================
  // =                   IMAGE URL FIXER                      =
  // ==========================================================

  static String fixImage(String? raw) {
    if (raw == null || raw.isEmpty) return "";

    String url = raw.trim();

    // ------------ CASE 1: Full URL but missing `/api` ------------
    if (url.startsWith("http://") || url.startsWith("https://")) {
      // fix emulator URL
      if (url.contains("10.0.2.2:8081/uploads")) {
        return url.replaceFirst(
          "10.0.2.2:8081/uploads",
          "10.0.2.2:8081/api/uploads",
        );
      }

      // fix localhost (Swagger mode)
      if (url.contains("localhost:8081/uploads")) {
        return url.replaceFirst(
          "localhost:8081/uploads",
          "localhost:8081/api/uploads",
        );
      }

      return url; // already correct
    }

    // ------------ CASE 2: Relative path --------------------------
    // example: "/uploads/file.png"

    // ensure leading slash
    if (!url.startsWith("/")) {
      url = "/$url";
    }

    // ensure /api prefix
    if (!url.startsWith("/api")) {
      url = "/api$url";
    }

    // final => http://HOST/api/uploads/...
    return "$fileBase$url";
  }
}
