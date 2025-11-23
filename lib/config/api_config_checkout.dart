class ApiConfigOrder {
  // ==============================
  // DEVICE / EMULATOR CONFIG
  // ==============================

  static const String laptopIp = "192.168.1.5:8081";  // phone wifi
  static const String emulatorHost = "10.0.2.2:8081"; // emulator → localhost

  static const bool usePhysicalDevice = false;

  static String get _host => usePhysicalDevice ? laptopIp : emulatorHost;

  // backend uses `/api/**`
  static String get apiBase => "http://$_host/api";

  // ==============================
  // ORDER ENDPOINTS
  // ==============================

  /// POST /api/orders/checkout
  static String get checkout => "$apiBase/orders/checkout";

  /// GET /api/orders
  static String get myOrders => "$apiBase/orders";
}
