import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';

class OU2Selection extends StatelessWidget {
  final selectionTilesData = [
    SelectionTile("Home2", Icons.home, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque dignissim sed arcu ac gravida. Aenean placerat sem quis leo suscipit, quis placerat quam varius. Sed porta neque elit, sed aliquam elit pulvinar at. In consequat metus eu tellus ultricies pellentesque. Quisque ac risus ac erat faucibus tempus sed id metus."),
    SelectionTile("email2", Icons.email, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vulputate mattis nunc in elementum. Aliquam ante neque, sagittis non blandit dapibus, laoreet a tortor. Maecenas non rutrum risus, vel lacinia magna. Vivamus fringilla ut metus non dignissim. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer lobortis metus."),
    SelectionTile("Chat2", Icons.chat, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque gravida, mi et porta lobortis, tortor mi varius ex, eget sagittis nisi purus quis nisi. Maecenas in risus sed nunc finibus eleifend. Vivamus eu odio non lorem gravida finibus. Integer dictum purus ac hendrerit tempor. Vivamus ut fringilla augue. Maecenas iaculis."),
    SelectionTile("News2", Icons.new_releases,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus id sapien dapibus, facilisis ligula at, posuere leo. Duis a nibh risus. Curabitur scelerisque diam pulvinar dolor tincidunt vehicula. Suspendisse ut finibus mi. Suspendisse dapibus erat a ligula porta, nec ornare magna luctus. Ut ultricies tempus tempus. In sem ligula, consectetur."),
    SelectionTile("Net2", Icons.network_wifi,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tempor eleifend tellus, vel tincidunt quam congue eget. Etiam vitae nisi condimentum, lacinia sem quis, vehicula enim. Donec ullamcorper pellentesque ipsum, et elementum tellus blandit eget. Integer maximus commodo lectus, et hendrerit ipsum eleifend a. Proin rhoncus quam id blandit laoreet."),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          tileSelectionBuilder(context, selectionTilesData[index]),
      itemCount: selectionTilesData.length,
    );
  }
}