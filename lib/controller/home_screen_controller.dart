import 'package:get/get.dart';
import '../model/trending_movies_model.dart';
import '../services/movies_data.dart';


class HomeScreenController extends GetxController {
  var isLoading = true.obs;
  var trendingMovies = <Result>[].obs;

  @override
  void onInit() {
    fetchTrendingMovies();
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
}
