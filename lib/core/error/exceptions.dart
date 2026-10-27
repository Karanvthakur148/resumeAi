class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class FileException implements Exception {
  final String message;
  const FileException(this.message);
}
