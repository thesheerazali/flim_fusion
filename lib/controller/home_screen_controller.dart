import 'dart:convert';

import 'package:get/get.dart';
import '../model/new_movies_model.dart';
import '../model/trending_movies_model.dart';
import '../services/movies_data.dart';
import 'package:http/http.dart' as http;

class HomeScreenController extends GetxController {
  var isLoading = true.obs;
  RxList<Result> trendingMovies = <Result>[].obs;
  RxList<Latest> latestMovies = <Latest>[].obs;

  @override
  void onInit() {
    fetchTrendingMovies();
    fetchLatestMovies();
    //fetchLatestMovies();

    super.onInit();
  }

  Future<void> fetchTrendingMovies() async {
    try {
      isLoading(true);
      final movies = await MovieService.fetchTrendingMovies();
      trendingMovies.assignAll(movies);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchLatestMovies() async {
    try {
      isLoading(true);
      final movies = await MovieService.getNewMovies();
      latestMovies.assignAll(movies);
    } finally {
      isLoading(false);
    }
  }
}
