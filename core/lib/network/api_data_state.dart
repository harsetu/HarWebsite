enum ApiLoadingState {
  loading,
  success,
  successParsingError,
  failure,
}

class ApiLoadingResponse<T> {
  final ApiLoadingState state;
  final T? data;
  final String? error;
  final String? errorCode;

  const ApiLoadingResponse._({
    required this.state,
    this.data,
    this.error,
    this.errorCode,
  });

  factory ApiLoadingResponse.loading() => const ApiLoadingResponse._(state: ApiLoadingState.loading);

  factory ApiLoadingResponse.successParsingError() => const ApiLoadingResponse._(state: ApiLoadingState.success);

  factory ApiLoadingResponse.success(T? data, {String? code}) =>
      ApiLoadingResponse._(state: ApiLoadingState.success, data: data, errorCode: code);

  factory ApiLoadingResponse.failure(String? error, String code) =>
      ApiLoadingResponse._(state: ApiLoadingState.failure, error: error, errorCode: code);
}
