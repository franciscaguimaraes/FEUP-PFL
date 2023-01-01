difficulty(1, 'Easy').
difficulty(2, 'Normal').

get_play_mode('Human', 'Human', 1).
get_play_mode('Human', 'Computer', 2).
get_play_mode('Computer', 'Human', 3).
get_play_mode('Computer', 'Computer', 4).

play_mode(1, GameState, _) :- play_pp(GameState, 1). %Player vs Player
play_mode(2, GameState, Difficulty) :- play_pc(GameState, Difficulty). %Player vs Computer
play_mode(3, GameState, Difficulty) :- play_cp(GameState, Difficulty). %Computer vs Player 
play_mode(4, GameState, Difficulty) :- play_cc(GameState, Difficulty). %Computer vs Computer

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
  format( '*~t Player ~d Lost!~t*~57|~n', [Player]),
  alternatePlayer(Player, NewPlayer),
  format( '*~t Player ~d Won!~t*~57|~n', [NewPlayer]),
  sleep(5).

play_pp(GameState, Player):-
  choose_move_human(GameState, Row, Col, Player),
  replace(GameState, Row, Col, Player, NewGameState),
  alternatePlayer(Player, NewPlayer),
  play_pp(NewGameState, NewPlayer).

alternatePlayer(1, 2).
alternatePlayer(2, 1).

choose_move_human(GameState, Row, Col, Player) :- 
  read_inputs(Row, Col),
  check_move(GameState, Row, Col, Player).

% check_move(+ListOfMoves,+Row,+Col)
% verifica se um movimento está presenta na Lista de movimentos dada
check_move(GameState, Row, Col, _) :-
  check_position(GameState, Row, Col).
check_move(GameState, _, _, Player):-
  write('Invalid position. Choose again!'), nl,
  play_pp(GameState, Player).

% game_over(+GameState)
game_over(GameState):-
  valid_moves(GameState, ListOfMoves),
  length(ListOfMoves, 0).
