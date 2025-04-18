abstract class AbstractStorageRepository {
  Future<List<dynamic>> getFileAndFolderModels({String path = '/'});
  Future<void> createFolder({required String name, required String path});
  Future<void> uploadFile({
    required String filePath,
    required String uploadPath,
  });
  Future<String> getImageDownloadUrl(String filePath);
}
