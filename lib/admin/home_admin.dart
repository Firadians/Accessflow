import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accessflow/auth/presentation/login_screen.dart';
import 'package:accessflow/create_card/data/repositories/card_repository.dart';

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? userEmail;
  final CardRepository cardRepository = CardRepository();
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadEmailFromSharedPreferences();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEmailFromSharedPreferences() async {
    userEmail = await getEmailFromSharedPreferences();
    setState(() {});
    _loadData(); // Load data after getting the user's email
  }

  void _logout(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // Clear session data in SharedPreferences
      prefs.setBool('isLoggedIn', false);
      prefs.remove('username');
      prefs.remove('email');
      prefs.remove('position');
      // Navigate back to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginScreen(), // Provide the FirebaseAuth instance if needed
        ),
      );
    } catch (e) {
      // Handle logout errors, if any.
      print(e.toString());
    }
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    // Load data
    try {
      // await cardRepository.getAdminSubmitCardData().then((snapshot) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // });
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
        title: Text('History', style: Theme.of(context).textTheme.headline1),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Recent'),
            Tab(text: 'On Progress'),
            Tab(text: 'Completed'),
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
                  image: AssetImage("assets/history_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Main Content
            Column(
              children: [
                userEmail == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // // Tab 1: Submit
                                // buildTabView(1),

                                // // Tab 2: On Progress
                                // buildTabView(2),

                                // // Tab 3: Completed
                                // buildTabView(3),
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

  // Widget buildTabView(int tabIndex) {
  //   List<int> statusFilter;

  //   if (tabIndex == 1) {
  //     statusFilter = [1, 2, 3, 4];
  //   } else if (tabIndex == 2) {
  //     statusFilter = [1, 2, 3];
  //   } else if (tabIndex == 3) {
  //     statusFilter = [4];
  //   } else {
  //     statusFilter = [1, 2, 3, 4];
  //   }

  // return StreamBuilder<QuerySnapshot>(
  //   stream: cardRepository.getAdminSubmitCardDataStream(userEmail!),
  //   builder: (context, snapshot) {
  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return ShimmerLoadingList();
  //     } else if (snapshot.hasError) {
  //       return Text('Error: ${snapshot.error}');
  //     } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //       return Center(
  //         child: Text('No data available'),
  //       );
  //     } else {
  //       final cardData = snapshot.data!.docs;
  //       return ListView.builder(
  //         itemCount: cardData.length,
  //         itemBuilder: (context, index) {
  //           final data = cardData[index].data() as Map<String, dynamic>;
  //           final cardStatus = data['card_status'];
  //           final Timestamp dataTimestamp = data['create_date'];
  //           DateTime dateTime = dataTimestamp.toDate();
  //           String DateTimeConvert =
  //               DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  //           final documentId = cardData[index].id; // Get the document ID

  //           if (statusFilter.contains(cardStatus)) {
  //             return Card(
  //               margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).push(MaterialPageRoute(
  //                         builder: (context) =>
  //                             CardAdmin(cardData: data, id: documentId),
  //                       ));
  //                     },
  //                     child: Padding(
  //                       padding:
  //                           const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
  //                       child: Container(
  //                         width: double.infinity,
  //                         height: 60,
  //                         decoration: const BoxDecoration(
  //                           color: Colors.white,
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Color.fromARGB(255, 211, 211, 211),
  //                               offset: Offset(0, 1),
  //                             ),
  //                           ],
  //                         ),
  //                         child: Padding(
  //                           padding:
  //                               EdgeInsetsDirectional.fromSTEB(16, 5, 16, 5),
  //                           child: Row(
  //                             mainAxisSize: MainAxisSize.max,
  //                             mainAxisAlignment:
  //                                 MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Column(
  //                                 mainAxisSize: MainAxisSize.max,
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 crossAxisAlignment:
  //                                     CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     'Tipe Kartu : ${data['card_type']}',
  //                                   ),
  //                                   Padding(
  //                                     padding: EdgeInsetsDirectional.fromSTEB(
  //                                         0, 5, 0, 0),
  //                                     child: Text(
  //                                       'Disubmit pada : $DateTimeConvert',
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               buildStatusIndicator(cardStatus),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           } else {
  //             return SizedBox(); // Return an empty widget if data doesn't match the status
  //           }
  //         },
  //       );
  //     }
  //   },
  // );
  // }

  Future<String?> getEmailFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
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
      statusText = 'Submit';
      break;
    case 2:
      indicatorColor = Color.fromARGB(49, 28, 165, 244);
      textColor = Color.fromARGB(95, 28, 165, 244);
      statusText = 'On Progress';
      break;
    case 3:
      indicatorColor = Color.fromARGB(48, 218, 214, 3);
      textColor = Color.fromARGB(95, 145, 143, 3);
      statusText = 'Completed';
      break;
    case 4:
      indicatorColor = Color.fromARGB(49, 44, 200, 52);
      textColor = Color.fromARGB(95, 31, 142, 37);
      statusText = 'Finish';
      break;
    default:
      indicatorColor = Color.fromARGB(49, 117, 216, 106);
      textColor = Color.fromARGB(49, 117, 216, 106);
      statusText = 'Error';
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
