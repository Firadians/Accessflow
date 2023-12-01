import 'package:flutter/material.dart';

class CustomTextEditableWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool isEditing;

  CustomTextEditableWidget({
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.isEditing,
  });

  @override
  _CustomTextEditableWidgetState createState() =>
      _CustomTextEditableWidgetState();
}

class _CustomTextEditableWidgetState extends State<CustomTextEditableWidget> {
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    // Add a listener to the TextEditingController
    widget.controller.addListener(_validateText);
  }

  void _validateText() {
    // Update the isValid state based on your validation logic
    setState(() {
      isValid = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.controller.removeListener(_validateText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            readOnly: !widget.isEditing,
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixIcon: isValid
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isValid ? Colors.green : Colors.red,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(225, 67, 67, 67),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (!isValid)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'You need to fill the data.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomNumberEditableWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool isEditing; // Add isEditing parameter

  CustomNumberEditableWidget({
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.isEditing, // Include isEditing in the constructor
  });

  @override
  _CustomNumberEditableWidgetState createState() =>
      _CustomNumberEditableWidgetState();
}

class _CustomNumberEditableWidgetState
    extends State<CustomNumberEditableWidget> {
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    // Add a listener to the TextEditingController
    widget.controller.addListener(_validateText);
  }

  void _validateText() {
    // Update the isValid state based on your validation logic
    setState(() {
      isValid = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.controller.removeListener(_validateText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            readOnly: !widget.isEditing, // Use widget.isEditing here
            keyboardType: TextInputType.number, // Set keyboard to number
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixIcon: isValid
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isValid ? Colors.green : Colors.red,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(225, 67, 67, 67),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (!isValid)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'You need to fill the data.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomTextCompleteWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool isEditing;

  CustomTextCompleteWidget({
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.isEditing,
  });

  @override
  _CustomTextCompleteWidgetState createState() =>
      _CustomTextCompleteWidgetState();
}

class _CustomTextCompleteWidgetState extends State<CustomTextCompleteWidget> {
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    // Add a listener to the TextEditingController
    widget.controller.addListener(_validateText);
  }

  void _validateText() {
    // Update the isValid state based on your validation logic
    setState(() {
      isValid = widget.controller.text.length >= 8;
    });
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.controller.removeListener(_validateText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            readOnly: !widget.isEditing,
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixIcon: isValid
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isValid ? Colors.green : Colors.red,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(225, 67, 67, 67),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNumberCompleteWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool isEditing; // Add isEditing parameter

  CustomNumberCompleteWidget({
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.isEditing, // Include isEditing in the constructor
  });

  @override
  _CustomNumberCompleteWidgetState createState() =>
      _CustomNumberCompleteWidgetState();
}

class _CustomNumberCompleteWidgetState
    extends State<CustomNumberCompleteWidget> {
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    // Add a listener to the TextEditingController
    widget.controller.addListener(_validateText);
  }

  void _validateText() {
    // Update the isValid state based on your validation logic
    setState(() {
      isValid = widget.controller.text.length >= 8;
    });
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.controller.removeListener(_validateText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            readOnly: !widget.isEditing, // Use widget.isEditing here
            keyboardType: TextInputType.number, // Set keyboard to number
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixIcon: isValid
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isValid ? Colors.green : Colors.red,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(225, 67, 67, 67),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomReasonEditableWidget extends StatefulWidget {
  final String labelText, hintText;
  final TextEditingController controller;
  final bool isEditing;

  CustomReasonEditableWidget(
      {required this.labelText,
      required this.hintText,
      required this.controller,
      required this.isEditing});

  @override
  __CustomReasonEditableWidgetStateState createState() =>
      __CustomReasonEditableWidgetStateState();
}

class __CustomReasonEditableWidgetStateState
    extends State<CustomReasonEditableWidget> {
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateText);
  }

  void _validateText() {
    setState(() {
      isValid = widget.controller.text.length >= 8;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: widget.controller,
              readOnly: !widget.isEditing,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon: isValid
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isValid ? Colors.green : Colors.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(225, 67, 67, 67),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
}
