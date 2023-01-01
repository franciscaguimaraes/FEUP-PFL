counter(0, Acc, Acc).
counter(-1, Acc, Acc).
counter(2, Acc, Acc1):-
    Acc1 is Acc-1.
counter(1, Acc, Acc1):-
    Acc1 is Acc+1.

% value_in_board(+Board, +X, +Y, -Value)
% returns in Value the value [0,1,2] at (X,Y) from Board 
value_in_board(Board, -1, Y, Value):-
    Value is 0.

value_in_board(Board, X, -1, Value):-
    Value is 0.

value_in_board(Board, X, Y, Value):-
    size_of_board(Board, Length),
    (X =:= Length; Y =:= Length),
    Value is 0.

value_in_board(Board, X, Y, Value):-
    nth0(X, Board, Row),
    nth0(Y, Row, Value).

% check_place(+Board, +X, +Y, +Count)
% checks if chosen position to place a piece is free and if it is surrounded by the same number of pieces

can_place(Board, X, Y, Result):-
    value_north(Board, X, Y, Value),
    counter(Value, 0, Count1),
    value_south(Board, X, Y, Value1),
    counter(Value1, Count1, Count2),
    value_left(Board, X, Y, Value2),
    counter(Value2, Count2, Count3),
    value_right(Board, X, Y, Value3),
    counter(Value3, Count3, Result).

% value_north(+Board, +X, +Y, -Value)
% returns the value [1,-1,0] of the piece above the piece chosen
value_north(Board, X, Y, Value) :-
    X1 is X - 1,
    value_in_board(Board, X1, Y, Value).

% value_south(+Board, +X, +Y, -Value)
% returns the value [1,-1,0] of the piece below the piece chosen
value_south(Board, X, Y, Value) :-
    X1 is X + 1,
    value_in_board(Board, X1, Y, Value).

% value_left(+Board, +X, +Y, -Value)
% returns the value [1,-1,0] of the piece on the left the piece chosen
value_left(Board, X, Y, Value) :-
    Y1 is Y - 1,
    value_in_board(Board, X, Y1, Value).

% value_right(+Board, +X, +Y, -Value)
% returns the value [1,-1,0] of the piece on the right the piece chosen
value_right(Board, X, Y,  Value) :-
    Y1 is Y + 1,
    value_in_board(Board, X, Y1, Value).


% replace_index(+I, +L, +E, -K)
% replaces Element E in List L at Index I, Resulting in List K
replace_index(I, L, E, K) :-
    nth0(I, L, _, R),
    nth0(I, K, E, R).

% replace(+Board, +X, +Y, +Value, -BoardResult)
% replaces a value in the board
replace(Board, X, Y, Player, BoardResult):-
    nth0(X, Board, Row),
    replace_index(Y, Row, Player, NewRow),
    replace_index(X, Board, NewRow, BoardResult),
    display_board(BoardResult).

% valid_moves(+GameState, -ListOfMoves)
valid_moves(GameState, ListOfMoves):-
    findall(X-Y, check_position(X, Y, GameState), Options).

check_position(X, Y, Board):-
    nth0(X, Board, Row),
    nth0(Y, Row, Value),
    Value =:= 0,
    can_place(Board, X, Y, Result),
    Result =:= 0.


