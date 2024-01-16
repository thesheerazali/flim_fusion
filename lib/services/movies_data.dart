import 'dart:convert';
import 'package:film_fusion/utils/constants/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../model/new_movies_model.dart';


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
      final trendingMovie =
          LatestMoviesModel.fromJson(json.decode(response.body));
      return trendingMovie.results;
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  static Future<List<Movies>> fetchToRatedMovies(int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&page=$page'),
    );
    debugPrint("To Rtaed Movies responce");
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final toRatedMovie =
          LatestMoviesModel.fromJson(json.decode(response.body));
      return toRatedMovie.results;
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  // https://api.themoviedb.org/3/movie/top_rated?api_key=47ffa47d8792fe1a414a82a3db71ea2e

  // static Future<MovieByIdModel> fetchMovieById(int movieId) async {
  //   // Replace with your actual API endpoint
  //   final apiUrl =
  //       'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';

  //   final response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     final movie = MovieByIdModel.fromJson(jsonData);
  //     return movie;
  //   } else {
  //     throw Exception('Failed to fetch movie details');
  //   }
  // }
}
