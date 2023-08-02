import 'package:teen_patti_utility/states/player_model.dart';

class PlayerListState {
  int? index = 0;
  List<PlayerState>? listOfPlayerState = [];

  PlayerListState({this.index, this.listOfPlayerState});

  PlayerListState copyWith({int? index, List<PlayerState>? listOfPlayerState}) {
    return PlayerListState(
        index: index ?? this.index,
        listOfPlayerState: listOfPlayerState ?? this.listOfPlayerState);
  }
}
