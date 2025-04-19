part of 'storage_info_bloc.dart';

enum StorageInfoStatus { initial, loading, success, failure }

class StorageInfoState extends Equatable {
  final StorageInfoStatus status;
  final bool connectionStatus;
  final int imagesCount;
  final double currentStorageSize; // в ГБ
  final double totalStorageSize;   // в ГБ
  final double storagePercentage;
  final String? errorMessage;

  const StorageInfoState({
    this.status = StorageInfoStatus.initial,
    this.connectionStatus = false,
    this.imagesCount = 0,
    this.currentStorageSize = 0,
    this.totalStorageSize = 0,
    this.storagePercentage = 0,
    this.errorMessage,
  });

  StorageInfoState copyWith({
    StorageInfoStatus? status,
    bool? connectionStatus,
    int? imagesCount,
    double? currentStorageSize,
    double? totalStorageSize,
    double? storagePercentage,
    String? errorMessage,
  }) {
    return StorageInfoState(
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      imagesCount: imagesCount ?? this.imagesCount,
      currentStorageSize: currentStorageSize ?? this.currentStorageSize,
      totalStorageSize: totalStorageSize ?? this.totalStorageSize,
      storagePercentage: storagePercentage ?? this.storagePercentage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        connectionStatus,
        imagesCount,
        currentStorageSize,
        totalStorageSize,
        storagePercentage,
        errorMessage,
      ];
}
