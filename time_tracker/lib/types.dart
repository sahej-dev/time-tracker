enum LoadingStatus { initial, pending, success, error }

extension LoadingStatusMixer on LoadingStatus {
  /// returns the worst loading status
  static LoadingStatus mix(List<LoadingStatus> statuses) {
    if (statuses.contains(LoadingStatus.error)) return LoadingStatus.error;
    if (statuses.contains(LoadingStatus.initial)) return LoadingStatus.initial;
    if (statuses.contains(LoadingStatus.pending)) return LoadingStatus.pending;

    return LoadingStatus.success;
  }
}
