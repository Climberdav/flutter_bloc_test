import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app/api/albums/exceptions.dart';
import 'package:bloc_app/api/albums/services.dart';
import 'package:bloc_app/bloc/albums/album_state.dart';
import 'package:bloc_app/model/album.dart';

import 'album_event.dart';

class AlbumsBloc extends Bloc<AlbumEvent, AlbumsState> {
  final AlbumsRepo albumsRepo;

  List<Album> albums = [];
  Album _selected;

  AlbumsBloc({this.albumsRepo}) : super(AlbumsInitState());

  @override
  Stream<AlbumsState> mapEventToState(AlbumEvent event) async* {
    if (event is FetchAlbumEvent) {
      yield AlbumsLoadingState();
      try {
        albums = await albumsRepo.getAlbumList();
        yield AlbumsLoadedState(albums: albums);
      } on SocketException {
        yield AlbumsListErrorState(
          error: NoInternetException('No Internet'),
        );
      } on HttpException {
        yield AlbumsListErrorState(
          error: NoServiceFoundException('No Service Found'),
        );
      } on FormatException {
        yield AlbumsListErrorState(
          error: InvalidFormatException('Invalid Response format'),
        );
      } catch (e) {
        yield AlbumsListErrorState(
          error: UnknownException('Unknown Error'),
        );
      }
    } else if (event is SelectedAlbumEvent) {
      _selected = event.selected;
    }
    yield* _loadAlbums();
  }

  Stream<AlbumsState> _loadAlbums() async* {
    if (albums.isEmpty) {
      yield AlbumsLoadingState();
    } else {
      final newState =
          AlbumsLoadedState(albums: [...albums], selected: _selected);
      yield newState;
    }
  }

  Stream<AlbumsState> _loadItems() async* {
    if (albums.isEmpty) {
      yield NoAlbumsState();
    } else {
      final newState = AlbumsLoadedState(
          albums: [...albums], selected: Album.fromItem(_selected));
      yield newState;
    }
  }
}
