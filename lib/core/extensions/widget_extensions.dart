import 'package:flutter/material.dart';

/// Padding extension methods for Widget
extension PaddingExtension on Widget {
  /// Adds padding to all sides
  Widget allPadding(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Adds symmetric padding (vertical and horizontal)
  Widget symmetricPadding({
    double vertical = 0,
    double horizontal = 0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }

  /// Adds padding to specific sides only
  Widget onlyPadding({
    double bottom = 0,
    double left = 0,
    double right = 0,
    double top = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, left: left, right: right, top: top),
      child: this,
    );
  }

  /// Quick padding shortcuts
  Widget paddingTop(double value) => onlyPadding(top: value);
  Widget paddingBottom(double value) => onlyPadding(bottom: value);
  Widget paddingLeft(double value) => onlyPadding(left: value);
  Widget paddingRight(double value) => onlyPadding(right: value);
  Widget paddingHorizontal(double value) => symmetricPadding(horizontal: value);
  Widget paddingVertical(double value) => symmetricPadding(vertical: value);
}

/// Spacing extension methods for Widget
extension SpacingExtension on Widget {
  /// Adds SizedBox with height after this widget
  Widget spaceBottom(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(height: height),
      ],
    );
  }

  /// Adds SizedBox with width after this widget
  Widget spaceRight(double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(width: width),
      ],
    );
  }

  /// Quick spacing shortcuts
  Widget space4() => spaceBottom(4);
  Widget space8() => spaceBottom(8);
  Widget space12() => spaceBottom(12);
  Widget space16() => spaceBottom(16);
  Widget space20() => spaceBottom(20);
  Widget space24() => spaceBottom(24);
}

/// Margin extension methods for Widget
extension MarginExtension on Widget {
  /// Adds margin to all sides
  Widget allMargin(double value) {
    return Container(
      margin: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Adds symmetric margin
  Widget symmetricMargin({
    double vertical = 0,
    double horizontal = 0,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }

  /// Adds margin to specific sides only
  Widget onlyMargin({
    double bottom = 0,
    double left = 0,
    double right = 0,
    double top = 0,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: bottom, left: left, right: right, top: top),
      child: this,
    );
  }

  /// Quick margin shortcuts
  Widget marginTop(double value) => onlyMargin(top: value);
  Widget marginBottom(double value) => onlyMargin(bottom: value);
  Widget marginLeft(double value) => onlyMargin(left: value);
  Widget marginRight(double value) => onlyMargin(right: value);
  Widget marginHorizontal(double value) => symmetricMargin(horizontal: value);
  Widget marginVertical(double value) => symmetricMargin(vertical: value);
}

/// Border radius extension methods for Widget
extension BorderRadiusExtension on Widget {
  /// Adds border radius to widget (wraps in Container with decoration)
  Widget borderRadius(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  /// Adds custom border radius
  Widget customBorderRadius(BorderRadius borderRadius) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: this,
    );
  }

  /// Quick border radius shortcuts
  Widget rounded4() => borderRadius(4);
  Widget rounded8() => borderRadius(8);
  Widget rounded12() => borderRadius(12);
  Widget rounded16() => borderRadius(16);
  Widget roundedCircle() => ClipOval(child: this);
}

/// General utility extensions for Widget
extension WidgetUtilExtension on Widget {
  /// Centers the widget
  Widget center() => Center(child: this);

  /// Expands the widget
  Widget expand([int flex = 1]) => Expanded(flex: flex, child: this);

  /// Adds flexible to widget
  Widget flexible([int flex = 1]) => Flexible(flex: flex, child: this);

  /// Adds gesture detector with onTap
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }

  /// Adds InkWell with onTap
  Widget inkWell(VoidCallback onTap, {BorderRadius? borderRadius}) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: this,
    );
  }

  /// Makes widget visible or invisible
  Widget visible(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: this,
    );
  }

  /// Adds opacity to widget
  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }  
}
/// Decoration extension methods for Widget
extension DecorationExtension on Widget {
  /// Adds decoration to widget
  Widget decorated({
    Color? color,
    BorderRadius? borderRadius,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: this,
    );
  }
 /// Adds box shadow to widget
  Widget withShadow({
    Color color = const Color(0xFF000000),
    double blurRadius = 4,
    Offset offset = const Offset(0, 2),
    double opacity = 0.1,
  }) {
    return decorated(
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(opacity),
          blurRadius: blurRadius,
          offset: offset,
        ),
      ],
    );
  }
}
