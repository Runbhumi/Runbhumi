import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String initialValue;
  final bool enabled;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode, nextFocusNode;
  final VoidCallback submitAction;
  final bool obscureText;
  final FormFieldValidator<String> validateFunction;
  final void Function(String) onSaved, onChange;
  final Widget sufIcon;
  final Widget icon;
  final String helpertext;
  final Key key;

  InputBox({
    this.initialValue,
    this.enabled,
    this.hintText,
    this.textInputType,
    this.controller,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.submitAction,
    this.obscureText = false,
    this.validateFunction,
    this.onSaved,
    this.onChange,
    this.sufIcon,
    this.icon,
    this.helpertext,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: TextFormField(
          obscureText: obscureText,
          enabled: enabled,
          onChanged: onChange,
          // validator: (val) {
          //   return val.length > 8 ? null : "Enter Password 8+ characters";
          // },
          validator: validateFunction,
          key: key,
          controller: controller,
          keyboardType: textInputType,
          onSaved: onSaved,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onFieldSubmitted: (String term) {
            if (nextFocusNode != null) {
              focusNode.unfocus();
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              submitAction();
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: border(),
            focusedBorder: focusedBorder(context),
            disabledBorder: border(),
            prefixIcon: icon,
            suffixIcon: sufIcon,
            helperText: helpertext,
            filled: true,
            fillColor: Color(0xffeeeeee),
            hintStyle: TextStyle(
              color: Color(0xff393E46),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder focusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: new BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: new BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Color(0xffB3ABAB),
        width: 1.0,
      ),
    );
  }
}
