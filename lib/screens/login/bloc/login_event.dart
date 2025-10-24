abstract class LoginEvent{}
class LoginButtonPressed extends LoginEvent{
  String email;
  String password;
  LoginButtonPressed({required this.email,required this.password});
}