% sizes according to the option chosen 
option_size(1, 5).
option_size(2, 7).
option_size(3, 9).

% difficulty according to the option chosen
option_difficulty(1, 'Easy').
option_difficulty(2, 'Greedy').

% number of the player according to the player turn
player_turn(-1,2).
player_turn(1,1).

% hadron_logo/0
% predicate that prints the logo of the game
hadron_logo :-
write('##    ##    ###    #####   #########  ######## ##     ##\n'),
write('##    ##   ## ##   #    #  ##      ## #      # ###    ##\n'),
write('##    ##  ##   ##  #     # ##      ## #      # ## #   ##\n'),
write('######## ##     ## #     # #########  #      # ##  #  ##\n'),
write('##    ## ######### #     # ####       #      # ##   # ##\n'),
write('##    ## ##     ## #    #  ##  ####   #      # ##    ###\n'),
write('##    ## ##     ## #####   ##     ### ######## ##     ##\n').

% menu_header_format(+Header)
% predicate that prints the header of the menu
menu_header_format(Header):-
  format( ' ~n~`*t ~p ~`*t~57|~n', [Header]).

% menu_empty_format/0
% predicate that prints an empty line inside a menu
menu_empty_format :-
  format( '*~t*~57|~n', []).

% menu_option_format(+Option, +Details)
% predicate that prints the number of the option and the details associated to it
menu_option_format(Option, Details):-
  format( '*~t~d~t~15|~t~a~t~40+~t*~57|~n', [Option, Details]).

% menu_second_header_format(+Label1, +Label2)
% predicate that prints a header with 2 columns for a secondary table
menu_second_header_format(Label1, Label2):-
      format( '*~t~a~t~15+~t~a~t~40+~t*~57|~n', [Label1, Label2]).

% menu_end_format/0
% predicate that prints a row of '*' to end the menu
menu_end_format :-
  format( '~`*t~57|~n', []).


% menu_text(+Text)
% predicate that prints text inside of a menu
menu_text(Text):-
    format( '*~t~a~t*~57|~n', [Text]).


% menu/0
% Main menu with all the options available
menu :-
    hadron_logo,
    menu_header_format('MAIN MENU'),
    menu_empty_format,
    menu_second_header_format('Option', 'Details'),
    menu_empty_format,
    menu_option_format(1, 'Player vs Player'),
    menu_option_format(2, 'Player vs Computer'),
    menu_option_format(3, 'Computer vs Computer'),
    menu_option_format(4, 'Game Rules'),
    menu_empty_format,
    menu_option_format(0, 'EXIT'),
    menu_empty_format,
    menu_end_format,

    read_number(4, Number),
    menu_option(Number).

% menu_choose_size(-Size)
% predicate that asks the user to choose a board size
menu_choose_size(Size):-
    menu_header_format('Choose a size to the board'),
    menu_empty_format,
    menu_second_header_format('Option', 'Details'),
    menu_option_format(1, '5x5'),
    menu_option_format(2, '7x7'),
    menu_option_format(3, '9x9'),
    menu_empty_format,
    menu_option_format(0,'EXIT'),
    menu_end_format,
    read_number(3,Size).

% banner(+ String)
% prints a banner with a String inside
banner(String) :-
    format( '~n~`*t~57|~n', []),
    format( '*~t~a~t*~57|~n', [String]),
    format( '~`*t~57|~n', []).

% win_message(+Player)
% predicate that prints the winner message 
win_message(Player):-
    player_turn(Player, PlayerNumber),
    format( '~n~`*t~57|~n', []),
    format( '*~t Player ~d Won!~t*~57|~n', [PlayerNumber]),
    format( '~`*t~57|~n', []),
    sleep(2).

% computer_move(+Row, +Col, +Player)
% predicate that prints what is the computer move
computer_move(Row, Col, Player):-
    player_turn(Player, PlayerNumber),
    row(Row, Letter),
    format( '*~t Computer ~d Put a Piece in Tale ~dx~a!~t*~57|~n', [PlayerNumber, Col, Letter]).

% menu_option(+Option)
% Sub-Menus related to the option selected in the main menu

% Exit Main Menu
menu_option(0):-
    banner('Thank You For Playing'),
    hadron_logo.



% Player vs Player, needs to choose Board Size
menu_option(1):-
    asserta(player(1, 'Human')),
    asserta(player(-1, 'Human')),
    menu_choose_size(Size),
    clear_screen,
    pp_start(Size), clear_screen.

% Player vs Computer, needs to choose the board size and the computer difficulty
menu_option(2):-
    banner('Player vs Computer'),
    menu_choose_size(Size),
    pc_menu_1(Size),
    clear_screen, menu.

% Computer vs Computer, needs to choose the board size and the computer 1 difficulty
menu_option(3):-
    banner('Computer vs Computer'),
    menu_choose_size(Size),
    cc_menu_1(Size),
    clear_screen, menu.

