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
read_inputs(Size, Row, Col):-
  read_column(Size, CCode),
  check_column(Size, CCode, Col), %Column
  read_row(Size, RCode), !,
  check_row(Size, RCode, Row), !. %Row

% read_column(-Column, +Size)
% predicate to read column from user
read_column(Size, CCode) :-
  format('> Column (0-~d) - ', Size-1),
  get_code(CCode).

% check_column(+Testing, -CheckedColumn, +Size)
% Checks if input is a valid column
check_column(Size, CCode, Y) :-
  peek_char(Char),
  Char == '\n',
  code_number(CCode, Y),
  Y < Size, Y >= 0, 
  format('| Column read : ~d~n', Y),
  skip_line.

check_column(Size, _, Y) :-
  write('| Invalid column\n| Select again\n'),
  skip_line,
  read_column(Size, CCode),
  check_column(Size, CCode, Y).

% read_row(-Row, +Size)
% predicate to read row from user
read_row(Size, RCode) :-
  SNumber is Size - 1,
  letter_number(Letter, SNumber),
  format('> Row (A-~s) - ', Letter),
  get_char(RCode).

% check_row(+Rowread, -CheckedRow, +Size)
% checking rows
check_row(Size, RCode, X) :-
  peek_char(Char),
  Char == '\n',
  letter_number(RCode, X),
  X < Size, X >= 0, 
  format('| Row read : ~w~n', RCode),
  skip_line.

check_row(Size, _, X) :-
  write('| Invalid row. Select again!! \n\n'), 
  skip_line,
  read_row(Size, RCode),
  check_row(Size, RCode, X).


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
 
