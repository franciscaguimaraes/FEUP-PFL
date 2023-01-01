code_number(48, 0).
code_number(49, 1).
code_number(50, 2).
code_number(51, 3).
code_number(52, 4).
code_number(53, 5).
code_number(54, 6).
code_number(55, 7).
code_number(56, 8).
code_number(57, 9).

% Letter to index ratio
letter_number('A',0).
letter_number('B',1).
letter_number('C',2).
letter_number('D',3).
letter_number('E',4).
letter_number('F',5).
letter_number('G',6).
letter_number('a',0).
letter_number('b',1).
letter_number('c',2).
letter_number('d',3).
letter_number('e',4).
letter_number('f',5).
letter_number('g',6).

% read_inputs(+Size, -X, -Y)
% Reads a Column and Row according to Size (of Board)
read_inputs(Row, Col):-
  read_column(CCode),
  check_column(CCode, Col), %Column
  read_row(RCode), !,
  check_row(RCode, Row), !. %Row

% read_column(-Column, +Size)
% predicate to read column from user
read_column(CCode) :-
  write('| Column - '),
  get_code(CCode).

% check_column(+Testing, -CheckedColumn, +Size)
% Checks if input is a valid column
check_column(CCode, Y) :-
  peek_char(Char),
  Char == '\n',
  code_number(CCode, Y),
  format(': Column read : ~d\n', Y),
  skip_line.

% read_row(-Row, +Size)
% predicate to read row from user
read_row(Rcode) :-
  write('| Row - '),
  get_char(RCode).

% check_row(+Rowread, -CheckedRow, +Size)
% checking rows
check_row(RCode, X) :-
  peek_char(Char),
  Char == '\n',
  letter_number(RCode, X),
  format(': Row read : ~w\n', RCode),
  skip_line.


% askMenuOption(+LowerBound, +UpperBound, -Number)
% used in menus to read inputs between the Lower and Upper Bounds
ask_menu_option(LowerBound, UpperBound, Number):-
  format('| Choose an Option (~d-~d) - ', [LowerBound, UpperBound]),
  get_code(NumberASCII),
  peek_char(Char),
  Char == '\n',
  code_number(NumberASCII, Number),
  Number =< UpperBound, Number >= LowerBound, skip_line.

ask_menu_option(LowerBound, UpperBound, Number):-
  write('Not a valid number, try again\n'), skip_line,
  ask_menu_option(LowerBound, UpperBound, Number).
 
