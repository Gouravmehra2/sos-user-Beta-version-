import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

void main() {
  test('parses the supplied CCTV service response', () {
    final json =
        jsonDecode(
              File('test/fixtures/services_response.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    final response = ServiceListResponse.fromJson(json);
    expect(response.success, isTrue);
    final service = response.services.single;
    expect(service.name, 'CCTV Installation');
    expect(service.priceMin, 134);
    expect(service.priceMax, 359);
    expect(service.offerPrice, 0);
    expect(service.shortDescription.split('\n'), hasLength(3));
    expect(
      service.shortDescription,
      contains('DVR/NVR setup and security testing'),
    );
    expect(service.variants, hasLength(3));
    expect(service.variants.first.offerPrice, 134);
    expect(service.addons, hasLength(4));
    expect(service.requirements, hasLength(3));
    expect(service.tools, hasLength(2));
    expect(service.processSteps, hasLength(3));
  });

  test('accepts scalar prices and legacy string descriptions', () {
    final service = ServiceItem.fromJson({
      'price': 49,
      'shortDescription': 'Installation',
    });
    expect(service.priceMin, 49);
    expect(service.priceMax, 49);
    expect(service.shortDescription, 'Installation');
  });

  test('missing price uses offer price without failing', () {
    final service = ServiceItem.fromJson({'offerPrice': 29});
    expect(service.priceMin, 29);
    expect(service.priceMax, 29);
    expect(service.shortDescription, isEmpty);
  });
}
