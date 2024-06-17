import 'package:flutter/material.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/draft/data/repositories/card_repository.dart';
import 'package:accessflow/create_card/presentation/create_card_screen.dart';
import 'package:accessflow/draft/presentation/widget/shimmer_loading_list.dart';
import 'package:accessflow/utils/strings.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  DraftScreenState createState() => DraftScreenState();
}

class DraftScreenState extends State<DraftScreen> {
  final CardRepository cardRepository = CardRepository();
  bool isLoading = true;

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DraftAssets.draftText,
            style: Theme.of(context).textTheme.displayLarge),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(DraftAssets.draftBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main Content
          RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder<List<CardResponse>>(
              future: cardRepository.getDraftCardData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: ShimmerLoadingList(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset(GlobalAssets
                              .noDataImage), // Replace with your image asset path
                        ),
                        const Text(
                          GlobalAssets.noDataText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  // Show default content if no data is available
                  return Center(
                    child: Text('Your default content goes here.'),
                  );
                } else {
                  // Show content when data is available
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final card = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CreateCardScreen(
                                      title: card.cardType,
                                      cards: snapshot.data![index],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 1),
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 211, 211, 211),
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 5, 16, 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tipe Kartu : ${card.cardType}',
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 5, 0, 0),
                                              child: Text(
                                                '${HistoryAssets.cardSaveDateText} : ${card.createData}',
                                                style: TextStyle(
                                                    fontSize:
                                                        12.0), // Specify the font size here
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Confirmation'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this data?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await cardRepository
                                                            .deleteDraftCardData(
                                                                card.id
                                                                    .toString());
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        _refreshData();
                                                      },
                                                      child:
                                                          const Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
