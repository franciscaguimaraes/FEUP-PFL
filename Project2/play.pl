% difficulty(+Code, -Difficulty)
% Gives the Difficulty associated with the code provided as an option
difficulty(1, 'Easy').
difficulty(2, 'Normal').

% mode(+Code, -Mode)
% Gives the Mode associated with the code provided as an option
mode(1, 'PP').
mode(2, 'PC').
mode(3, 'CC').

% play/0
% main predicate for game start, presents the main menu
play :-
  clear,
  mainMenu.

% start_game(+GameState, +Player1Type, +Player2Type)
% starts a game with Player1Type vs Player2Type
startGame(Difficulty, Size, Player, Mode):-
  clear, 
  board(Size, GameState),
  display_game(GameState).

% turn(GameState, Player1Type, 'Player 1', Player2Type ).

% turn(+GameState, +Player, +PlayerS, +NextPlayer)
% Turn predicate for final game state where player removes a piece instead of moving it
turn(GameState, Player, PlayerS, NextPlayer):-
  ( Player = 'Player', format('~n~`*t ~a turn ~`*t~57|~n', [PlayerS]) ;
    Player \= 'Player', format('~n~`*t Computer turn as ~s ~`*t~57|~n', [PlayerS]) ),
  check_final(GameState, PlayerS),
  remove(Player, GameState, PlayerS, NewGameState),
  game_over(NewGameState, PlayerS, TempResult),
  process_result(NewGameState, TempResult, Player, NextPlayer, PlayerS).

% Turn predicate for moving a piece
turn(GameState, Player, PlayerS, NextPlayer):-
  make_move(Player, GameState, PlayerS, NewGameState),
  game_over(NewGameState, PlayerS, TempResult),
  process_result(NewGameState, TempResult, Player, NextPlayer, PlayerS).

% process_result(+NewGameState, +Winner, +TypePlayer, +TypeToPlay, +PlayerS)
% Processes the Winner argument, if there are no winners then it's the opponent's turn
process_result(NewGameState, 'none', TypePlayer, TypeToPlay, PlayerS):-
  clear, 
  display_game(NewGameState), 
  opposed_opponent_string(PlayerS, EnemyS),
  turn(NewGameState, TypeToPlay, EnemyS, TypePlayer).
% If there's a winner, the game ends
process_result(NewGameState, Winner, _, _, _):-
  clear, 
  display_game(NewGameState),
  format('~n~`*t Winner - ~a ~`*t~57|~n', [Winner]),
  sleep(5), clear.

% game_over(+GameState, +Player , -Winner)
% checks first if enemy is winner
game_over(GameState, CurrentPlayer, EnemyS):-
  size_of_board(GameState, Size), 
  opposed_opponent_string(CurrentPlayer, EnemyS),
  check_win(EnemyS, GameState, Size).
% then checks if player is the winner
game_over(GameState, CurrentPlayer, CurrentPlayer):-
  size_of_board(GameState, Size),
  check_win(CurrentPlayer, GameState, Size).
% in case there is no winner, 'none' is returned
game_over(_, _, 'none').

% check_win(+PlayerS, +GameState, +K, -Result)
% to check the win for Player 1, we can check the win for Player 1 with the transposed matrix
check_win('Player 2', GameState, X):-
  transpose(GameState, Transpose),
  check_win('Player 1', Transpose, X).

check_win('Player 1', GameState, Size):-
  value(GameState, 'Player 1', Value),
  Value == Size.