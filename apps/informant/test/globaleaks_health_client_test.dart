import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:verdad_oculta/globaleaks_health_client.dart';

void main() {
  test('accepts HTTPS backend base URI', () {
    final client = GlobaleaksHealthClient(
      baseUri: Uri.parse('https://submit.example.test'),
      client: http.MockClient(
        (_) async => http.Response('OK', 200),
      ),
    );

    expect(client.baseUri.scheme, 'https');
    client.close();
  });

  test('requires HTTPS backend base URI', () {
    expect(
      () => GlobaleaksHealthClient(
        baseUri: Uri.parse('http://127.0.0.1'),
      ),
      throwsArgumentError,
    );
  });

  test('rejects backend base URI with query or fragment', () {
    expect(
      () => GlobaleaksHealthClient(
        baseUri: Uri.parse('https://submit.example.test?token=secret'),
      ),
      throwsArgumentError,
    );
    expect(
      () => GlobaleaksHealthClient(
        baseUri: Uri.parse('https://submit.example.test/#secret'),
      ),
      throwsArgumentError,
    );
  });

  test('reports GlobaLeaks health response', () async {
    final client = GlobaleaksHealthClient(
      baseUri: Uri.parse('https://submit.example.test/root'),
      client: http.MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), 'https://submit.example.test/api/health');
        expect(request.headers['accept'], 'text/plain');
        return http.Response('OK\n', 200);
      }),
    );

    expect(await client.isHealthy(), isTrue);
    client.close();
  });

  test('reports unhealthy response without leaking body', () async {
    final client = GlobaleaksHealthClient(
      baseUri: Uri.parse('https://submit.example.test'),
      client: http.MockClient(
        (_) async => http.Response('internal failure', 500),
      ),
    );

    expect(await client.isHealthy(), isFalse);
    client.close();
  });
}
