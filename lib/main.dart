import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app/api/albums/services.dart';
import 'package:bloc_app/bloc/albums/album_bloc.dart';
import 'package:bloc_app/ui/albums.dart';
import 'package:bloc_app/ui/login.dart';
import 'package:bloc_app/settings/preferences.dart';

import 'api/authentication/services.dart';
import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/authentication/authentication_event.dart';
import 'bloc/authentication/authentication_state.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(
    // Injects the Authentication service
    RepositoryProvider<AuthenticationService>(
      create: (context) {
        return FakeAuthenticationService();
      },
      // Injects the Authentication BLoC
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              final authService =
                  RepositoryProvider.of<AuthenticationService>(context);
              return AuthenticationBloc(authService)..add(AppLoaded());
            },
          ),
          BlocProvider(create: (context) => ThemeBloc()),
          BlocProvider(create: (context) => AlbumsBloc()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) {
          return MaterialApp(
            title: 'Flutter Bloc Demo',
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData,
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationAuthenticated) {
                  // show home page
                  return BlocProvider(
                    create: (context) =>
                        AlbumsBloc(albumsRepo: AlbumServices()),
                    child: AlbumsUI(),
                  );
                }
                // otherwise show login page
                return LoginPage();
              },
            ),
          );
        },
      ),
    );
  }
}
