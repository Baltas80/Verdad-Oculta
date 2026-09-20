/// Build-time configuration for the non-production backend.
class BackendConfig {
  const BackendConfig._();

  static const String mode =
      String.fromEnvironment('VO_BACKEND_MODE', defaultValue: 'demo');
  static const String stagingBaseUrl =
      String.fromEnvironment('VO_STAGING_BASE_URL', defaultValue: '');

  static bool get isLocalDemo => mode == 'demo';
  static bool get isStaging =>
      mode == 'staging' && stagingBaseUrl.isNotEmpty;

  static Uri? get stagingUri {
    if (!isStaging) return null;
    final uri = Uri.tryParse(stagingBaseUrl);
    if (uri == null || uri.scheme != 'https' || uri.userInfo.isNotEmpty ||
        uri.query.isNotEmpty || uri.fragment.isNotEmpty) {
      return null;
    }
    return uri;
  }
}
