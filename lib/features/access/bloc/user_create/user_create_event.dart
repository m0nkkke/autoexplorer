part of 'user_create_bloc.dart';

abstract class UserCreateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Поля формы
class UpdateCreateFieldEvent extends UserCreateEvent {
  final String field;
  final dynamic value;
  UpdateCreateFieldEvent(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

/// Загрузить регионы
class LoadCreateRegionsEvent extends UserCreateEvent {}

/// Пользователь выбрал регион по имени
class OnCreateRegionChangedEvent extends UserCreateEvent {
  final String regionName;
  OnCreateRegionChangedEvent(this.regionName);
  @override
  List<Object?> get props => [regionName];
}

/// Загрузить участки для заданного regionId
class LoadCreateAreasEvent extends UserCreateEvent {
  final String regionId;
  LoadCreateAreasEvent(this.regionId);
  @override
  List<Object?> get props => [regionId];
}

/// Пользователь изменил набор выбранных участков
class OnCreateAreaChangedEvent extends UserCreateEvent {
  final Set<String> areaIds;
  OnCreateAreaChangedEvent(this.areaIds);
  @override
  List<Object?> get props => [areaIds];
}

/// Нажали «Создать»
class SubmitCreateEvent extends UserCreateEvent {}
