import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/content_hash.dart';

void main() {
  test('computes the standard SHA-256 digest', () {
    final bytes = Uint8List.fromList(utf8.encode('abc'));

    expect(
      sha256Hex(bytes),
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
    );
  });

  test('empty content has the standard SHA-256 digest', () {
    expect(
      sha256Hex(Uint8List(0)),
      'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
    );
  });
}
