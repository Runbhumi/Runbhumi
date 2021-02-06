// import 'package:Runbhumi/services/paymentServices.dart';
// import 'package:Runbhumi/utils/validations.dart';
// import 'package:Runbhumi/widget/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

// class Cards extends StatefulWidget {
//   @override
//   _CardsState createState() => _CardsState();
// }

// class _CardsState extends State<Cards> {
//   String text = 'Click the button to start the payment';
//   double totalCost = 10.0;
//   double tip = 1.0;
//   double tax = 0.0;
//   double taxPercent = 0.2;
//   int amount = 0;
//   bool loader = false;
//   String url =
//       'https://meet.google.com/linkredirect?authuser=0&dest=https%3A%2F%2Fus-central1-runbhumi-574fe.cloudfunctions.net%2FStripePI';
//   @override
//   void initState() {
//     super.initState();
//     //Initializing the Stripe payments
//     StripePayment.setOptions(StripeOptions(
//         publishableKey:
//             "pk_test_51I6CMmJPWaNkr0Lah9HJZdLfmjUdAxryodw7Li7aDecc2fQM5sGK98mKU7WvCoMldjttpaubdIfPwWHTsJeFzwdJ00gBS2QcL8",
//         //Giving In the publishable key from client side communicate
//         merchantId: "Test",
//         //Should get from apple Id when in IOS
//         //androidPayMode should be changed during production
//         androidPayMode: 'test'));
//   }

//   void checkIfNativePayIsReady() async {
//     //TODO: To discuss if we need the native payments
//     print('started to check if native pay ready');
//     //bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
//     //to check not native payments
//     bool deviceSupportNativePay = false;
//     //Checking if the payments are of the given type: We are just working with VISA and master_card and american express for now
//     bool isNativeReady = await StripePayment.canMakeNativePayPayments(
//         ['american_express', 'visa', 'master_card']);
//     deviceSupportNativePay && isNativeReady
//         ? createPaymentMethodNative()
//         : createPaymentMethod();
//   }

//   Future<void> createPaymentMethodNative() async {
//     print('Starting NATIVE payments');
//     //Initializing Stripe account of the user to null to avoid discrepancies
//     StripePayment.setStripeAccount(null);
//     //List<ApplePayItem> required for IOS
//     List<ApplePayItem> items = [];
//     items.add(ApplePayItem(
//       label: 'Demo Tokens',
//       amount: totalCost.toString(),
//     ));
//     items.add(ApplePayItem(
//       label: 'Runbhumi',
//       amount: (totalCost + tip + tax).toString(),
//     ));
//     amount = ((totalCost + tip + tax) * 100).toInt();
//     print('amount in pence/cent which will be charged = $amount');

//     //Initializing the paymnet method
//     PaymentMethod paymentMethod = PaymentMethod();
//     //Getting the token from Stripe payments with Native pay
//     //The Token contains the
//     Token token = await StripePayment.paymentRequestWithNativePay(
//       androidPayOptions: AndroidPayPaymentRequest(
//         totalPrice: (totalCost + tax + tip).toStringAsFixed(2),
//         currencyCode: 'INR',
//       ),
//       applePayOptions: ApplePayPaymentOptions(
//         countryCode: 'IN',
//         currencyCode: 'INR',
//         items: items,
//       ),
//     ).then((token) {
//       //Add the token to the database if required'
//     });

//     paymentMethod = await StripePayment.createPaymentMethod(
//       PaymentMethodRequest(
//         card: CreditCard(
//           token: token.tokenId,
//         ),
//       ),
//     );
//     //To check if the payment method is still null, if not the charge is excuted.
//     paymentMethod != null
//         ? processPaymentAsDirectCharge(paymentMethod)
//         : showDialog(
//             context: context,
//             builder: (BuildContext context) => ShowDialogToDismiss(
//                 title: 'Error',
//                 content:
//                     'It is not possible to pay with this card. Please try again with a different card',
//                 buttonText: 'CLOSE'));
//   }

//   Future<void> createPaymentMethod() async {
//     StripePayment.setStripeAccount(null);
//     tax = ((totalCost * taxPercent) * 100).ceil() / 100;
//     amount = ((totalCost + tip + tax) * 100).toInt();
//     print('amount in pence/cent which will be charged = $amount');
//     //step 1: add card
//     PaymentMethod paymentMethod = PaymentMethod();
//     paymentMethod = await StripePayment.paymentRequestWithCardForm(
//       CardFormPaymentRequest(),
//     ).then((PaymentMethod paymentMethod) {
//       //Add the token to the database if required
//       return paymentMethod;
//     }).catchError((e) {
//       print('Error Card: ${e.toString()}');
//     });
//     paymentMethod != null
//         ? processPaymentAsDirectCharge(paymentMethod)
//         : showDialog(
//             context: context,
//             builder: (BuildContext context) => ShowDialogToDismiss(
//                 title: 'Error',
//                 content:
//                     'It is not possible to pay with this card. Please try again with a different card.',
//                 buttonText: 'CLOSE'));
//   }

