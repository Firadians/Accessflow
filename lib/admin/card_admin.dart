import 'package:flutter/material.dart';
import 'package:accessflow/create_card/data/repositories/card_repository.dart';
import 'dart:math'; // Import the dart:math library

class CardAdmin extends StatefulWidget {
  final Map<String, dynamic> cardData;
  final String? id;

  CardAdmin({required this.cardData, this.id});

  @override
  _CardAdminState createState() => _CardAdminState();
}

class _CardAdminState extends State<CardAdmin> {
  int _currentStep = 0;
  final CardRepository cardRepository = CardRepository();
  final List<String> stepTitles = [
    'Submit',
    'On Review',
    'Take Card',
    'Finish',
  ];

  List<List<Widget>> stepContents = [];
  TextEditingController credentialController =
      TextEditingController(); // Controller for the input field
  @override
  void initState() {
    super.initState();

    // Assuming that 'card_status' is an integer in your cardData
    final cardStatus = widget.cardData['card_status'];
    // Update _currentStep based on card_status
    _currentStep = cardStatus - 1; // Adjust if card_status is 1-based

    stepContents = [
      // Content for "Submit" step
      [
        buildDataTables(widget.cardData),
      ],
      // Content for "On Review" step
      [
        buildDataTables(widget.cardData),
      ],
      // Content for "Take Card" step
      [
        Card(
          elevation: 2.0,
          margin: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: credentialController,
                  decoration: InputDecoration(
                    labelText: 'Enter Card Credential',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      // Content for "Finish" step
      [
        Card(
          elevation: 2.0,
          margin: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Anda sudah mengambil kartu.'),
              // Add other content for Step 4 as needed
            ],
          ),
        ),
      ],
    ];
  }

  // Future<String> _UpdateStatusCardCredential(
  //     {int? cardStatus, String? cardCredential}) async {
  //   try {
  //     await cardRepository.updateCardStatusCredential(
  //         widget.id, cardStatus!, cardCredential!);
  //     return cardCredential;
  //   } catch (e) {
  //     print('Error updating card status: $e');
  //     return '';
  //   }
  // }

  // Future<String> _UpdateStatusCard({int? cardStatus}) async {
  //   try {
  //     await cardRepository.updateCardStatus(widget.id, cardStatus!);
  //     return '';
  //   } catch (e) {
  //     print('Error updating card status: $e');
  //     return '';
  //   }
  // }

  // New method for handling acceptance logic in each step
  // void _handleAccept() {
  //   switch (_currentStep) {
  //     case 0:
  //       _UpdateStatusCard(cardStatus: 2);
  //       break;
  //     case 1:
  //       final String newRandomCode = generateRandomCode();
  //       _UpdateStatusCardCredential(
  //           cardStatus: 3, cardCredential: newRandomCode);
  //       break;
  //     case 2:
  //       final String enteredCredential = credentialController.text;
  //       if (validateCardCredential(enteredCredential)) {
  //         // Credential is valid, proceed
  //         _UpdateStatusCard(cardStatus: 4);
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('Success.'),
  //         ));
  //       } else {
  //         // Credential is invalid, show an error message
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('Invalid card credential. Please try again.'),
  //         ));
  //       }
  //       break;
  //   }
  //   // After handling logic for the current step, proceed to the next step
  //   _nextStep();
  // }

  // New method for validating the entered card credential
  bool validateCardCredential(String inputCredential) {
    // Get the card credential from the database
    final String databaseCredential = widget.cardData['card_credential'];

    // Compare the entered credential with the one in the database
    return inputCredential == databaseCredential;
  }

  // New method for handling decline logic in each step
  void _handleDecline() {
    switch (_currentStep) {
      case 0:
        // Decline logic for "Submit" step
        // You can implement specific logic for this step
        break;
      case 1:
        // Decline logic for "On Review" step
        // You can implement specific logic for this step
        break;
      case 2:
        // Decline logic for "Take Card" step
        // You can implement specific logic for this step
        break;
    }
    // After handling logic for the current step, proceed to the next step
    _nextStep();
  }

  // New method to move to the next step
  void _nextStep() {
    setState(() {
      if (_currentStep < stepTitles.length - 1) {
        _currentStep++;
      }
    });
  }

  String generateRandomCode() {
    String? randomCode; // Variable to hold the generated random code
    final Random random = Random();
    final int min = 100000; // Minimum value for the random code
    final int max = 999999; // Maximum value for the random code
    randomCode = (min + random.nextInt(max - min + 1)).toString();
    print(randomCode);
    return randomCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Status Pengajuan',
            style: Theme.of(context).textTheme.headline1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < stepTitles.length; i++)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _currentStep = i;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentStep == i ? Colors.blue : Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        stepTitles[i],
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: _currentStep == i
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _currentStep == i ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Display data for the current step below
            Container(
              margin: EdgeInsets.all(16.0),
              child: stepContents[_currentStep].isNotEmpty
                  ? stepContents[_currentStep][0]
                  : Container(),
            ),
            // Accept and Decline buttons
            // Accept and Decline buttons for each step
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // _handleAccept();
                  },
                  child: Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleDecline();
                  },
                  child: Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataTables(Map<String, dynamic> cardData) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataTable(
            columns: [
              DataColumn(label: Text('Field')),
              DataColumn(label: Text('Value')),
            ],
            rows: buildDataRows(cardData),
          ),
        ],
      ),
    );
  }

  List<DataRow> buildDataRows(Map<String, dynamic> cardData) {
    List<DataRow> dataRows = [];

    // Add common rows regardless of card type
    dataRows.add(DataRow(
      cells: [
        DataCell(Text('Tipe Kartu')),
        DataCell(Text(cardData['card_type'])),
      ],
    ));
    if (cardData['card_sub_type'] != null) {
      dataRows.add(DataRow(
        cells: [
          DataCell(Text('Posisi Pemegang')),
          DataCell(Text(cardData['card_sub_type'])),
        ],
      ));
    }
    if (cardData['name'] != null) {
      dataRows.add(DataRow(
        cells: [
          DataCell(Text('Nama')),
          DataCell(Text(cardData['name'])),
        ],
      ));
    }
    if (cardData['ktp'] != null) {
      dataRows.add(DataRow(
        cells: [
          DataCell(Text('Nomor KTP')),
          DataCell(Text(cardData['ktp'])),
        ],
      ));
    }
    if (cardData['photo'] != null) {
      final String profileImageUrl = cardData['photo'];
      dataRows.add(
        DataRow(cells: [
          DataCell(Text('Foto Profil')),
          DataCell(
            Image.network(
              profileImageUrl,
              width: 100, // Adjust the width as needed
              height: 100, // Adjust the height as needed
            ),
          ),
        ]),
      );
    }
    // Add more rows and conditions for other fields as needed
    return dataRows;
  }
}
