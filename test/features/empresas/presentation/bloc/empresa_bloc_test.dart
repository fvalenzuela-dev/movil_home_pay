import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/empresas/domain/entities/empresa.dart';
import 'package:movil_home_pay/features/empresas/domain/repositories/empresa_repository.dart';
import 'package:movil_home_pay/features/empresas/presentation/bloc/empresa_bloc.dart';

export 'package:movil_home_pay/features/empresas/domain/repositories/empresa_repository.dart'
    show PaginatedResult;

class MockEmpresaRepository extends Mock implements EmpresaRepository {}

class FakeEmpresa extends Fake implements Empresa {}

void main() {
  late MockEmpresaRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeEmpresa());
  });

  setUp(() {
    mockRepository = MockEmpresaRepository();
  });

  const testEmpresa = Empresa(
    id: 'emp-123',
    authUserId: 'user-456',
    categoryId: 1,
    name: 'Test Company',
    website: 'https://test.com',
    phone: '+56912345678',
    isActive: true,
  );

  const testPaginatedResult = PaginatedResult<Empresa>(
    items: [testEmpresa],
    currentPage: 1,
    totalPages: 1,
    totalCount: 1,
  );

  group('EmpresaBloc', () {
    test('initial state is EmpresaInitial', () {
      final bloc = EmpresaBloc(mockRepository);
      expect(bloc.state, isA<EmpresaInitial>());
      bloc.close();
    });

    group('EmpresaListRequested', () {
      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaListLoaded] when getCompanies succeeds',
        setUp: () {
          when(() => mockRepository.getCompanies(
                page: any(named: 'page'),
                pageSize: any(named: 'pageSize'),
              )).thenAnswer((_) async => testPaginatedResult);
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaListRequested()),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaListLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepository.getCompanies(page: 1, pageSize: 20)).called(1);
        },
      );

      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaError] when getCompanies fails',
        setUp: () {
          when(() => mockRepository.getCompanies(
                page: any(named: 'page'),
                pageSize: any(named: 'pageSize'),
              )).thenThrow(Exception('Network error'));
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaListRequested()),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaError>(),
        ],
      );

      blocTest<EmpresaBloc, EmpresaState>(
        'uses custom page and pageSize when provided',
        setUp: () {
          when(() => mockRepository.getCompanies(
                page: any(named: 'page'),
                pageSize: any(named: 'pageSize'),
              )).thenAnswer((_) async => testPaginatedResult);
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaListRequested(page: 2, pageSize: 10)),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaListLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepository.getCompanies(page: 2, pageSize: 10)).called(1);
        },
      );
    });

    group('EmpresaDetailRequested', () {
      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaDetailLoaded] when getCompanyById succeeds',
        setUp: () {
          when(() => mockRepository.getCompanyById(any()))
              .thenAnswer((_) async => testEmpresa);
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaDetailRequested('emp-123')),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaDetailLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepository.getCompanyById('emp-123')).called(1);
        },
      );

      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaError] when getCompanyById fails',
        setUp: () {
          when(() => mockRepository.getCompanyById(any()))
              .thenThrow(Exception('Company not found'));
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaDetailRequested('invalid-id')),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaError>(),
        ],
      );
    });

    group('EmpresaCreateRequested', () {
      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaOperationSuccess] when createCompany succeeds',
        setUp: () {
          when(() => mockRepository.createCompany(any()))
              .thenAnswer((_) async => testEmpresa);
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaCreateRequested(testEmpresa)),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaOperationSuccess>(),
        ],
        verify: (_) {
          verify(() => mockRepository.createCompany(testEmpresa)).called(1);
        },
      );

      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaError] when createCompany fails',
        setUp: () {
          when(() => mockRepository.createCompany(any()))
              .thenThrow(Exception('Duplicate company'));
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaCreateRequested(testEmpresa)),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaError>(),
        ],
      );

      test('EmpresaOperationSuccess contains the created empresa', () async {
        when(() => mockRepository.createCompany(any()))
            .thenAnswer((_) async => testEmpresa);

        final bloc = EmpresaBloc(mockRepository);
        bloc.add(const EmpresaCreateRequested(testEmpresa));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<EmpresaLoading>(),
            isA<EmpresaOperationSuccess>(),
          ]),
        );
        bloc.close();
      });
    });

    group('EmpresaUpdateRequested', () {
      final updatedEmpresa = testEmpresa.copyWith(name: 'Updated Company');

      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaOperationSuccess] when updateCompany succeeds',
        setUp: () {
          when(() => mockRepository.updateCompany(any()))
              .thenAnswer((_) async => updatedEmpresa);
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(EmpresaUpdateRequested(updatedEmpresa)),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaOperationSuccess>(),
        ],
        verify: (_) {
          verify(() => mockRepository.updateCompany(updatedEmpresa)).called(1);
        },
      );

      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaError] when updateCompany fails',
        setUp: () {
          when(() => mockRepository.updateCompany(any()))
              .thenThrow(Exception('Update failed'));
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(EmpresaUpdateRequested(updatedEmpresa)),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaError>(),
        ],
      );
    });

    group('EmpresaDeleteRequested', () {
      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaOperationSuccess] when deleteCompany succeeds',
        setUp: () {
          when(() => mockRepository.deleteCompany(any()))
              .thenAnswer((_) async => true);
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaDeleteRequested('emp-123')),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaOperationSuccess>(),
        ],
        verify: (_) {
          verify(() => mockRepository.deleteCompany('emp-123')).called(1);
        },
      );

      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaLoading, EmpresaError] when deleteCompany fails',
        setUp: () {
          when(() => mockRepository.deleteCompany(any()))
              .thenThrow(Exception('Delete failed'));
        },
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaDeleteRequested('emp-123')),
        expect: () => [
          isA<EmpresaLoading>(),
          isA<EmpresaError>(),
        ],
      );
    });

    group('EmpresaListReset', () {
      blocTest<EmpresaBloc, EmpresaState>(
        'emits [EmpresaInitial] when EmpresaListReset is added',
        build: () => EmpresaBloc(mockRepository),
        act: (bloc) => bloc.add(const EmpresaListReset()),
        expect: () => [
          isA<EmpresaInitial>(),
        ],
      );
    });
  });
}
