import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/layout.dart';
import 'package:mtgtracker/widgets/boxes/empty.dart';
import 'package:mtgtracker/widgets/boxes/player.dart';
import 'package:provider/provider.dart';

import '../models/layout.dart';

class Grid extends StatelessWidget {
  const Grid({
    Key? key,
  }) : super(key: key);

  List<Widget> generateWidgets(BuildContext context) {
    List<List<Layout>> rows = context.watch<LayoutNotifier>().rows;

    List<Widget> children = [];
    for (var row in rows) {
      List<Widget> rowChildren = [];
      for (var layout in row) {
        rowChildren.add(
          layout.player == null
              ? EmptyBox(
                  color: Theme.of(context).primaryColor,
                )
              : ChangeNotifierProvider.value(
                  value: layout.player,
                  key: ValueKey(layout.player!.keyId),
                  child: PlayerBox(
                    rotation: layout.getRotation(),
                  ),
                ),
        );
      }

      children.add(
        Expanded(
          flex: (row.length == 2 ? 6 : 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rowChildren,
          ),
        ),
      );
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: generateWidgets(context),
    );
  }
}
