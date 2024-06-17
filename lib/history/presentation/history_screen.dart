import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/history/presentation/detail_card_screen.dart';
import 'package:accessflow/history/data/repositories/card_repository.dart';
import 'package:accessflow/history/presentation/widget/shimmer_loading_list.dart';
import 'package:accessflow/utils/strings.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final CardRepository cardRepository = CardRepository();
  final SharedPreference sharedPreference = SharedPreference();
  List<CardResponse> filteredCards = [];
  bool isLoading = true;
  String? owner;
  late TabController _tabController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadUserFromSharedPreferences();
    _tabController = TabController(length: 3, vsync: this);
    _initializeNotifications();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      // 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Kartu anda telah selesai',
      'Silahkan lakukan pengambilan di departemen keamanan.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserFromSharedPreferences() async {
    setState(() {});
    _loadData(); // Load data after getting the user's email
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    // Load data
    try {
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  Future<void> _refreshData() async {
    // Simulate a delay for refresh
    await Future.delayed(Duration(seconds: 2));
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HistoryAssets.historyText,
            style: Theme.of(context).textTheme.headline1),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: HistoryAssets.tabAllText),
            Tab(text: HistoryAssets.tabOnProgressText),
            Tab(text: HistoryAssets.tabCompletedText),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(HistoryAssets.historyBackgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Main Content
            Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Submit
                      buildTabView(1),

                      // Tab 2: On Progress
                      buildTabView(2),

                      // Tab 3: Completed
                      buildTabView(3),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabView(int tabIndex) {
    return FutureBuilder<List<CardResponse>>(
      future: cardRepository.getSubmitCardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: ShimmerLoadingList(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset(GlobalAssets.noDataImage),
                ),
                Text(
                  GlobalAssets.noDataText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset(GlobalAssets.noDataImage),
                ),
                Text(
                  GlobalAssets.noDataText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          // Filter card data based on status
          if (tabIndex == 1) {
            // "All" tab: Show cards with status 1-4
            filteredCards = snapshot.data!;
          } else if (tabIndex == 2) {
            // "On Progress" tab: Show cards with status 1-3
            filteredCards = snapshot.data!
                .where((card) => [1, 2, 3].contains(card.cardStatus))
                .toList();
          } else if (tabIndex == 3) {
            // "Completed" tab: Show cards with status 4
            filteredCards =
                snapshot.data!.where((card) => card.cardStatus == 4).toList();
          }

          // Check if there is any card with status 3
          bool hasStatusThreeCard =
              snapshot.data!.any((card) => card.cardStatus == 3);

          if (hasStatusThreeCard) {
            _showNotification();
          }

          if (filteredCards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset(GlobalAssets.noDataImage),
                  ),
                  Text(
                    GlobalAssets.noDataText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Background Image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(HistoryAssets.historyBackgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Main Content
              ListView.builder(
                itemCount: filteredCards.length,
                itemBuilder: (context, index) {
                  final card = filteredCards[index];
                  return Card(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate to card detail screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailCardScreen(
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
                                    color: Color.fromARGB(255, 211, 211, 211),
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
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
                                            '${HistoryAssets.cardTypeText} : ${card.cardType}'),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Text(
                                            '${HistoryAssets.cardSaveDateText} : ${card.createData}',
                                            style: TextStyle(
                                                fontSize:
                                                    12.0), // Specify the font size here
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildStatusIndicator(card.cardStatus),
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
              ),
            ],
          );
        }
      },
    );
  }

  // Helper function to check if card status matches the given tabIndex
  bool _isCardStatusMatch(CardResponse card, int tabIndex) {
    if (tabIndex == 1) {
      return [1, 2, 3, 4].contains(card.cardStatus);
    } else if (tabIndex == 2) {
      return [1, 2, 3].contains(card.cardStatus);
    } else if (tabIndex == 3) {
      return [4].contains(card.cardStatus);
    } else {
      return [1, 2, 3, 4].contains(card.cardStatus);
    }
  }

  Widget buildStatusIndicator(int cardStatus) {
    Color indicatorColor;
    Color textColor;
    String statusText;

    switch (cardStatus) {
      case 1:
        indicatorColor = Color.fromARGB(49, 106, 216, 214);
        textColor = Color.fromARGB(92, 83, 169, 167);
        statusText = HistoryAssets.statusIndicatorOne;
        break;
      case 2:
        indicatorColor = Color.fromARGB(49, 28, 165, 244);
        textColor = Color.fromARGB(95, 28, 165, 244);
        statusText = HistoryAssets.statusIndicatorTwo;
        break;
      case 3:
        indicatorColor = Color.fromARGB(48, 218, 214, 3);
        textColor = Color.fromARGB(95, 145, 143, 3);
        statusText = HistoryAssets.statusIndicatorThree;
        break;
      case 4:
        indicatorColor = Color.fromARGB(49, 44, 200, 52);
        textColor = Color.fromARGB(95, 31, 142, 37);
        statusText = HistoryAssets.statusIndicatorFour;
        break;
      default:
        indicatorColor = Color.fromARGB(48, 216, 106, 106);
        textColor = Color.fromARGB(47, 216, 126, 106);
        statusText = HistoryAssets.statusIndicatorFive;
        break;
    }

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: indicatorColor,
          width: 2,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
