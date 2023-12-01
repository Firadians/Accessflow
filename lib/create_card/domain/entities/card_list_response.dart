import 'package:accessflow/create_card/domain/entities/card.dart';

class CardListResponse {
  final int status;
  final String message;
  final List<Card> cards;

  CardListResponse({
    required this.status,
    required this.message,
    required this.cards,
  });

  factory CardListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> cardsData = json['cards'];
    final List<Card> cards =
        cardsData.map((data) => Card.fromJson(data)).toList();

    return CardListResponse(
      status: json['status'],
      message: json['message'],
      cards: cards,
    );
  }
}
