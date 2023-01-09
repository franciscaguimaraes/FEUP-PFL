% Gives the size of the board associated with the option
board_size(1,5).
board_size(2,7).


% difficulty according to the option chosen
difficulty(1, 'Random').
difficulty(2, 'Greedy').


% clear/0
% Clears SICStus screen
clear :- write('\33\[2J').


% main_menu/0
% clears the screen, prints main menu and asks for user input 
main_menu :-
  clear,
  print_menu,
  ask_menu_option(0, 3, Number),
  manage_option(Number).


% menu_board_size(-Size) 
% clears the screen, prints board menu and asks for user input
menu_board_size(Size) :- 
  clear,
  print_board_menu,
  ask_menu_option(0, 2, Size).


% menu_choose_player(-Player)
% clears the screen, prints player menu and asks for user input
menu_choose_player(Player) :- 
  clear,
  print_player_menu,
  ask_menu_option(0, 2, Player).

% menu_choose_difficulty(-Difficulty)
% clears the screen, prints difficulty menu and asks for user input
menu_choose_difficulty(Difficulty) :- 
  clear,
  print_difficulty_menu,
  ask_menu_option(0, 2, Difficulty).


% manage_option(+Number)
% takes action from main menu, taking into consideration user input
manage_option(0) :-
  write('\nThank you for Playing (or trying)! Exiting game...\n\n'), !.
manage_option(1) :-
  menu_board_size(Size),
  manage_board_option_pp(Size).
manage_option(2) :-
  menu_board_size(Size),
  manage_board_option_pc(Size).
manage_option(3) :-
  menu_board_size(Size),
  manage_board_option_cc(Size).


% manage_board_option_pp(+Number)
% takes action with player-player mode from board menu, taking into consideration user input 
manage_board_option_pp(0) :-
  main_menu.
manage_board_option_pp(Number) :-
  board_size(Number, Size),
  start_game(Size, 'Human', 'Human', 0, 0).


% manage_board_option_pc(+Number)
% takes action with player-computer mode from board menu, taking into consideration user input 
manage_board_option_pc(0) :-
  main_menu.
manage_board_option_pc(Size) :-
  menu_choose_player(Player),
  manage_player_option_pc(Size, Player).


% manage_board_option_cc(+Number):-
% takes action with computer-computer mode from board menu, taking into consideration user input 
manage_board_option_cc(0):-
  main_menu.
manage_board_option_cc(Size):-
  clear,
  print_difficulty_menu(1),
  ask_menu_option(0, 2, Difficulty1),
  clear,
  print_difficulty_menu(2),
  ask_menu_option(0, 2, Difficulty2),
  clear,
  manage_difficulty_option_cc(Size, Difficulty1, Difficulty2).


% manage_player_option_pc(+Size, +Player) :- 
% takes action with player-computer mode from player menu, taking into consideration user input 
manage_player_option_pc(_,0) :- 
  main_menu.
manage_player_option_pc(Size, Player) :-
  menu_choose_difficulty(Difficulty),
  manage_difficulty_option_pc(Size, Player, Difficulty).


% manage_difficulty_option_pc(+Size, +Player, +Difficulty)
% takes action with player-computer mode from difficulty menu, taking into consideration user input 
manage_difficulty_option_pc(_,_,0) :-
  main_menu.
manage_difficulty_option_pc(Size, 1, Difficulty) :-
  difficulty(Difficulty, DifficultyOption),
  board_size(Size, SizeOption),
  start_game(SizeOption, 'Human', 'Computer', DifficultyOption, 0).
manage_difficulty_option_pc(Size, 2, Difficulty) :-
  difficulty(Difficulty, DifficultyOption),
  board_size(Size, SizeOption),
  start_game(SizeOption, 'Computer', 'Human', DifficultyOption, 0).


% manage_difficulty_option_cc(+Size, +Difficulty1, +Difficulty2)
% takes action with computer-computer mode from difficulty menu, taking into consideration user input 
manage_difficulty_option_cc(_,0,_):-
  main_menu.
manage_difficulty_option_cc(_,_,0):-
  main_menu.
