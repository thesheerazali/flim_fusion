// To parse this JSON data, do
//
//     final trendingMovieModel = trendingMovieModelFromJson(jsonString);

import 'dart:convert';

TrendingMovieModel trendingMovieModelFromJson(String str) =>
    TrendingMovieModel.fromJson(json.decode(str));

String trendingMovieModelToJson(TrendingMovieModel data) =>
    json.encode(data.toJson());

class TrendingMovieModel {
  // int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  TrendingMovieModel({
    //  required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TrendingMovieModel.fromJson(Map<String, dynamic> json) =>
      TrendingMovieModel(
        //  page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        //  "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Result {
  bool adult;
  String? backdropPath;
  int id;
  String title;
//    OriginalLanguage originalLanguage;
  String originalTitle;
  String overview;
  String? posterPath;
  //  MediaType mediaType;
  List<int> genreIds;
  double popularity;
  DateTime releaseDate;
  bool video;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.title,
    //  required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    // required this.mediaType,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) {

 
   return Result(
      adult: json["adult"],
      backdropPath:
          json["backdrop_path"] != null ? json["backdrop_path"] as String : "",
      id: json["id"],
      title: json["title"],
      // originalLanguage: originalLanguageValues.map[json["original_language"]]!,
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath:
          json["poster_path"] != null ? json["poster_path"] as String : "",
      // mediaType: mediaTypeValues.map[json["media_type"]]!,
      genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
      popularity: json["popularity"]?.toDouble(),
        releaseDate: json["release_date"] != null
        ? DateTime.tryParse(json["release_date"] as String? ?? "") ?? DateTime.now()
        : DateTime.now(),
      video: json["video"],
      voteAverage: json["vote_average"]?.toDouble(),
      voteCount: json["vote_count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "id": id,
        "title": title,
        //  "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        //   "media_type": mediaTypeValues.reverse[mediaType],
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "popularity": popularity,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}

enum MediaType { MOVIE }

final mediaTypeValues = EnumValues({"movie": MediaType.MOVIE});

enum OriginalLanguage { EN, NL, SV }

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN,
  "nl": OriginalLanguage.NL,
  "sv": OriginalLanguage.SV
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
