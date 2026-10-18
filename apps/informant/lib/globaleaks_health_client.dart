import 'package:http/http.dart' as http;

/// Small read-only adapter for the GlobaLeaks health endpoint.
///
/// A healthy response proves only that this health endpoint answered. It does
/// not verify submission compatibility, encryption, authorization, anonymity,
/// receipt handling, or production readiness. This client deliberately exposes
/// no submission, authentication, attachment, or correspondence operations;
/// those remain blocked until the production security gates are independently
/// verified.
class GlobaleaksHealthClient {
  GlobaleaksHealthClient({
    required Uri baseUri,
    http.Client? client,
  })  : baseUri = _validateBaseUri(baseUri),
        client = client ?? http.Client();

  final Uri baseUri;
  final http.Client client;

  Future<bool> isHealthy() async {
    final uri = baseUri.resolve('/api/health');
    final response = await client.get(
      uri,
      headers: const <String, String>{
        'accept': 'text/plain',
      },
    );

    return response.statusCode == 200 && response.body.trim() == 'OK';
  }

  void close() => client.close();

  static Uri _validateBaseUri(Uri value) {
    if (value.scheme != 'https') {
      throw ArgumentError.value(
        value,
        'baseUri',
        'The backend adapter requires HTTPS.',
      );
    }

    if (value.userInfo.isNotEmpty ||
        value.query.isNotEmpty ||
        value.fragment.isNotEmpty) {
      throw ArgumentError.value(
        value,
        'baseUri',
        'Backend base URI must not contain credentials, query parameters or fragments.',
      );
    }

    return value;
  }
}
