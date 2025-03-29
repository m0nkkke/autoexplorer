abstract class AbstractStorageRepository {
  Future<List<dynamic>> getFileAndFolderModels({String path = '/'});
  Future<void> createFolder({required String name, required String path});
}
