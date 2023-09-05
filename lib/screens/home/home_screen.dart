// lib/views/trending_movies_view.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_screen_controller.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Movies'),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: controller.trendingMovies.length,
              itemBuilder: (context, index) {
                final movie = controller.trendingMovies[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.releaseDate.toString()),
                  onTap: () {
                    // Handle movie item tap here
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
