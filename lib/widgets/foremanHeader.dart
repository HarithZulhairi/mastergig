import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mastergig_app/pages/Manage_profile/ForemanProfile.dart';
import 'package:mastergig_app/pages/Manage_login/Login.dart'; // Assuming you have a login page here

AppBar foremanHeader(BuildContext context) {
  return AppBar(
    title: Stack(
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 38.0,
              fontWeight: FontWeight.bold,
              foreground:
                  Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4.0
                    ..color = Colors.black,
              textStyle: const TextStyle(
                shadows: [
                  Shadow(
                    blurRadius: 3.0,
                    color: Colors.black,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            children: const [
              TextSpan(text: "M", style: TextStyle(color: Color(0xFFFFC100))),
              TextSpan(text: "aster"),
              TextSpan(text: "G", style: TextStyle(color: Color(0xEEEFD30B))),
              TextSpan(text: "ig"),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 38.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: const [
              TextSpan(text: "M", style: TextStyle(color: Color(0xFFFFC100))),
              TextSpan(text: "aster"),
              TextSpan(text: "G", style: TextStyle(color: Color(0xEEEFD30B))),
              TextSpan(text: "ig"),
            ],
          ),
        ),
      ],
    ),
    centerTitle: true,
    backgroundColor: const Color(0xDDDFDFD9),
    elevation: 0,
    toolbarHeight: 100,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
      side: BorderSide(color: Colors.black, width: 1),
    ),
    leading: Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: IconButton(
        icon: const Icon(Icons.notifications, color: Colors.black, size: 50),
        onPressed: () {
          // Handle notifications
        },
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: Colors.black, size: 50),
          onSelected: (String value) {
            if (value == 'Profile') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ForemanProfile(foremanEmail: 'melow@gmail.com'),
                ),
              );
            } else if (value == 'Logout') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
              );
            }
          },
          itemBuilder:
              (BuildContext context) => [
                const PopupMenuItem(value: 'Profile', child: Text('Profile')),
                const PopupMenuItem(value: 'Logout', child: Text('Logout')),
              ],
        ),
      ),
    ],
  );
}
