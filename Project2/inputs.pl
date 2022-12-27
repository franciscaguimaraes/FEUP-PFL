
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


