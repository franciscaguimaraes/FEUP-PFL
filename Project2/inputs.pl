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


% read_inputs(+Size, -X, -Y)
% Reads a Column and Row according to Size (of Board)
read_inputs(Size, X, Y):-
  read_column(Column, Size),
  check_column(Column, X, Size),
  format(': Column read :  ~d\n', X),
  read_row(Row, Size),
  check_row(Row, Y, Size),
  format(': Row read :     ~w\n', Y).

% read_column(-Column, +Size)
% predicate to read column from user
read_column(Column, Size) :-
  format('| Column (0-~d) - ', Size-1),
  get_code(Column).


% read_row(-Row, +Size)
% predicate to read row from user
read_row(Row, Size) :-
  Size1 is Size-1,
  row(Size1, Letter),
  format('| Row (A-~s) -    ', Letter),
  get_char(Row).

% askMenuOption(+LowerBound, +UpperBound, -Number)
% used in menus to read inputs between the Lower and Upper Bounds
askMenuOption(LowerBound, UpperBound, Number):-
  format('| Choose an Option (~d-~d) - ', [LowerBound, UpperBound]),
  get_code(NumberASCII),
  peek_char(Char),
  Char == '\n',
  code_number(NumberASCII, Number),
  Number =< UpperBound, Number >= LowerBound, skip_line.

askMenuOption(LowerBound, UpperBound, Number):-
  write('Not a valid number, try again\n'), skip_line,
  askMenuOption(LowerBound, UpperBound, Number).
 
