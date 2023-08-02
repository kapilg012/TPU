import '../states/player_model.dart';

abstract class listOfPlayerEvent {}

class addPlayer extends listOfPlayerEvent {
  List<PlayerState> listOfPlayer;

  addPlayer(this.listOfPlayer);
}
