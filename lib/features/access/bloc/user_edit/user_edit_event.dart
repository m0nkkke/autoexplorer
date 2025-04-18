// lib/features/access/bloc/user_edit_event.dart
part of 'user_edit_bloc.dart';

abstract class UserEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Field-by-field updates for firstName, lastName, middleName
class UpdateFieldEvent extends UserEditEvent {
  final String fieldName;
  final String newValue;
  UpdateFieldEvent(this.fieldName, this.newValue);
  @override
  List<Object?> get props => [fieldName, newValue];
}

/// Load top‑level folders → regions
class LoadRegionsEvent extends UserEditEvent {}

/// Load sub‑folders (areas) for a given region
class LoadAreasEvent extends UserEditEvent {
  final String regionId;
  LoadAreasEvent(this.regionId);
  @override
  List<Object?> get props => [regionId];
}

/// User picked a new region (name)
class OnRegionChangedEvent extends UserEditEvent {
  final String regionName;
  OnRegionChangedEvent(this.regionName);
  @override
  List<Object?> get props => [regionName];
}

/// User changed the selected areas (IDs)
class OnAreaChangedEvent extends UserEditEvent {
  final Set<String> newAreas;
  OnAreaChangedEvent(this.newAreas);
  @override
  List<Object?> get props => [newAreas];
}

/// Final “save everything” tap
class SubmitUserEvent extends UserEditEvent {}
