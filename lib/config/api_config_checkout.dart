class ApiConfigOrder {
  // ==============================
  // DEVICE / EMULATOR CONFIG
  // ==============================

  /// Laptop IP for physical Android device (same WiFi / LAN)
  static const String laptopIp = "192.168.1.7:8081";

  /// Phone hotspot IP (when backend runs from phone network or LAN)
  static const String phone = "192.168.0.90:8081";

  /// Android Emulator → maps to your PC localhost
  static const String emulatorHost = "192.168.0.90:8081";



  /// Switch environment:
  /// true  = physical Android device
  /// false = Android emulator
  static const bool usePhysicalDevice = false;

  /// Auto-selected host
  static String get _host => usePhysicalDevice ? phone : laptopIp;

  /// Base API → matches backend `/api/**`
  static String get apiBase => "http://$_host/api";

  // ==============================
  // ORDER ENDPOINTS
  // ==============================

  /// POST /api/orders/checkout
  static String get checkout => "$apiBase/orders/checkout";

  /// GET /api/orders
  static String get myOrders => "$apiBase/orders";
}
