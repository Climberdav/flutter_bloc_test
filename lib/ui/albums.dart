import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app/bloc/albums/album_bloc.dart';
import 'package:bloc_app/bloc/albums/album_event.dart';
import 'package:bloc_app/bloc/albums/album_state.dart';
import 'package:bloc_app/bloc/theme/theme_bloc.dart';
import 'package:bloc_app/bloc/theme/theme_events.dart';
import 'package:bloc_app/model/album.dart';
import 'package:bloc_app/settings/app_themes.dart';
import 'package:bloc_app/settings/preferences.dart';
import 'package:bloc_app/ui/album.dart';
import 'package:bloc_app/widgets/error.dart';
import 'package:bloc_app/widgets/loading.dart';

class AlbumsUI extends StatefulWidget {
  @override
  _AlbumsUIState createState() => _AlbumsUIState();
}

class _AlbumsUIState extends State<AlbumsUI> {
  AlbumsBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _loadTheme();
    _loadAlbums();
  }

  _loadTheme() async {
    context.read<ThemeBloc>().add(ThemeEvent(appTheme: Preferences.getTheme()));
  }

  _loadAlbums() async {
    context.read<AlbumsBloc>().add(FetchAlbumEvent());
  }

  _setTheme(bool darkTheme) {
    AppTheme selectedTheme =
        darkTheme ? AppTheme.lightTheme : AppTheme.darkTheme;
    context.read<ThemeBloc>().add(ThemeEvent(appTheme: selectedTheme));
    Preferences.saveTheme(selectedTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
        actions: [
          Switch(
            value: Preferences.getTheme() == AppTheme.lightTheme,
            onChanged: (val) {
              _setTheme(val);
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        child: _body(),
      ),
    );
  }

  _body() {
    return Column(
      children: [
        BlocBuilder<AlbumsBloc, AlbumsState>(
          builder: (BuildContext context, AlbumsState state) {
            if (state is AlbumsListErrorState) {
              final error = state.error;
              String message = '${error.message}\nTap retry';
              return ErrorTxt(
                message: message,
                onTap: _loadAlbums(),
              );
            }
            if (state is AlbumsLoadedState) {
              List<Album> albums = state.albums;
              return Expanded(
                child: ListView.builder(
                  itemCount: albums.length,
                  itemBuilder: (_, index) {
                    final Album album = albums[index];
                    return ListTile(
                      title: Text(album.title),
                      selected: album == state.selected,
                      onTap: () => _selectAlbum(context, album),
                    );
                  },
                ),
              );
            }
            return Loading();
          },
        )
      ],
    );
  }

  _selectAlbum(BuildContext context, Album item) {
    context.read<AlbumsBloc>().add(SelectedAlbumEvent(selected: item));
    if (MediaQuery.of(context).size.shortestSide < 768) {
      final route = MaterialPageRoute(builder: (context) => (AlbumUI()));
      Navigator.push(context, route);
    }
  }
}
