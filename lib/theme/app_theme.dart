import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme customTextTheme = TextTheme(
  // Example of changing the font for the headline1 style
  displayLarge: GoogleFonts.roboto(
    // Change the font family
    textStyle: const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 255, 255, 255),
    ),
  ),
  // Add or modify more styles as needed
  displayMedium: GoogleFonts.roboto(
    textStyle: const TextStyle(
      fontSize: 20.0, // Modify the font size
      fontWeight: FontWeight.normal, // Change the font weight
      color: Color.fromARGB(255, 255, 255, 255), // Change the text color
    ),
  ),
  displaySmall: GoogleFonts.roboto(
    // Use a different font for bodyText1
    textStyle: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.grey, // Change the text color
    ),
  ),

  headlineMedium: GoogleFonts.roboto(
    // Use a different font for bodyText1
    textStyle: const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 116, 116, 116), // Change the text color
    ),
  ),

  //FONT BLACK
  headlineLarge: GoogleFonts.roboto(
    // Use a different font for bodyText1
    textStyle: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 24, 24, 24), // Change the text color
    ),
  ),
  headlineSmall: GoogleFonts.roboto(
    // Use a different font for bodyText1
    textStyle: const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 24, 24, 24), // Change the text color
    ),
  ),
  titleLarge: GoogleFonts.roboto(
    // Use a different font for bodyText1
    textStyle: const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 24, 24, 24), // Change the text color
    ),
  ),
);

TextStyle cardView = const TextStyle(
  fontFamily: 'roboto', // Specify the font family if you have a custom font
  fontSize: 24, // Adjust font size as needed
  fontWeight: FontWeight.bold, // Adjust font weight as needed
  color: Colors.blue, // Change text color as needed
  letterSpacing: 1.0, // Adjust letter spacing as needed
  fontStyle: FontStyle.italic, // Specify italic style if needed
  decoration: TextDecoration.underline, // Specify text decoration if needed
  decorationColor: Colors.red, // Specify decoration color if needed
  // Add more properties as needed
);
