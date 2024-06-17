import 'package:flutter/material.dart';

class InformationDialog extends StatefulWidget {
  @override
  _InformationDialogState createState() => _InformationDialogState();
}

class _InformationDialogState extends State<InformationDialog> {
  int currentPage = 0;

  final List<Widget> pages = [
    InformationPage(
      title: 'Selamat Datang di AccessFlow',
      content:
          'Ini merupakan aplikasi Departemen Keamanan PT Petrokimia Gresik yang bertujuan untuk menangani pembuatan kartu akses',
      imagePath: 'assets/guide/app_guide_one.png',
    ),
    InformationPage(
      title: 'Home',
      content:
          'In home, you can get information about access card and making access card through this.',
      imagePath: 'assets/guide/app_guide_two.jpg',
    ),
    InformationPage(
      title: 'Draft',
      content:
          'This is page where you saved draft while creating access card in case you need some time to think about filled data.',
      imagePath: 'assets/guide/app_guide_three.jpg',
    ),
    InformationPage(
      title: 'History',
      content:
          'You will find history of submitted access card and currently card that being processed.',
      imagePath: 'assets/guide/app_guide_four.jpg',
    ),
    InformationPage(
      title: 'Profile',
      content: 'This is personal settings for user and Log out.',
      imagePath: 'assets/guide/app_guide_five.jpg',
    ),
    InformationPage(
      title: 'That is it!',
      content: 'Hope you enjoy our apps, thank you.',
      imagePath: 'assets/guide/app_guide_finish.png',
    ),
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() {
        currentPage++;
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  void closePage() {
    if (currentPage == pages.length - 1) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20.0), // Circular border for AlertDialog
      ),
      title: Text('Application Guide - Page ${currentPage + 1}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          pages[currentPage],
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentPage > 0 && currentPage != pages.length - 1)
                Expanded(
                  child: ElevatedButton(
                    onPressed: previousPage,
                    child: Text('Kembali'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Circular border for buttons
                      ),
                    ),
                  ),
                ),
              if (currentPage > 0 && currentPage != pages.length - 1)
                SizedBox(width: 16), // Add space between the buttons
              if (currentPage < pages.length - 1)
                Expanded(
                  child: ElevatedButton(
                    onPressed: nextPage,
                    child: Text('Berikutnya'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Circular border for buttons
                      ),
                    ),
                  ),
                ),
              if (currentPage == pages.length - 1)
                Expanded(
                  child: ElevatedButton(
                    onPressed: closePage,
                    child: Text('Selesai'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Circular border for buttons
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class InformationPage extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath;

  const InformationPage({
    required this.title,
    required this.content,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Center(
          child: Image.asset(
            imagePath,
            width: 200, // Adjust the width as needed
            height: 200, // Adjust the height as needed
          ),
        ),
      ],
    );
  }
}
