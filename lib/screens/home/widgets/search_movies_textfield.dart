import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchMoviesTextField extends StatelessWidget {
  const SearchMoviesTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: passwordController,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white.withOpacity(0.6),
        ),
        suffixIcon: Icon(
          Icons.mic,
          color: Colors.white.withOpacity(0.6),
        ),
        hintText: "Search",
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.6),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
