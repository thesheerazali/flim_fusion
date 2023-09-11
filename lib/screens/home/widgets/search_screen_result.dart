// import 'package:film_fusion/controller/home_screen_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SearchResultsScreen extends GetView<HomeScreenController> {
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController searchController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: TextFormField(
//           controller: searchController,
//           decoration: InputDecoration(
//             hintText: "Search",
//           ),
//           onFieldSubmitted: (query) {
//             controller.searchMovies(query);

//             // Perform the search and display results
//             // You can call your searchMovies function here
//             // Don't forget to show a loading indicator while searching
//           },
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           // Display search results here in a ListView
//           return ListView.builder(
//             itemCount: controller.searchResults.length,
//             itemBuilder: (context, index) {
//               final result = controller.searchResults[index];
//               // Create widgets to display search results
//               // You can customize this part as needed
//               return ListTile(
//                 title: Text(result.title),
//                 // Add more details or customize the result display
//               );
//             },
//           );
//         }
//       }),
//     );
//   }
// }
