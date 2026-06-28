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
  final String accountId;
  final String periodo;
  const CuentaDetalleRequested(this.cuentaId, this.accountId, this.periodo);
  @override
  List<Object?> get props => [cuentaId, accountId, periodo];
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

class CuentaReopenRequested extends CuentasEvent {
  final String cuentaId;
  final String accountId;
  final double montoOriginal;
  const CuentaReopenRequested({
    required this.cuentaId,
    required this.accountId,
    required this.montoOriginal,
  });
  @override
  List<Object?> get props => [cuentaId, accountId, montoOriginal];
}

class AgregarCuentaIndividualRequested extends CuentasEvent {
  final String accountId;
  final double monto;
  final double montoPagado;
  final String? periodo;
  final String? nombre;

  const AgregarCuentaIndividualRequested({
    required this.accountId,
    required this.monto,
    this.montoPagado = 0,
    this.periodo,
    this.nombre,
  });

  @override
  List<Object?> get props => [accountId, monto, montoPagado, periodo, nombre];
}

class AbrirPeriodoRequested extends CuentasEvent {
  final String periodo;
  const AbrirPeriodoRequested(this.periodo);
  @override
  List<Object?> get props => [periodo];
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

class ReopenSuccess extends CuentasState {
  final String cuentaId;
  const ReopenSuccess(this.cuentaId);
  @override
  List<Object?> get props => [cuentaId];
}

class ReopenFailure extends CuentasState {
  final String message;
  const ReopenFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class CuentaAgregadaFailure extends CuentasState {
  final String message;
  const CuentaAgregadaFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class AbrirPeriodoSuccess extends CuentasState {
  final int cantidad;
  const AbrirPeriodoSuccess(this.cantidad);
  @override
  List<Object?> get props => [cantidad];
}

class AbrirPeriodoFailure extends CuentasState {
  final String message;
  const AbrirPeriodoFailure(this.message);
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
    on<CuentaReopenRequested>(_onReopenRequested);
    on<AgregarCuentaIndividualRequested>(_onAgregarCuentaIndividualRequested);
    on<AbrirPeriodoRequested>(_onAbrirPeriodoRequested);
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
      final cuenta = await _repository.getDetalleCuenta(event.cuentaId);
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
        event.montoTotal,
        event.montoPagado,
      );
      emit(PagoSuccess(event.cuentaId));
    } catch (e) {
      emit(PagoFailure(e.toString()));
    }
  }

  Future<void> _onReopenRequested(
    CuentaReopenRequested event,
    Emitter<CuentasState> emit,
  ) async {
    emit(CuentasLoading());
    try {
      await _repository.reopenAccount(
        event.cuentaId,
        event.montoOriginal,
      );
      emit(ReopenSuccess(event.cuentaId));
    } catch (e) {
      emit(ReopenFailure(e.toString()));
    }
  }

  Future<void> _onAgregarCuentaIndividualRequested(
    AgregarCuentaIndividualRequested event,
    Emitter<CuentasState> emit,
  ) async {
    emit(CuentasLoading());
    try {
      await _repository.agregarCuentaIndividual(
        accountId: event.accountId,
        monto: event.monto,
        montoPagado: event.montoPagado,
        periodo: event.periodo,
        nombre: event.nombre,
      );
      // Reload the cuentas list after adding
      final currentState = state;
      final periodo = event.periodo ?? _derivePeriodo(currentState);
      if (periodo != null) {
        final cuentas = await _repository.getCuentasPorPeriodo(periodo);
        emit(CuentasLoaded(cuentas, periodo));
      } else {
        emit(CuentasLoaded([], ''));
      }
    } catch (e) {
      emit(CuentaAgregadaFailure(e.toString()));
    }
  }

  Future<void> _onAbrirPeriodoRequested(
    AbrirPeriodoRequested event,
    Emitter<CuentasState> emit,
  ) async {
    emit(CuentasLoading());
    try {
      final cuentas = await _repository.abrirPeriodo(event.periodo);
      emit(AbrirPeriodoSuccess(cuentas.length));
      emit(CuentasLoaded(cuentas, event.periodo));
    } catch (e) {
      emit(AbrirPeriodoFailure(e.toString()));
    }
  }

  String? _derivePeriodo(CuentasState state) {
    if (state is CuentasLoaded) return state.periodo;
    if (state is CuentaDetalleLoaded) return state.cuenta.periodo;
    return null;
  }
}
