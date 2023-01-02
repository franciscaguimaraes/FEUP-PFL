difficulty(1, 'Easy').
difficulty(2, 'Normal').

get_play_mode('Human', 'Human', 1).
get_play_mode('Human', 'Computer', 2).
get_play_mode('Computer', 'Human', 3).
get_play_mode('Computer', 'Computer', 4).

play_mode(1, GameState, _) :- play_pp(GameState, 1). %Player vs Player
play_mode(2, GameState, Difficulty) :- play_pc(GameState, 1, Difficulty). %Player vs Computer
play_mode(3, GameState, Difficulty) :- play_cp(GameState, 1, Difficulty). %Computer vs Player 
play_mode(4, GameState, Difficulty) :- play_cc(GameState, 1, Difficulty). %Computer vs Computer

% alternatePlayer(+Player, -OtherPlayer)
alternatePlayer(1, 2).
alternatePlayer(2, 1).

is_human_pc(1).
is_human_cp(2).

play :-
  clear,
  main_menu, !.

start_game(Number, TypePlayer1, TypePlayer2, Difficulty):-
  clear, 
  board(Number, Size),
  initial_state(Size, GameState),
  display_board(GameState),
  get_play_mode(TypePlayer1, TypePlayer2, Mode),
  play_mode(Mode, GameState, Difficulty).

% play_pp(+GameState, +Player)
play_pp(GameState, Player) :-
  game_over(GameState), nl,
  format( '| Player ~d - ' , [Player]), write_player(Player), write( ' - Lost!'), nl,
  alternatePlayer(Player, NewPlayer),
  format( '| Player ~d - ' , [NewPlayer]), write_player(NewPlayer), write( ' - Won!'), nl,
  sleep(5),
  main_menu.

play_pp(GameState, Player):-
  choose_move_human(GameState, Player, Row, Col),
  replace(GameState, Row, Col, Player, NewGameState),
  display_board(NewGameState),
  alternatePlayer(Player, NewPlayer),
  play_pp(NewGameState, NewPlayer).

% choose_move_human(+GameState, +Player, -Row, -Col)
choose_move_human(GameState, Player, Row, Col) :- 
  size_of_board(GameState, Size),
  format( '~n| Player ~d - ' , [Player]), write_player(Player), write( ' - make a move! \n\n'),
  read_inputs(Size, Row, Col), 
  check_move(GameState, Player, Row, Col).

% check_move(+ListOfMoves,+Row,+Col)
% verifica se um movimento está presenta na Lista de movimentos dada
check_move(GameState, _, Row, Col) :-
  check_position(GameState, Row, Col).
check_move(GameState, Player, _, _):-
  write('\n| Invalid position. Choose again!\n'),
  play_pp(GameState, Player).

% ------------------------------------

play_pc(GameState, 1, _) :-
  game_over(GameState), nl,
  write( '| Player - '), write_player(1), write( ' - Lost!'), nl,
  write( '| Computer - '), write_player(2), write( ' - Won!'), nl,
  sleep(5),!,
  main_menu.

play_pc(GameState, 2, _) :-
  game_over(GameState), nl,
  write( '| Computer - '), write_player(2), write( ' - Lost!'), nl,
  write( '| Player - '), write_player(1), write( ' - Won!'), nl,
  sleep(5), !,
  main_menu.

play_pc(GameState, Player, Difficulty) :-  
  is_human_pc(Player),
  choose_move_human(GameState, Player, Row, Col),
  replace(GameState, Row, Col, Player, NewGameState),
  display_board(NewGameState),
  alternatePlayer(Player, NewPlayer),
  play_pc(NewGameState, NewPlayer, Difficulty).

play_pc(GameState, Player , Difficulty) :-  
  choose_move_computer(GameState, Difficulty, Player, Row, Col),
  letter_number(Column, Col),
  sleep(1),
  replace(GameState, Row, Col, Player, NewGameState), nl,
  display_board(NewGameState),
  format('| Computer placed a piece in Row:~d Column:~a! ~n~n', [Row, Column]),
  alternatePlayer(Player, NewPlayer),
  play_pc(NewGameState, NewPlayer, Difficulty).

% ---------------------------------------------------

play_cp(GameState, 2, _) :-
  game_over(GameState), nl,
  write( '| Player - '), write_player(1), write( ' - Lost!'), nl,
  write( '| Computer - '), write_player(2), write( ' - Won!'), nl,
  sleep(5),!,
  main_menu.

play_cp(GameState, 1, _) :-
  game_over(GameState), nl,
  write( '| Computer - '), write_player(2), write( ' - Lost!'), nl,
  write( '| Player - '), write_player(1), write( ' - Won!'), nl,
  sleep(5), !,
  main_menu.

play_cp(GameState, Player, Difficulty) :-  
  is_human_cp(Player),
  choose_move_human(GameState, Player, Row, Col),
  replace(GameState, Row, Col, Player, NewGameState),
  display_board(NewGameState),
  alternatePlayer(Player, NewPlayer),
  play_cp(NewGameState, NewPlayer, Difficulty).

play_cp(GameState, Player , Difficulty) :-  
  choose_move_computer(GameState, Difficulty, Player, Row, Col),
  letter_number(Column, Col),
  sleep(1),
  replace(GameState, Row, Col, Player, NewGameState), nl,
  display_board(NewGameState),
  format('| Computer placed a piece in Row:~d Column:~a! ~n~n', [Row, Column]),
  alternatePlayer(Player, NewPlayer),
  play_cp(NewGameState, NewPlayer, Difficulty).

% --------------------

play_cc(GameState, Player, _) :-
  game_over(GameState), nl,
  format( '| Computer ~d - ' , [Player]), write_player(Player), write( ' - Lost!'), nl,
  alternatePlayer(Player, NewPlayer),
  format( '| Computer ~d - ' , [NewPlayer]), write_player(NewPlayer), write( ' - Won!'), nl,
  sleep(5),
  main_menu. 

play_cc(GameState, Player, Difficulty) :-  
  choose_move_computer(GameState, Difficulty, Player, Row, Col),
  letter_number(Column, Col),
  sleep(2),
  replace(GameState, Row, Col, Player, NewGameState),
  display_board(NewGameState),
  format('~n| Computer ~d - ', [Player]), write_player(Player), format(' - placed a piece in Row:~d Column:~a! ~n~n', [Row, Column]),
  alternatePlayer(Player, NewPlayer),
  play_cc(NewGameState, NewPlayer, Difficulty).

% game_over(+GameState)
game_over(GameState):-
  valid_moves(GameState, ListOfMoves),
  length(ListOfMoves, 0).
