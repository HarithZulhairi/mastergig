import 'package:flutter/material.dart';
import 'package:mastergig_app/pages/manage_schedule/ownerViewSchedulePage.dart';
import 'package:mastergig_app/pages/manage_inventory/inventoryPage.dart';
import 'package:mastergig_app/pages/manage_rating/ownerRatingPage.dart';
import 'package:mastergig_app/pages/manage_payroll/payrollPage.dart'; // ✅ Added import for PayrollPage

int _currentIndex = 0; // Track current tab index

BottomNavigationBar ownerFooter(BuildContext context) {
  return BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (int index) {
      _currentIndex = index;

      if (index == 1) {
        // Navigate to Inventory Page when outbox icon is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InventoryPage()),
        );
      } else if (index == 2) {
        // ✅ Navigate to Payroll Page when engineering icon is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ownerPayrollPage()),
        );
      } else if (index == 3) {
        // Navigate to Schedule Page when calendar icon is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OwnerViewSchedulePage()),
        );
      } else if (index == 4) {
        // Navigate to Rating Page when star icon is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ownerRatingPage()),
        );
      }
    },
    backgroundColor: const Color(0xBBBCBCBC),
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black.withOpacity(0.5),
    elevation: 10,
    showSelectedLabels: false,
    showUnselectedLabels: false,
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
          child: const Icon(Icons.home, size: 40),
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
          child: const Icon(Icons.outbox, size: 40),
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
          child: const Icon(Icons.engineering, size: 40),
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == 3
                ? Colors.black.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: const Icon(Icons.calendar_month, size: 40),
        ),
        label: '',
      ),
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == 4
                ? Colors.black.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: const Icon(Icons.star, size: 40),
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == 5
                ? Colors.black.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: const Icon(Icons.settings, size: 40),
        ),
        label: '',
      ),
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    ],
  );
}
