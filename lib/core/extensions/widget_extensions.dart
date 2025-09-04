import 'package:flutter/material.dart';

// Padding extension
extension PaddingExtension on Widget {

  Widget allPadding(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  //  symmetric padding (vertical ve horizontal için )
  Widget symmetricPadding({
    double vertical = 0,
    double horizontal = 0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }

  //spesifif kenarları için
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


  Widget paddingTop(double value) => onlyPadding(top: value);
  Widget paddingBottom(double value) => onlyPadding(bottom: value);
  Widget paddingLeft(double value) => onlyPadding(left: value);
  Widget paddingRight(double value) => onlyPadding(right: value);
  Widget paddingHorizontal(double value) => symmetricPadding(horizontal: value);
  Widget paddingVertical(double value) => symmetricPadding(vertical: value);
}

/// space için
extension SpacingExtension on Widget {
  Widget spaceBottom(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(height: height),
      ],
    );
  }


  Widget spaceRight(double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(width: width),
      ],
    );
  }


  Widget space4() => spaceBottom(4);
  Widget space8() => spaceBottom(8);
  Widget space12() => spaceBottom(12);
  Widget space16() => spaceBottom(16);
  Widget space20() => spaceBottom(20);
  Widget space24() => spaceBottom(24);
}

/// Margin için
extension MarginExtension on Widget {
  Widget allMargin(double value) {
    return Container(
      margin: EdgeInsets.all(value),
      child: this,
    );
  }

  
  Widget symmetricMargin({
    double vertical = 0,
    double horizontal = 0,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }

  //spesifik margin
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


  Widget marginTop(double value) => onlyMargin(top: value);
  Widget marginBottom(double value) => onlyMargin(bottom: value);
  Widget marginLeft(double value) => onlyMargin(left: value);
  Widget marginRight(double value) => onlyMargin(right: value);
  Widget marginHorizontal(double value) => symmetricMargin(horizontal: value);
  Widget marginVertical(double value) => symmetricMargin(vertical: value);
}

// Border radius için
extension BorderRadiusExtension on Widget {
  Widget borderRadius(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

 
  Widget customBorderRadius(BorderRadius borderRadius) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: this,
    );
  }


  Widget rounded4() => borderRadius(4);
  Widget rounded8() => borderRadius(8);
  Widget rounded12() => borderRadius(12);
  Widget rounded16() => borderRadius(16);
  Widget roundedCircle() => ClipOval(child: this);
}

/// Genel utility extensions 
extension WidgetUtilExtension on Widget {
  
  Widget center() => Center(child: this);


  Widget expand([int flex = 1]) => Expanded(flex: flex, child: this);


  Widget flexible([int flex = 1]) => Flexible(flex: flex, child: this);


  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }


  Widget inkWell(VoidCallback onTap, {BorderRadius? borderRadius}) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: this,
    );
  }


  Widget visible(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: this,
    );
  }


  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }  
}
/// Decoration extension 
extension DecorationExtension on Widget {

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
 // box shadow 
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
