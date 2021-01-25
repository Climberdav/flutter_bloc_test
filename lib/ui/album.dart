import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app/bloc/albums/album_bloc.dart';
import 'package:bloc_app/bloc/albums/album_state.dart';

class AlbumUI extends StatefulWidget {
  @override
  _AlbumUIState createState() => _AlbumUIState();
}

class _AlbumUIState extends State<AlbumUI> {
  AlbumsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AlbumsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: BlocBuilder(
        cubit: _bloc,
        builder: (context, state) {
          if (state is AlbumsLoadedState) {
            return Center(
              child: Text(state.selected?.title ?? "No Album selected"),
            );
          } else {
            return Container(
              // state is AlbumInitState
              child: Text("No Album selected 2 ${state.toString()}"),
            );
          }
        },
      ),
    );
  }
}
