import 'package:flutter/widgets.dart';

mixin ScrollVisibilityMixin {
  final ValueNotifier<bool> _headerVisibilityNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _paginationVisibilityNotifier = ValueNotifier<bool>(false);
  
  ValueNotifier<bool> get headerVisibilityNotifier => _headerVisibilityNotifier;
  ValueNotifier<bool> get paginationVisibilityNotifier => _paginationVisibilityNotifier;
  
  void updateVisibilityBasedOnScroll(double scrollPosition, double maxScroll) {
    const double headerThreshold = 100.0;
    const double paginationThreshold = 200.0;
    
    final bool shouldShowHeader = scrollPosition < headerThreshold;
    if (_headerVisibilityNotifier.value != shouldShowHeader) {
      _headerVisibilityNotifier.value = shouldShowHeader;
    }
    
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