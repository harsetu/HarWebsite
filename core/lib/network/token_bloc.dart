import 'package:core/network/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/network_constants.dart';

// Events
abstract class TokenEvent {}
class FetchAccessToken extends TokenEvent {}
class FetchRefreshToken extends TokenEvent {}

// State
class TokenState {
  final String? accessToken;
  final String? refreshToken;
  final bool isLoading;
  final String? error;

  TokenState({
    this.accessToken,
    this.refreshToken,
    this.isLoading = false,
    this.error,
  });

  TokenState copyWith({
    String? accessToken,
    String? refreshToken,
    bool? isLoading,
    String? error,
  }) {
    return TokenState(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Bloc
class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final SecureStorageService secureStorage;

  TokenBloc({required this.secureStorage}) : super(TokenState()) {
    on<FetchAccessToken>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final token = await secureStorage.get(NetworkConstants.accessTokenKey);
        emit(state.copyWith(accessToken: token, isLoading: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });
    on<FetchRefreshToken>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final token = await secureStorage.get(NetworkConstants.refreshTokenKey);
        emit(state.copyWith(refreshToken: token, isLoading: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });
  }
}

