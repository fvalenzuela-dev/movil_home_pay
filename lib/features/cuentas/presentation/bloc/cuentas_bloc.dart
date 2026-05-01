import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/cuenta.dart';
import '../../domain/repositories/cuenta_repository.dart';

// Events
abstract class CuentasEvent extends Equatable {
  const CuentasEvent();
  @override
  List<Object?> get props => [];
}

class CuentasLoadRequested extends CuentasEvent {
  final String periodo;
  const CuentasLoadRequested(this.periodo);
  @override
  List<Object?> get props => [periodo];
}

class CuentaDetalleRequested extends CuentasEvent {
  final String cuentaId;
  final String periodo;
  const CuentaDetalleRequested(this.cuentaId, this.periodo);
  @override
  List<Object?> get props => [cuentaId, periodo];
}

class PagoRegistrado extends CuentasEvent {
  final String cuentaId;
  final String accountId;
  final double montoTotal;
  final double montoPagado;
  const PagoRegistrado(
    this.cuentaId,
    this.accountId,
    this.montoTotal,
    this.montoPagado,
  );
  @override
  List<Object?> get props => [cuentaId, accountId, montoTotal, montoPagado];
}

// States
abstract class CuentasState extends Equatable {
  const CuentasState();
  @override
  List<Object?> get props => [];
}

class CuentasInitial extends CuentasState {}

class CuentasLoading extends CuentasState {}

class CuentasLoaded extends CuentasState {
  final List<Cuenta> cuentas;
  final String periodo;
  const CuentasLoaded(this.cuentas, this.periodo);
  @override
  List<Object?> get props => [cuentas, periodo];
}

class CuentaDetalleLoaded extends CuentasState {
  final Cuenta cuenta;
  const CuentaDetalleLoaded(this.cuenta);
  @override
  List<Object?> get props => [cuenta];
}

class PagoSuccess extends CuentasState {
  final String cuentaId;
  const PagoSuccess(this.cuentaId);
  @override
  List<Object?> get props => [cuentaId];
}

class PagoFailure extends CuentasState {
  final String message;
  const PagoFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class CuentasError extends CuentasState {
  final String message;
  const CuentasError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class CuentasBloc extends Bloc<CuentasEvent, CuentasState> {
  final CuentaRepository _repository;

  CuentasBloc(this._repository) : super(CuentasInitial()) {
    on<CuentasLoadRequested>(_onLoadRequested);
    on<CuentaDetalleRequested>(_onDetalleRequested);
    on<PagoRegistrado>(_onPagoRegistrado);
  }

  Future<void> _onLoadRequested(
    CuentasLoadRequested event,
    Emitter<CuentasState> emit,
  ) async {
    emit(CuentasLoading());
    try {
      final cuentas = await _repository.getCuentasPorPeriodo(event.periodo);
      emit(CuentasLoaded(cuentas, event.periodo));
    } catch (e) {
      emit(CuentasError(e.toString()));
    }
  }

  Future<void> _onDetalleRequested(
    CuentaDetalleRequested event,
    Emitter<CuentasState> emit,
  ) async {
    emit(CuentasLoading());
    try {
      final cuenta = await _repository.getDetalleCuenta(
        event.cuentaId,
        event.periodo,
      );
      emit(CuentaDetalleLoaded(cuenta));
    } catch (e) {
      emit(CuentasError(e.toString()));
    }
  }

  Future<void> _onPagoRegistrado(
    PagoRegistrado event,
    Emitter<CuentasState> emit,
  ) async {
    emit(CuentasLoading());
    try {
      await _repository.registrarPago(
        event.cuentaId,
        event.accountId,
        event.montoTotal,
        event.montoPagado,
      );
      emit(PagoSuccess(event.cuentaId));
    } catch (e) {
      emit(PagoFailure(e.toString()));
    }
  }
}
