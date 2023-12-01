import 'package:flutter/material.dart';

class SubmitDataConfirm extends StatelessWidget {
  final Function onSubmit;

  SubmitDataConfirm({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Show a confirmation dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Submit Card Confirmation'),
                content:
                    const Text('Are you sure you want to submit this data?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      // Call the onSubmit function to submit data
                      await onSubmit();
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          print('Error inserting data: $e');
          // Handle the error here
        }
      },
      child: const Text('Submit'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(
            255, 84, 192, 51)), // Set the background color here
      ),
    );
  }
}

class SubmitDraftConfirm extends StatelessWidget {
  final Function onSubmit;

  SubmitDraftConfirm({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Show a confirmation dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Draft Card Confirmation'),
                content:
                    const Text('Are you sure you want to draft this data?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await onSubmit();
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          print('Error inserting data: $e');
          // Handle the error here
        }
      },
      child: const Text('Save Draft'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(
            255, 206, 170, 27)), // Set the background color here
      ),
    );
  }
}

class LoadIDCardData extends StatelessWidget {
  final Function onSubmit;

  LoadIDCardData({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {},
      child: const Text('Edit Data'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(
            255, 233, 192, 30)), // Set the background color here
      ),
    );
  }
}

class SubmitCompleteDataConfirm extends StatelessWidget {
  final Function onSubmit;
  final Function validateFields; // Add validation function

  SubmitCompleteDataConfirm(
      {super.key, required this.onSubmit, required this.validateFields});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Validate the fields before showing the confirmation dialog
        bool validateResult = validateFields();
        if (!validateResult) {
          // Show a popup indicating validation failure
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Validation Error'),
                content: const Text(
                    'Please fill in all required fields and ensure they are valid.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return; // Exit the onPressed function if fields are not valid
        } else {
          // Show a confirmation dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Submit Card Confirmation'),
                content:
                    const Text('Are you sure you want to submit this data?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      // Call the onSubmit function to submit data
                      await onSubmit();
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: const Text('Submit'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 84, 192, 51)),
      ),
    );
  }
}

class SubmitCompleteDraftConfirm extends StatelessWidget {
  final Function onSubmit;
  final Function validateFields; // Add validation function

  SubmitCompleteDraftConfirm(
      {super.key, required this.onSubmit, required this.validateFields});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        bool validateResult = validateFields();
        if (!validateResult) {
          // Show a popup indicating validation failure
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Save Draft Error'),
                content: const Text(
                    'Please fill at least one field in order to save as Draft.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return; // Exit the onPressed function if fields are not valid
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Draft Card Confirmation'),
                content:
                    const Text('Are you sure you want to draft this data?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await onSubmit();
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: const Text('Save Draft'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 206, 170, 27)),
      ),
    );
  }
}
