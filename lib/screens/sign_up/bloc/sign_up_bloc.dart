import 'package:chatting_app/screens/sign_up/bloc/sign_up_event.dart';
import 'package:chatting_app/screens/sign_up/bloc/sign_up_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Repository/repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final Repository repository;
  SignUpBloc(this.repository) : super(SignUpInitial()) {
    on<OnTapSignUP>((event, state) async {
      emit(SignUpLoading());
      try {
        await repository.signUp(
          name: event.name,
          email: event.eamil,
          password: event.password,
        );
        emit(SignUpSuccess(message: 'Sign Up Successfully'));
      } on FirebaseAuthException catch (e) {
        emit(SignUpError(errorMessage: e.toString()));
      } catch (e) {
        emit(SignUpError(errorMessage: e.toString()));
      }
    });
  }
}