manage_difficulty_option_cc(Size, Difficulty1, Difficulty2):-
  board_size(Size, SizeOption),
  
  difficulty(Difficulty1, DifficultyOption1),
  difficulty(Difficulty2, DifficultyOption2),
  start_game(SizeOption, 'Computer', 'Computer', DifficultyOption1, DifficultyOption2).


% print_menu/0
% prints menu to choose game mode 
print_menu :-
write(' _______________________________________________________________________ \n'),
write('|                                                                       |\n'), 
write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
write('|               -----------------------------------------               |\n'),
write('|                                                                       |\n'),
write('|                             MAIN MENU                                 |\n'),
write('|                                                                       |\n'),                                                                                                                                            
write('|                       Choose a Game Mode:                             |\n'),
write('|                                                                       |\n'),
write('|                       1. Player vs Player                             |\n'),
write('|                                                                       |\n'),
write('|                       2. Player vs Computer                           |\n'),
write('|                                                                       |\n'),
write('|                       3. Computer vs Computer                         |\n'),
write('|                                                                       |\n'),
write('|                       0. Leave Game                                   |\n'),
write('|_______________________________________________________________________|\n').

% print_player_menu/0
% prints menu to choose player 
print_player_menu :-
write(' _______________________________________________________________________ \n'),
write('|                                                                       |\n'), 
write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
write('|               -----------------------------------------               |\n'),
write('|                                                                       |\n'),
write('|                             PLAYER MENU                               |\n'),
write('|                                                                       |\n'),
write('|                       Choose a Player:                                |\n'),
write('|                                                                       |\n'),
write('|                       1. x - Player 1  (Starts First)                 |\n'),
write('|                                                                       |\n'),
write('|                       2. o - Player 2                                 |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Main Menu                         |\n'),
write('|_______________________________________________________________________|\n').

% print_board_menu/0
% prints menu for board size
print_board_menu :-
write(' _______________________________________________________________________ \n'),
write('|                                                                       |\n'), 
write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
write('|               -----------------------------------------               |\n'),
write('|                                                                       |\n'),
write('|                             BOARD MENU                                |\n'),
write('|                                                                       |\n'),
write('|                       Choose a Board Size:                            |\n'),
write('|                                                                       |\n'),
write('|                       1. 5x5                                          |\n'),
write('|                                                                       |\n'),
write('|                       2. 7x7                                          |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Main Menu                         |\n'),
write('|_______________________________________________________________________|\n').

% print_difficulty_menu/0
% prints menu for difficulty level
print_difficulty_menu :-
write(' _______________________________________________________________________ \n'),
write('|                                                                       |\n'), 
write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
write('|               -----------------------------------------               |\n'),
write('|                                                                       |\n'),
write('|                           DIFFICULTY MENU                             |\n'),
write('|                                                                       |\n'),
write('|                       Choose a Difficulty Level:                      |\n'),
write('|                                                                       |\n'),
write('|                       1. Level 1  (Random Strategy)                   |\n'),
write('|                                                                       |\n'),
write('|                       2. Level 2  (Greedy Strategy)                   |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Main Menu                         |\n'),
write('|_______________________________________________________________________|\n').

% print_difficulty_menu(+Player)
% prints difficulty menu for computer vs computer mode
print_difficulty_menu(Player) :-
  write(' _______________________________________________________________________ \n'),
  write('|                                                                       |\n'), 
  write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
  write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
  write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
  write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
  write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
  write('|               -----------------------------------------               |\n'),
  write('|                                                                       |\n'),
  write('|                           DIFFICULTY MENU                             |\n'),
  format('|                           * Computer ~d *                              |\n' , [Player]),
  write('|                                                                       |\n'),
  write('|                       Choose a Difficulty Level:                      |\n'),
  write('|                                                                       |\n'),
  write('|                       1. Level 1  (Random Strategy)                   |\n'),
  write('|                                                                       |\n'),
  write('|                       2. Level 2  (Greedy Strategy)                   |\n'),
  write('|                                                                       |\n'),
  write('|                       0. Go Back to Main Menu                         |\n'),
  write('|_______________________________________________________________________|\n').
