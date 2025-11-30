class CategoryModel {
  final int id;
  final String name;
  final bool active;

  CategoryModel({
    required this.id,
    required this.name,
    required this.active,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      active: json["active"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'active': active,
    };
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, active: $active)';
  }
}