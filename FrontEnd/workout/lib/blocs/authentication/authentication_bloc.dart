import 'package:bloc/bloc.dart';
import 'package:workout/models/models.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:workout/services/authentication_service.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService;

  AuthenticationBloc(AuthenticationService? authenticationService)
      : assert(authenticationService != null),
        _authenticationService = authenticationService!,
        super(AuthenticationInitial()) {
    on<AppLoaded>(_mapAppLoadedToState);
    on<UserLoggedIn>(_mapUserLoggedInToState);
    on<UserLoggedOut>(_mapUserLoggedOutToState);
  }

  // @override
  // Stream<AuthenticationState> mapEventToState(
  //     AuthenticationEvent event) async* {
  //   if (event is AppLoaded) {
  //     yield* _mapAppLoadedToState(event);
  //   }

  //   if (event is UserLoggedIn) {
  //     yield* _mapUserLoggedInToState(event);
  //   }
  //   if (event is UserLoggedOut) {
  //     yield* _mapUserLoggedOutToState(event);
  //   }
  // }

  Future<void> _mapAppLoadedToState(
      AppLoaded event, Emitter<AuthenticationState> emit) async {
    print("Determining auth state");
    emit(AuthenticationLoading());
    try {
      User? currentUser;
      if (await _authenticationService.getRefreshToken()) {
        currentUser = await _authenticationService.getUser();
      }
      if (currentUser != null) {
        emit(AuthenticationAuthenticated(user: currentUser));
        print("Yielding authenticated");
      } else {
        print("yielding not authenticated");
        emit(AuthenticationNotAuthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(message: e.toString()));
    }
  }

  Future<void> _mapUserLoggedInToState(
      UserLoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationAuthenticated(user: event.user));
  }

  Future<void> _mapUserLoggedOutToState(
      UserLoggedOut event, Emitter<AuthenticationState> emit) async {
    await _authenticationService.logoutUser();
    emit(AuthenticationNotAuthenticated());
  }
}
