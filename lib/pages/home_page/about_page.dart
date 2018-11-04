import 'package:flutter/material.dart';
import 'package:simulop_v1/pages/helper_classes/options_input_helper.dart';

var list2 = [
  Options(name: "000", pos: 0),
  Options(name: "111", pos: 1),
  Options(name: "222", pos: 2),
];

final lisTes = [
  DropdownMenuItem(
    value: LiqTes(Liq.op1, "name1"),
    child: Text("name1"),
  ),
  DropdownMenuItem(
    value: LiqTes(Liq.op2, "name2"),
    child: Text("name2"),
  ),
  DropdownMenuItem(
    value: LiqTes(Liq.op3, "name3"),
    child: Text("name3"),
  ),
];

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() {
    return new AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  List<DropdownMenuItem<dynamic>> listDrp(BuildContext context) {
    final water = LiquidHelper(liquid: LiquidOptions.water, context: context);
    final benzene =
        LiquidHelper(liquid: LiquidOptions.benzene, context: context);
    final toluene =
        LiquidHelper(liquid: LiquidOptions.toluene, context: context);
    return [
      DropdownMenuItem(
        value: water,
        child: Text(water.name),
      ),
      DropdownMenuItem(
        value: benzene,
        child: Text(benzene.name),
      ),
      DropdownMenuItem(
        value: toluene,
        child: Text(toluene.name),
      ),
    ];
  }

  List<DropdownMenuItem<dynamic>> inputDropDownItems2(BuildContext context) {
    return list2.map((Options lis) {
      return DropdownMenuItem(
        value: lis,
        child: Text(
          lis.name,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<dynamic>> inputDropDownItems(BuildContext context) {
    return LiquidHelper.liquidsPumpingOfLiquids.map((LiquidOptions lis) {
      //final liq = LiquidHelper(liquid: lis, context: context);
      return DropdownMenuItem(
        value: LiquidHelper(liquid: lis, context: context),
        child: Text(
          LiquidHelper.getLocalizedName(lis, context),
        ),
      );
    }).toList();
  }

  Options op;
  LiquidHelper lh;
  LiqTes lt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButton(
            hint: Text("help!"),
            value: lt,
            items: lisTes,
            onChanged: (dynamic value) {
              print(value.name);
              setState(() {
                lt = value;
              });
            }),
      ),
    );
  }
}

class Options {
  String name;
  int pos;

  Options({this.name, this.pos});
}

enum Liq {
  op1,
  op2,
  op3,
}

class LiqTes {
  final String name;
  final Liq liq;

  LiqTes(this.liq, this.name);
}
