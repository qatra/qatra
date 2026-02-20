class MessageModel {
  String? messageText;
  String? sender;
  dynamic now;

  MessageModel({
    this.messageText,
    this.sender,
    this.now,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        messageText: map['messageText'],
        sender: map['sender'],
        now: map['now'],
      );

  Map<String, dynamic> toMap() => {
        "text": messageText,
        "sender": sender,
        'date': now,
      };
}
