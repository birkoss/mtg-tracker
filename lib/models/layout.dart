import '../providers/player.dart';

enum LayoutDirection {
  top,
  left,
  right,
  bottom,
}

class Layout {
  final Player? player;
  final LayoutDirection? direction;

  Layout({
    required this.player,
    required this.direction,
  });

  int getRotation() {
    switch (direction!) {
      case LayoutDirection.top:
        return 2;
      case LayoutDirection.left:
        return 1;
      case LayoutDirection.right:
        return 3;
      case LayoutDirection.bottom:
        return 0;
    }
  }
}
