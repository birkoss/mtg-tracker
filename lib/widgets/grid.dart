import 'package:flutter/material.dart';
import 'package:mtgtracker/widgets/commander.dart';
import 'package:provider/provider.dart';

import '../models/layout.dart';

import '../providers/player.dart';

import '../widgets/tracker.dart';

class Grid extends StatelessWidget {
  final List<Player> players;
  final Player? selectedPlayer;
  final Function onPress;

  const Grid({
    Key? key,
    required this.players,
    required this.selectedPlayer,
    required this.onPress,
  }) : super(key: key);

  List<Widget> generate() {
    List<List<Layout>> rows = [];

    switch (players.length) {
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

    TrackerSize trackerSize = TrackerSize.medium;
    if (players.length > 6) {
      trackerSize = TrackerSize.small;
    } else if (players.length < 4) {
      trackerSize = TrackerSize.large;
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
            child: selectedPlayer == null
                ? Tracker(
                    rotation: layout.getRotation(),
                    size: trackerSize,
                    type: TrackerType.normal,
                    onPressOptions: onPress,
                  )
                : selectedPlayer != layout.player
                    ? TrackerCommander(
                        rotation: selectedPlayerLayout!.getRotation(),
                        size: trackerSize,
                        onPressOptions: onPress,
                        currentPlayer: int.parse(selectedPlayer!.id) - 1,
                      )
                    : Tracker(
                        rotation: layout.getRotation(),
                        size: trackerSize,
                        type: TrackerType.poison,
                        onPressOptions: onPress,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: generate(),
    );
  }
}
