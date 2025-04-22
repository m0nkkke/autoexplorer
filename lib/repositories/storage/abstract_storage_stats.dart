import 'package:autoexplorer/repositories/storage/models/disk_capacity.dart';
import 'package:autoexplorer/repositories/storage/models/disk_stat.dart';

/// Только для получения capacity и общих stats
abstract class StorageStatsRepository {
  Future<DiskCapacity> getCapacity();
  Future<DiskStats> getDiskStats();
}
