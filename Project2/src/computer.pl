% choose_move_computer(+GameState, +Difficulty, +Player -Row, -Col)
% predicate that, according to difficulty, makes a random or a greedy move, calculating possible moves
choose_move_computer(Board, 'Random', _, Row, Col):-
    valid_moves(Board, ListOfMoves),
    length(ListOfMoves, L),
    random(0, L, Position),
    nth0(Position, ListOfMoves, Row-Col).
choose_move_computer(GameState, 'Greedy', Player, Row, Col):-
    valid_moves(GameState, ListOfMoves),
    counter_of_moves(ListOfMoves, GameState, Player, Result),
    samsort(Result, OrderedSolution),
    length(OrderedSolution, Size),
    Size > 2,
    random(0, 4, Position), %best 3
    nth0(Position, OrderedSolution, _-Row-Col).

choose_move_computer(GameState, 'Greedy', Player, Row, Col):-
    valid_moves(GameState, ListOfMoves),
    counter_of_moves(ListOfMoves, GameState, Player, Result),
    samsort(Result, OrderedSolution),
    nth0(0, OrderedSolution, _-Row-Col).


% counter_of_moves(+ListOfMoves, +GameState, +Player, -Result)
% predicate that counts the number of moves the opposite player can take for each move player makes. Result is the move which results in less moves for the opposite player
counter_of_moves([], _, _, []).
counter_of_moves([ X-Y | L], GameState, Player, Result):-
    replace(GameState, X, Y, Player, NewGameState), 
    valid_moves(NewGameState, Options),
    length(Options, Plays),
    counter_of_moves(L, GameState, Player, NewResult),
    append(NewResult, [Plays-X-Y], Result).

