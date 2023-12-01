import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:accessflow/create_card/presentation/widget/custom_text_editable_widget.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_model_list/dropdown_model_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/create_card/presentation/widget/submit_data_confirm.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:accessflow/create_card/data/repositories/card_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accessflow/utils/success.dart';
import 'package:accessflow/draft/domain/card_response.dart';

class AksesPerumdinContent extends StatefulWidget {
  final CardResponse? cards; // Change the type to List<CardResponse>

  AksesPerumdinContent({this.cards});

  @override
  _AksesPerumdinContentState createState() => _AksesPerumdinContentState();
}

class _AksesPerumdinContentState extends State<AksesPerumdinContent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic profileImageFile;

  String? profileImageName;

  final ImagePicker picker = ImagePicker();
  bool checklistStatus = false;
  late String userEmail;
  int? id;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ktpController = TextEditingController();

  OptionItem optionItemSelected = OptionItem(title: "Select User");
  DropListModel dropListModel = DropListModel([
    OptionItem(id: "1", title: "Ayah"),
    OptionItem(id: "2", title: "Ibu"),
    OptionItem(id: "3", title: "Anak"),
    OptionItem(id: "4", title: "Driver"),
    OptionItem(id: "5", title: "ART"),
  ]);
  String? selectedItem = 'no data';

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String currentDateTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  final CardRepository cardRepository = CardRepository();
  final SharedPreference sharedPreference = SharedPreference();
  bool isEditMode = false;
  bool isNew = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    if (widget.cards != null) {
      isEditMode = true;
      populateFieldsForEditing();
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
        // String? profileImageUrl;
        String? owner = await sharedPreference.getUserFromSharedPreferences();

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
                "Akses Perumdin",
                selectedItem ?? "no data",
                false,
                currentDateTime,
                ktpController.text,
                "no data",
                "no data")
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

  void _createDraftCard() {
    _createCard(
        isDraft: true,
        cardStatus:
            0); // Set isDraft to true and cardStatus to 0 when saving as draft
  }

  void populateFieldsForEditing() async {
    final card = widget.cards;
    id = card!.id;
    nameController.text = card.name;
    ktpController.text = card.ktpNumber;
    // Set the image files if they exist in the card data
    if (card.photo != null) {
      if (card.photo is String) {
        // Decode the base64 string to a Uint8List
        Uint8List bytes = base64Decode(card.photo!);
        // Create an image widget from the bytes
        profileImageFile = Image.memory(bytes);
        profileImageName = 'Image Selected';
      } else if (card.photo is File) {
        profileImageFile = card.photo;
        profileImageName = 'Image Selected';
      }
    }
    selectedItem = card.cardSubType;
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
            isNew = true;
            profileImageFile = File(pickedFile.path);
          }
        }
      });
    } catch (e) {
      print('Error selecting image: $e');
    }
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
                : Image.memory(
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
          if (imageFile is File) {
            showImagePreview(imageFile);
          } else {
            final image = imageFromBase64String(imageFile);
            showImagePreview(image);
          }
        }
      },
      child: Text(
        imageFile != null
            ? 'Click here to see'
            : imageName ?? 'No Image Selected',
        style: TextStyle(
          color: imageFile != null ? Colors.blue : Colors.grey,
          decoration: imageFile != null
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close, // You can use a different icon if needed
            color: Colors.white, // Customize the color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Akses Perumdin',
            style: Theme.of(context).textTheme.headline2),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTitleText(),
              buildDescriptionText(),
              CustomTextEditableWidget(
                controller: nameController,
                labelText: 'Nama',
                hintText: 'Masukkan Nama Anda',
                isEditing: true,
              ),
              CustomNumberEditableWidget(
                controller: ktpController,
                labelText: 'Nomor KTP',
                hintText: 'Masukkan Nomor KTP Anda',
                isEditing: true,
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, 0, 0, 0), // Add left spacing of 10 units
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            myAlert(1);
                          },
                          child: Text('Pilih Pas Foto'),
                        ),
                        SizedBox(width: 10), // Add spacing
                        Expanded(
                          child: buildClickableImageName(
                              profileImageName, profileImageFile),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SelectDropList(
                itemSelected: optionItemSelected,
                dropListModel: dropListModel,
                showIcon: true, // Show Icon in DropDown Title
                showArrowIcon: true, // Show Arrow Icon in DropDown
                showBorder: true,
                paddingTop: 0,
                icon: const Icon(Icons.person, color: Colors.black),
                onOptionSelected: (optionItem) {
                  optionItemSelected = optionItem;
                  setState(() {
                    selectedItem = optionItemSelected.title.toString();
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SubmitCompleteDraftConfirm(
                          onSubmit: _createDraftCard,
                          validateFields: validateFieldsDraft,
                        ),
                      ),
                      SizedBox(width: 10), // Add spacing between the buttons
                      Expanded(
                        child: SubmitCompleteDataConfirm(
                          onSubmit: _createCard,
                          validateFields: validateFieldsSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateFieldsSubmit() {
    return nameController.text.isNotEmpty &&
        ktpController.text.isNotEmpty &&
        profileImageFile != null && // Check if profileImageFile is not empty
        optionItemSelected.title !=
            'Select User'; // Check if optionItemSelected is selected
  }

  bool validateFieldsDraft() {
    return nameController.text.isNotEmpty && ktpController.text.isNotEmpty;
  }

  Future<void> _loadUserEmail() async {
    final email = await getEmailFromSharedPreferences();
    setState(() {
      // Convert the retrieved value to a string
      userEmail = email.toString();
    });
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
