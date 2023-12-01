import 'package:flutter/material.dart';
import 'package:accessflow/create_card/presentation/exist_akses_perumdin_content.dart';
import 'package:accessflow/create_card/presentation/access_card_content.dart';
import 'package:accessflow/create_card/presentation/id_card_content.dart';
import 'package:accessflow/create_card/presentation/akses_perumdin_content.dart';
import 'package:accessflow/create_card/presentation/exist_access_card_content.dart';
import 'package:accessflow/draft/domain/card_response.dart';

class CreateCardScreen extends StatefulWidget {
  final String title;
  final CardResponse? cards;

  CreateCardScreen({required this.title, this.cards});

  @override
  _CreateCardScreenState createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (widget.title == 'Access Card') {
      return AccessCardContent(cards: widget.cards);
    } else if (widget.title == 'ID Card') {
      return IDCardContent();
    } else if (widget.title == 'Akses Perumdin') {
      return AksesPerumdinContent(cards: widget.cards);
    } else if (widget.title == 'Access Card Sudah Pernah') {
      return existAccessCardContent();
    } else if (widget.title == 'Akses Perumdin Sudah Pernah') {
      return existAksesPerumdinContent();
    }
    return Container(
      child: Text('Default Content for ${widget.title}'),
    );
  }
}
