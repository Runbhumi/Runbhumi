import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Cards extends StatefulWidget {
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51I6CMmJPWaNkr0Lah9HJZdLfmjUdAxryodw7Li7aDecc2fQM5sGK98mKU7WvCoMldjttpaubdIfPwWHTsJeFzwdJ00gBS2QcL8",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: CustomBackButton(),
        title: buildTitle(context, "Add Post"),
      ),
      body: Center(
        child: Button(
          myText: 'Add Card',
          myColor: null,
          onPressed: () {},
        ),
      ),
    );
  }
}
