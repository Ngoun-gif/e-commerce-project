class ApiConfigAuth {
  static const String laptopIp = "192.168.1.5:8081";
  static const String emulatorHost = "10.0.2.2:8081";

  static const bool usePhysicalDevice = false;

  static String get _host => usePhysicalDevice ? laptopIp : emulatorHost;

  static String get apiBase => "http://$_host/api";

  // ===== AUTH =====
  static String get login => "$apiBase/auth/login";
  static String get register => "$apiBase/auth/register";
  static String get refresh => "$apiBase/auth/refresh";
  static String get logout => "$apiBase/auth/logout";

  // ===== USER =====
  static String get me => "$apiBase/users/me";
}
