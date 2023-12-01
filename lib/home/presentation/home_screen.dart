import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:accessflow/cards/access_card.dart';
import 'package:accessflow/cards/akses_perumdin.dart';
import 'package:accessflow/cards/id_card.dart';
import 'package:accessflow/create_card/presentation/create_card_screen.dart';
import 'package:accessflow/home/presentation/widget/custom_card.dart';
import 'package:accessflow/home/presentation/widget/information_dialog.dart';
import 'package:accessflow/home/presentation/widget/image_gallery_widget.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/utils/strings.dart';
import 'package:accessflow/information/information_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Positioned(
        right: 0.0,
        top: -20.0,
        child: Opacity(
          opacity: 1,
          child: Image.asset(
            HomeAssets.homeBackgroundImage,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kToolbarHeight,
            ),
            homeSection(),
            const SizedBox(
              height: 50.0,
            ),
            ContentSection(),
          ],
        ),
      ),
    ]);
  }
}

Widget customCard(
    {required String imagePath,
    required String title,
    TextStyle? titleTextStyle}) {
  return Column(
    children: [
      Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color.fromARGB(255, 246, 246, 246),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(14),
              child: Image.asset(
                imagePath,
                width: 46,
                height: 46,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      SizedBox(width: 10),
      Text(
        title,
        style: titleTextStyle,
      ),
    ],
  );
}

Widget homeSection() {
  final SharedPreference sharedPreference = SharedPreference();
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16.0,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<String?>(
            future: sharedPreference.getUserFromSharedPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final username = snapshot.data ?? HomeAssets.nameGuestText;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      // ignore: unnecessary_null_comparison
                      child: username != null
                          ? Text.rich(
                              TextSpan(
                                text: "${HomeAssets.welcomeText},\n",
                                style: Theme.of(context).textTheme.headline2,
                                children: [
                                  TextSpan(
                                    text: username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Shimmer.fromColors(
                              baseColor: Color.fromARGB(255, 211, 211, 211),
                              highlightColor:
                                  Color.fromARGB(255, 211, 211, 211),
                              child: Container(
                                width: double.infinity,
                                height: 30.0, // Adjust the height as needed
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}

class ContentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPreference().getPositionFromSharedPreferences(),
      builder: (context, positionSnapshot) {
        if (positionSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final userPosition = positionSnapshot.data;
          //CREATE CARD FUNCTION
          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 200.0,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              color: Color.fromARGB(255, 255, 253, 248),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0)),
                                ),
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Container(
                                          width: 40, // Set the desired width
                                          height: 40, // Set the desired height
                                          child: Image.asset(
                                              HomeAssets.accessCardIcon),
                                        ),
                                        title: Text(
                                          HomeAssets.validPositions
                                                  .contains(userPosition)
                                              ? HomeAssets.accessCardText
                                              : HomeAssets.accessCardNAText,
                                          style: TextStyle(
                                            color: HomeAssets.validPositions
                                                    .contains(userPosition)
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        onTap: HomeAssets.validPositions
                                                .contains(userPosition)
                                            ? () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    25.0)),
                                                  ),
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        // Custom title widget
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Text(
                                                            HomeAssets
                                                                .cardStatusText,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        ListTile(
                                                          leading: Container(
                                                            width:
                                                                40, // Set the desired width
                                                            height:
                                                                40, // Set the desired height
                                                            child: Image.asset(
                                                                HomeAssets
                                                                    .createNewIcon),
                                                          ),
                                                          title: Text(HomeAssets
                                                              .createNewText),
                                                          onTap: () {
                                                            // Handle Non-RFID choice here
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CreateCardScreen(
                                                                      title: HomeAssets
                                                                          .accessCardText),
                                                            ));
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: Container(
                                                            width:
                                                                40, // Set the desired width
                                                            height:
                                                                40, // Set the desired height
                                                            child: Image.asset(
                                                                HomeAssets
                                                                    .printAvailableIcon),
                                                          ),
                                                          title: Text(HomeAssets
                                                              .printAvailableText),
                                                          onTap: () {
                                                            // Handle RFID choice here
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CreateCardScreen(
                                                                      title: HomeAssets
                                                                          .accessCardExistText),
                                                            ));
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            : null, // Set onTap to null to disable
                                      ),
                                      ListTile(
                                        leading: Container(
                                          width: 40, // Set the desired width
                                          height: 40, // Set the desired height
                                          child: Image.asset(
                                              HomeAssets.idCardIcon),
                                        ),
                                        title: Text(
                                          HomeAssets.validPositions
                                                  .contains(userPosition)
                                              ? HomeAssets.idCardText
                                              : HomeAssets.idCardNAText,
                                          style: TextStyle(
                                            color: HomeAssets.validPositions
                                                    .contains(userPosition)
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        onTap: HomeAssets.validPositions
                                                .contains(userPosition)
                                            ? () {
                                                // Handle Non-RFID choice here
                                                Navigator.pop(context);
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateCardScreen(
                                                          title: HomeAssets
                                                              .idCardText),
                                                ));
                                              }
                                            : null,
                                      ),
                                      ListTile(
                                        leading: Container(
                                          width: 40, // Set the desired width
                                          height: 40, // Set the desired height
                                          child: Image.asset(
                                              HomeAssets.aksesPerumdinIcon),
                                        ),
                                        title: Text(
                                          HomeAssets.validPositions
                                                  .contains(userPosition)
                                              ? HomeAssets.aksesPerumdinText
                                              : HomeAssets.aksesPerumdinNAText,
                                          style: TextStyle(
                                            color: HomeAssets.validPositions
                                                    .contains(userPosition)
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        onTap: HomeAssets.validPositions
                                                .contains(userPosition)
                                            ? () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    25.0)),
                                                  ),
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        // Custom title widget
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: const Text(
                                                            HomeAssets
                                                                .cardCreateStatusText,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        ListTile(
                                                          leading: Container(
                                                            width:
                                                                40, // Set the desired width
                                                            height:
                                                                40, // Set the desired height
                                                            child: Image.asset(
                                                                HomeAssets
                                                                    .createNewIcon),
                                                          ),
                                                          title: Text(HomeAssets
                                                              .createNewText),
                                                          onTap: () {
                                                            // Handle RFID choice here
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CreateCardScreen(
                                                                title: HomeAssets
                                                                    .aksesPerumdinText,
                                                              ),
                                                            ));
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: Container(
                                                            width:
                                                                40, // Set the desired width
                                                            height:
                                                                40, // Set the desired height
                                                            child: Image.asset(
                                                                HomeAssets
                                                                    .printAvailableIcon),
                                                          ),
                                                          title: Text(HomeAssets
                                                              .printAvailableText),
                                                          onTap: () {
                                                            // Handle Non-RFID choice here
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CreateCardScreen(
                                                                title: HomeAssets
                                                                    .aksesPerumdinExistText,
                                                              ),
                                                            ));
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            : null,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: customCard(
                              imagePath: HomeAssets.makeCardIcon,
                              title: HomeAssets.createCardText,
                              titleTextStyle:
                                  Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          //INFORMATION
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InformationScreen(),
                              ));
                            },
                            child: customCard(
                                imagePath: HomeAssets.informationIcon,
                                title: HomeAssets.informationText,
                                titleTextStyle:
                                    Theme.of(context).textTheme.headline6),
                          ),
                          //USER APP GUIDE
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return InformationDialog();
                                },
                              );
                            },
                            child: customCard(
                              imagePath: HomeAssets.userGuideIcon,
                              title: HomeAssets.userGuideText,
                              titleTextStyle:
                                  Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //IMAGE GALLERY
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 16.0, // Adjust the top value as needed
                        left: 20.0,
                      ),
                      child: Text(HomeAssets.imageGalleryTitle,
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ],
                ),
                const SizedBox(height: 7.0),
                const ImageGallery(),
                //CARD TYPE INFORMATION
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0, // Adjust the top value as needed
                    left: 20.0,
                  ),
                  child: Text(HomeAssets.contentTitle,
                      style: Theme.of(context).textTheme.headline5),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomCard(
                      title: CardAssets.accessCardTitle,
                      subTitle: CardAssets.accessCardPositionText,
                      imagePath: CardAssets.accessCardImage,
                      onTap: () {
                        // Navigate to the Scan Barcode page
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AccessCardPage(),
                        ));
                      },
                    ),
                    CustomCard(
                      title: CardAssets.idCardTitle,
                      subTitle: CardAssets.idCardPositionText,
                      imagePath: CardAssets.idCardImage,
                      onTap: () {
                        // Navigate to the Scan Barcode page
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IDCardPage(),
                        ));
                      },
                    ),
                    CustomCard(
                      title: CardAssets.aksesPerumdinTitle,
                      subTitle: CardAssets.aksesPerumdinPositionText,
                      imagePath: CardAssets.aksesPerumdinImage,
                      onTap: () {
                        // Navigate to the Scan Barcode page
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AksesPerumdinPage(),
                        ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
