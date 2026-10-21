import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plan_api.dart';
import 'plan_test_support.dart';

class _Client extends DioClient {
  String? path;
  Map<String, dynamic>? queryParameters;
  dynamic payload;
  dynamic responseData;
  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    this.path = path;
    payload = data;
    return Response(
      requestOptions: RequestOptions(path: path),
      data: responseData,
    );
  }

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    this.path = path;
    this.queryParameters = queryParameters;
    return Response(
      requestOptions: RequestOptions(path: path),
      data: responseData,
    );
  }
}

void main() {
  test('checkout and verification send only the documented IDs', () async {
    final client = _Client();
    final api = PlanApi(ApiRepo(client));
    client.responseData = {
      'success': true,
      'data': {
        'planPurchase': purchaseJson(),
        'paymentOrder': {
          'provider': 'stripe',
          'id': 'pi_example',
          'clientSecret': 'secret',
          'amount': 172500,
          'currency': 'usd',
          'publishableKey': 'pk_test_example',
        },
      },
    };
    await api.create('plan1');
    expect(client.path, '/api/plans/purchases');
    expect(client.payload, {'planId': 'plan1'});
    client.responseData = {
      'success': true,
      'data': {'planPurchase': purchaseJson('active')},
    };
    await api.verify('purchase1', 'pi_example');
    expect(client.path, '/api/plans/purchases/verify');
    expect(client.payload, {
      'planPurchaseId': 'purchase1',
      'stripePaymentIntentId': 'pi_example',
    });
  });
  test(
    'inactive catalog plans are excluded and history parses dates',
    () async {
      final client = _Client();
      final api = PlanApi(ApiRepo(client));
      client.responseData = {
        'success': true,
        'data': {
          'plans': [
            planJson(),
            {...planJson(), 'isActive': false},
          ],
        },
      };
      expect(await api.catalog(), hasLength(1));
      expect(client.path, '/api/plans');
      client.responseData = {
        'success': true,
        'data': {
          'planPurchases': [
            {...purchaseJson('active'), 'expiresAt': '2027-10-01T00:00:00Z'},
          ],
        },
      };
      expect((await api.history()).single.expiresAt, DateTime.utc(2027, 10, 1));
      expect(client.path, '/api/plans/my-purchases');
    },
  );

  test('catalog sends selected category and duration filters', () async {
    final client = _Client();
    final api = PlanApi(ApiRepo(client));
    client.responseData = {
      'success': true,
      'data': {
        'plans': [planJson()],
      },
    };

    await api.catalog(category: 'Business', durationYears: 2);

    expect(client.path, '/api/plans');
    expect(client.queryParameters, {
      'category': 'Business',
      'durationYears': 2,
    });
  });
}
