% ASCII code and respective decimal number
ascii_code(48, 0).
ascii_code(49, 1).
ascii_code(50, 2).
ascii_code(51, 3).
ascii_code(52, 4).
ascii_code(53, 5).
ascii_code(54, 6).
ascii_code(55, 7).
ascii_code(56, 8).
ascii_code(57, 9).

% Letter to index ratio
letter_to_number('A',0).
letter_to_number('B',1).
letter_to_number('C',2).
letter_to_number('D',3).
letter_to_number('E',4).
letter_to_number('F',5).
letter_to_number('G',6).
letter_to_number('H',7).
letter_to_number('I',8).
letter_to_number('a',0).
letter_to_number('b',1).
letter_to_number('c',2).
letter_to_number('d',3).
letter_to_number('e',4).
letter_to_number('f',5).
letter_to_number('g',6).
letter_to_number('h',7).
letter_to_number('i',8).

% between(+S, +Upper)
% predicate that checks if S is between 0 and Upper
between(S,Upper) :- S >= 0, S< Upper.

% read_input(+Size, -Column, -Row)
% predicate that reads and checks if a input for a Column and a row is valid
read_input(Size, Column, Row) :-
	read_column(Size, ColumnCode),
	check_column(Size,ColumnCode, Column),
	read_row(Size, RowCode), !,
	check_row(Size, RowCode, Row), !.

% read_column(+Size, -Column)
% predicate that reads the input for a Column
read_column(Size, Column):-
	format( ' | Column 0-~d\n', Size - 1),
	get_code(Column).

% check_column(+Size, +ColumnCode, -Column)
% predicate that checks if the input for a Column is valid
check_column(Size, ColumnCode, Column) :-
		peek_char(Enter),
		Enter == '\n',
		ascii_code(ColumnCode, Column),
		skip_line,
		between(Column,Size),
		format( ': Column read : ~d\n', Column).
% if not between 0-x then try again recursively
check_column(Size, _, Column):-
		write('~ Invalid column | Enter a column again:\n'), 
		read_column(Size, ColumnCode),
		check_column(Size, ColumnCode, Column).

% read_row(+Size, -RowCode)
% predicate that reads the input for a Row
read_row(Size, RowCode):-
	S1 is Size -1,
	letter_to_number(Letter, S1), !,
	format( ' | Row A-~a\n', Letter),
	get_char(RowCode).

% check_row(+Size, +RowCode, -Row)
% predicate that checks if the input for a Row is valid
check_row(Size, RowCode, Row) :-
	peek_char(Enter),
	Enter == '\n',
	letter_to_number(RowCode, Row),
	skip_line,
	between(Row,Size), format( ': Row read : ~a\n', RowCode).
% if not between A-y then try again recursively
check_row(Size,_, Row):-
	write('~ Invalid row | Enter a row again:\n'), 
	read_row(Size, RowCode),
	check_row(Size, RowCode, Row).

% read_number(+UpperBound, -Result)
% predicate that receives inputs and validates them regarding the menus
read_number(UpperBound, Result) :-
	repeat,
		format( '| Choose an Option (~d-~d) - ', [0, UpperBound]),
		get_code(ASCIICode),
		peek_char(Enter),
		Enter == '\n',
		ascii_code(ASCIICode, Result),
		skip_line,
		UP is UpperBound +1,
		(between(Result,UP) -> true;
		write('Not a valid number, try again\n')),
		between(Result,UP), !.



