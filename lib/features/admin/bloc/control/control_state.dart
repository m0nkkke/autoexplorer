part of 'control_bloc.dart';

enum ControlStatus { initial, loading, success, failure }

class ControlState extends Equatable {
  final ControlStatus status;
  final List<QueryDocumentSnapshot> users;
  final String errorMessage;
  final Map<String, String> regionNamesMap;

  const ControlState({
    this.status = ControlStatus.initial,
    this.users = const [],
    this.errorMessage = '',
    this.regionNamesMap = const {},    
  });

  ControlState copyWith({
    ControlStatus? status,
    List<QueryDocumentSnapshot>? users,
    String? errorMessage,
    Map<String, String>? regionNamesMap,  
  }) {
    return ControlState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
      regionNamesMap: regionNamesMap ?? this.regionNamesMap, 
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage, regionNamesMap];
}
