import 'package:flutter/material.dart';
import 'package:accessflow/auth/presentation/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:accessflow/profile/data/preferences/shared_preference.dart';

class ProfileScreen extends StatelessWidget {
  final SharedPreference sharedPreference = SharedPreference();

  void _logout(BuildContext context) async {
    try {
      // Clear session data in SharedPreferences
      await sharedPreference.removeTokenFromSharedPreferences();
      await sharedPreference.removePositionFromSharedPreferences();

      // Show a snackbar message upon successful logout
      Fluttertoast.showToast(
          msg: "Log Out Success.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 206, 206, 206),
          textColor: Colors.white,
          fontSize: 16.0);
      // Navigate back to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 236, 236), // Not const
      appBar: AppBar(
        title: Text(
          'Profile', // Customize the title
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // _buildProfileHeader(),
                _buildSectionTitle('General'),
                _buildSectionItem(
                    Icons.notifications_none, 'Pengaturan Notifikasi', context),
                _buildSectionItem(Icons.help_outline_rounded, 'FAQ', context),
                _buildSectionItem(
                    Icons.privacy_tip_rounded, 'Terms of Service', context),
                _buildSectionItem(Icons.ios_share, 'Call Center', context),
                _buildLogoutButton(context), // Pass context here
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: 'roboto', fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildSectionItem(IconData icon, String text, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use Navigator to navigate based on the text
        switch (text) {
          case 'Language':
            Navigator.pushNamed(context, '/language');
            break;
          case 'Pengaturan Notifikasi':
            Navigator.pushNamed(context, '/pengaturan_notifikasi');
            break;
          case 'FAQ':
            Navigator.pushNamed(context, '/faq');
            break;
          case 'Terms of Service':
            Navigator.pushNamed(context, '/terms_of_service');
            break;
          case 'Call Center':
            Navigator.pushNamed(context, '/call_center');
            break;
          default:
            // Handle unknown text or do nothing
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x3416202A),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Color.fromARGB(65, 0, 0, 0),
                  size: 24,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(text),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(65, 0, 0, 0),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    // Pass context here
    return GestureDetector(
      onTap: () {
        _logout(context); // Pass context here
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Center(
          child: Text(
            'Keluar',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 63, 63, 63),
            ),
          ),
        ),
      ),
    );
  }
}
