
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomButton extends StatelessWidget {
  CustomButton({required this.text, required this.backgroundColor, required this.onPressed, this.isLoading = false, this.loadingWidget = null, this.fontSize= 16, this.height = 54});
  String text;
  Color backgroundColor;
  Function onPressed;
  bool isLoading;
  var loadingWidget;
  double fontSize;
  double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onPressed();
      },
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(16)),
        child: Center(child: isLoading ? loadingWidget : Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: fontSize),)),
      ),
    );
  }
}
