// lib/features/admin/bloc/storage_info/storage_info_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:get_it/get_it.dart';

part 'storage_info_event.dart';
part 'storage_info_state.dart';

class StorageInfoBloc extends Bloc<StorageInfoEvent, StorageInfoState> {
  final StorageRepository _storage =
      GetIt.I<AbstractStorageRepository>(instanceName: 'yandex_repository')
          as StorageRepository;

  StorageInfoBloc() : super(const StorageInfoState()) {
    on<LoadStorageInfo>(_onLoad);
  }

  Future<void> _onLoad(LoadStorageInfo _, Emitter<StorageInfoState> emit) async {
    emit(state.copyWith(status: StorageInfoStatus.loading));

    try {
      // получаем capacity
      final cap   = await _storage.getCapacity();
      // получаем папки и изображения
      final stats = await _storage.getDiskStats();
      
      final percent = stats.imagesCount > 0
          ? (cap.usedGb / cap.totalGb) * 100
          : 0.0;

      emit(state.copyWith(
        status: StorageInfoStatus.success,
        connectionStatus: true,
        imagesCount: stats.imagesCount,
        currentStorageSize: cap.usedGb,
        totalStorageSize: cap.totalGb,
        storagePercentage: percent,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StorageInfoStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}