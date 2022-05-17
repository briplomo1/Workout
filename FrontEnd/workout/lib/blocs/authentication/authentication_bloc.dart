import 'package:bloc/bloc.dart';
import 'package:workout/models/models.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:workout/services/authentication_service.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService;

  AuthenticationBloc(AuthenticationService authenticationService)
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }
    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    print("Determining auth state");
    yield AuthenticationLoading();
    try {
      User currentUser;
      if (await _authenticationService.getRefreshToken()) {
        currentUser = await _authenticationService.getUser();
      }
      if (currentUser != null) {
        yield AuthenticationAuthenticated(user: currentUser);
        print("Yielding authenticated");
      } else {
        print("yielding not authenticated");
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(
          message: e.toString() ?? 'An unknown error occured');
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
      UserLoggedIn event) async* {
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
      UserLoggedOut event) async* {
    await _authenticationService.logoutUser();
    yield AuthenticationNotAuthenticated();
  }
}
