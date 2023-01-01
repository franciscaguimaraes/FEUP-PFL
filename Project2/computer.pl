% choose_move(+GameState, +Player, +Difficulty, -Row, -Col)
choose_move_computer(Board, 'Easy', Row, Col):-
    valid_moves(Board, ListOfMoves),
    length(ListOfMoves, L),
    /* L1 is L - 1, */ %pq serve isto?
    random(0, L, Position),
    nth0(Position, ListOfMoves, Row-Col).

choose_move_computer(Board, Row, Col, 'Normal'):-
    valid_moves(Board, ListOfMoves),
    length(ListOfMoves, L),
    L1 is L - 1,
    random(0, L1, Position),
    nth0(Position, ListOfMoves, Row-Col).

counter_of_moves([X-Y | L], GameState, Player):-
    replace(GameState, X, Y, Player, NewGameState),
    valid_moves(NewGameState, Options),
    counter_of_moves(L, GameState, Player).
