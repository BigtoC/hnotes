class BaseResultDto {
  String? errorMessage;
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
}
