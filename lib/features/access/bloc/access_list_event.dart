part of 'access_list_bloc.dart';

abstract class AccessListEvent {}

class LoadAccessList extends AccessListEvent {
  final String accessKey;

  LoadAccessList({required this.accessKey});
}