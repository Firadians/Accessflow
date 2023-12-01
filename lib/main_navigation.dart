import 'package:flutter/material.dart';
import 'package:accessflow/draft/presentation/draft_screen.dart';
import 'package:accessflow/history/presentation/history_screen.dart';
import 'package:accessflow/home/presentation/home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:accessflow/profile/presentation/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void main() {
    runApp(const MaterialApp(
      home: MainNavigation(),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: ClampingScrollPhysics(), // Disable overscroll glow
        children: [
          HomeScreen(),
          DraftScreen(),
          HistoryScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        buttonBackgroundColor: Color.fromARGB(255, 226, 184, 35),
        items: [
          Icon(Icons.home,
              size: 30,
              color:
                  _currentIndex == 0 ? Colors.white : const Color(0xFFC8C9CB)),
          Icon(Icons.folder,
              size: 30,
              color:
                  _currentIndex == 1 ? Colors.white : const Color(0xFFC8C9CB)),
          Icon(Icons.history,
              size: 30,
              color:
                  _currentIndex == 2 ? Colors.white : const Color(0xFFC8C9CB)),
          Icon(Icons.person,
              size: 30,
              color:
                  _currentIndex == 3 ? Colors.white : const Color(0xFFC8C9CB)),
        ],
      ),
    );
  }
}
