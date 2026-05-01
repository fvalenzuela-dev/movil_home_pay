import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/empresas/domain/entities/empresa.dart';

void main() {
  group('Empresa Entity', () {
    const testEmpresa = Empresa(
      id: '123',
      authUserId: 'user-456',
      categoryId: 1,
      name: 'Test Company',
      website: 'https://test.com',
      phone: '+56912345678',
      isActive: true,
    );

    test('creates Empresa with all fields', () {
      expect(testEmpresa.id, '123');
      expect(testEmpresa.authUserId, 'user-456');
      expect(testEmpresa.categoryId, 1);
      expect(testEmpresa.name, 'Test Company');
      expect(testEmpresa.website, 'https://test.com');
      expect(testEmpresa.phone, '+56912345678');
      expect(testEmpresa.isActive, true);
    });

    test('creates Empresa with optional fields null', () {
      const empresa = Empresa(
        id: '123',
        authUserId: 'user-456',
        categoryId: 1,
        name: 'Test Company',
      );

      expect(empresa.website, isNull);
      expect(empresa.phone, isNull);
      expect(empresa.isActive, true); // default value
    });

    group('fromJson', () {
      test('parses JSON correctly', () {
        final json = {
          'id': 'emp-001',
          'auth_user_id': 'user-123',
          'category_id': 2,
          'name': 'Empresa Test',
          'website': 'https://empresa.cl',
          'phone': '+56999999999',
          'is_active': false,
        };

        final empresa = Empresa.fromJson(json);

        expect(empresa.id, 'emp-001');
        expect(empresa.authUserId, 'user-123');
        expect(empresa.categoryId, 2);
        expect(empresa.name, 'Empresa Test');
        expect(empresa.website, 'https://empresa.cl');
        expect(empresa.phone, '+56999999999');
        expect(empresa.isActive, false);
      });

      test('handles missing optional fields', () {
        final json = {
          'id': 'emp-001',
          'auth_user_id': 'user-123',
          'category_id': 2,
          'name': 'Empresa Test',
        };

        final empresa = Empresa.fromJson(json);

        expect(empresa.website, isNull);
        expect(empresa.phone, isNull);
        expect(empresa.isActive, true); // default
      });

      test('handles null values in JSON', () {
        final json = <String, dynamic>{
          'id': 'emp-001',
          'auth_user_id': 'user-123',
          'category_id': 2,
          'name': 'Empresa Test',
          'website': null,
          'phone': null,
        };

        final empresa = Empresa.fromJson(json);

        expect(empresa.website, isNull);
        expect(empresa.phone, isNull);
      });
    });

    group('toJson', () {
      test('converts to JSON correctly', () {
        final json = testEmpresa.toJson();

        expect(json['id'], '123');
        expect(json['auth_user_id'], 'user-456');
        expect(json['category_id'], 1);
        expect(json['name'], 'Test Company');
        expect(json['website'], 'https://test.com');
        expect(json['phone'], '+56912345678');
        expect(json['is_active'], true);
      });

      test('excludes null optional fields', () {
        const empresa = Empresa(
          id: '123',
          authUserId: 'user-456',
          categoryId: 1,
          name: 'Test Company',
        );

        final json = empresa.toJson();

        expect(json.containsKey('website'), false);
        expect(json.containsKey('phone'), false);
      });
    });

    group('copyWith', () {
      test('creates copy with modified name', () {
        final updated = testEmpresa.copyWith(name: 'New Name');

        expect(updated.name, 'New Name');
        expect(updated.id, testEmpresa.id);
        expect(updated.categoryId, testEmpresa.categoryId);
      });

      test('creates copy with modified website', () {
        final updated = testEmpresa.copyWith(website: 'https://new.com');

        expect(updated.website, 'https://new.com');
        expect(updated.name, testEmpresa.name);
      });

      test('creates copy with modified isActive', () {
        final updated = testEmpresa.copyWith(isActive: false);

        expect(updated.isActive, false);
        expect(updated.name, testEmpresa.name);
      });

      test('keeps original values when no parameters provided', () {
        final copy = testEmpresa.copyWith();

        expect(copy.id, testEmpresa.id);
        expect(copy.name, testEmpresa.name);
        expect(copy.website, testEmpresa.website);
        expect(copy.phone, testEmpresa.phone);
        expect(copy.isActive, testEmpresa.isActive);
      });
    });

    group('props', () {
      test('two empresas with same values are equal', () {
        const empresa1 = Empresa(
          id: '123',
          authUserId: 'user-456',
          categoryId: 1,
          name: 'Test Company',
        );
        const empresa2 = Empresa(
          id: '123',
          authUserId: 'user-456',
          categoryId: 1,
          name: 'Test Company',
        );

        expect(empresa1, equals(empresa2));
      });

      test('two empresas with different values are not equal', () {
        const empresa1 = Empresa(
          id: '123',
          authUserId: 'user-456',
          categoryId: 1,
          name: 'Test Company',
        );
        const empresa2 = Empresa(
          id: '999',
          authUserId: 'user-456',
          categoryId: 1,
          name: 'Test Company',
        );

        expect(empresa1, isNot(equals(empresa2)));
      });
    });
  });
}
