import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar ownerHeader(BuildContext context) {
  return AppBar(
    title: Stack(
      children: [
        // Black outline text
        RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 38.0,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4.0
                ..color = Colors.black,
              textStyle: const TextStyle(
                shadows: [
                  Shadow(
                    blurRadius: 3.0,
                    color: Colors.black,
                    offset: Offset(0, 4),
                  )
                ],  
              ),
            ),
            children: [
              TextSpan(text: "M", style: TextStyle(color: const Color(0xFFFFC100))),
              TextSpan(text: "aster"),
              TextSpan(text: "G", style: TextStyle(color: const Color(0xEEEFD30B))),
              TextSpan(text: "ig"),
            ],
          ),
        ),
        // White fill text
        RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 38.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: [
              TextSpan(text: "M", style: TextStyle(color: const Color(0xFFFFC100))),
              TextSpan(text: "aster"),
              TextSpan(text: "G", style: TextStyle(color: const Color(0xEEEFD30B))),
              TextSpan(text: "ig"),
            ],
          ),
        ),
      ],
    ),
    centerTitle: true,
    backgroundColor: const Color(0xFFFFC100),
    elevation: 0,
    toolbarHeight: 100,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(8),
      ),
      side: BorderSide(  // NEW: Black border around AppBar
        color: Colors.black,
        width: 1,
      ),
    ),
    leading: Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: IconButton(
        icon: const Icon(Icons.notifications, color: Colors.black, size: 50),
        onPressed: () {
          // Handle notification bell press
        },
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.black, size: 50),
          onPressed: () {
            // Handle profile icon press
          },
        ),
      ),
    ],
  );
}