

import 'package:film_fusion/controller/home_screen_controller.dart';
import 'package:film_fusion/screens/home/widgets/search_screen_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchMoviesTextField extends StatelessWidget{
  SearchMoviesTextField({
    super.key,
  });

  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
       HomeScreenController controller= Get.put(HomeScreenController());
    return TextFormField(
        controller: searchController,
        onChanged: (query) {
          if (query.isEmpty) {
            controller.clearSuggestions();
            _searchFocusNode.unfocus();
          } else {
            controller.searchMovies(query);
            _searchFocusNode.requestFocus();
          }
        },

        // Clear the suggestions list when the text field is empty
        onEditingComplete: () {
          if (searchController.text.isEmpty) {
            controller.clearSuggestions();
          }
        },
        // controller: searchController,
        style: TextStyle(color: Colors.white),
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.6),
          ),
          suffixIcon: GestureDetector(
            onTap: () => Get.to(()),
            child: Icon(
              Icons.mic,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          hintText: "Search",
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.6),
          ),
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ));
  }
}
