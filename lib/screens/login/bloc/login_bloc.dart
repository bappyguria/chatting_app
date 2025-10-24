import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Repository/repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Repository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoddingLogin()); // লগইন শুরু

      try {
        // Repository থেকে লগইন কল
        await repository.login(
          email: event.email,
          password: event.password,
        );

        emit(LoginSuccess(message: 'Login Successfully!')); // সফল হলে
      } on FirebaseAuthException catch (e) {
        emit(LoginError(errorMessage: e.toString()));
      } catch (e) {
        emit(LoginError(errorMessage: e.toString()));
      }
    });
  }
}
