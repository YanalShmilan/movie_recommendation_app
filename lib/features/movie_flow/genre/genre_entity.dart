import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class GenreEntity {
  final int id;
  final String name;
  const GenreEntity({
    required this.id,
    required this.name,
  });

  GenreEntity copyWith({
    int? id,
    String? name,
  }) {
    return GenreEntity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory GenreEntity.fromMap(Map<String, dynamic> map) {
    return GenreEntity(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GenreEntity.fromJson(String source) => GenreEntity.fromMap(json.decode(source));

  @override
  String toString() => 'GenreEntity(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GenreEntity &&
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
