abstract class SignUpEvent{}
class OnTapSignUP extends SignUpEvent{
  String name;
  String eamil;
  String password;
  OnTapSignUP({required this.eamil,required this.password,required this.name});
}