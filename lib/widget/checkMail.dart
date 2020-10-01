import 'package:Runbhumi/utils/validations.dart';
import 'widgets.dart';
import 'package:flutter/material.dart';

class CheckEmail extends StatefulWidget {
  @override
  _CheckEmailState createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email = '';

  checkEmail() async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: formKey,
                  child: InputBox(
                    enabled: !loading,
                    hintText: "jhondoe@gmail.com",
                    textInputAction: TextInputAction.done,
                    validateFunction: Validations.validateEmail,
                    submitAction: checkEmail,
                    onSaved: (String val) {
                      email = val;
                    },
                  ),
                ),
                buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Button(
            myColor: Theme.of(context).primaryColor,
            myText: "Continue",
            onPressed: () => checkEmail(),
          );
  }
}
