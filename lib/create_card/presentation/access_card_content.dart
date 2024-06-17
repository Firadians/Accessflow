import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:accessflow/create_card/presentation/widget/custom_text_editable_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_model_list/dropdown_model_list.dart';
import 'package:accessflow/create_card/presentation/widget/submit_data_confirm.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:accessflow/create_card/data/repositories/card_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accessflow/utils/success.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/utils/strings.dart';

class AccessCardContent extends StatefulWidget {
  final CardResponse? cards;

  AccessCardContent({this.cards});

  @override
  AccessCardContentState createState() => AccessCardContentState();
}

class AccessCardContentState extends State<AccessCardContent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ktpController = TextEditingController();
  final CardRepository cardRepository = CardRepository();
  final SharedPreference sharedPreference = SharedPreference();

  OptionItem optionItemSelected = OptionItem(title: "Select User");
  DropListModel dropListModel = DropListModel([
    OptionItem(id: "1", title: "PT Graha Sarana Gresik"),
    OptionItem(id: "2", title: "RS Graha Husada"),
    OptionItem(id: "3", title: "Mandiri"),
    OptionItem(id: "4", title: "BNI"),
    OptionItem(id: "5", title: "Tamu")
  ]);

  dynamic profileImageFile;
  String? profileImageName;
  final ImagePicker picker = ImagePicker();
  bool checklistStatus = false;
  late String userEmail;
  int? id;
  String? selectedItem = GlobalAssets.noData;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String currentDateTime =
      DateFormat(GlobalAssets.dateFormat).format(DateTime.now());
  bool isEditMode = false;
  bool isNew = false;

  @override
  void initState() {
    super.initState();
    // Set up listeners for text changes
    nameController.addListener(() {
      validateFieldsSubmit();
    });

    ktpController.addListener(() {
      validateFieldsSubmit();
    });
    if (widget.cards != null) {
      isEditMode = true;
      populateFieldsForEditing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: 'Access Card',
            description: 'Access Card',
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/icons/icon_close.png',
                  height: 24, width: 24),
            ),
            actions: [
              SubmitCompleteDraftConfirm(
                onSubmit: _createDraftCard,
                validateFields: validateFieldsDraft,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // buildTitleText(),
                  // buildDescriptionText(),
                  CustomTextEditableWidget(
                    controller: nameController,
                    labelText: CreateCardAssets.nameLabelText,
                    hintText: CreateCardAssets.nameHintText,
                    isEditing: true,
                  ),
                  CustomNumberEditableWidget(
                    controller: ktpController,
                    labelText: CreateCardAssets.ktpLabelText,
                    hintText: CreateCardAssets.ktpHintText,
                    isEditing: true,
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
                  SelectDropList(
                    itemSelected: optionItemSelected,
                    dropListModel: dropListModel,
                    showIcon: true,
                    showArrowIcon: true,
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
                        validateFields: validateFieldsSubmit,
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

  void _createCard({bool isDraft = false, int cardStatus = 1}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Data Sedang Diproses...'),
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
              title: Text('Nama telah tersedia'),
              content: Text(
                  'Silahkan gunakan nama lain atau silahkan cek kartu yang tersedia/pernah dibuat.'),
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

        cardRepository
            .insertCard(
                id,
                owner ?? GlobalAssets.noData,
                nameController.text,
                GlobalAssets.noData,
                cardStatus,
                CreateCardAssets.accessCardText,
                selectedItem ?? GlobalAssets.noData,
                false,
                currentDateTime,
                ktpController.text,
                //Photo format is not yet set
                GlobalAssets.noData,
                GlobalAssets.noData)
            .then((result) {
          int status = result['status'];
          String message = result['message'];
          if (status == 200) {
            // Successful insertion, you can show a success message
            print(message);
            Navigator.of(context).pop(); // Close the loading dialog
            Navigator.of(context).pop(); // Close the previous dialogs
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Success(),
            ));
          } else {
            print(status);
            // Handle errors or show an error message
            Navigator.of(context).pop(); // Close the loading dialog
            Navigator.of(context).pop(); // Close the loading dialog
            _showErrorNotification(message);
          }
        }).catchError((error) {
          // Handle errors here
          print('Errors: $error');
          Navigator.of(context).pop(); // Close the loading dialog
          Navigator.of(context).pop(); // Close the loading dialog

          _showErrorNotification('An error occurred while submitting data.');
        });
      }
    } catch (e) {
      print('Error uploading images or inserting/updating data: $e');
      Navigator.of(context).pop(); // Close the loading dialog
      _showErrorNotification('An unexpected error occurred.');
    }
  }

  void _showErrorNotification(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
        profileImageName = 'Gambar telah dipilih';
      } else if (card.photo is File) {
        profileImageFile = card.photo;
        profileImageName = 'Gambar telah dipilih';
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
          title: Text('Silahkan pilih media'),
          content: Container(
            height: MediaQuery.of(context).size.height / 8,
            child: Row(
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery, imageNumber);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 64),
                        Text('Dari Galeri'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8), // Add some space between buttons
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera, imageNumber);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera, size: 64),
                        Text('Dari Kamera'),
                      ],
                    ),
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
            profileImageName = 'Gambar Dipilih';
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
          if (imageFile is String) {
            final image = imageFromBase64String(imageFile);
            showImagePreview(image);
          } else if (imageFile is File) {
            showImagePreview(imageFile);
          }
        }
      },
      child: Text(
        imageFile != null
            ? 'Klik disini untuk lihat'
            : imageName ?? 'Tidak ada gambar',
        style: TextStyle(
          color: imageFile != null ? Colors.blue : Colors.grey,
          decoration: imageFile != null
              ? TextDecoration.underline
              : TextDecoration.none,
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
}

Future<String?> getEmailFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
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
