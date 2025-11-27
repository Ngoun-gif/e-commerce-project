class ApiConfigAuth {
  /// Laptop IP for physical Android device (same WiFi / LAN)
  static const String laptopIp = "192.168.1.5:8081";

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

  // ===== AUTH =====
  static String get login => "$apiBase/auth/login";
  static String get register => "$apiBase/auth/register";
  static String get refresh => "$apiBase/auth/refresh";
  static String get logout => "$apiBase/auth/logout";

  // ===== USER =====
  static String get me => "$apiBase/users/me";
}
