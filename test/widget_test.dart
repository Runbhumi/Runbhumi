// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:runbhumi/view/views.dart';
import 'package:runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }

void main() {
  MaterialApp inp = MaterialApp(
    home: Scaffold(
      body: InputBox(hintText: "inp"),
    ),
  );
  // MaterialApp gauthPageUI = MaterialApp(
  //   home: Scaffold(body: SafeArea(child: GauthPage())),
  // );
  MaterialApp googleOauthBigUI = MaterialApp(
    home: Scaffold(
      body: GoogleOauth(),
    ),
  );
  testWidgets('input box UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(inp);

    expect(find.byType(TextFormField), findsNWidgets(1));
  });
  // testWidgets('GauthPageUI test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(gauthPageUI);

  //   expect(find.byType(Column), findsNWidgets(1));
  // });
  testWidgets('GoogleOauthBig UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(googleOauthBigUI);

    expect(find.byType(Text), findsNWidgets(1));
  });
}
