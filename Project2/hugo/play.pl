% game_loop/0
% predicate responsible for the main loop game
game_loop :- 
	clear_screen,
	repeat,
		change_turn,
		gameboard(GameState),
		display_game(GameState),
		next_move(NewGameState),
		game_over(NewGameState), !,
	display_game(NewGameState),
	turn(Winner),
	win_message(Winner),
	retract(gameboard(_)),
	retract(turn(_)),
	retract(player(_,_)),
	retract(difficulty(_,_)).


% next_move(-NewGameState)
% predicate that is responsible for who plays next and changing the gamestate in the database
next_move(NewGameState) :-
	turn(NextPlayer),
	gameboard(GameState),
	player(NextPlayer, Type),
	move(GameState, NextPlayer, Type, NewGameState), !,
	retract(gameboard(_)), 
	asserta(gameboard(NewGameState)).

% move(+GameState, +NextPlayer, +Type, -NewGameState)
% predicate that makes a move according to the type of player that the NextPlayer is and returns the NewGameState
move(GameState, NextPlayer, 'Human', NewGameState) :-
	board_size(GameState, Size),
	read_input(Size, Column, Row),
	check_move(Column, Row, GameState), 
	change_element(Row, Column, NextPlayer, GameState, NewGameState).

move(GameState, NextPlayer, 'Bot', NewGameState) :-
	difficulty(NextPlayer, Difficulty),
	choose_move(GameState, NextPlayer,Difficulty, Col, Row),
	change_element(Row, Col, NextPlayer, GameState, NewGameState),
	computer_move(Row, Col, NextPlayer),
	sleep(2).

% change_turn/0
% predicate that changes the next player who is playing
change_turn :-
	turn(Player),
	retract(turn(_)), !,
	NextPlayer is - Player,
	asserta(turn(NextPlayer)), !.

