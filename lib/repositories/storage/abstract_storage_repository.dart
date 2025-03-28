abstract class AbstractStorageRepository {
  Future<List<dynamic>> getFileAndFolderModels({String path = '/'});
}
