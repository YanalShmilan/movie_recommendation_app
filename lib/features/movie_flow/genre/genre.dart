
import 'package:flutter/foundation.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/genre/genre_entity.dart';
@immutable 
class Genre {
final String name;
final bool isSelected;
final int id;
  const Genre({
    required this.name,
    this.isSelected = false,
    this.id = 0,
  });

  Genre toggleSelected() {
    return Genre(
      name: name,
      isSelected: !isSelected,
      id: id,
    );
  }

  Genre copyWith({
    String? name,
    bool? isSelected,
    int? id,
  }) {
    return Genre(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      id: id ?? this.id,
    );
  }

  factory Genre.fromEntity(GenreEntity entity){
    return Genre(
      name: entity.name,
      isSelected: false,
      id: entity.id,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Genre &&
      other.name == name &&
      other.isSelected == isSelected &&
      other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ isSelected.hashCode ^ id.hashCode;
}
