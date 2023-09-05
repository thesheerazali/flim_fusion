import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/trending_movies_model.dart';

class MovieService {
  static Future<List<Result>> fetchTrendingMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/trending/movie/day?api_key=47ffa47d8792fe1a414a82a3db71ea2e'),
    );

    if (response.statusCode == 200) {
      final trendingMovieModel =
          TrendingMovieModel.fromJson(json.decode(response.body));
      return trendingMovieModel.results;
    } else {
      throw Exception('Failed to load trending movies');
    }
  }
}
