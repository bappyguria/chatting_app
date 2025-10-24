abstract class LoginState{}
class LoginInitial extends LoginState{}
class LoddingLogin extends LoginState{}
class LoginSuccess extends LoginState{
  String message;
  LoginSuccess({required this.message});
}
class LoginError extends LoginState{
  String errorMessage;
  LoginError({required this.errorMessage});
}