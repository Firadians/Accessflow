import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:accessflow/create_card/presentation/widget/custom_text_editable_widget.dart';
import 'package:flutter/material.dart';
import 'package:accessflow/utils/success.dart';
import 'package:image_picker/image_picker.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/create_card/presentation/widget/submit_data_confirm.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:accessflow/create_card/data/repositories/card_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';

class IDCardContent extends StatefulWidget {
  final Map<String, dynamic>? editData;
  final int? id;

  IDCardContent({this.editData, this.id});

  @override
  _IDCardContentState createState() => _IDCardContentState();
}

class _IDCardContentState extends State<IDCardContent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final CardRepository cardRepository = CardRepository();
  final SharedPreference sharedPreference = SharedPreference();
  dynamic profileImageFile;
  String? profileImageName;
  String? name;
  String? ktp;
  int? id;
  final ImagePicker picker = ImagePicker();
  bool checklistStatus = false;
  late String userEmail;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ktpController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String currentDateTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  bool isEditing = false;
  bool isNew = false;
  bool isNameValid = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: 'ID Card',
            description: 'ID Card',
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/icons/icon_close.png',
                  height: 24, width: 24),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // buildTitleText(),
                  // buildDescriptionText(),
                  CustomTextEditableWidget(
                    labelText: 'Nama',
                    hintText: 'Masukkan Nama Anda',
                    controller: nameController,
                    isEditing: isEditing,
                  ),
                  CustomNumberEditableWidget(
                    labelText: 'NIK',
                    hintText: 'Masukkan NIK Anda',
                    controller: ktpController,
                    isEditing: isEditing,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                myAlert(1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: const Text('Pilih Pas Foto'),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(38.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(vertical: 15.0),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: buildClickableImageName(
                                  profileImageName, profileImageFile),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomTextEditableWidget(
                    labelText: 'Alasan',
                    hintText: 'Masukkan Alasan Pembuatan Kartu',
                    controller: reasonController,
                    isEditing: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 1,
                // margin: EdgeInsets.symmetric(horizontal: 20), // Optional margin
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 201, 201, 201), // Color of the divider
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(66, 178, 178, 178), // Shadow color
                      offset: Offset(0, -4), // Offset in x and y directions
                      blurRadius: 2, // Blur radius
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SubmitCompleteDataConfirm(
                        onSubmit: _createCard,
                        validateFields: validateFields,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool validateFields() {
    return nameController.text.isNotEmpty &&
        ktpController.text.isNotEmpty &&
        profileImageFile != null &&
        reasonController.text.isNotEmpty;
  }

  Future<void> _loadUserData() async {
    String? owner = await sharedPreference.getUserFromSharedPreferences();
    String? ktp = await sharedPreference.getNIKFromSharedPreferences();
    try {
      setState(() {
        nameController.text = owner!;
        ktpController.text = ktp!;
        // Set the image files if they exist in the editData
        // if (user['photo'] != null) {
        //   profileImageFile = user['photo'];
        //   profileImageName = 'Press Here!';
        // } else {
        //   profileImageName = 'No available image';
        // }
      });
      _showSuccessFlash("Data loaded successfully");
    } catch (e) {
      print('Error loading user data: $e');
      _showErrorFlash("Error loading user data");
    }
  }

  void _createCard({bool isDraft = false, int cardStatus = 1}) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog with a tap
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Submitting Data...'),
            ],
          ),
        );
      },
    );

    try {
      if (isDraft == false && cardStatus == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Name Taken'),
              content: Text(
                  'The name is already taken. Please choose a different name.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        String? owner = await sharedPreference.getUserFromSharedPreferences();

        // String? profileImageUrl;
        // if (profileImageFile != null && isNew == true) {
        //   profileImageUrl = await imageFileToBase64(profileImageFile);
        // } else {
        //   profileImageUrl = profileImageFile;
        // }
        // Perform an update operation if in edit mode
        cardRepository
            .insertCard(
                id,
                owner ?? "no data",
                nameController.text,
                "no data",
                cardStatus,
                "ID Card",
                "no data",
                false,
                currentDateTime,
                ktpController.text,
                "no data",
                reasonController.text)
            .then((result) {
          int status = result['status'];
          String message = result['message'];

          // Now you can handle the status and message here
          if (status == 200) {
            // Successful insertion, you can show a success message
            print(message);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Success(),
            ));
          } else {
            // Handle errors or show an error message
            Navigator.of(context).pop();
          }
        }).catchError((error) {
          // Handle errors here
          print('Error: $error');
        });
      }
    } catch (e) {
      print('Error uploading images or inserting/updating data: $e');
    }
  }

  Future<String?> imageFileToBase64(File imageFile) async {
    try {
      // Read the image file into bytes
      Uint8List imageBytes = await readBytesFromFile(imageFile);

      // Convert the bytes to a base64 string
      String base64String = imageToBase64(imageBytes);

      return base64String;
    } catch (e) {
      print("Error converting image to base64: $e");
      return null;
    }
  }

  Future<Uint8List> readBytesFromFile(File file) async {
    Uint8List uint8list = await file.readAsBytes();
    return uint8list;
  }

  String imageToBase64(Uint8List imageBytes) {
    String base64String = base64Encode(imageBytes);
    // Ensure the base64 string is properly padded
    while (base64String.length % 4 != 0) {
      base64String += '=';
    }
    return base64String;
  }

  Image imageFromBase64String(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return Image.memory(bytes);
  }

  // Updated myAlert function
  void myAlert(int imageNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('Please choose media to select'),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery, imageNumber);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      Text('From Gallery'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera, imageNumber);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      Text('From Camera'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getImage(ImageSource source, int imageNumber) async {
    try {
      final pickedFile = await picker.getImage(source: source);

      setState(() {
        if (pickedFile != null) {
          if (imageNumber == 1) {
            profileImageFile = File(pickedFile.path);
            isNew = true;
          }
        }
      });
    } catch (e) {
      print('Error selecting image: $e');
    }
  }

  void _showSuccessFlash(String message) {
    Flushbar(
      title: 'Success',
      message: message,
      duration: Duration(seconds: 1),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.green,
    )..show(context);
  }

  void _showErrorFlash(String message) {
    Flushbar(
      title: 'Error',
      message: message,
      duration: Duration(seconds: 1),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.red,
    )..show(context);
  }

  void showImagePreview(dynamic image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: image is File
                ? Image.file(
                    image,
                    fit: BoxFit.contain,
                  )
                : Image.network(
                    image,
                    fit: BoxFit.contain,
                  ),
          ),
        );
      },
    );
  }

  Widget buildClickableImageName(String? imageName, dynamic imageFile) {
    return GestureDetector(
      onTap: () {
        if (imageFile != null) {
          showImagePreview(imageFile);
        } else {
          // Load image from an asset if imageFile is null
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Image.asset(
                    'assets/no_image.png', // Replace with your image asset path
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          );
        }
      },
      child: Text(
        imageName ?? 'No Image Selected',
        style: TextStyle(
          color: imageFile != null ? Colors.blue : Colors.grey,
          decoration: imageFile != null
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );
  }
}

Future<String?> getEmailFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Widget buildTitleText() {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
    child: const Text(
      'Perlu Diperhatikan',
      style: TextStyle(
        fontFamily:
            'roboto', // Specify the font family if you have a custom font
        color: Color.fromARGB(255, 4, 4, 4),
        fontWeight: FontWeight.w900,
        fontSize: 30,
      ),
    ),
  );
}

Widget buildDescriptionText() {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: const Text(
      'Data yang diisi bukan merupakan data yang pernah didaftarkan sebelumnya (Baru). Pastikan data yang dimasukkan sesuai dengan ketentuan.',
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily:
            'roboto', // Specify the font family if you have a custom font
        color: Color.fromARGB(255, 25, 25, 25),
        fontSize: 14,
      ),
    ),
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String description;
  final Widget? leading;
  final List<Widget>? actions;
  const CustomAppBar(
      {super.key,
      required this.title,
      required this.description,
      this.leading,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 1, 58, 73),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: leading,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions ?? [],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Space between title and description
            Text(
              description,
              style: TextStyle(
                fontFamily:
                    'roboto', // Specify the font family if you have a custom font
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20), // Space between description and image
            Text(
              'Data yang diisi bukan merupakan data yang pernah didaftarkan sebelumnya (Baru). Pastikan data yang dimasukkan sesuai dengan ketentuan.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily:
                    'roboto', // Specify the font family if you have a custom font
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w100,
                fontSize: 14,
                height: 1.5, // Add line spacing here
              ),
            ),
            const SizedBox(height: 20), // Space between description and image
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 210);
}
