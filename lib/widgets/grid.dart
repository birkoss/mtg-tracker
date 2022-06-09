import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/widgets/boxes/player.dart';
import 'package:provider/provider.dart';

import '../models/layout.dart';

import '../providers/player.dart';

class Grid extends StatelessWidget {
  final List<Player> players;
  final Player? selectedPlayer;
  final Function onToggleCommanderView;

  const Grid({
    Key? key,
    required this.players,
    required this.selectedPlayer,
    required this.onToggleCommanderView,
  }) : super(key: key);

  List<List<Layout>> generateLayout(int playersNumber) {
    List<List<Layout>> rows = [];

    switch (playersNumber) {
      case 2:
        rows.add([
          Layout(player: players[0], direction: LayoutDirection.left),
          Layout(player: players[1], direction: LayoutDirection.right),
        ]);
        break;
      case 3:
        rows.add([
          Layout(player: players[0], direction: LayoutDirection.left),
          Layout(player: players[1], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[2], direction: LayoutDirection.bottom),
        ]);
        break;
      case 4:
        // Old layout
        // -----------
        // rows.add([
        //   Layout(player: players[0], direction: LayoutDirection.top),
        // ]);

        // rows.add([
        //   Layout(player: players[1], direction: LayoutDirection.left),
        //   Layout(player: players[2], direction: LayoutDirection.right),
        // ]);

        // rows.add([
        //   Layout(player: players[3], direction: LayoutDirection.bottom),
        // ]);

        rows.add([
          Layout(player: players[0], direction: LayoutDirection.left),
          Layout(player: players[1], direction: LayoutDirection.right),
        ]);

        rows.add([
          Layout(player: players[2], direction: LayoutDirection.left),
          Layout(player: players[3], direction: LayoutDirection.right),
        ]);

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

  List<Widget> generateWidgets(int playersNumber) {
    print("NB Players: " + playersNumber.toString());
    List<List<Layout>> rows = generateLayout(playersNumber);

    PlayerBoxSize trackerSize = PlayerBoxSize.medium;
    if (players.length > 6) {
      trackerSize = PlayerBoxSize.small;
    } else if (players.length < 4) {
      trackerSize = PlayerBoxSize.large;
    }

    Layout? selectedPlayerLayout;
    if (selectedPlayer != null) {
      for (var row in rows) {
        for (var layout in row) {
          if (layout.player.id == selectedPlayer?.id) {
            selectedPlayerLayout = layout;
          }
        }
      }
    }

    List<Widget> children = [];
    for (var row in rows) {
      List<Widget> rowChildren = [];
      for (var layout in row) {
        print(layout.player.id);
        rowChildren.add(
          ChangeNotifierProvider.value(
            value: layout.player,
            key: ValueKey(layout.player.id),
            child: PlayerBox(
              view: selectedPlayer == null
                  ? PlayerBoxView.normal
                  : PlayerBoxView.commander,
              rotation: selectedPlayer == null
                  ? layout.getRotation()
                  : selectedPlayer != layout.player
                      ? selectedPlayerLayout!.getRotation()
                      : layout.getRotation(),
              selectedPlayer: selectedPlayer,
              size: trackerSize,
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
    return Consumer<SettingNotifier>(
      builder: (context, setting, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: generateWidgets(setting.playersNumber),
        );
      },
    );
  }
}
