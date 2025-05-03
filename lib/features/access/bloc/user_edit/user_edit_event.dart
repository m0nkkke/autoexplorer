part of 'user_edit_bloc.dart';

abstract class UserEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateFieldEvent extends UserEditEvent {
  final String fieldName;
  final String newValue;
  UpdateFieldEvent(this.fieldName, this.newValue);
  @override
  List<Object?> get props => [fieldName, newValue];
}

class LoadRegionsEvent extends UserEditEvent {}

class LoadAreasEvent extends UserEditEvent {
  final String regionId;
  LoadAreasEvent(this.regionId);
  @override
  List<Object?> get props => [regionId];
}

class OnRegionChangedEvent extends UserEditEvent {
  final String regionName;
  OnRegionChangedEvent(this.regionName);
  @override
  List<Object?> get props => [regionName];
}

class OnAreaChangedEvent extends UserEditEvent {
  final Set<String> newAreas;
  OnAreaChangedEvent(this.newAreas);
  @override
  List<Object?> get props => [newAreas];
}

class SubmitUserEvent extends UserEditEvent {}
