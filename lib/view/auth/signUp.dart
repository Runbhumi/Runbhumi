import 'package:Runbhumi/utils/validations.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:flutter/material.dart';
import '../../widget/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();
  String email = '';
  String fullName = '';
  String password = '';

  checkAll() async {
    FormState form = formKey2.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      Constants.prefs.setBool("loggedin", true);
      print("going to " + "/home");
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey2.currentState.removeCurrentSnackBar();
    _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey2,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CreateAccHeading(),
            Form(
              key: formKey2,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  InputBox(
                    enabled: !loading,
                    hintText: "Full name",
                    icon: Icon(Icons.contacts_outlined),
                    validateFunction: Validations.validateNonEmpty,
                    textInputAction: TextInputAction.done,
                    onSaved: (String val) {
                      fullName = val;
                    },
                  ),
                  // InputBox(
                  //   hintText: "Username",
                  //   icon: Icon(Icons.account_circle_outlined),
                  // ),
                  InputBox(
                    enabled: !loading,
                    hintText: "E-mail",
                    icon: Icon(Icons.mail_outline),
                    textInputAction: TextInputAction.done,
                    validateFunction: Validations.validateEmail,
                    submitAction: checkAll,
                    textInputType: TextInputType.emailAddress,
                    onSaved: (String val) {
                      email = val;
                    },
                  ),
                  InputBox(
                    enabled: !loading,
                    hintText: "Password",
                    obscureText: true,
                    helpertext: "use at least 8 charecters",
                    sufIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      splashRadius: 1,
                      onPressed: () {},
                    ),
                    icon: Icon(Icons.lock_outline),
                    textInputAction: TextInputAction.done,
                    validateFunction: Validations.validatePassword,
                  ),
                ],
              ),
            ),
            Button(
              myText: "Sign Up For Runbhumi",
              myColor: Theme.of(context).accentColor,
              onPressed: () => checkAll(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                "By signing up for Runbhumi you agree to our terms and conditions and privacy policy",
                textAlign: TextAlign.center,
              ),
            ),
            DividingOr(),
            Button(
              myText: "Login",
              myColor: Theme.of(context).primaryColor,
              routeName: "/login",
            ),
            SizedBox(height: 20),
            GoogleOauth(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CreateAccHeading extends StatelessWidget {
  const CreateAccHeading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          "Create Account",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
