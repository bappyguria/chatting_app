import 'package:bloc/bloc.dart';
import 'package:chatting_app/Repository/repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Repository repository ;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try{
        final userData = await repository.currentUserData();
        if (userData != null) {
          emit(ProfileLoaded(userData));
        } else {
          emit(ProfileLoaded({}));
        }
      }catch(e){
        emit(ProfileLoaded({}));
      }
    });
  }
}
