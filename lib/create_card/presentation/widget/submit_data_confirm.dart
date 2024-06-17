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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                ),
                title: const Text('Validation Error'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/icon_warning.png',
                      width: 160,
                      height: 160,
                    ), // Adjust the path as needed
                    const SizedBox(
                        height:
                            16), // Add some space between the image and text
                    const Text(
                        'Mohon untuk mengisi seluruh kolom field yang kosong dan pastikan data yang dimasukkan sesuai!'),
                  ],
                ),
                actions: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 1, 58,
                              73), // Set the background color if needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // Circular border radius
                          ),
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                              color:
                                  Colors.white), // Set the text color to white
                        ),
                      ),
                    ),
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
      child: const Text(
        'Submit',
        style: TextStyle(
          fontWeight: FontWeight.bold, // Make the text bold
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(215, 53, 163, 57)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 15.0),
        ),
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
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/icon_safe_draft.png',
          height: 24, width: 24), // Change to your local image asset
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
                      Navigator.of(context)
                          .pop(); // Close the dialog after submission
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
    );
  }
}
