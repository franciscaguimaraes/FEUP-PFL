difficulty(1, 'Easy').
difficulty(2, 'Normal').

get_play_mode('Human', 'Human', 1).
get_play_mode('Human', 'Computer', 2).
get_play_mode('Computer', 'Human', 3).
get_play_mode('Computer', 'Computer', 4).

play_mode(1, GameState, _) :- play_pp(GameState). %Player vs Player
play_mode(2, GameState, Difficulty) :- play_pc(GameState, Difficulty). %Player vs Computer
play_mode(3, GameState, Difficulty) :- play_cp(GameState, Difficulty).. %Computer vs Player 
play_mode(4, GameState, Difficulty) :- play_cc(GameState, Difficulty).. %Computer vs Computer

play :-
  clear,
  main_menu.

start_game(Number, TypePlayer1, TypePlayer2, Difficulty):-
  clear, 
  board(Number, Size),
  initial_state(Size, GameState),
  display_board(GameState),
  get_play_mode(TypePlayer1, TypePlayer2, Mode),
  play_mode(Mode, GameState, Difficulty).

play_pp(GameState, Player) :-
  game_over(GameState),

play_pp(GameState):-
  choose_move_human(GameState, Row, Col),

alternatePlayer(1, _, P2, P2, 2).
alternatePlayer(2, P1, _, P1, 1).

playPvP(GameState) :-   

  move(GameState,Move,NewGameState),
  clear,
  display_game(NewGameState),
  playPvP(NewGameState).


move(GameState,'Human', NewGameState, TC) :-
  size_of_board(GameState, Size),
  read_inputs(Size, Row, Col),
  check_position(Row, Col, GameState),
  replace(GameState, Row, Col, TC, NewGameState).

% -----------------

choose_move_human(GameState, Row, Col) :- 
  valid_moves(GameState, ListOfMoves),
  read_inputs(Row, Col),
  check_move(ListOfMoves, Row, Col),

% check_move(+ListOfMoves,+Row,+Col,-Valid)
% verifica se um movimento está presenta na Lista de movimentos dada
check_move(ListOfMoves, Row, Col) :-
  append(_, [Row-Col | _], ListOfMoves).
check_move(_,_,_):-
  write('Invalid position. Choose again!'),
  choose_move_human(GameState, Row, Col).

% game_over(+GameState)
game_over(GameState):-
  valid_moves(GameState, ListOfMoves),
  length(ListOfMoves, 0).
