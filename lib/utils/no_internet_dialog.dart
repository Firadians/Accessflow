import 'package:flutter/material.dart';

class NoInternetDialog extends StatelessWidget {
  final Function onRefresh;

  NoInternetDialog({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No Internet Connection'),
      content: Text('Please check your internet connection and try again.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: Text('Dismiss'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
            onRefresh(); // Call the refresh function
          },
          child: Text('Refresh'),
        ),
      ],
    );
  }
}
