% choose_move(+GameState, +Player, +Difficulty, -Row, -Col)
choose_move(Board, Row, Col):-
    valid_positions(Board, ListOfMoves),
    length(ListOfMoves, L),
    L1 is L - 1,
    random(0, L1, Position),
    nth0(Position, ListOfMoves, Row-Col).


move(GameState, 'Human', NewGameState, TC)