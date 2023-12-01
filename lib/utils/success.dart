import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:accessflow/utils/strings.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds and then navigate to another page or widget
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color.fromARGB(255, 0, 175, 0),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    UtilsAssets.successLottieJson,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    frameRate: FrameRate(60),
                    repeat: false,
                    animate: true,
                  ),
                ],
              ),
            ),
            Text(UtilsAssets.successTitle,
                style: TextStyle(
                  fontSize: 24, // Adjust the font size here
                  fontWeight: FontWeight.bold, // Change the font weight here
                  color: Color.fromARGB(
                      255, 255, 255, 255), // Change the text color here
                )),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: Text(UtilsAssets.successdesc,
                  style: TextStyle(
                    fontSize: 18, // Adjust the font size here
                    fontWeight: FontWeight.bold, // Change the font weight here
                    color: Color.fromARGB(
                        255, 255, 255, 255), // Change the text color here
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
