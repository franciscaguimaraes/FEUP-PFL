
bot_place_random(Board, X, Y):-
    move_options(Board, Options),
    length(Options, L),
    random(0, L, Index),
    nth0(Index, Options, X-Y).


