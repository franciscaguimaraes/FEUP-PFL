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

% check_column(+Testing, -CheckedColumn, +Size)
% Checks if input is a valid column
check_column(Testing, Number, Size) :-
  peek_char(Char),
  Char == '\n',
  code_number(Testing, Number),
  Number < Size, Number >= 0, skip_line.

% if not between 0-x then try again
check_column(_, CheckedColumn, Size) :-
  write('~ Invalid column\n| Select again\n'),
  skip_line,
  read_column(Column, Size),
  check_column(Column, CheckedColumn, Size).

% read_row(-Row, +Size)
% predicate to read row from user
read_row(Row, Size) :-
  Size1 is Size-1,
  row(Size1, Letter),
  format('| Row (A-~s) -    ', Letter),
  get_char(Row).

% check_row(+Rowread, -CheckedRow, +Size)
% checking rows
check_row(Rowread, RowreadUpper, Size) :-
  (row(RowNumb, Rowread) ; row_lower(RowNumb, Rowread)), RowNumb < Size, RowNumb >= 0, 
  row(RowNumb, RowreadUpper). 
  
% Gets Capital letter, ic case it reads lowercase letter
% if not between A-y then try again
check_row(_, CheckedRow, Size) :-
  write('~ Invalid row\n| Select again\n'),
  skip_line,
  read_row(Row, Size),
  check_row(Row, CheckedRow, Size).

% askMenuOption(+LowerBound, +UpperBound, -Number)
% used in menus to read inputs between the Lower and Upper Bounds
askMenuOption(LowerBound, UpperBound, Number):-
  format('| Choose an Option (~d-~d) - ', [LowerBound, UpperBound]),
  get_code(NumberASCII),
  peek_char(Char),
  Char == '\n',
  code_number(NumberASCII, Number),
  write(Number),
  write(UpperBound),
  write(LowerBound),
  Number =< UpperBound, Number >= LowerBound, write('hi'), skip_line.

askMenuOption(LowerBound, UpperBound, Number):-
  write('Not a valid number, try again\n'), skip_line,
  askMenuOption(LowerBound, UpperBound, Number).
 
 