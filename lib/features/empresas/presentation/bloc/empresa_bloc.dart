import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/empresa.dart';
import '../../domain/repositories/empresa_repository.dart';

// Events
abstract class EmpresaEvent extends Equatable {
  const EmpresaEvent();

  @override
  List<Object?> get props => [];
}

class EmpresaListRequested extends EmpresaEvent {
  final int page;
  final int pageSize;

  const EmpresaListRequested({this.page = 1, this.pageSize = 20});

  @override
  List<Object?> get props => [page, pageSize];
}

class EmpresaDetailRequested extends EmpresaEvent {
  final String id;

  const EmpresaDetailRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class EmpresaCreateRequested extends EmpresaEvent {
  final Empresa empresa;

  const EmpresaCreateRequested(this.empresa);

  @override
  List<Object?> get props => [empresa];
}

class EmpresaUpdateRequested extends EmpresaEvent {
  final Empresa empresa;

  const EmpresaUpdateRequested(this.empresa);

  @override
  List<Object?> get props => [empresa];
}

class EmpresaDeleteRequested extends EmpresaEvent {
  final String id;

  const EmpresaDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class EmpresaListReset extends EmpresaEvent {
  const EmpresaListReset();
}

// States
abstract class EmpresaState extends Equatable {
  const EmpresaState();

  @override
  List<Object?> get props => [];
}

class EmpresaInitial extends EmpresaState {}

class EmpresaLoading extends EmpresaState {}

class EmpresaListLoaded extends EmpresaState {
  final List<Empresa> empresas;
  final int page;
  final int totalPages;
  final int totalCount;

  const EmpresaListLoaded({
    required this.empresas,
    required this.page,
    required this.totalPages,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [empresas, page, totalPages, totalCount];
}

class EmpresaDetailLoaded extends EmpresaState {
  final Empresa empresa;

  const EmpresaDetailLoaded(this.empresa);

  @override
  List<Object?> get props => [empresa];
}

class EmpresaOperationSuccess extends EmpresaState {
  final String message;
  final Empresa? empresa;

  const EmpresaOperationSuccess(this.message, {this.empresa});

  @override
  List<Object?> get props => [message, empresa];
}

class EmpresaError extends EmpresaState {
  final String message;

  const EmpresaError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class EmpresaBloc extends Bloc<EmpresaEvent, EmpresaState> {
  final EmpresaRepository _repository;

  EmpresaBloc(this._repository) : super(EmpresaInitial()) {
    on<EmpresaListRequested>(_onListRequested);
    on<EmpresaDetailRequested>(_onDetailRequested);
    on<EmpresaCreateRequested>(_onCreateRequested);
    on<EmpresaUpdateRequested>(_onUpdateRequested);
    on<EmpresaDeleteRequested>(_onDeleteRequested);
    on<EmpresaListReset>(_onListReset);
  }

  void _onListReset(
    EmpresaListReset event,
    Emitter<EmpresaState> emit,
  ) {
    emit(EmpresaInitial());
  }

  Future<void> _onListRequested(
    EmpresaListRequested event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(EmpresaLoading());
    try {
      final result = await _repository.getCompanies(
        page: event.page,
        pageSize: event.pageSize,
      );
      emit(EmpresaListLoaded(
        empresas: result.items,
        page: result.currentPage,
        totalPages: result.totalPages,
        totalCount: result.totalCount,
      ));
    } catch (e) {
      emit(EmpresaError(e.toString()));
    }
  }

  Future<void> _onDetailRequested(
    EmpresaDetailRequested event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(EmpresaLoading());
    try {
      final empresa = await _repository.getCompanyById(event.id);
      emit(EmpresaDetailLoaded(empresa));
    } catch (e) {
      emit(EmpresaError(e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    EmpresaCreateRequested event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(EmpresaLoading());
    try {
      final empresa = await _repository.createCompany(event.empresa);
      emit(EmpresaOperationSuccess('Empresa creada exitosamente', empresa: empresa));
    } catch (e) {
      emit(EmpresaError(e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    EmpresaUpdateRequested event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(EmpresaLoading());
    try {
      final empresa = await _repository.updateCompany(event.empresa);
      emit(EmpresaOperationSuccess('Empresa actualizada exitosamente', empresa: empresa));
    } catch (e) {
      emit(EmpresaError(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    EmpresaDeleteRequested event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(EmpresaLoading());
    try {
      await _repository.deleteCompany(event.id);
      emit(const EmpresaOperationSuccess('Empresa eliminada exitosamente'));
    } catch (e) {
      emit(EmpresaError(e.toString()));
    }
  }
}