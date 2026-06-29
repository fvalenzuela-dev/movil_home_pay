import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class AccountListRequested extends AccountEvent {
  final String? companyId;
  final String? sort;
  final String? order;
  final int page;
  final int limit;

  const AccountListRequested({
    this.companyId,
    this.sort,
    this.order,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [companyId, sort, order, page, limit];
}

class AccountDetailRequested extends AccountEvent {
  final String id;

  const AccountDetailRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class AccountCreateRequested extends AccountEvent {
  final Account account;

  const AccountCreateRequested(this.account);

  @override
  List<Object?> get props => [account];
}

class AccountUpdateRequested extends AccountEvent {
  final Account account;

  const AccountUpdateRequested(this.account);

  @override
  List<Object?> get props => [account];
}

class AccountDeleteRequested extends AccountEvent {
  final String id;

  const AccountDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class AccountListReset extends AccountEvent {
  const AccountListReset();
}

// ─── States ──────────────────────────────────────────────────────────────────

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountListLoaded extends AccountState {
  final List<Account> accounts;
  final int page;
  final int totalPages;
  final int totalCount;

  const AccountListLoaded({
    required this.accounts,
    required this.page,
    required this.totalPages,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [accounts, page, totalPages, totalCount];
}

class AccountDetailLoaded extends AccountState {
  final Account account;

  const AccountDetailLoaded(this.account);

  @override
  List<Object?> get props => [account];
}

class AccountOperationSuccess extends AccountState {
  final String message;
  final Account? account;

  const AccountOperationSuccess(this.message, {this.account});

  @override
  List<Object?> get props => [message, account];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ────────────────────────────────────────────────────────────────────

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _repository;

  AccountBloc(this._repository) : super(const AccountInitial()) {
    on<AccountListRequested>(_onListRequested);
    on<AccountDetailRequested>(_onDetailRequested);
    on<AccountCreateRequested>(_onCreateRequested);
    on<AccountUpdateRequested>(_onUpdateRequested);
    on<AccountDeleteRequested>(_onDeleteRequested);
    on<AccountListReset>(_onListReset);
  }

  void _onListReset(
    AccountListReset event,
    Emitter<AccountState> emit,
  ) {
    emit(const AccountInitial());
  }

  Future<void> _onListRequested(
    AccountListRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    try {
      final result = await _repository.getAccounts(
        companyId: event.companyId,
        sort: event.sort,
        order: event.order,
        page: event.page,
        limit: event.limit,
      );
      emit(AccountListLoaded(
        accounts: result.items,
        page: result.currentPage,
        totalPages: result.totalPages,
        totalCount: result.totalCount,
      ));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onDetailRequested(
    AccountDetailRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    try {
      final account = await _repository.getAccountById(event.id);
      emit(AccountDetailLoaded(account));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    AccountCreateRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    try {
      final account = await _repository.createAccount(event.account);
      emit(AccountOperationSuccess('Cuenta creada exitosamente', account: account));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    AccountUpdateRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    try {
      final account = await _repository.updateAccount(event.account);
      emit(AccountOperationSuccess('Cuenta actualizada exitosamente', account: account));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    AccountDeleteRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    try {
      await _repository.deleteAccount(event.id);
      emit(const AccountOperationSuccess('Cuenta eliminada exitosamente'));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
