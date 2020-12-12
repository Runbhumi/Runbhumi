import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';

class Faq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: buildTitle(context, "FAQ"),
      ),
      body: ListView(
        children: [
          Card(
            child: ExpansionTile(
              title: Text(
                  " some very very very very very very very very big question?"),
              children: [
                ListTile(
                  title: Text(
                      " some very very very very very very very very big answer"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
