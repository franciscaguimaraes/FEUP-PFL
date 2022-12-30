% difficulty(+Code, -Difficulty)
% Gives the Difficulty associated with the code provided as an option
difficulty(1, 'Easy').
difficulty(2, 'Normal').

% mode(+Code, -Mode)
% Gives the Mode associated with the code provided as an option
mode(1, 'Player 1', 'Player 2').
mode(2, 'Player', 'Computer').
mode(3, 'Computer 1', 'Computer 2').

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
  display_board(GameState).

% turn(GameState, Player1Type, 'Player 1', Player2Type ).

% turn(+GameState, +Player, +PlayerS, +NextPlayer)
% Turn predicate for final game state where player removes a piece instead of moving it
turn(GameState, Player):-
  game_over(GameState).
  

% Turn predicate for moving a piece
turn(GameState, Player, PlayerS, NextPlayer):-
  format('~n~`-t ~a turn ~`-t~57|~n', Player).



% game_over(+GameState)
game_over(GameState):-
  move_options(GameState, Options),
  length(Options, 0).

  