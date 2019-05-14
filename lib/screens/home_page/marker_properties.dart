

class MarkerProperties {
  bool bookmarked;
  String markerId;

  MarkerProperties({ this.markerId, this.bookmarked });

  @override
  String toString() {
    return 'bookmarked: $bookmarked, markerId: ${markerId.toString()}';
  }
}