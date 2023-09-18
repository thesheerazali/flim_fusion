import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/new_movies_model.dart';
import '../model/trending_movies_model.dart';
import '../services/movies_data.dart';

class HomeScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Movies> latsetmoviesList = <Movies>[].obs;
  RxList<Movies> trendingmoviesList = <Movies>[].obs;
  RxList<Movies> topRatedmoviesList = <Movies>[].obs;
  // RxList<Movies> moviesList = <Movies>[].obs;

  RxInt latestPage = 1.obs; // Page for latest movies
  RxInt trendingPage = 1.obs;
  RxInt topRtaedPage = 1.obs; // Page for trending movies
  RxBool latestHasMoreData = true.obs;
  RxBool trendingHasMoreData = true.obs;
  RxBool topRatedHasMoreData = true.obs;
  var scrollControllerLatest = ScrollController();
  var scrollControllerTrending = ScrollController();
  var scrollControllerTopRated = ScrollController();
  final searchResults = <Movies>[].obs;

  // final suggestions = <String>[].obs; // Suggestions list

  @override
  void onInit() {
    fetchLatestMovies();
    fetchTrendingMovies();
    configureScrollControllers();
    fetchTopRatedMovies();

    super.onInit();
  }

  Future<void> fetchLatestMovies() async {
    try {
      isLoading.value = true;
      // Fetch latest movies data
      final newLatestMovies = await MovieService.getNewMovies(latestPage.value);
      latsetmoviesList.addAll(newLatestMovies);
      latestHasMoreData.value = true;
      // Set to true if there's more data to load
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTrendingMovies() async {
    try {
       isLoading.value = true;
      // Fetch trending movies data
      final newTrendingMovies =
          await MovieService.fetchTrendingMovies(trendingPage.value);
      trendingmoviesList.addAll(newTrendingMovies);
      trendingHasMoreData.value =
          true; // Set to true if there's more data to load
    } finally {
     isLoading.value = false;
    }
  }

  Future<void> fetchTopRatedMovies() async {
    try {
       isLoading.value = true;
      // Fetch trending movies data
      final topRated =
          await MovieService.fetchToRatedMovies(topRtaedPage.value);
      topRatedmoviesList.addAll(topRated);
      topRatedHasMoreData.value =
          true; // Set to true if there's more data to load
    } finally {
     isLoading.value = false;
    }
  }

  Future<void> searchMovies(String query) async {
    try {
      isLoading.value = true;
      final movies = await MovieService.searchMovies(query);
      debugPrint(movies.length.toString());
      searchResults.assignAll(movies);
    } finally {
      isLoading.value = false;
    }
  }

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

    scrollControllerTopRated.addListener(() {
      if (scrollControllerTopRated.position.pixels ==
          scrollControllerTopRated.position.maxScrollExtent) {
        // Reached the end of the list, load more data
        if (topRatedHasMoreData.value) {
          loadMoreTopRatedMovies();
        }
      }
    });
  }

  void loadMoreLatestMovies() async {
    latestPage++;
    debugPrint(latestPage.toString());
    final moreLatestMovies = await MovieService.getNewMovies(latestPage.value);
    latsetmoviesList.addAll(moreLatestMovies);
  }

  void loadMoreTrendingMovies() async {
    trendingPage++;
    debugPrint(trendingPage.toString());
    final moreTrendingMovies =
        await MovieService.fetchTrendingMovies(trendingPage.value);
    trendingmoviesList.addAll(moreTrendingMovies);
  }

  void loadMoreTopRatedMovies() async {
    topRtaedPage++;
    debugPrint(topRtaedPage.toString());
    final moreToRatedMovies =
        await MovieService.fetchTrendingMovies(topRtaedPage.value);
    topRatedmoviesList.addAll(moreToRatedMovies);
  }

  void resetPageParameter() {
    trendingPage = 1.obs; // Reset the page parameter for trending movies
    latestPage = 1.obs;
    topRtaedPage = 1.obs; // Reset the page parameter for latest movies
  }

  @override
  void onClose() {
    scrollControllerLatest
        .dispose(); // Dispose of the latest movies scroll controller
    scrollControllerTrending.dispose();
    scrollControllerTopRated
        .dispose(); // Dispose of the trending movies scroll controller
    super.onClose();
  }
}
