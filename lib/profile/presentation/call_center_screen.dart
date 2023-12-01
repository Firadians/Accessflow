import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:accessflow/utils/strings.dart';

class CallCenterScreen extends StatefulWidget {
  const CallCenterScreen({Key? key}) : super(key: key);
  @override
  _CallCenterScreenState createState() => _CallCenterScreenState();
}

class _CallCenterScreenState extends State<CallCenterScreen> {
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
        title:
            Text('Call Center', style: Theme.of(context).textTheme.headline2),
      ),
      body: ListView.builder(
        itemCount: ProfileAssets.callCenterData.length,
        itemBuilder: (context, index) {
          final item = ProfileAssets.callCenterData[index];

          return ExpansionTile(
            backgroundColor: activeIndex == index ? Colors.blue : Colors.white,
            onExpansionChanged: (bool isExpanded) {
              // ... (the rest of your code)
            },
            title: Text(item['title'] ?? ''),
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  final phoneNumber = item['phoneNumber'];
                  if (phoneNumber != null) {
                    _navigateToPhoneNumber(phoneNumber);
                  } else {
                    // Handle the case where phoneNumber is null
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Phone number is missing.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: ListTile(
                  title: Text(
                    item['content'] ?? '', // Use item['content']
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToPhoneNumber(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error, e.g., show a dialog or message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Could not make a phone call.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
