% initial_state(+Size, +Count)
% predicate the creates and stores the board dynamically
initial_state(Size, Count):-
	Size > Count,
	length(List, Size),
	maplist(=(0), List),
	Count1 is Count + 1,
	assertz(gameboard(List)),
	initial_state(Size, Count1).

initial_state(Size, Size):-
	findall(Row, gameboard(Row), Board), 
	retractall(gameboard(_)),
	asserta(gameboard(Board)). 

% take(+N, +List, -Result)
% predicate that takes the first N elements of a list 
take(0, _, []). 
take(N, [H|T], [H|Rest]) :-
    N > 0, 
    N1 is N - 1, 
    take(N1, T, Rest).  

% drop(+N, +List, -Result)
% predicate that drops the first N elements of a list
drop(0, List, List). 
drop(N, [_|T], Rest) :-
    N > 0,  
    N1 is N - 1, 
    drop(N1, T, Rest). 

% change_row(+OldRow, +Col, +Value, -NewRow)
% predicate that changes the index Col of a OldRow to Value and returns the result in NewRow
change_row(OldRow, Col, Value, NewRow):-
	take(Col, OldRow, Previous),
	Col1 is Col + 1,
	drop(Col1, OldRow, After),
	append(Previous, [Value], FirstResult),
	append(FirstResult, After, NewRow).

% change_element(+Row, +Col, +Value, +Board, -NewBoard)
% predicate responsible for changing the value at 'Row' and 'Col' of the board and returns the NewBoard
change_element(Row, Col, Value, Board, NewBoard) :-
    take(Row, Board, Previous),
    Row1 is Row +1,
    drop(Row1, Board, After),
    nth0(Row, Board, OldRow),
    change_row(OldRow, Col, Value, NewRow),
    append(Previous, [NewRow], FirstResult),
    append(FirstResult, After, NewBoard).

% check_place(+Row, +Col,+Board, -Player1Count, -Player2Count)
% predicate that checks which player has a piece in the tale Row x Col and increments the respective counter
check_place(Row, Col, Board, Player1Count, Player2Count):-
	nth0(Row, Board, X),
	nth0(Col, X, Position),
	(Position == 1 -> Player1Count is 1, Player2Count is 0;
	Position == -1 -> Player2Count is 1, Player1Count is 0;
	Position == 0 -> Player1Count is 0, Player2Count is 0).

% check_all_places(+Col, +Row, +Board, -Player1Count, -Player2Count)
% predicate that checks all tales adjacent to a given tale in Row x Col
check_all_places(Col, Row, Board, Player1Count, Player2Count):-
	board_size(Board, Size),

	RowUp is Row - 1,
	RowDown is Row + 1,
	ColUp is Col + 1,
	ColDown is Col -1,
	(RowUp >= 0 -> check_place(RowUp, Col, Board, Player1Count1, Player2Count1);
	 RowUp < 0 -> Player1Count1 is 0, Player2Count1 is 0),

	((RowDown < Size) -> check_place(RowDown, Col, Board, Player1Count2, Player2Count2);
	(RowDown == Size) -> Player1Count2 is 0, Player2Count2 is 0),

	(ColUp < Size -> 	check_place(Row, ColUp, Board,Player1Count3, Player2Count3);
	ColUp == Size ->  Player1Count3 is 0, Player2Count3 is 0),

	(ColDown >= 0 -> check_place(Row, ColDown, Board, Player1Count4, Player2Count4);
	 ColDown < 0 -> Player1Count4 is 0, Player2Count4 is 0),

	Player1Count is Player1Count1 + Player1Count2 + Player1Count3 + Player1Count4,
	Player2Count is Player2Count1 + Player2Count2 + Player2Count3 + Player2Count4.

% check_move(+Col, +Row, +Board)
% predicate that checks if a move is valid
check_move(Col, Row, Board):-
	nth0(Row, Board, X),
	nth0(Col, X, Position),
	Position == 0, 
	check_all_places(Col, Row, Board, Player1Count, Player2Count),
	Player1Count == Player2Count.


% valid_moves(+GameState, +Player, -ListOfMoves)
% predicate that returns a list with all the possible moves
valid_moves(GameState, ListOfMoves) :-
	findall([Columns, Rows], check_move(Columns, Rows, GameState), ListOfMoves).


% game_over(+GameState)
% predicate that checks if the game is over
game_over(GameState) :-
	valid_moves(GameState, AvailableMoves),
	length(AvailableMoves, X),
	X == 0.




