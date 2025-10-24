abstract class SignUpState{}
class SignUpInitial extends SignUpState{}
class SignUpLoading extends SignUpState{}
class SignUpSuccess extends SignUpState{
  String message;
  SignUpSuccess({required this.message});
}
class SignUpError extends SignUpState{
  String errorMessage;
  SignUpError({required this.errorMessage});
}