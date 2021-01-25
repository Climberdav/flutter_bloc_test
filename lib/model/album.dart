import 'dart:convert';

import 'package:equatable/equatable.dart';

List<Album> albumFromJson(String str) =>
    List<Album>.from(json.decode(str).map((x) => Album.fromJson(x)));

String albumToJson(List<Album> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Album extends Equatable {
  int userId;
  int id;
  String title;

  Album({
    this.userId,
    this.id,
    this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
      );

  factory Album.fromItem(Album album) {
    if (album == null) {
      return null;
    }
    return Album(title: album.title, userId: album.userId);
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
      };

  @override
  List<Object> get props => [title, userId];
}
