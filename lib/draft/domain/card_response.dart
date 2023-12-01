class CardResponse {
  final int? id; // Change the type to int
  final String? owner;
  final int cardStatus;
  final String cardCredential;
  final String cardType;
  final String cardSubType;
  final bool checklistStatus;
  final String createData;
  final String ktpNumber;
  final String? photo;
  final String reason;
  final String name;

  CardResponse({
    this.id,
    this.owner,
    required this.cardStatus,
    required this.cardCredential,
    required this.cardType,
    required this.cardSubType,
    required this.checklistStatus,
    required this.createData,
    required this.ktpNumber,
    required this.photo,
    required this.reason,
    required this.name,
  });

  factory CardResponse.fromJson(Map<String, dynamic> json) {
    return CardResponse(
      id: json['id'] as int, // Change the type to int
      cardStatus: json['card_status'] as int,
      cardCredential: json['card_credential'] as String,
      cardType: json['card_type'] as String,
      cardSubType: json['card_sub_type'] as String,
      checklistStatus: json['checklist_status'] as bool,
      createData: json['create_date'] as String,
      ktpNumber: json['ktp_number'] as String,
      photo: json['photo'] as String,
      reason: json['reason'] as String,
      name: json['name'] as String,
    );
  }

  @override
  String toString() {
    return 'Card(cardStatus: $cardStatus, cardCredential: $cardCredential, cardType: $cardType, cardSubType: $cardSubType, checklistStatus: $checklistStatus, createData: $createData, ktpNumber: $ktpNumber, photo: $photo, reason: $reason, name: $name)';
  }
}
