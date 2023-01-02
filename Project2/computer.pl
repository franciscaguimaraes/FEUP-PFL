% choose_move(+GameState, +Player, +Difficulty, -Row, -Col)
choose_move_computer(Board, 1, _, Row, Col):-
    valid_moves(Board, ListOfMoves),
    length(ListOfMoves, L),
    random(0, L, Position),
    nth0(Position, ListOfMoves, Row-Col).

choose_move_computer(GameState, 2, Player, Row, Col):-
    valid_moves(GameState, ListOfMoves),
    counter_of_moves(ListOfMoves, GameState, Player, Result),
    samsort(Result, OrderedSolution), % cant have random bc when availabeMoves is only 1 for example and random picks number 3, crashes
    nth0(0, OrderedSolution, _-Row-Col).

counter_of_moves([], _, _, []).
counter_of_moves([ X-Y | L], GameState, Player, Result):-
    replace(GameState, X, Y, Player, NewGameState), 
    valid_moves(NewGameState, Options),
    length(Options, Plays),
    counter_of_moves(L, GameState, Player, NewResult),
    append(NewResult, [Plays-X-Y], Result).

sort_by_plays(List, Sorted) :- 
    predsort(compare_plays, List, Sorted).

compare_plays(Plays1-_-_, Plays2-_-_) :- Plays1 @< Plays2.

