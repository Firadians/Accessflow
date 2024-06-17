import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_model_list/dropdown_model_list.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/create_card/presentation/widget/custom_text_editable_widget.dart';
import 'package:accessflow/create_card/presentation/widget/submit_data_confirm.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:accessflow/draft/presentation/widget/shimmer_loading_list.dart';
import 'package:accessflow/create_card/data/repositories/card_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accessflow/utils/success.dart';

class existAksesPerumdinContent extends StatefulWidget {
  final Map<String, dynamic>? editData;
  final String? id;

  existAksesPerumdinContent({this.editData, this.id});

  @override
  _existAksesPerumdinContentState createState() =>
      _existAksesPerumdinContentState();
}

class _existAksesPerumdinContentState extends State<existAksesPerumdinContent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic profileImageFile;

  String? profileImageName;

  String? dataSubType;
  final ImagePicker picker = ImagePicker();
  bool checklistStatus = false;
  late String userEmail;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ktpController = TextEditingController();

  OptionItem optionItemSelected = OptionItem(title: "Select User");
  OptionItem subTypeItemSelected = OptionItem(title: "Select User");
  late DropListModel dropListModel = DropListModel([]);
  DropListModel subTypeDropList = DropListModel([
    OptionItem(id: "1", title: "Ayah"),
    OptionItem(id: "2", title: "Ibu"),
    OptionItem(id: "3", title: "Anak"),
    OptionItem(id: "4", title: "Driver"),
    OptionItem(id: "5", title: "ART"),
  ]);
  List<CardResponse> cardData = [];
  List<CardResponse>? cards;
  int? id;
  String selectedItem = 'no data'; // Set an initial value
  String subTypeSelectedItem = 'no data'; // Set an initial value
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String currentDateTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  final CardRepository cardRepository = CardRepository();
  final SharedPreference sharedPreference = SharedPreference();
  bool isEditMode = false;
  bool isEditing = false;
  bool isNew = false;

  @override
  void initState() {
    super.initState();
    getAccessCards(); // Fetch the data when the widget is initialized.
  }

  Future<void> getAccessCards() async {
    try {
      List<CardResponse> retrievedCards =
          await cardRepository.getAvailableAksesPerumdin();
      setState(() {
        cardData = retrievedCards; // Store the data.
      });
    } catch (e) {
      // Handle the error.
      print('Error: $e');
    }
  }

// Example function to load data based on the name
  CardResponse? loadDataByName(String name) {
    return cardData.firstWhere((card) => card.name == name);
  }

  void _loadUserDataForSelectedItems(String name) async {
    try {
      CardResponse? selectedCard = loadDataByName(name);

      if (selectedCard != null) {
        nameController.text = selectedCard.name;
        ktpController.text = selectedCard.ktpNumber;
        selectedItem = selectedCard.cardSubType;
        subTypeItemSelected = OptionItem(title: selectedCard.cardSubType);
        // Set the image files if they exist in the card data
        if (selectedCard.photo != null) {
          if (selectedCard.photo is String) {
            // Decode the base64 string to a Uint8List
            Uint8List bytes = base64Decode(selectedCard.photo!);
            // Create an image widget from the bytes
            profileImageFile = Image.memory(bytes);
            profileImageName = 'Image Selected';
          } else if (selectedCard.photo is File) {
            profileImageFile = selectedCard.photo;
            profileImageName = 'Image Selected';
          }
        } else {
          // Handle the case where no matching card is found.
        }
      }
    } catch (e) {
      print('Error loading user data for selected items: $e');
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
        String? profileImageUrl;
        String? owner = await sharedPreference.getUserFromSharedPreferences();

        if (profileImageFile != null && isNew == true) {
          profileImageUrl = await imageFileToBase64(profileImageFile);
        } else {
          profileImageUrl = profileImageFile;
        }
        // Perform an update operation if in edit mode
        cardRepository
            .insertCard(
                id,
                owner ?? "",
                nameController.text,
                "no data",
                cardStatus,
                "Akses Perumdin",
                subTypeSelectedItem,
                false,
                currentDateTime,
                ktpController.text,
                profileImageUrl ?? "",
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
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: 'Akses Perumdin',
            description: 'Akses Perumdin',
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
                  FutureBuilder<List<CardResponse>>(
                    future: Future.value(cardData), // Use the stored data.
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ShimmerLoadingList(),
                        );
                      } else if (snapshot.hasError) {
                        // Handle the error and return a Widget.
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.data == null &&
                          snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No card data available.'),
                        );
                      } else {
                        // Load card names into DropListModel.
                        dropListModel = DropListModel(
                          cardData.map((card) {
                            return OptionItem(
                              id: card.id.toString(),
                              title: card.name,
                            );
                          }).toList(),
                        );

                        return Column(
                          children: [
                            SelectDropList(
                              itemSelected: optionItemSelected,
                              dropListModel: dropListModel,
                              showIcon: true,
                              showArrowIcon: true,
                              showBorder: true,
                              paddingTop: 0,
                              icon:
                                  const Icon(Icons.person, color: Colors.black),
                              onOptionSelected: (optionItem) {
                                optionItemSelected = optionItem;
                                setState(() {
                                  selectedItem =
                                      optionItemSelected.title.toString();
                                  _loadUserDataForSelectedItems(
                                      optionItemSelected.title.toString());
                                });
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  CustomTextEditableWidget(
                    controller: nameController,
                    labelText: 'Nama',
                    hintText: 'Masukkan Nama Anda',
                    isEditing: isEditing,
                  ),
                  CustomNumberEditableWidget(
                    controller: ktpController,
                    labelText: 'Nomor KTP',
                    hintText: 'Masukkan Nomor KTP Anda',
                    isEditing: isEditing,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            20, 0, 0, 0), // Add left spacing of 10 units
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: isEditing
                                  ? () async {
                                      myAlert(1);
                                    }
                                  : null,
                              child: Text('Pilih Pas Foto'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  isEditing
                                      ? Color.fromARGB(255, 37, 109, 180)
                                      : Colors.grey,
                                ),
                              ),
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
                    itemSelected: subTypeItemSelected,
                    dropListModel: subTypeDropList,
                    showIcon: true, // Show Icon in DropDown Title
                    showArrowIcon: true, // Show Arrow Icon in DropDown
                    showBorder: true,
                    paddingTop: 0,
                    icon: const Icon(Icons.person, color: Colors.black),
                    onOptionSelected: (optionItem) {
                      subTypeItemSelected = optionItem;
                      setState(() {
                        subTypeSelectedItem =
                            subTypeItemSelected.title.toString();
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
        profileImageFile != null && // Check if profileImageFile is not empty
        optionItemSelected
            .title.isNotEmpty; // Check if optionItemSelected is selected
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
        color: Color.fromARGB(255, 4, 4, 4),
        fontWeight: FontWeight.bold,
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
      'Data yang tersedia adalah data yang pernah dibuat. Silahkan pilih nama dibawah ini : ',
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
