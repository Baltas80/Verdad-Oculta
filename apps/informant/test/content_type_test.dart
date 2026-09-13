import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:verdad_oculta/content_type.dart';

Uint8List _bytes(List<int> values) => Uint8List.fromList(values);

void main() {
  test('detects PDF signature', () {
    expect(
      detectContentType(_bytes([0x25, 0x50, 0x44, 0x46, 0x2D])),
      DetectedContentType.pdf,
    );
  });

  test('detects PNG signature', () {
    expect(
      detectContentType(_bytes([
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
      ])),
      DetectedContentType.png,
    );
  });

  test('detects JPEG signature', () {
    expect(
      detectContentType(_bytes([0xFF, 0xD8, 0xFF, 0xE0])),
      DetectedContentType.jpeg,
    );
  });

  test('detects ZIP and GZIP signatures', () {
    expect(
      detectContentType(_bytes([0x50, 0x4B, 0x03, 0x04])),
      DetectedContentType.zip,
    );
    expect(
      detectContentType(_bytes([0x1F, 0x8B, 0x08])),
      DetectedContentType.gzip,
    );
  });

  test('returns unknown for empty or unrecognised content', () {
    expect(detectContentType(Uint8List(0)), DetectedContentType.unknown);
    expect(
      detectContentType(_bytes([0x54, 0x45, 0x58, 0x54])),
      DetectedContentType.unknown,
    );
  });

  test('does not infer a type from a truncated signature', () {
    expect(
      detectContentType(_bytes([0x89, 0x50, 0x4E])),
      DetectedContentType.unknown,
    );
  });

  test('does not confuse RIFF with WebP without the WEBP marker', () {
    expect(
      detectContentType(_bytes([
        0x52,
        0x49,
        0x46,
        0x46,
        0,
        0,
        0,
        0,
        0x57,
        0x41,
        0x56,
        0x45,
      ])),
      DetectedContentType.unknown,
    );
  });
}
