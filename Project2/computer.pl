% choose_move(+GameState, +Player, +Difficulty, -Row, -Col)
choose_move_computer(Board, 'Easy', _, Row, Col):-
    valid_moves(Board, ListOfMoves),
    length(ListOfMoves, L),
    /* L1 is L - 1, */ %pq serve isto?
    random(0, L, Position),
    nth0(Position, ListOfMoves, Row-Col).

choose_move_computer_n(GameState, Player, Row, Col):-
    valid_moves(GameState, ListOfMoves),
    A is -1, Row is 0, Col is 0,
    counter_of_moves(ListOfMoves, GameState, Player, A-Row-Col).

counter_of_moves([X-Y | L], GameState, Player, A-B-C):-
    replace(GameState, X, Y, Player, NewGameState),
    valid_moves(NewGameState, Options),
    length(Options, Length),
    Length > A,
    counter_of_moves(L, GameState, Player, Length-X-Y).

counter_of_moves([X-Y | L], GameState, Player, A-B-C):-
    counter_of_moves(L, GameState, Player, A-B-C).
