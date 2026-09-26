/// Standardized lifecycle statuses for UI views.
enum ViewStatus {
  initial,
  loading,
  loaded,
  error,
}

/// Generic, immutable state container representing Loading, Loaded, and Error states.
class ViewState<T> {
  final ViewStatus status;
  final T? data;
  final String? errorMessage;

  const ViewState._({
    required this.status,
    this.data,
    this.errorMessage,
  });

  /// Initial idle state
  factory ViewState.initial() => const ViewState._(status: ViewStatus.initial);

  /// Loading state, optionally preserving previous data for smooth optimistic UI
  factory ViewState.loading([T? previousData]) => ViewState._(
        status: ViewStatus.loading,
        data: previousData,
      );

  /// Successfully loaded state containing data payload
  factory ViewState.loaded(T data) => ViewState._(
        status: ViewStatus.loaded,
        data: data,
      );

  /// Error state with descriptive user-facing message
  factory ViewState.error(String message, [T? fallbackData]) => ViewState._(
        status: ViewStatus.error,
        errorMessage: message,
        data: fallbackData,
      );

  bool get isInitial => status == ViewStatus.initial;
  bool get isLoading => status == ViewStatus.loading;
  bool get isLoaded => status == ViewStatus.loaded;
  bool get isError => status == ViewStatus.error;

  /// Helper to map over states with custom widget builders
  R when<R>({
    required R Function() initial,
    required R Function(T? previousData) loading,
    required R Function(T data) loaded,
    required R Function(String message) error,
  }) {
    switch (status) {
      case ViewStatus.initial:
        return initial();
      case ViewStatus.loading:
        return loading(data);
      case ViewStatus.loaded:
        return loaded(data as T);
      case ViewStatus.error:
        return error(errorMessage ?? 'An unexpected error occurred.');
    }
  }
}
