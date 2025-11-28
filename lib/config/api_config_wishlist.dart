class ApiConfigWishlist {
  // ================== HOST / ENV ==================
  static const String laptopIp = "192.168.1.7:8081";
  static const String phone = "10.50.155.44:8081";
  static const String emulatorHost = "192.168.1.7:8081";

  /// Physical = true / Emulator = false
  static const bool usePhysicalDevice = false;

  static String get _host => usePhysicalDevice ? laptopIp : emulatorHost;

  static String get apiBase => "http://$_host/api";
  static String get fileBase => "http://$_host";

  // ================== WISHLIST ==================
  static String get wishlist => "$apiBase/wishlist";
  static String addWishlist(int pid) => "$apiBase/wishlist/add/$pid";
  static String removeWishlist(int pid) => "$apiBase/wishlist/remove/$pid";

  // ===================================================
  // UNIVERSAL IMAGE FIX
  // ===================================================
  static String fixImage(String? raw) {
    if (raw == null) return "";

    String url = raw.trim();

    // Already full HTTP URL → ensure /api
    if (url.startsWith("http://") || url.startsWith("https://")) {
      if (!url.contains("/api/")) {
        return url.replaceFirst("/uploads", "/api/uploads");
      }
      return url;
    }

    // Relative → force correct
    // "/uploads/..." or "uploads/..."
    if (!url.startsWith("/")) url = "/$url";
    if (!url.startsWith("/api")) url = "/api$url";

    return "$fileBase$url";
  }
}
