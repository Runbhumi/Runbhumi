import 'package:Runbhumi/utils/validations.dart';
import 'package:Runbhumi/view/auth/loginPage.dart';
import 'package:flutter/material.dart';
import '../../widget/widgets.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage('assets/forgotpassword.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 40.0),
                    child: Container(
                      child: Text(
                        "Tell us your E-mail ID, we will send you A mail with the instructions to reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formKey,
                    child: InputBox(
                      enabled: !loading,
                      hintText: "E-mail",
                      icon: Icon(Icons.mail_outline),
                      textInputAction: TextInputAction.done,
                      validateFunction: Validations.validateEmail,
                      submitAction: checkEmail,
                      onSaved: (String val) {
                        email = val;
                      },
                    ),
                  ),
                  buildButton(),
                  SizedBox(
                    height: 16.0,
                  )
                ],
              ),
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

class BackBtn extends StatelessWidget {
  const BackBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Icon(Icons.arrow_back, color: Colors.black)));
  }
}
