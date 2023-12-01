import 'package:flutter/material.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/utils/strings.dart';

class DetailCardScreen extends StatefulWidget {
  final CardResponse? cards;

  const DetailCardScreen({this.cards});

  @override
  _DetailCardScreenState createState() => _DetailCardScreenState();
}

class _DetailCardScreenState extends State<DetailCardScreen> {
  int _currentStep = 0;

  List<List<Widget>> stepContents = [];

  @override
  void initState() {
    super.initState();
    final cardStatus = widget.cards!.cardStatus;

    if (cardStatus != 5) {
      _currentStep = cardStatus - 1;
    } else {
      _currentStep = 1;
    }

    stepContents = [
      // Content for "All" step
      [
        buildDataTables(widget.cards),
      ],
      // Content for "On Review" step
      [
        buildDataTablesCorrection(widget.cards),
      ],
      // Content for "Finish" step
      [
        Card(
          elevation: 2.0,
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  HistoryAssets.takeCardText, // Display the cardCredential
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center, // Center the text
                ),
                Container(
                  padding: EdgeInsets.all(14),
                  child: Image.asset(
                    HistoryAssets.takeCardLocationImage,
                    width: 46,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  HistoryAssets
                      .cardCredentialText, // Add a label or description if needed
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Center the text
                ),
                Text(
                  widget.cards!.cardCredential, // Display the cardCredential
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center, // Center the text
                ),
              ],
            ),
          ),
        ),
      ],
      // Content for "Finish" step
      [
        Card(
          elevation: 2.0,
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  HistoryAssets
                      .alreadyTakeText, // Add a label or description if needed
                  style: TextStyle(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center, // Center the text
                ),
              ],
            ),
          ),
        ),
      ],
    ];
  }

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
        title: Text(HistoryAssets.detailCardTitle,
            style: Theme.of(context).textTheme.headline2),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(), // Disable overscroll glow
        child: Column(
          children: [
            Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepTapped: (step) {
                // Do nothing when a step is tapped to make it unclickable
              },
              onStepContinue: () {
                // Do nothing when the continue button is pressed to make it unclickable
              },
              onStepCancel: () {
                // Do nothing when the cancel button is pressed to make it unclickable
              },
              controlsBuilder: (
                BuildContext context,
                ControlsDetails controlsDetails,
              ) {
                return Container();
              },
              steps: [
                for (var i = 0; i < HistoryAssets.stepTitles.length; i++)
                  Step(
                    title: Text(
                      HistoryAssets.stepTitles[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: _currentStep >= i
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _currentStep >= i ? Colors.blue : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      stepContents[i].length == 0 ? '' : 'Tahap ${i + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: _currentStep >= i ? Colors.blue : Colors.grey,
                      ),
                    ),
                    content:
                        _currentStep == i ? stepContents[i][0] : Container(),
                    state: _currentStep >= i
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: _currentStep >= i,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataTables(CardResponse? cardData) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DataTable(
              columns: [
                DataColumn(
                  label: Text(HistoryAssets.fieldText,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text(HistoryAssets.valueText,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              rows: buildDataRows(cardData),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> buildDataRows(CardResponse? cardData) {
    List<DataRow> dataRows = [];

    // Add common rows regardless of card type
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(HistoryAssets.cardTypeText)),
        DataCell(Text(cardData!.cardType)),
      ],
    ));
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(HistoryAssets.holderPositionText)),
        DataCell(Text(cardData.cardSubType)),
      ],
    ));
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(HistoryAssets.nameText)),
        DataCell(Text(cardData.name)),
      ],
    ));
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(HistoryAssets.ktpNumberText)),
        DataCell(Text(cardData.ktpNumber)),
      ],
    ));
    // if (cardData.photo != null) {
    //   final String profileImageUrl = cardData.photo!;
    //   dataRows.add(
    //     DataRow(cells: [
    //       DataCell(Text('Foto Profil')),
    //       DataCell(
    //         // Wrap the image in InkWell to make it clickable
    //         InkWell(
    //           onTap: () {
    //             // Show the image in a popup dialog
    //             showDialog(
    //               context: context,
    //               builder: (BuildContext context) {
    //                 return AlertDialog(
    //                   content: Image.network(
    //                     fit: BoxFit.contain,
    //                     profileImageUrl,
    //                     width: MediaQuery.of(context)
    //                         .size
    //                         .width, // Adjust the width as needed
    //                     height: MediaQuery.of(context).size.width /
    //                         2, // Adjust the height as needed
    //                   ),
    //                 );
    //               },
    //             );
    //           },
    //           child: Image.network(
    //             profileImageUrl,
    //             width: 100, // Adjust the width as needed
    //             height: 100, // Adjust the height as needed
    //           ),
    //         ),
    //       ),
    //     ]),
    //   );
    // }

    // Add more rows and conditions for other fields as needed
    return dataRows;
  }

  Widget buildDataTablesCorrection(CardResponse? cardData) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DataTable(
              columns: [
                DataColumn(
                  label: Text(HistoryAssets.valueText,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text(HistoryAssets.statusText,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              rows: buildDataRowsCorrection(cardData),
            ),
            DataTable(
              columns: [
                DataColumn(
                  label: Text(HistoryAssets.messageText,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              rows: buildDataRowsMessage(cardData),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> buildDataRowsCorrection(CardResponse? cardData) {
    List<DataRow> dataRows = [];
    bool checklistStatus = cardData!.checklistStatus;

    // Add common rows regardless of card type
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(cardData.cardType)),
        DataCell(
          _buildStatusWidget(checklistStatus),
        ),
      ],
    ));
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(cardData.cardSubType)),
        DataCell(
          _buildStatusWidget(checklistStatus),
        ),
      ],
    ));
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(cardData.name)),
        DataCell(
          _buildStatusWidget(checklistStatus),
        ),
      ],
    ));
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(cardData.ktpNumber)),
        DataCell(
          _buildStatusWidget(checklistStatus),
        ),
      ],
    ));
    //PUT SHOW IMAGE FUNCTION HERE

    return dataRows;
  }

  Widget _buildStatusWidget(bool checklistStatus) {
    return checklistStatus
        ? Icon(
            Icons.check_circle,
            color: Colors.green,
          )
        : Icon(
            Icons.cancel,
            color: Colors.red,
          );
  }

  List<DataRow> buildDataRowsMessage(CardResponse? cardData) {
    List<DataRow> dataRows = [];

    // Add common rows regardless of card type
    dataRows.add(DataRow(
      cells: [
        DataCell(Text(
            'penamanaan dari yang namanya nama perlu diperhatikan lagi agar namnya tidak namapnama'))
      ],
    ));
    return dataRows;
  }
}
