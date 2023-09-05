import 'dart:convert';
import 'package:film_fusion/constants/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/new_movies_model.dart';
import '../model/trending_movies_model.dart';

class MovieService {
  static Future<List<Result>> fetchTrendingMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final trendingMovieModel =
          TrendingMovieModel.fromJson(json.decode(response.body));
      return trendingMovieModel.results;
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  /// New Movies//
  static Future<List<Latest>> getNewMovies() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey'),
    );
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final lstestMovieModel =
          LatestMoviesModel.fromJson(json.decode(response.body));
     
      return lstestMovieModel.results;
    } else {
      throw Exception('Failed to load new movies');
    }
  }
}
