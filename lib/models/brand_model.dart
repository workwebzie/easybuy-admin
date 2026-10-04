class BrandModel {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  BrandModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.description = '',
    this.isActive = true,
    required this.createdAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json, String id) {
    return BrandModel(
      id: id,
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt']
              : DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  BrandModel copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? description,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
