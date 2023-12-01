import 'package:flutter/material.dart';
import 'package:accessflow/utils/strings.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
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
        title: Text('FAQ', style: Theme.of(context).textTheme.headline2),
      ),
      body: ListView.builder(
        itemCount: ProfileAssets.faqData.length,
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
            title: Text(ProfileAssets.faqData[index]['title'] ?? ''),
            children: <Widget>[
              ListTile(
                title: Text(
                  ProfileAssets.faqData[index]['content'] ?? '',
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
