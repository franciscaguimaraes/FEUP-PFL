% value_in_board(+Board, +X, +Y, -Value)
% returns in Value the value [0,1,-1] at (X,Y) from Board
value_in_board(Board, X, Y, Value):-
    nth0(Y, Board, Row),
    nth0(X, Row, Value).



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


% count(+Num,+List, -X)
% Returns in X the amount of Num in List
count(_, [], 0).
count(Num, [H|T], X) :- Num \= H, count(Num, T, X).
count(Num, [H|T], X) :- Num = H, count(Num, T, X1), X is X1 + 1.

