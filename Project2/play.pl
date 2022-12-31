difficulty(1, 'Easy').
difficulty(2, 'Normal').

play :-
  clear,
  main_menu,
  write('end').

start_game(Number, TypePlayer1, TypePlayer2, Difficulty):-
  clear, 
  board(Number, Size),
  initial_state(Size, GameState),
  display_board(GameState),
  mid_game(GameState, 1, TypePlayer1, TypePlayer2).

mid_game(GameState, TurnCounter, P1, P2):- 
  alternatePlayer(TurnCounter, P1, P2, NextPlayer, TurnCounter1),
  next_move(GameState, NextPlayer, NewGameState, TurnCounter1),
  write(TurnCounter1),
  mid_game(NewGameState, TurnCounter1, P1, P2).

alternatePlayer(1, _, P2, P2, 2).
alternatePlayer(2, P1, _, P1, 1).

next_move(GameState, Type, NewGameState, TC) :-
  move(GameState, Type, NewGameState, TC).

move(GameState,'Human', NewGameState, TC) :-
  size_of_board(GameState, Size),
  read_inputs(Size, Column, Row),
  check_position(Column, Row, GameState), 
  replace(GameState, Row, Column, TC, NewGameState).

move(GameState, Type, NewGameState, TC) :-
  write('errooo'),
  move(GameState, Type, NewGameState, TC).

% game_over(+GameState)
game_over(GameState):-
  valid_positions(GameState, ListOfMoves),
  length(Options, 0).