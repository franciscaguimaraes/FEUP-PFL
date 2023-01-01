
% board(+Number, -Size)
% Gives the size of the board associated with the option
board(1,5).
board(2,7).

% initial_state(+Size, -GameState)
initial_state(5, [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0] ]).

initial_state(7, [
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0]
]).

% size_of_board(+Board, -Size)
% returns the size of the Square Board. Does not accept Rectangular Boards
size_of_board(Board, Size):-
  nth0(0, Board, Header),
  length(Header, Size),
  length(Board, Y),
  Size == Y.

code(0, 32).   % space
code(1, 215).  % × - Player 1
code(2, 216).  % Ø - Player 2


% Codes for board rows
row(0, 'A').
row(1, 'B').
row(2, 'C').
row(3, 'D').
row(4, 'E').
row(5, 'F').
row(6, 'G').
row(7, 'H').
row(8, 'I').
row(9, 'J').

print_separator(0):-
  write('+\n').
print_separator(X):-
  write('+---'), X1 is X-1, print_separator(X1).

print_header_numbers(Initial, Initial):-
  write(' '), 
  write(Initial),
  write(' |\n').
print_header_numbers(Initial, Final):-
  write(' '), 
  write(Initial), 
  write(' |'), 
  N1 is Initial + 1,
  print_header_numbers(N1, Final).

print_header(X):-
  write('   |'),
  X1 is X -1, 
  print_header_numbers(0, X1),
  write('---'),
  print_separator(X).

print_matrix([L|T], N, X):-
    write(' '), row(N,R), write(R), write(' | '), % letra da linha
    N1 is N + 1,
    print_line(L), nl,
    write('---'), print_separator(X),
    print_matrix(T, N1, X).
print_matrix(_, _, X).

print_line([]).

print_line([C|L]):-
  code(C, P),put_code(P), write(' | '),
  print_line(L).

display_board(Board):-
  clear,
  size_of_board(Board, X),
  print_header(X),
  print_matrix(Board, 0, X).

computer_move(Row, Col, Player):-
  player_turn(Player, PlayerNumber),
  row(Row, Letter),
  format( '*~t Computer ~d Put a Piece in Tale ~dx~a!~t*~57|~n', [PlayerNumber, Col, Letter]).
