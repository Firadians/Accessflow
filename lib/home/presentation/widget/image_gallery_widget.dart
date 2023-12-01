import 'package:flutter/material.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'dart:async';

class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key});

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final List<String> imageUrls = [
    'assets/card/image_card_1.png',
    'assets/card/image_card_2.png',
    'assets/card/image_card_3.png',
    'assets/card/image_card_4.png',
    'assets/card/image_card_5.png',
    'assets/card/image_card_6.png'
  ];
  final SharedPreference sharedPreference = SharedPreference();
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200, // Adjust the height as needed
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imageUrls[index],
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
        ),
        DotsIndicator(
          dotsCount: imageUrls.length,
          position: _currentPage,
          decorator: DotsDecorator(
            size: const Size.square(8.0),
            activeSize: const Size(20.0, 8.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }
}
