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

accumulator(0, Acc, Acc).
accumulator(-1, Acc, Acc1):-
    Acc1 is Acc-1.
accumulator(1, Acc, Acc1):-
    Acc1 is Acc+1.

% value_in_board(+Board, +X, +Y, -Value)
% returns in Value the value [0,1,-1] at (X,Y) from Board 
value_in_board(Board, X, Y, Value):-
    nth0(X, Board, Row),
    nth0(Y, Row, Value).

check_possible(Board, X, Y, Count):-
    count_adjacentA(Board, X, Y, Value),
    accumulator(Value, Count, Count1),
    count_adjacentB(Board, X, Y, Value1),
    accumulator(Value1, Count1, Count2),
    count_adjacentL(Board, X, Y, Value2),
    accumulator(Value2, Count2, Count3),
    count_adjacentR(Board, X, Y, Value3),
    accumulator(Value3, Count3, Count4),
    Count4 =:= 0,
    write('well well').

check_possible(Board, X, Y, Count):-
    write('Position not possible. Choose again!').

% above
count_adjacentA(Board, X, Y, Value) :-
    X1 is X - 1,
    value_in_board(Board, X1, Y, Value).

% below
count_adjacentB(Board, X, Y, Value) :-
    X1 is X + 1,
    value_in_board(Board, X1, Y, Value).

% left
count_adjacentL(Board, X, Y, Value) :-
    Y1 is Y - 1,
    value_in_board(Board, X, Y1, Value).

% Right 
count_adjacentR(Board, X, Y,  Value) :-
    Y1 is Y + 1,
    value_in_board(Board, X, Y1, Value).


% replace_index(+I, +L, +E, -K)
% replaces Element E in List L at Index I, Resulting in List K
replace_index(I, L, E, K) :-
    nth0(I, L, _, R),
    nth0(I, K, E, R).

% replace(+Board, +X, +Y, +Value, -BoardResult)
% replaces a value in the board
replace(Board, X, Y, Value, BoardResult):-
%usar substitute(+X, +Xlist, +Y, ?Ylist)
    nth0(Y, Board, Row),
    replace_index(X, Row, Value, NewRow),
    replace_index(Y, Board, NewRow, BoardResult).


% MUDAR ISTOOO
% move(+GameState, +X-Y-Direction, -NewGameState)
%  performs the change in the board, replaces current piece with 0 and enemy piece with player code
move(GameState, X-Y-Direction, NewGameState):-
    value_in_board(GameState, X, Y, Code),
    replace(GameState, X, Y, 0, Board1),
    direction(X-Y, Direction, X1, Y1),
    replace(Board1, X1, Y1, Code, NewGameState).



