% difficulty according to the option chosen
option_difficulty(1, 'Easy').
option_difficulty(2, 'Greedy').

% clear/0
% Clears the screen, for better user experience (UX)
clear :- write('\33\[2J').

main_menu :-
  clear,
  print_menu,
  ask_menu_option(0, 3, Number),
  manage_option(Number).

menu_board_size(Size) :- 
  clear,
  print_board_menu,
  ask_menu_option(0, 2, Size).

menu_choose_player(Player) :- 
  clear,
  print_player_menu,
  ask_menu_option(0, 2, Player).

menu_choose_difficulty(Difficulty) :- 
  clear,
  print_difficulty_menu,
  ask_menu_option(0, 2, Difficulty).

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

manage_board_option_pp(0) :-
  main_menu.
manage_board_option_pp(Number) :-
  start_game(Number, 'Human', 'Human', 0).

manage_board_option_pc(0) :-
  main_menu.
manage_board_option_pc(Size) :-
  menu_choose_player(Player),
  manage_player_option_pc(Size, Player).

manage_player_option_pc(_,0) :- 
  main_menu.
manage_player_option_pc(Size, Player) :-
  menu_choose_difficulty(Difficulty),
  manage_difficulty_option_pc(Size, Player, Difficulty).

manage_difficulty_option_pc(_,_,0) :-
  main_menu.
manage_difficulty_option_pc(Size, 1, Difficulty) :-
  start_game(Size, 'Human', 'Computer', Difficulty).
manage_difficulty_option_pc(Size, 2, Difficulty) :-
  start_game(Size, 'Computer', 'Human', Difficulty).

manage_board_option_cc(0):-
  main_menu.
manage_board_option_cc(Size):-
  menu_choose_difficulty(Difficulty),
  manage_difficulty_option_cc(Size, Difficulty).

manage_difficulty_option_cc(_,0):-
  main_menu.
manage_difficulty_option_cc(Size, Difficulty):-
  start_game(Size, 'Computer', 'Computer', Difficulty).

% printMenu/0
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

% printPlayerMenu/0
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

% printBoardMenu/0
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

% printDifficultyMenu/0
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
write('|                       1. Easy  (Random Strategy)                      |\n'),
write('|                                                                       |\n'),
write('|                       2. Normal  (Greedy Strategy)                    |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Main Menu                         |\n'),
write('|_______________________________________________________________________|\n').
