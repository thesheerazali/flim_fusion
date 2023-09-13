import 'dart:convert';
import 'package:film_fusion/constants/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/movie_by_id_model.dart';
import '../model/new_movies_model.dart';
import '../model/trending_movies_model.dart';

class MovieService {
  static Future<List<Movies>> fetchTrendingMovies(int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey&page=$page'),
    );
    debugPrint("Trending Movies responce");
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final trendingMovieModel =
          LatestMoviesModel.fromJson(json.decode(response.body));
      return trendingMovieModel.results;
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  /// New Movies//
  static Future<List<Movies>> getNewMovies(int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&page=$page'),
    );
    debugPrint("Latest Movies responce");
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final lstestMovieModel =
          LatestMoviesModel.fromJson(json.decode(response.body));

      return lstestMovieModel.results;
    } else {
      throw Exception('Failed to load new movies');
    }
  }

  static Future<List<Movies>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      final trendingMovieModel =
          LatestMoviesModel.fromJson(json.decode(response.body));
      return trendingMovieModel.results;
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  static Future<MovieByIdModel> fetchMovieById(int movieId) async {
    // Replace with your actual API endpoint
    final apiUrl =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final movie = MovieByIdModel.fromJson(jsonData);
      return movie;
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }
}
