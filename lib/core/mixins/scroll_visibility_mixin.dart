import 'package:flutter/widgets.dart';

mixin ScrollVisibilityMixin {
  final ValueNotifier<bool> _headerVisibilityNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _paginationVisibilityNotifier = ValueNotifier<bool>(false);
  
  ValueNotifier<bool> get headerVisibilityNotifier => _headerVisibilityNotifier;
  ValueNotifier<bool> get paginationVisibilityNotifier => _paginationVisibilityNotifier;
  
  void updateVisibilityBasedOnScroll(double scrollPosition, double maxScroll, {bool isEmptyState = false}) {
    // Empty state'te header'ı hiçbir zaman gizleme
    if (isEmptyState) {
      if (_headerVisibilityNotifier.value != true) {
        _headerVisibilityNotifier.value = true;
      }
      if (_paginationVisibilityNotifier.value != false) {
        _paginationVisibilityNotifier.value = false;
      }
      return;
    }
    
    const double headerThreshold = 100.0;
    const double paginationThreshold = 200.0;
    
    final bool shouldShowHeader = scrollPosition < headerThreshold;
    if (_headerVisibilityNotifier.value != shouldShowHeader) {
      _headerVisibilityNotifier.value = shouldShowHeader;
    }
    
   // Sadece pagination visibility'yi güncelle
    final bool shouldShowPagination = (maxScroll - scrollPosition) < paginationThreshold;
    if (_paginationVisibilityNotifier.value != shouldShowPagination) {
      _paginationVisibilityNotifier.value = shouldShowPagination;
    }
  }
  void updateHeaderVisibility(bool isVisible) {
    if (_headerVisibilityNotifier.value != isVisible) {
      _headerVisibilityNotifier.value = isVisible;
    }
  }
  
  void updatePaginationVisibility(bool isVisible) {
    if (_paginationVisibilityNotifier.value != isVisible) {
      _paginationVisibilityNotifier.value = isVisible;
    }
  }
  
  void disposeVisibilityNotifiers() {
    _headerVisibilityNotifier.dispose();
    _paginationVisibilityNotifier.dispose();
  }
}