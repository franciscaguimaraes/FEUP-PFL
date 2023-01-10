
% counter(+Number, +Acc, -Acc1)
% Counter used to count pieces around position to be checked.
counter(0, Acc, Acc).
counter(-1, Acc, Acc).
counter(2, Acc, Acc1):-
    Acc1 is Acc-1.
counter(1, Acc, Acc1):-
    Acc1 is Acc+1.


% value_in_board(+Board, +X, +Y, -Value)
% returns in Value the value [0,1,2] at (X,Y) from Board.
value_in_board(_, -1, _, 0).
value_in_board(_, _, -1, 0).
value_in_board(Board, X, Y, 0):-
    size_of_board(Board, Length),
    (X =:= Length; Y =:= Length).
value_in_board(Board, X, Y, Value):-
    nth0(X, Board, Row),
    nth0(Y, Row, Value).


% can_place(+Board, +X, +Y, -Result)
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
% returns the value [0,1,2] of the piece above the piece chosen
value_north(Board, X, Y, Value) :-
    X1 is X - 1,
    value_in_board(Board, X1, Y, Value).


% value_south(+Board, +X, +Y, -Value)
% returns the value [0,1,2] of the piece below the piece chosen
value_south(Board, X, Y, Value) :-
    X1 is X + 1,
    value_in_board(Board, X1, Y, Value).


% value_left(+Board, +X, +Y, -Value)
% returns the value [0,1,2] of the piece on the left the piece chosen
value_left(Board, X, Y, Value) :-
    Y1 is Y - 1,
    value_in_board(Board, X, Y1, Value).


% value_right(+Board, +X, +Y, -Value)
% returns the value [0,1,2] of the piece on the right the piece chosen
value_right(Board, X, Y,  Value) :-
    Y1 is Y + 1,
    value_in_board(Board, X, Y1, Value).


% replace_index(+Index, +List, +Element, -RList)
% replaces Element in List at Index, Resulting in RList
replace_index(Index, List, Element, RList) :-
    nth0(Index, List, _, R),
    nth0(Index, RList, Element, R).


% replace(+Board, +X, +Y, +PLayer, -BoardResult)
% replaces a value in the board resulting in BoardResult
replace(Board, X, Y, Player, BoardResult):-
    nth0(X, Board, Row),
    replace_index(Y, Row, Player, NewRow),
    replace_index(X, Board, NewRow, BoardResult).


% valid_moves(+GameState, -ListOfMoves)
% returns in ListOfMoves all possible moves for GameState
valid_moves(GameState, ListOfMoves):-
    findall(X-Y, check_position(GameState, X, Y), ListOfMoves).


% check_position(+Board, +X, +Y)
% checks if it is valid put a piece in position (X,Y)
check_position(Board, X, Y):-
    nth0(X, Board, Row),
    nth0(Y, Row, Value),
    Value =:= 0,
    can_place(Board, X, Y, Result),
    Result =:= 0.

% check_move(+GameState, +Player, +Row, +Col)
% verifies if row and col from user input is present in list of valid moves
check_move(GameState, _, Row, Col, _, _) :-
    check_position(GameState, Row, Col).
  check_move(GameState, Player, _, _, 'pp', _):-
    write('\n| Invalid position. Choose again!\n'),
    play_pp(GameState, Player).
  check_move(GameState, Player, _, _, 'pc', Difficulty):-
    write('\n| Invalid position. Choose again!\n'),
    play_pc(GameState, Player, Difficulty).
  check_move(GameState, Player, _, _, 'cp', Difficulty):-
    write('\n| Invalid position. Choose again!\n'),
    play_cp(GameState, Player, Difficulty).
  