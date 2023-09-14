// To parse this JSON data, do
//
//     final latestMoviesModel = latestMoviesModelFromJson(jsonString);

import 'dart:convert';

LatestMoviesModel latestMoviesModelFromJson(String str) =>
    LatestMoviesModel.fromJson(json.decode(str));

String latestMoviesModelToJson(LatestMoviesModel data) =>
    json.encode(data.toJson());

class LatestMoviesModel {
  // Dates dates;
  // int page;
  List<Movies> results;
  int totalPages;
  int totalResults;

  LatestMoviesModel({
    // required this.dates,
    // required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory LatestMoviesModel.fromJson(Map<String, dynamic> json) =>
      LatestMoviesModel(
        // dates: Dates.fromJson(json["dates"]),
        // page: json["page"],
        results:
            List<Movies>.from(json["results"]!.map((x) => Movies.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        // "dates": dates.toJson(),
        // "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  Map<String, dynamic> toJson() => {
        "maximum":
            "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
      };
}

class Movies {
  bool isFavorite;
  List<int> genreIds;
  int id;
  String overview;
  String? posterPath;
  DateTime releaseDate;
  String title;
  double voteAverage;

  Movies({
    required this.isFavorite,
    required this.genreIds,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
  });

  factory Movies.fromJson(Map<String, dynamic> json,
          {bool isFavorite = false}) =>
      Movies(
        isFavorite: isFavorite,
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        overview: json["overview"],
        posterPath:
            json["poster_path"] != null ? json["poster_path"] as String : "",
        releaseDate: json["release_date"] != null
            ? DateTime.tryParse(json["release_date"] as String? ?? "") ??
                DateTime.now()
            : DateTime.now(),
        title: json["title"],
        voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "overview": overview,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "vote_average": voteAverage,
      };
}

enum OriginalLanguage { EN, ES }

final originalLanguageValues =
    EnumValues({"en": OriginalLanguage.EN, "es": OriginalLanguage.ES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
