import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/widgets/boxes/empty.dart';
import 'package:mtgtracker/widgets/boxes/player.dart';
import 'package:provider/provider.dart';

import '../models/layout.dart';

import '../providers/player.dart';

class Grid extends StatelessWidget {
  final List<Player> players;
  final Player? selectedPlayer;
  final Function onToggleCommanderView;
  final int diceRollWinner;

  const Grid({
    Key? key,
    required this.players,
    required this.selectedPlayer,
    required this.onToggleCommanderView,
    required this.diceRollWinner,
  }) : super(key: key);

  List<List<Layout>> generateLayout(BuildContext context, int playersNumber) {
    SettingNotifier setting =
        Provider.of<SettingNotifier>(context, listen: false);

    List<List<Layout>> rows = [];

    switch (playersNumber) {
      case 2:
        if (setting.tableLayout == 2) {
          rows.add([
            Layout(player: players[0], direction: LayoutDirection.top),
          ]);
          rows.add([
            Layout(player: players[1], direction: LayoutDirection.bottom),
          ]);
        } else {
          rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);
        }

        break;
      case 3:
        if (setting.tableLayout == 2) {
          rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          rows.add([
            Layout(player: players[2], direction: LayoutDirection.bottom),
          ]);
        } else {
          rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          rows.add([
            Layout(player: players[2], direction: LayoutDirection.left),
            Layout(player: players[3], direction: null),
          ]);
        }

        break;
      case 4:
        if (setting.tableLayout == 2) {
          rows.add([
            Layout(player: players[0], direction: LayoutDirection.top),
          ]);

          rows.add([
            Layout(player: players[1], direction: LayoutDirection.left),
            Layout(player: players[2], direction: LayoutDirection.right),
          ]);

          rows.add([
            Layout(player: players[3], direction: LayoutDirection.bottom),
          ]);
        } else {
          rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          rows.add([
            Layout(player: players[2], direction: LayoutDirection.left),
            Layout(player: players[3], direction: LayoutDirection.right),
          ]);
        }

        break;
      case 5:
        rows.add([
          Layout(player: players[0], direction: LayoutDirection.left),
          Layout(player: players[1], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[2], direction: LayoutDirection.left),
          Layout(player: players[3], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[4], direction: LayoutDirection.bottom),
        ]);
        break;
      case 6:
        rows.add([
          Layout(player: players[0], direction: LayoutDirection.top),
        ]);

        rows.add([
          Layout(player: players[1], direction: LayoutDirection.left),
          Layout(player: players[2], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[3], direction: LayoutDirection.left),
          Layout(player: players[4], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[5], direction: LayoutDirection.bottom),
        ]);
        break;
      case 7:
        rows.add([
          Layout(player: players[0], direction: LayoutDirection.left),
          Layout(player: players[1], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[2], direction: LayoutDirection.left),
          Layout(player: players[3], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[4], direction: LayoutDirection.left),
          Layout(player: players[5], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[6], direction: LayoutDirection.bottom),
        ]);
        break;
      case 8:
        rows.add([
          Layout(player: players[0], direction: LayoutDirection.top),
        ]);

        rows.add([
          Layout(player: players[1], direction: LayoutDirection.left),
          Layout(player: players[2], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[3], direction: LayoutDirection.left),
          Layout(player: players[4], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[5], direction: LayoutDirection.left),
          Layout(player: players[6], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[7], direction: LayoutDirection.bottom),
        ]);
        break;
      default:
        rows.add([
          Layout(player: players[1], direction: LayoutDirection.bottom),
        ]);
    }

    return rows;
  }

  List<Widget> generateWidgets(BuildContext context, int playersNumber) {
    print("Grid.generateWidgets(" + playersNumber.toString() + ")");
    List<List<Layout>> rows = generateLayout(context, playersNumber);

    Layout? selectedPlayerLayout;
    if (selectedPlayer != null) {
      for (var row in rows) {
        for (var layout in row) {
          if (layout.direction != null &&
              layout.player!.id == selectedPlayer?.id) {
            selectedPlayerLayout = layout;
          }
        }
      }
    }

    SettingNotifier setting =
        Provider.of<SettingNotifier>(context, listen: false);

    List<Widget> children = [];
    for (var row in rows) {
      List<Widget> rowChildren = [];
      for (var layout in row) {
        //@TODO: Reset
        //layout.player!.reset(setting.startingLives);
        rowChildren.add(
          ChangeNotifierProvider.value(
            value: layout.player,
            key: ValueKey(layout.player!.id),
            child: layout.direction == null
                ? const EmptyBox()
                : PlayerBox(
                    diceRollWinner:
                        diceRollWinner.toString() == layout.player!.id
                            ? true
                            : false,
                    view: selectedPlayer == null
                        ? PlayerBoxView.normal
                        : PlayerBoxView.commander,
                    rotation: selectedPlayer == null
                        ? layout.getRotation()
                        : selectedPlayer != layout.player
                            ? selectedPlayerLayout!.getRotation()
                            : layout.getRotation(),
                    selectedPlayer: selectedPlayer,
                    onToggleCommanderView: onToggleCommanderView,
                  ),
          ),
        );
      }

      children.add(
        Expanded(
          flex: row.length,
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
    print("Grid.build()");
    return Consumer<SettingNotifier>(
      builder: (context, setting, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: generateWidgets(context, setting.playersNumber),
        );
      },
    );
  }
}
