class ApiConfig {
  // ==============================
  // DEVICE MODES
  // ==============================
  static const bool usePhysicalDevice = false;
  static const bool useEmulator = true;

  // ==============================
  // HOSTS (customize yours)
  // ==============================
  static const String laptopIp     = "192.168.1.7:8081";
  static const String phone        = "192.168.0.90:8081";
  static const String emulatorHost = "10.0.2.2:8081";

  static String get _host {
    if (useEmulator) return emulatorHost;
    if (usePhysicalDevice) return phone;
    return laptopIp;
  }

  // ==============================
  // BASE URLs
  // ==============================
  static String get apiBase  => "http://$_host/api";
  static String get fileBase => "http://$_host";

  // ==============================
  // PRODUCTS
  // ==============================
  static String get products => "$apiBase/products";
  static String productById(int id) => "$apiBase/products/$id";
  static String productsByCategory(int categoryId) =>
      "$apiBase/products/category/$categoryId";

  // ==============================
  // CATEGORIES
  // ==============================
  static String get categories => "$apiBase/categories";

  // ==============================
  // IMAGE FIXER
  // ==============================
  static String fixImage(String? raw) {
    if (raw == null || raw.isEmpty) return "";

    String url = raw.trim();

    /// Already full URL?
    if (url.startsWith("http://") || url.startsWith("https://")) {
      return url;
    }

    /// If backend returns `/uploads/abc.png`
    if (url.startsWith("/uploads")) {
      return "$fileBase$url";
    }

    /// If backend returns plain `uploads/abc.png`
    if (!url.startsWith("/")) {
      url = "/$url";
    }

    return "$fileBase$url";
  }
}
