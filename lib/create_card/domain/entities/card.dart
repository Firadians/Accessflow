class Card {
  final int? id;
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

  Card({
    this.id,
    this.owner,
    required this.cardStatus,
    required this.cardCredential,
    required this.cardType,
    required this.cardSubType,
    required this.checklistStatus,
    required this.createData,
    required this.ktpNumber,
    this.photo,
    required this.reason,
    required this.name,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return Card(
      id: data['id'] as int,
      cardStatus: data['card_status'] as int,
      cardCredential: data['card_credential'] as String,
      cardType: data['card_type'] as String,
      cardSubType: data['card_sub_type'] as String,
      checklistStatus: data['checklist_status'] as bool,
      createData: data['create_date'] as String,
      ktpNumber: data['ktp_number'] as String,
      photo: data['photo'] as String?,
      reason: data['reason'] as String,
      name: data['name'] as String,
    );
  }

  @override
  String toString() {
    return 'Card(cardStatus: $cardStatus, cardCredential: $cardCredential, cardType: $cardType, cardSubType: $cardSubType, checklistStatus: $checklistStatus, createData: $createData, ktpNumber: $ktpNumber, photo: $photo, reason: $reason, name: $name)';
  }
}
