
counter(0, Acc, Acc).
counter(-1, Acc, Acc1):-
    Acc1 is Acc-1.
counter(1, Acc, Acc1):-
    Acc1 is Acc+1.

% value_in_board(+Board, +X, +Y, -Value)
% returns in Value the value [0,1,-1] at (X,Y) from Board
:-use_module(library(lists)).

% choose_piece(+Board, +PlayerS, -Xtemp, -Ytemp, -Directions)
% predicate to read input, checks if piece belongs to player, gets available directions and return
choose_piece(Board, PlayerS, X, Y, Directions):-
    size_of_board(Board, Size),
    read_inputs(Size, Xread, Yread).

% checks if list os available directions is empty, in that case, calls choose_piece again
check_list(Board, PlayerS, _, _, [], Directions, XFinal, YFinal):-
    format('~`xt No plays available for that piece ~`xt~57|~n', []),
    format('~`*t Chose Another Piece ~`*t~57|~n', []),
    skip_line,
    choose_piece(Board, PlayerS, XFinal, YFinal, Directions).
% if List is not empty
check_list(_,_,X,Y,List,List,X,Y):-
    format('~`-t There are plays available for that spot ~`-t~57|~n', []).

% value_in_board(+Board, +X, +Y, -Value)
% returns in Value the value [0,1,-1] at (X,Y) from Board 
value_in_board(Board, X, Y, Value):-
    nth0(X, Board, Row),
    nth0(Y, Row, Value).

% check_possible(+Board, +X, +Y, +Count)
% checks if chosen position to place a piece is free and if it is surrounded by the same number of pieces
check_possible(Board, X, Y, _, _):-
    value_in_board(Board, X, Y, Value),
    Value \= 0,
    write('This position is already occupied! Choose again!').

check_possible(Board, X, Y, Count, Player):-
    value_north(Board, X, Y, Value),
    counter(Value, Count, Count1),
    value_south(Board, X, Y, Value1),
    counter(Value1, Count1, Count2),
    value_left(Board, X, Y, Value2),
    counter(Value2, Count2, Count3),
    value_right(Board, X, Y, Value3),
    counter(Value3, Count3, Count4),
    Count4 =:= 0,
    replace(Board, X, Y, Player, BoardResult).

check_possible(_, _, _, _, _):-
    write('Position not possible. Choose again!').

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
%usar substitute(+X, +Xlist, +Y, ?Ylist)
    nth0(Y, Board, Row),
    replace_index(X, Row, Player, NewRow),
    replace_index(Y, Board, NewRow, BoardResult),
    display_game(BoardResult).




