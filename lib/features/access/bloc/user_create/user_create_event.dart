part of 'user_create_bloc.dart';

abstract class UserCreateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateCreateFieldEvent extends UserCreateEvent {
  final String field;
  final dynamic value;
  UpdateCreateFieldEvent(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class LoadCreateRegionsEvent extends UserCreateEvent {}

class OnCreateRegionChangedEvent extends UserCreateEvent {
  final String regionName;
  OnCreateRegionChangedEvent(this.regionName);
  @override
  List<Object?> get props => [regionName];
}

class LoadCreateAreasEvent extends UserCreateEvent {
  final String regionId;
  LoadCreateAreasEvent(this.regionId);
  @override
  List<Object?> get props => [regionId];
}

class OnCreateAreaChangedEvent extends UserCreateEvent {
  final Set<String> areaIds;
  OnCreateAreaChangedEvent(this.areaIds);
  @override
  List<Object?> get props => [areaIds];
}

class SubmitCreateEvent extends UserCreateEvent {}
