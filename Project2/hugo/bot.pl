% choose_move(+GameState, +PlayerTurn, +Difficulty, -Col, -Row)
% Bot predicate that calculates all the possible moves and according to Difficulty 
% makes a greedy move or a random move
% Difficulty 1 means random move
choose_move(GameState,_, 'Easy', Col, Row):-
	valid_moves(GameState, AvailableMoves),
	length(AvailableMoves, X),
	Size is X - 1,
	random(0,Size, MoveIndex),
	nth0(MoveIndex, AvailableMoves, ChosenMove),
	nth0(0, ChosenMove, Col),
	nth0(1, ChosenMove, Row).

% Difficulty 2 means greedy move
choose_move(GameState, PlayerTurn, 'Greedy', Col, Row):-
	valid_moves(GameState, AvailableMoves),
	number_moves_opponent(AvailableMoves, GameState, PlayerTurn, Solution),
	samsort(Solution, OrderedSolution),
	nth0(0, OrderedSolution, Result),
	nth0(1, Result, Col),
	nth0(2, Result, Row).


% number_moves_opponent(+AvailableMoves, +GameState, +PlayerTurn, -Solution)
% Bot predicate used in the greedy move
% calculates the number of moves available to the opposite player for each possible move of the current player
number_moves_opponent([], _, _, []).
number_moves_opponent([H | T], GameState, PlayerTurn, Solution):-
	nth0(0,H, Col),
	nth0(1, H, Row),
	change_element(Row, Col, PlayerTurn, GameState, NewGameState),
	findall([Columns, Rows], check_move(Columns, Rows, NewGameState), AvailableMoves),
	length(AvailableMoves, Size),
	number_moves_opponent(T, GameState, PlayerTurn, SolutionSize),
	append(SolutionSize, [[Size, Col, Row]], Solution).







