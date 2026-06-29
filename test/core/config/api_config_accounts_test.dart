import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/core/config/api_config.dart';

import '../../helpers/test_bootstrap.dart';

void main() {
  setUpAll(() {
    bootstrapTests();
  });

  group('ApiConfig - Accounts', () {
    group('accountsUrl', () {
      test('default URL contains limit=20 and does NOT contain page_size', () {
        final url = ApiConfig.accountsUrl();
        expect(url, contains('limit=20'));
        expect(url, isNot(contains('page_size')));
      });

      test('URL contains company_id when companyId is provided', () {
        final url = ApiConfig.accountsUrl(companyId: 'c-1');
        expect(url, contains('company_id=c-1'));
      });

      test('URL contains page and limit when both provided', () {
        final url = ApiConfig.accountsUrl(page: 2, limit: 10);
        expect(url, contains('page=2'));
        expect(url, contains('limit=10'));
      });

      test('URL does NOT contain company_id when companyId is null', () {
        final url = ApiConfig.accountsUrl();
        expect(url, isNot(contains('company_id')));
      });

      test('URL contains sort when sort is provided', () {
        final url = ApiConfig.accountsUrl(sort: 'name');
        expect(url, contains('sort=name'));
      });

      test('URL contains order when order is provided', () {
        final url = ApiConfig.accountsUrl(order: 'asc');
        expect(url, contains('order=asc'));
      });
    });

    group('accountUrl', () {
      test('returns correct URL for a given account id', () {
        final url = ApiConfig.accountUrl('abc-123');
        expect(url, equals('${ApiConfig.baseUrl}/accounts/abc-123'));
      });
    });

    group('accountsPath', () {
      test('is /accounts', () {
        expect(ApiConfig.accountsPath, equals('/accounts'));
      });
    });
  });
}
