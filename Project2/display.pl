initial(1, [
  [ 1, 0, 1, 0, 1,-1],
  [-1, 1,-1, 0,-1, 1],
  [ 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 0,-1, 1],
  [ 1,-1, 1, 0, 1,-1],
  [-1, 1,-1, 1,-1, 1]
]).

% board(+Code, -Board)
% Gives the Board associated with the code provided as an option

board(1, [
  [0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0]
]).

board(2, [
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0], 
  [0, 0, 0, 0, 0, 0, 0]
]).

% size_of_board(+Board, -X)
% returns in X the size of the Square Board. Does not accept Rectangular Boards
size_of_board(Board, X):-
  nth0(0, Board, Header),
  length(Header, X),
  length(Board, Y),
  X == Y. % check if board is nxn and not nxm

code(0, 32).   % ascii code for space
code(1, 215).  % × - Player 1
code(-1, 216). % Ø - Player 2

player_piece('Player 1', 1).
player_piece('Player 2', -1).

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

display_game(Board):-
  clear,
  size_of_board(Board, X),
  print_header(X),
  print_matrix(Board, 0, X).