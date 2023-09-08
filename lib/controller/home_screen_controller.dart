import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/new_movies_model.dart';
import '../model/trending_movies_model.dart';
import '../services/movies_data.dart';

class HomeScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Latest> latestMovies = <Latest>[].obs;
  RxList<Result> trendingMovies = <Result>[].obs;
  RxInt latestPage = 1.obs; // Page for latest movies
  RxInt trendingPage = 1.obs; // Page for trending movies
  RxBool latestHasMoreData = true.obs;
  RxBool trendingHasMoreData = true.obs;
  var scrollControllerLatest = ScrollController();
  var scrollControllerTrending = ScrollController();
  final searchResults = <Result>[].obs;
  // final suggestions = <String>[].obs; // Suggestions list

  @override
  void onInit() {
    fetchLatestMovies();
    fetchTrendingMovies();
    configureScrollControllers();
    super.onInit();
  }

  Future<void> fetchLatestMovies() async {
    try {
      isLoading(true);
      // Fetch latest movies data
      final newLatestMovies = await MovieService.getNewMovies(latestPage.value);
      latestMovies.addAll(newLatestMovies);
      latestHasMoreData.value =
          true; // Set to true if there's more data to load
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTrendingMovies() async {
    try {
      isLoading(true);
      // Fetch trending movies data
      final newTrendingMovies =
          await MovieService.fetchTrendingMovies(trendingPage.value);
      trendingMovies.addAll(newTrendingMovies);
      trendingHasMoreData.value =
          true; // Set to true if there's more data to load
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchMovies(String query) async {
    try {
      isLoading(true);
      final movies = await MovieService.searchMovies(query);
      debugPrint(movies.length.toString());
      searchResults.assignAll(movies);
    } finally {
      isLoading(false);
    }
  }

  // void updateSuggestions(String query) {
  //   final movieNames = trendingMovies
  //       .map((movie) => movie.title)
  //       .where((name) => name.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //   suggestions.assignAll(movieNames);
  // }

  void clearSuggestions() {
    searchResults.clear();
  }

  void configureScrollControllers() {
    // Configure scroll controller for latest movies list
    scrollControllerLatest.addListener(() {
      if (scrollControllerLatest.position.pixels ==
          scrollControllerLatest.position.maxScrollExtent) {
        // Reached the end of the list, load more data
        if (latestHasMoreData.value) {
          loadMoreLatestMovies();
        }
      }
    });

    // Configure scroll controller for trending movies list
    scrollControllerTrending.addListener(() {
      if (scrollControllerTrending.position.pixels ==
          scrollControllerTrending.position.maxScrollExtent) {
        // Reached the end of the list, load more data
        if (trendingHasMoreData.value) {
          loadMoreTrendingMovies();
        }
      }
    });
  }

  void loadMoreLatestMovies() async {
    // Implement logic to load more latest movies data
    // For example, increment page number and call fetchLatestMovies()
    latestPage++;
    debugPrint(latestPage.toString());
    final moreLatestMovies = await MovieService.getNewMovies(latestPage.value);
    latestMovies.addAll(moreLatestMovies);
  }

  void loadMoreTrendingMovies() async {
    // Implement logic to load more trending movies data
    // For example, increment page number and call fetchTrendingMovies()
    trendingPage++;
    debugPrint(trendingPage.toString());
    final moreTrendingMovies =
        await MovieService.fetchTrendingMovies(trendingPage.value);
    trendingMovies.addAll(moreTrendingMovies);
  }

  // ... other fields ...

  void resetPageParameter() {
    trendingPage = 1.obs; // Reset the page parameter for trending movies
    latestPage = 1.obs; // Reset the page parameter for latest movies
  }

  @override
  void onClose() {
    scrollControllerLatest
        .dispose(); // Dispose of the latest movies scroll controller
    scrollControllerTrending
        .dispose(); // Dispose of the trending movies scroll controller
    super.onClose();
  }
}
