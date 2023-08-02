import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/list_of_player_events.dart';
import '../states/PlayerListState.dart';
import '../states/player_model.dart';

class ListOfPlayerBloc extends Bloc<addPlayer, PlayerListState> {
  ListOfPlayerBloc() : super(PlayerListState()) {
    on<addPlayer>(_addPlayer);
  }

  void _addPlayer(addPlayer event, emit) {
    emit(state.copyWith(listOfPlayerState: event.listOfPlayer));
  }
}
