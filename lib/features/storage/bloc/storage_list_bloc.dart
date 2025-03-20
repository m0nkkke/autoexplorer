import 'package:flutter_bloc/flutter_bloc.dart';
part 'storage_list_event.dart';
part 'storage_list_state.dart';

class StorageListBloc extends Bloc<StorageListEvent, StorageListState> {
  StorageListBloc() : super(StorageListInitial()) {
    on<StorageListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}