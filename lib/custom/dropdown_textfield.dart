import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TextDropdown extends StatefulWidget {
  TextDropdown({required this.title, required this.list, required this.onChanged, this.hintText = '', this.dropDownHint = ''});
  String title, hintText, dropDownHint;
  List<DropDownValueModel> list = [];
  Function onChanged;

  @override
  State<TextDropdown> createState() => _TextDropdownState();
}

class _TextDropdownState extends State<TextDropdown> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.hintText =
    (widget.hintText.isEmpty) ? 'Enter ${widget.title}' : widget.hintText;

  }
  @override
  Widget build(BuildContext context) {

    widget.hintText =
    (widget.hintText.isEmpty) ? 'Enter ${widget.title}' : widget.hintText;

    return Row(
      children: [
        Expanded(
          child: DropDownTextField(
            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            dropDownList: widget.list,
            enableSearch: true,
            textFieldDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: (widget.dropDownHint == '') ? widget.list[0].name : widget.dropDownHint),
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
