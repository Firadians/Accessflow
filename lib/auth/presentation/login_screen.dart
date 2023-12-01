import 'package:flutter/material.dart';
import 'dart:async';
import 'package:accessflow/utils/strings.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:accessflow/auth/presentation/widget/custom_loading_dialog.dart';
import 'package:accessflow/main_navigation.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:accessflow/auth/domain/entities/user.dart';
import 'package:accessflow/auth/domain/user_use_case.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SharedPreference sharedPreference = SharedPreference();
  User? user;
  bool isPasswordVisible = false;
  bool isEmailValid = true;
  bool isPasswordValid = true;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
    // Add listeners to controllers
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text(GlobalAssets.noConnectionText),
          content: const Text(GlobalAssets.pleaseCheckText),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    // Remove listeners when the widget is disposed
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      isEmailValid = _emailController.text.isNotEmpty;
    });
  }

  void _validatePassword() {
    setState(() {
      isPasswordValid = _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildLoginBackground(),
          buildCompanyImages(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildAppLogo(),
                buildLoginForm(),
                buildLoginButton(),
                buildForgotPasswordButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginBackground() {
    return Positioned.fill(
      child: Image.asset(
        LoginAssets.loginBackground,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildCompanyImages() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildImageAsset(LoginAssets.bumnLogo),
          buildImageAsset(LoginAssets.pupukIndonesiaLogo),
          buildImageAsset(LoginAssets.petrokimiaGresikLogo),
        ],
      ),
    );
  }

  Widget buildAppLogo() {
    return Image.asset(
      LoginAssets.appLogo,
      width: 170.0,
      height: 80.0,
    );
  }

  Widget buildImageAsset(String assetPath) {
    return Image.asset(
      assetPath,
      width: 40.0,
      height: 40.0,
    );
  }

  Widget buildWelcomeText() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: const Text(
        LoginAssets.sacText,
        style: TextStyle(
          color: Color.fromRGBO(0, 1, 49, 63),
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildTextField(
              _emailController, GlobalAssets.ktpText, Icons.account_circle),
          buildPasswordField(
              _passwordController, GlobalAssets.passwordText, Icons.lock),
        ],
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String labelText,
    IconData prefixIcon,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isEmailValid ? Colors.white : Colors.red,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(1, 49, 63, 91),
            ),
          ),
          labelStyle: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }

  Widget buildPasswordField(
    TextEditingController controller,
    String labelText,
    IconData prefixIcon,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
      child: TextField(
        obscureText: !isPasswordVisible,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isPasswordValid ? Colors.white : Colors.red,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(1, 49, 63, 100),
            ),
          ),
          labelStyle: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0), // Add space on top
      height: 50,
      width: 1920,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(50, 90, 102, 1),
        ),
        onPressed: _signIn,
        child: Text(LoginAssets.loginText,
            style: Theme.of(context).textTheme.displayMedium),
      ),
    );
  }

  Widget buildForgotPasswordButton() {
    return TextButton(
      onPressed: () async {},
      child: Text(LoginAssets.forgotPasswordText,
          style: Theme.of(context).textTheme.headlineMedium),
    );
  }

  Future<void> _signIn() async {
    final String username = _emailController.text;
    final String password = _passwordController.text;

    // Show loading indicator
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomLoadingDialog(),
    );

    try {
      // Perform the sign-in operation (e.g., making a network request)
      user = await UserUseCase.signIn(username, password);

      // Save user information to SharedPreferences
      await sharedPreference.saveTokenToSharedPreferences(user!.rememberToken);
      await sharedPreference.savePositionToSharedPreferences(user!.position);
      await sharedPreference.saveUserToSharedPreferences(user!.name);
      await sharedPreference.saveNIKToSharedPreferences(user!.ktp);

      // Hide the loading indicator
      Navigator.of(context).pop(); // Pop the loading dialog

      Fluttertoast.showToast(
        msg: "Log In Success.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 206, 206, 206),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate based on the user's position
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Pop the loading dialog
      _showErrorFlash('Authentication failed');
    }
  }

  void _showErrorFlash(String message) {
    Flushbar(
      title: 'Error',
      message: message,
      duration: const Duration(
          seconds:
              2), // Set the duration for which the message will be displayed
      flushbarPosition:
          FlushbarPosition.BOTTOM, // Adjust the position as needed
      flushbarStyle: FlushbarStyle.GROUNDED, // Set the style as needed
      backgroundColor: Colors.red, // Set the background color
    ).show(context);
  }
}
