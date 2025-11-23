class ApiConfigPayment {
  // ================== HOST ==================
  static const String laptopIp = "192.168.1.5:8081"; // <-- your backend
  static const String emulatorHost = "10.0.2.2:8081";

  /// If you test on physical phone → true
  static const bool usePhysicalDevice = false;

  static String get _host => usePhysicalDevice ? laptopIp : emulatorHost;

  /// main API prefix
  static String get apiBase => "http://$_host/api";

  // ================== PAYMENT ==================
  /// POST -> /api/payment
  static String get pay => "$apiBase/payment";

  /// GET -> /api/payment/me
  static String get lastPayment => "$apiBase/payment/me";
}
