import 'package:equatable/equatable.dart';
import 'package:bloc_app/model/album.dart';

abstract class AlbumsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AlbumsInitState extends AlbumsState {}

class AlbumsLoadingState extends AlbumsState {}

class NoAlbumsState extends AlbumsState {}

class AlbumsLoadedState extends AlbumsState {
  final List<Album> albums;
  final Album selected;
  AlbumsLoadedState({this.albums, this.selected});

  @override
  List<Object> get props => [selected, ...albums];
}

class AlbumsListErrorState extends AlbumsState {
  final error;
  AlbumsListErrorState({this.error});
}
