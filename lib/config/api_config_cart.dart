// lib/config/api_config_cart.dart

class ApiConfigCart {
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

  // ==========================================================
  // =                    CART ENDPOINTS                     =
  // ==========================================================

  static String get getCart => "$apiBase/cart";

  static String get add => "$apiBase/cart/add";

  static String get update => "$apiBase/cart/update";

  static String increase(int itemId) => "$apiBase/cart/increase/$itemId";

  static String decrease(int itemId) => "$apiBase/cart/decrease/$itemId";

  static String remove(int itemId) => "$apiBase/cart/remove/$itemId";

  static String get clear => "$apiBase/cart/clear";
}