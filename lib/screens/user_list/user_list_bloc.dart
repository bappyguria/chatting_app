import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository/repository.dart';

abstract class UserListEvent {}
class LoadUsersEvent extends UserListEvent {}

abstract class UserListState {}
class UserListInitialState extends UserListState {}
class UsersLoadingState extends UserListState {}
class UsersLoadedState extends UserListState {
  final List <Map<String,dynamic>> users;
  UsersLoadedState(this.users);
}
class UsersErrorState extends UserListState {
  final String message;
  UsersErrorState(this.message);
}


class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final Repository repository;

  UserListBloc(this.repository) : super(UserListInitialState()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(UsersLoadingState());
      try {
        final users = await repository.getUserList();
        // emit(UsersLoadedState(users.map((user) => {
        //   'name': user['name'],
        //   'email': user['email'],
        // }).toList()));
        emit(UsersLoadedState(users));
      } catch (e) {
        emit(UsersErrorState(e.toString()));
      }
    });
  }
}