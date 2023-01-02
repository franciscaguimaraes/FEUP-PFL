% choose_move(+GameState, +Player, +Difficulty, -Row, -Col)
choose_move_computer(Board, 'Easy', _, Row, Col):-
    valid_moves(Board, ListOfMoves),
    length(ListOfMoves, L),
    random(0, L, Position),
    nth0(Position, ListOfMoves, Row-Col).

choose_move_computer(GameState, 'Normal', Player, Row, Col):-
    valid_moves(GameState, ListOfMoves),
    counter_of_moves(ListOfMoves, GameState, Player, Result),
    sort_by_plays(Result, OrderedSolution),
    random(0, 4, Position), % best 3
    nth0(Position, OrderedSolution, _-Row-Col).

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

