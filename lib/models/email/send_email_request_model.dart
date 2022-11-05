import 'package:ahanghaa/models/abstract_dto.dart';

class SendEmailRequestModel extends AbstractDto {
  String name = '';
  String email = '';
  String subject = '';
  String message = '';

  @override
  fromMap(Map<String, dynamic> map) {
    name = map['name'];
    email = map['email'];
    subject = map['subject'];
    message = map['message'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };
  }
}
