import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email, String subject, String body) =>
      launch("mailto:$email?subject=$subject&body=$body");
}
