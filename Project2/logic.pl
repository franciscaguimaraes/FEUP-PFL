:-use_module(library(lists)).
% value_in_board(+Board, +X, +Y, -Value)
% returns in Value the value [0,1,-1] at (X,Y) from Board

bla(0, Acc, Acc).
bla(-1, Acc, Acc1):-
    Acc1 is Acc-1.
bla(1, Acc, Acc1):-
    Acc1 is Acc+1.

value_in_board(Board, X, Y, Value):-
    nth0(X, Board, Row),
    nth0(Y, Row, Value).

check_possible(Board, X, Y, Count):-
    count_adjacentA(Board, X, Y, Value),
    bla(Value, Count, Count1),
    count_adjacentB(Board, X, Y, Value1),
    bla(Value1, Count1, Count2),
    count_adjacentL(Board, X, Y, Value2),
    bla(Value2, Count2, Count3),
    count_adjacentR(Board, X, Y, Value3),
    bla(Value3, Count3, Count4),
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



