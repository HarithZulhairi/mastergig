import 'package:flutter/material.dart';
import 'package:mastergig_app/pages/manage_schedule/foremanViewSchedulePage.dart';

int _currentIndex = 0; // Track current tab index

BottomNavigationBar foremanFooter(BuildContext context) {
  return BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (int index) {
      // Handle tab changes
      _currentIndex = index;
      if (index == 1) { // Assuming calendar is at index 2
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  ForemanViewSchedulePage()),
      );
    }
    },
    backgroundColor: const Color(0xBBBCBCBC), // Yellow background
    selectedItemColor: Colors.black, // Selected icon color
    unselectedItemColor: Colors.black.withOpacity(0.5), // Unselected icon color
    elevation: 10, // Shadow
    showSelectedLabels: false, // Hide labels
    showUnselectedLabels: false, // Hide labels
    type: BottomNavigationBarType.fixed,
    items: [
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == 0 
                ? Colors.black.withOpacity(0.1) 
                : Colors.transparent,
          ),
          child: const Icon(Icons.home, size: 50),
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == 1 
                ? Colors.black.withOpacity(0.1) 
                : Colors.transparent,
          ),
          child: const Icon(Icons.calendar_month, size: 50),
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == 2 
                ? Colors.black.withOpacity(0.1) 
                : Colors.transparent,
          ),
          child: const Icon(Icons.settings, size: 50),
        ),
        label: '',
      ),
    ],
  );
}