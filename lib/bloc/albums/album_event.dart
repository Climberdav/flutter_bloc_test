import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:bloc_app/model/album.dart';

abstract class AlbumEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAlbumEvent extends AlbumEvent {}

class AddAlbumEvent extends AlbumEvent {
  final Album album;
  AddAlbumEvent({this.album});
  @override
  List<Object> get props => [album];
}

class SelectedAlbumEvent extends AlbumEvent {
  final Album selected;

  SelectedAlbumEvent({@required this.selected});

  @override
  List<Object> get props => [selected];
}
