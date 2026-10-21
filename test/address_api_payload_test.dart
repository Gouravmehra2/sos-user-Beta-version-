import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';

class _RecordedPut {
  final String path;
  final Map<String, dynamic> data;

  const _RecordedPut(this.path, this.data);
}

class _RecordingDioClient extends DioClient {
  final requests = <_RecordedPut>[];
  Map<String, dynamic> responseData = {
    'success': true,
    'data': {
      'user': {'addresses': []},
    },
  };

  @override
  Future<Response> put(String path, {dynamic data, Options? options}) async {
    requests.add(_RecordedPut(path, data as Map<String, dynamic>));
    return Response(
      requestOptions: RequestOptions(path: path),
      data: responseData,
    );
  }
}

void main() {
  test('add address sends the supplied fields without a server-owned id', () async {
    final client = _RecordingDioClient();
    await ApiRepo(client).addAddress(
      label: 'Office',
      name: '',
      addressLine:
          'Haridwar Railway Station Grounds, Shikhu Pur, Devpura, Haridwar, Uttarakhand 249401, India',
      house: 'CXO Suits Ground floor',
      building: 'Sector 28 Road',
      city: 'Devpura road',
      state: 'Uttarakhand',
      zipcode: '249401',
      area:
          'Haridwar Railway Station Grounds, Shikhu Pur, Devpura, Haridwar, Uttarakhand 249401, India',
      addressType: 'Office',
    );

    final payload =
        client.requests.single.data['addAddress'] as Map<String, dynamic>;
    expect(
      payload,
      containsPair(
        'addressLine',
        'Haridwar Railway Station Grounds, Shikhu Pur, Devpura, Haridwar, Uttarakhand 249401, India',
      ),
    );
    expect(payload, containsPair('buildingFloor', 'CXO Suits Ground floor'));
    expect(payload, containsPair('street', 'Sector 28 Road'));
    expect(payload, containsPair('city', 'Devpura road'));
    expect(payload, containsPair('state', 'Uttarakhand'));
    expect(payload, containsPair('zipcode', '249401'));
    expect(payload, containsPair('label', 'Office'));
    expect(payload, containsPair('name', ''));
    expect(payload, isNot(contains('id')));
  });

  test('update address keeps the supplied id and field names', () async {
    final client = _RecordingDioClient();
    await ApiRepo(client).updateAddress(
      const UserAddress(
        id: '6acffd44eba70f575cd9a5de',
        label: 'Office',
        name: '',
        addressLine:
            'Haridwar Railway Station Grounds, Shikhu Pur, Devpura, Haridwar, Uttarakhand 249401, India',
        house: 'CXO Suits Ground floor',
        building: 'Sector 28 Road',
        city: 'Devpura road',
        state: 'Uttarakhand',
        zipcode: '249401',
      ),
    );

    final payload =
        client.requests.single.data['updateAddress'] as Map<String, dynamic>;
    expect(payload, containsPair('id', '6acffd44eba70f575cd9a5de'));
    expect(payload, containsPair('buildingFloor', 'CXO Suits Ground floor'));
    expect(payload, containsPair('street', 'Sector 28 Road'));
    expect(
      payload,
      containsPair(
        'addressLine',
        'Haridwar Railway Station Grounds, Shikhu Pur, Devpura, Haridwar, Uttarakhand 249401, India',
      ),
    );
  });
  test(
    'manual addresses omit coordinates and defaults use the saved id',
    () async {
      final client = _RecordingDioClient();
      final repo = ApiRepo(client);
      await repo.addAddress(
        label: 'Home',
        addressLine: 'Main Street',
        city: '',
        state: '',
        zipcode: '',
        isDefault: true,
      );
      final payload = client.requests.last.data['addAddress'] as Map;
      expect(payload.containsKey('coordinates'), isFalse);
      expect(payload['isDefault'], isTrue);
      await repo.setDefaultAddress('saved-id');
      expect(client.requests.last.data, {'setDefaultAddress': 'saved-id'});
      await repo.addAddress(
        label: 'Work',
        addressLine: 'Zero Road',
        city: '',
        state: '',
        zipcode: '',
        latitude: 0,
        longitude: 0,
      );
      expect(client.requests.last.data['addAddress']['coordinates'], {
        'lat': 0,
        'lng': 0,
      });
    },
  );
  test(
    'save returns the server-owned id and nested coordinates from data.user',
    () async {
      final client = _RecordingDioClient()
        ..responseData = {
          'success': true,
          'data': {
            'user': {
              'addresses': [
                {
                  '_id': 'server-id',
                  'addressLine': 'Main Street',
                  'coordinates': {'lat': 0, 'lng': 0},
                },
              ],
            },
          },
        };
      final updated = await ApiRepo(client).addAddress(
        label: 'Home',
        addressLine: 'Main Street',
        city: '',
        state: '',
        zipcode: '',
      );
      expect(updated.single.id, 'server-id');
      expect(updated.single.latitude, 0);
      expect(updated.single.longitude, 0);
    },
  );
}
