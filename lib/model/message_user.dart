enum Type { text, image, video }

class Message {
  final String msg;
  final String read;
  final String told;
  final Type type;
  final String fromId;
  final String sent;

  Message({
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.fromId,
    required this.sent,
  });

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'read': read,
      'told': told,
      'type': type.toString().split('.').last, // Convert Enum to String
      'fromId': fromId,
      'sent': sent,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      msg: json['msg'],
      read: json['read'],
      told: json['told'],
      type: Type.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
      fromId: json['fromId'],
      sent: json['sent'],
    );
  }
}
