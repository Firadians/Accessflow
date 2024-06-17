import 'package:flutter/material.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);
  @override
  _InformationScreenPage createState() => _InformationScreenPage();
}

class _InformationScreenPage extends State<InformationScreen> {
  var data = [
    {
      'title': 'How do I get started with the app?',
      'content':
          'To get started with the app, simply download it from the app store...',
    },
    {
      'title': 'Can I change my account settings?',
      'content':
          'Yes, you can change your account settings by going to the "Settings" tab...',
    },
    {
      'title': 'What should I do if I forgot my password?',
      'content':
          'If you forgot your password, you can reset it by clicking on the "Forgot Password" link on the login screen...',
    },
    {
      'title': 'How can I contact customer support?',
      'content':
          'You can contact our customer support team by emailing support@example.com...',
    },
  ];

  int? activeIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Information',
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            backgroundColor: activeIndex == index
                ? Colors.blue // Set the background color to blue when active
                : Colors.white,
            onExpansionChanged: (bool isExpanded) {
              if (isExpanded) {
                setState(() {
                  activeIndex = index;
                });
              } else {
                setState(() {
                  activeIndex = null;
                });
              }
            },
            title: Text(data[index]['title'] ?? ''),
            children: <Widget>[
              ListTile(
                title: Text(
                  data[index]['content'] ?? '',
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
