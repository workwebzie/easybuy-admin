class AnnouncementModel {
  final String id;
  final String title;
  final String body;
  final String imageUrl;
  final String type; // 'all', 'promo', 'alert', 'update'
  final bool isSent;
  final DateTime createdAt;
  final DateTime? sentAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl = '',
    this.type = 'all',
    this.isSent = false,
    required this.createdAt,
    this.sentAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json, String id) {
    return AnnouncementModel(
      id: id,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? 'all',
      isSent: json['isSent'] ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt']
              : DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      sentAt: json['sentAt'] != null
          ? DateTime.tryParse(json['sentAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'type': type,
      'isSent': isSent,
      'createdAt': createdAt.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
    };
  }

  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    String? type,
    bool? isSent,
    DateTime? createdAt,
    DateTime? sentAt,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      isSent: isSent ?? this.isSent,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}
