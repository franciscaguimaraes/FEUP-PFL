player_char(0,32). % Empty tale
player_char(1,79). % player1
player_char(-1,88). % player2

% index of a row to the respective letter
row(0,'A').
row(1,'B').
row(2,'C').
row(3,'D').
row(4,'E').
row(5,'F').
row(6,'G').
row(7,'H').
row(8,'I').
row(9,'J').

% clear_screen/0
% predicate that clears the screen
clear_screen :- write('\33\[2J'), !.

% board_size(+GameState, -Size)
% Predicate that returns in Size the size of the GameState
% Does not accept rectangular GameStates
board_size(GameState, Size):-
	nth0(0, GameState, Row),
	length(Row, Size),
	length(GameState, Y),
	Size == Y.


% print_separator_mid(+X)
% prints the middle separator of the board
print_separator_mid(X) :-
	X > 2,
	write('- + '),
	X1 is X - 1, 
	print_separator_mid(X1).
print_separator_mid(2) :-
	write('- |\n').

% print_board(+GameState, +Counter, +Size)
% predicate responsible for printing the board to the console
print_board(_, X, X).
print_board([Row|T],N,X) :-
	X > N,
	letter_to_number(Letter, N), !,
	write(' '), write(Letter),write(' | '),
	print_line(Row), nl,
	write('---| - + '), print_separator_mid(X),
	N1 is N + 1,
	print_board(T, N1, X).

% print_line(+Row)
% predicate that prints a row to the terminal
print_line([]).
print_line([C|L]):-
	player_char(C, Char),
	put_code(Char),
	write(' | '),
	print_line(L).

% print_header(+X)
% predicate that prints the header of the board
print_header(X) :-
	write('   |'),
  	print_columns_numbers(0, X),
  	write('---'),
  	print_separator_board(X).

% print_separator_board(+X)
% predicate that prints the separator between the header and the rest of the board
print_separator_board(0) :-
	write('|'), nl.
print_separator_board(X) :-
	X >0,
	write('+---'), 
	X1 is X-1, 
	print_separator_board(X1).

% print_columns_numbers(+Initial, +Final)
% predicate that prints the number of columns recursively between the initial number until the final number
print_columns_numbers(Initial, Initial) :-
	nl.
print_columns_numbers(Initial, Final) :-
	write(' '), write(Initial), write(' |'),
	Initial1 is Initial + 1,
	print_columns_numbers(Initial1, Final). 

% display_game(+GameState)
% predicate responsible for displaying the entire Board
display_game(GameState) :-
	nl, board_size(GameState, Size), !,
	print_header(Size), !,
	print_board(GameState,0,Size). 