//   Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {
//     setState(() {
//       loader = true;
//     });
//     //requesting to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
//     //Call to the server to get back the payment Intent
//     final http.Response response = await http
//         .post('$url?amount=$amount&currency=INR&paym=${paymentMethod.id}');
//     print('Now i decode');
//     if (response.body != null && response.body != 'error') {
//       final paymentIntentDecoded = jsonDecode(response.body);
//       final status = paymentIntentDecoded['paymentIntent']['status'];
//       final stripeAccount = paymentIntentDecoded['stripeAccount'];
//       //check if payment was succesfully confirmed
//       if (status == 'succeeded') {
//         //payment was confirmed by the server without need for futher authentification
//         StripePayment.completeNativePayRequest();
//         //TODO: Code after the payment succesful
//         setState(() {
//           text =
//               'Payment completed. ${paymentIntentDecoded['paymentIntent']['amount'].toString()}p succesfully charged';
//           loader = false;
//         });
//       } else {
//         //When there is a need to authenticate, 3D (Usually needed in indian banking system)
//         StripePayment.setStripeAccount(stripeAccount);
//         await StripePayment.confirmPaymentIntent(PaymentIntent(
//                 paymentMethodId: paymentIntentDecoded['paymentIntent']
//                     ['payment_method'],
//                 clientSecret: paymentIntentDecoded['paymentIntent']
//                     ['client_secret']))
//             .then(
//           (PaymentIntentResult paymentIntentResult) async {
//             //This code will be executed if the authentication is successful
//             //step 5: request the server to confirm the payment with
//             final statusFinal = paymentIntentResult.status;
//             if (statusFinal == 'succeeded') {
//               StripePayment.completeNativePayRequest();
//               //TODO: Code after the payment succesful
//               setState(() {
//                 loader = false;
//               });
//             } else if (statusFinal == 'processing') {
//               StripePayment.cancelNativePayRequest();
//               setState(() {
//                 loader = false;
//               });
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) => ShowDialogToDismiss(
//                       title: 'Warning',
//                       content:
//                           'The payment is still in \'processing\' state. This is unusual. Please contact us',
//                       buttonText: 'CLOSE'));
//             } else {
//               StripePayment.cancelNativePayRequest();
//               setState(() {
//                 loader = false;
//               });
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) => ShowDialogToDismiss(
//                       title: 'Error',
//                       content:
//                           'There was an error to confirm the payment. Details: $statusFinal',
//                       buttonText: 'CLOSE'));
//             }
//           },
//           //If Authentication fails, a PlatformException will be raised which can be handled here
//         ).catchError((e) {
//           print(e);
//           //case B1
//           StripePayment.cancelNativePayRequest();
//           setState(() {
//             loader = false;
//           });
//           showDialog(
//               context: context,
//               builder: (BuildContext context) => ShowDialogToDismiss(
//                   title: 'Error',
//                   content:
//                       'There was an error to confirm the payment. Please try again with another card',
//                   buttonText: 'CLOSE'));
//         });
//       }
//     } else {
//       //case A
//       //If the server does not connect to the stripe account
//       StripePayment.cancelNativePayRequest();
//       setState(() {
//         loader = false;
//       });
//       showDialog(
//           context: context,
//           builder: (BuildContext context) => ShowDialogToDismiss(
//               title: 'Error',
//               content:
//                   'There was an error in creating the payment. Please try again with another card.',
//               buttonText: 'CLOSE'));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: CustomBackButton(),
//         title: buildTitle(context, "Add Post"),
//       ),
//       body: loader
//           ? Loader()
//           : Column(
//               children: [
//                 Center(
//                   child: Text(
//                       "We need a drop down for the number of tokens the user wants"),
//                 ),
//                 Center(
//                   child: Button(
//                     myText: 'add card',
//                     myColor: null,
//                     onPressed: () async {},
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class ShowDialogToDismiss extends StatelessWidget {
//   final String content;
//   final String title;
//   final String buttonText;
//   ShowDialogToDismiss({this.title, this.buttonText, this.content});
//   @override
//   Widget build(BuildContext context) {
//     if (!Platform.isIOS) {
//       return AlertDialog(
//         title: new Text(
//           title,
//         ),
//         content: new Text(
//           this.content,
//         ),
//         actions: <Widget>[
//           new FlatButton(
//             child: new Text(
//               buttonText,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     } else {
//       return CupertinoAlertDialog(
//           title: Text(
//             title,
//           ),
//           content: new Text(
//             this.content,
//           ),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: new Text(
//                 buttonText[0].toUpperCase() +
//                     buttonText.substring(1).toLowerCase(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             )
//           ]);
//     }
//   }
// }
