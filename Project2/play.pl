% given type of players, gives mode to start playing
get_play_mode('Human', 'Human', 1).
get_play_mode('Human', 'Computer', 2).
get_play_mode('Computer', 'Human', 3).
get_play_mode('Computer', 'Computer', 4).


% given play mode, starts game accordingly
play_mode(1, GameState, _) :- play_pp(GameState, 1). %Player vs Player
play_mode(2, GameState, Difficulty) :- play_pc(GameState, 1, Difficulty). %Player vs Computer
play_mode(3, GameState, Difficulty) :- play_cp(GameState, 1, Difficulty). %Computer vs Player 
play_mode(4, GameState, Difficulty) :- play_cc(GameState, 1, Difficulty). %Computer vs Computer


% alternates players between games
alternatePlayer(1, 2).
alternatePlayer(2, 1).


% checks if, given play mode, player is human
is_human_pc(1). % PlayervsComputer - player 1st
is_human_cp(2). % ComputervsPlayer - player 2nd


% start_game(+Number, +TypePlayer1, +TypePlayer2, +Difficulty)
% starts game given boardSize, play mode and difficulty 
start_game(Number, TypePlayer1, TypePlayer2, Difficulty):-
  clear, 
  initial_state(Number, GameState),
  display_board(GameState),
  get_play_mode(TypePlayer1, TypePlayer2, Mode),
  play_mode(Mode, GameState, Difficulty).


% play_pp(+GameState, +Player)
% starts Player vs Player game loop
play_pp(GameState, Player) :-
  game_over(GameState), nl,
  format( '| Player ~d - ' , [Player]), write_player(Player), write( ' - Lost!'), nl,
  alternatePlayer(Player, NewPlayer),
  format( '| Player ~d - ' , [NewPlayer]), write_player(NewPlayer), write( ' - Won!'), nl,
  sleep(5),
  main_menu.
play_pp(GameState, Player):-
  choose_move_human(GameState, Player, Row, Col, 'pp', 0),
  replace(GameState, Row, Col, Player, NewGameState),
  display_board(NewGameState),
  alternatePlayer(Player, NewPlayer),
  play_pp(NewGameState, NewPlayer).


% choose_move_human(+GameState, +Player, -Row, -Col)
% predicate that asks user for input 
choose_move_human(GameState, Player, Row, Col, Mode, Difficulty) :- 
  size_of_board(GameState, Size),
  format( '~n| Player ~d - ' , [Player]), write_player(Player), write( ' - make a move! \n\n'),
  read_inputs(Size, Row, Col), 
  check_move(GameState, Player, Row, Col, Mode, Difficulty).


% check_move(+GameState, +Player, +Row, +Col)
% verifies if row and col from user input is present in list of valid moves
check_move(GameState, _, Row, Col, _, _) :-
  check_position(GameState, Row, Col).
check_move(GameState, Player, _, _, 'pp', _):-
  write('\n| Invalid position. Choose again!\n'),
  play_pp(GameState, Player).
check_move(GameState, Player, _, _, 'pc', Difficulty):-
  write('\n| Invalid position. Choose again!\n'),
  play_pc(GameState, Player, Difficulty).
check_move(GameState, Player, _, _, 'cp', Difficulty):-
  write('\n| Invalid position. Choose again!\n'),
  play_cp(GameState, Player, Difficulty).


% play_pc(GameState, Player, Difficulty)
% starts Player vs Computer game loop
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
  choose_move_human(GameState, Player, Row, Col, 'pc', Difficulty),
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
  format('~n| Computer placed a piece in Row:~d Column:~a! ~n~n', [Row, Column]),
  alternatePlayer(Player, NewPlayer),
  play_pc(NewGameState, NewPlayer, Difficulty).


% play_cp(GameState, Player, Difficulty)
% starts Computer vs Player game loop
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
  choose_move_human(GameState, Player, Row, Col, 'cp', Difficulty),
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
  format('~n| Computer placed a piece in Row:~d Column:~a! ~n~n', [Row, Column]),
  alternatePlayer(Player, NewPlayer),
  play_cp(NewGameState, NewPlayer, Difficulty).


% play_cc(GameState, Player, Difficulty) 
% starts Computer vs Computer game loop
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
% checks if list of valid moves is null, meaning no more plays to make and game over
game_over(GameState):-
  valid_moves(GameState, ListOfMoves),
  length(ListOfMoves, 0).
