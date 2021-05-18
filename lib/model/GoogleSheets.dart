// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

Categories categoriesFromJson(String str) =>
    Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  String range;
  String majorDimension;
  List<List<String>> values;

  Categories({
    this.range,
    this.majorDimension,
    this.values,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        range: json["range"],
        majorDimension: json["majorDimension"],
        values: List<List<String>>.from(
            json["values"].map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "range": range,
        "majorDimension": majorDimension,
        "values": List<dynamic>.from(
            values.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
