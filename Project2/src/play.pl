% given type of players, gives mode to start playing
get_play_mode('Human', 'Human', 1).
get_play_mode('Human', 'Computer', 2).
get_play_mode('Computer', 'Human', 3).
get_play_mode('Computer', 'Computer', 4).

% play_mode(+Mode, +GameState, +Difficulty)
% given play mode, starts game accordingly
play_mode(1, GameState, _, _) :- play_pp(GameState, 1). %Player vs Player
play_mode(2, GameState, Difficulty, _) :- play_pc(GameState, 1, Difficulty). %Player vs Computer
play_mode(3, GameState, Difficulty, _) :- play_cp(GameState, 1, Difficulty). %Computer vs Player 
play_mode(4, GameState, Difficulty1, Difficulty2) :- play_cc(GameState, 1, Difficulty1, Difficulty2). %Computer vs Computer


% alternatePlayer(+Player, -NewPlayer)
% alternates players between games
alternatePlayer(1, 2).
alternatePlayer(2, 1).


% is_human_pc(+Player)
% checks if, given play mode pc, player is human
is_human_pc(1). % PlayervsComputer - player 1st


% is_human_cp(+Player)
% checks if, given play mode cp, player is human
is_human_cp(2). % ComputervsPlayer - player 2nd


% start_game(+Number, +TypePlayer1, +TypePlayer2, +Difficulty)
% starts game given boardSize, play mode and difficulty 
start_game(Number, 'Computer', 'Computer', Difficulty1, Difficulty2):-
  clear, 
  initial_state(Number, GameState),
  display_board(GameState), 
  get_play_mode('Computer', 'Computer', Mode),
  play_mode(Mode, GameState, Difficulty1, Difficulty2).
start_game(Number, TypePlayer1, TypePlayer2, Difficulty, _):-
  clear, 
  initial_state(Number, GameState),
  display_board(GameState),
  get_play_mode(TypePlayer1, TypePlayer2, Mode),
  play_mode(Mode, GameState, Difficulty, _).


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
  move_human(GameState, Player, 'pp', 0, NewGameState),
  display_board(NewGameState),
  alternatePlayer(Player, NewPlayer),
  play_pp(NewGameState, NewPlayer).


% choose_move_human(+GameState, +Player, -Row, -Col)
% predicate that asks user for input 
choose_move_human(GameState, Player, Row, Col) :- 
  size_of_board(GameState, Size),
  format( '~n| Player ~d - ' , [Player]), write_player(Player), write( ' - make a move! \n\n'),
  read_inputs(Size, Row, Col).

% move_human(+GameState, +Row, +Col, +Player, +Mode, +Difficulty, -NewGameState)
% predicate that validates chosen position and replaces piece returning NewGameState
move_human(GameState, Player, Mode, Difficulty, NewGameState) :-
  choose_move_human(GameState, Player, Row, Col),
  check_move(GameState, Player, Row, Col, Mode, Difficulty),
  replace(GameState, Row, Col, Player, NewGameState).


% move_cumputer(+GameState, +Player, +Difficulty, -NewGameState, -Row, -Col)
% choses move for computer and places it in new board
move_computer(GameState, Player, Difficulty, NewGameState, Row, Col) :- 
  choose_move_computer(GameState, Difficulty, Player, Row, Col),
  replace(GameState, Row, Col, Player, NewGameState).


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
  move_human(GameState, Player, 'pc', 0, NewGameState),
  display_board(NewGameState),
  alternatePlayer(Player, NewPlayer),
  play_pc(NewGameState, NewPlayer, Difficulty).
play_pc(GameState, Player , Difficulty) :-  
  move_computer(GameState, Player, Difficulty, NewGameState, Row, Col),
  letter_number(R, Row),
  sleep(1),
  display_board(NewGameState),
  format('~n| Computer placed a piece in Row:~a Column:~d! ~n~n', [R, Col]),
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
  move_human(GameState, Player, 'cp', Difficulty, NewGameState),
  display_board(NewGameState),
  alternatePlayer(Player, NewPlayer),
  play_cp(NewGameState, NewPlayer, Difficulty).
play_cp(GameState, Player , Difficulty) :-  
  move_computer(GameState, Player, Difficulty, NewGameState, Row, Col),
  letter_number(R, Row),
  sleep(1),
  display_board(NewGameState),
  format('~n| Computer placed a piece in Row:~a Column:~d! ~n~n', [R, Col]),
  alternatePlayer(Player, NewPlayer),
  play_cp(NewGameState, NewPlayer, Difficulty).


% play_cc(GameState, Player, Difficulty) 
% starts Computer vs Computer game loop
play_cc(GameState, Player, _, _) :-
  game_over(GameState), nl,
  format( '| Computer ~d - ' , [Player]), write_player(Player), write( ' - Lost!'), nl,
  alternatePlayer(Player, NewPlayer),
  format( '| Computer ~d - ' , [NewPlayer]), write_player(NewPlayer), write( ' - Won!'), nl,
  sleep(5),
  main_menu. 
play_cc(GameState, Player, Difficulty1, Difficulty2) :-  
  move_computer(GameState, Player, Difficulty1, NewGameState, Row, Col),
  letter_number(R, Row),
  sleep(2),
  display_board(NewGameState),
  format('~n| Computer ~d - ', [Player]), write_player(Player), format(' - placed a piece in Row:~a Column:~d! ~n~n', [R, Col]),
  alternatePlayer(Player, NewPlayer),
  play_cc(NewGameState, NewPlayer, Difficulty2, Difficulty1).


% game_over(+GameState)
% checks if list of valid moves is null, meaning no more plays to make and game over
game_over(GameState):-
  valid_moves(GameState, ListOfMoves),
  length(ListOfMoves, 0).