% Game rules 
menu_option(4):-
    clear_screen,
    menu_header_format('INSTRUCTIONS'),
    menu_empty_format,
    format( '*~t~s~t~30|~t~c~t~23+~t*~57|~n', ["Player 1", 79]),
    format( '*~t~s~t~30|~t~c~t~23+~t*~57|~n', ["Player 2", 88]),
    menu_empty_format,
    menu_empty_format,
    menu_text('-- INTRODUCTION --'),
    menu_empty_format,
    menu_text('Hadron is a two player game played on a 5x5'),
    menu_text('(or 7x7...) square board,initially empty.'),
    menu_text('The two players, O and X, take turns adding their '),
    menu_text('own checkers to the board,'),
    menu_text('one checker per turn, starting with player 1. '),
    menu_text('If you have a placement available, you must make one.'),
    menu_text('Passing is not allowed.'),
    menu_text('Draws cannot occur in Hadron.'),
    menu_empty_format,
    menu_empty_format,
    menu_text('-- PLACEMENT RULES --'),
    menu_empty_format,
    menu_text('You can place a checker in isolation,'),
    menu_text('not adjacent to anything.'),
    menu_text('Or you can place a checker to form one'),
    menu_text('(horizontal or vertical) adjacency with a friendly'),
    menu_text('checker and one adjacency with an enemy checker.'),
    menu_text('Or you can form two adjacencies with friendly'),
    menu_text('checkers and two adjacencies with enemy checkers'),
    menu_empty_format,
    menu_empty_format,
    menu_text('-- ENDING CONDITIONS --'),
    menu_empty_format,
    menu_text('The last player to make a placement wins.'),
    menu_text('If you do not have a placement available on'),
    menu_text('your turn, you lose'),
    menu_empty_format,
    menu_text('-- AUTHOR --'),
    menu_text('Game invented by: '),
    menu_text('Mark Steere'),
    menu_empty_format,
    menu_end_format,

    menu.

% pp_start(+Option)
% starts the game with the option size selected

% Chose to exit to the main menu
pp_start(0):-
    menu.

pp_start(Option):-
    option_size(Option, Size),
    initial_state(Size,0),
    asserta(turn(-1)),
    game_loop,
    menu.

% pc_menu_1(+Size)
% predicate that asks the user for the difficulty of the computer

% Chose to exit to the main menu
pc_menu_1(0):-
    menu.

pc_menu_1(Size):-
    banner('Player vs Computer'),
    menu_header_format('Choose a Difficulty'),
    menu_empty_format,
    menu_second_header_format('Option', 'Details'),
    menu_empty_format,
    menu_option_format(1, 'Easy (Random)'),
    menu_option_format(2, 'Normal (Greedy)'),
    menu_empty_format,
    menu_option_format(0, 'EXIT'),
    menu_empty_format,
    menu_end_format,

    read_number(2,Difficulty),
    pc_menu_2(Size, Difficulty).

% pc_menu_2(+Size, +Difficulty)
% predicate that asks the user who plays first

% Chose to exit to the main menu 
pc_menu_2(_,0):-
    menu.

pc_menu_2(Size, Difficulty):-
    banner('Player vs Computer'),
    menu_header_format('Choose a Player'),
    menu_empty_format,
    menu_second_header_format('Option', 'Details'),
    menu_empty_format,
    menu_option_format(1, 'Player 1 (Plays First)'),
    menu_option_format(2, 'Player 2'),
    menu_empty_format,
    menu_option_format(0, 'EXIT'),
    menu_empty_format,
    menu_end_format,
    read_number(2, PlayerTurn),
    pc_start(Size, Difficulty, PlayerTurn).


% pc_start(+Option, +Difficulty, +PlayerTurn)
% predicate that starts the game according to the choices made by the user

pc_start(_,_,0):-
    menu. 

pc_start(Option, Difficulty, 1):-
    option_size(Option, Size),
    initial_state(Size,0),
    asserta(player(1, 'Human')),
    asserta(player(-1, 'Bot')),
    asserta(turn(-1)),
    option_difficulty(Difficulty, Choice1),
    asserta(difficulty(-1,Choice1)),
    game_loop.

pc_start(Option, Difficulty, 2):-
    option_size(Option, Size),
    initial_state(Size,0),
    asserta(player(1, 'Bot')),
    asserta(player(-1, 'Human')),
    asserta(turn(-1)),
    option_difficulty(Difficulty, Choice1),
    asserta(difficulty(1, Choice1)),
    game_loop.

% cc_menu_1(+Size)
% predicate that asks the user for the difficulty of computer 1

% chose to exit to the main menu 
cc_menu_1(0):-
    menu.

cc_menu_1(Size):-
    banner('Computer vs Computer'),
    menu_header_format('Choose a Difficulty For Computer 1'),
    menu_empty_format,
    menu_second_header_format('Option', 'Details'),
    menu_empty_format,
    menu_option_format(1, 'Easy (Random)'),
    menu_option_format(2, 'Normal (Greedy)'),
    menu_empty_format,
    menu_option_format(0, 'EXIT'),
    menu_empty_format,
    menu_end_format,

    read_number(2,Difficulty),
    cc_menu_2(Size, Difficulty).

% cc_menu_2(+Size, +Difficulty1)
% predicate that asks the user for the difficulty of computer 2

% chose to exit to the main menu
cc_menu_2(_,0).

cc_menu_2(Size, Difficulty1):-
    banner('Computer vs Computer'),
    menu_header_format('Choose a Difficulty For Computer 2'),
    menu_empty_format,
    menu_second_header_format('Option', 'Details'),
    menu_empty_format,
    menu_option_format(1, 'Easy (Random)'),
    menu_option_format(2, 'Normal (Greedy)'),
    menu_empty_format,
    menu_option_format(0, 'EXIT'),
    menu_empty_format,
    menu_end_format,

    read_number(2,Difficulty),
    cc_start(Size, Difficulty1, Difficulty).

% cc_start(+Option, +Difficulty1, +Difficulty2)
% predicate that starts the game according to the choices made by the user

% chose to exit to the main menu 
cc_start(_,_,0).

cc_start(Option, Difficulty1, Difficulty2):-
    option_size(Option, Size),
    initial_state(Size, 0),
    option_difficulty(Difficulty1, Choice1),
    option_difficulty(Difficulty2, Choice2),
    asserta(difficulty(1, Choice1)),
    asserta(difficulty(-1, Choice2)),
    asserta(turn(-1)),
    asserta(player(1, 'Bot')),
    asserta(player(-1, 'Bot')),
    game_loop.






    


