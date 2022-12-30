% clear/0
% Clears the screen, for better user experience (UX)
clear :- write('\33\[2J').

% mainMenu/0
% Prints the mainMenu and asks for user input to game mode
main_menu :-
  printMenu,
  askMenuOption(0, 3, Number),
  manageOption(Number).

menu_board_size(Size) :- 
  printBoardMenu,
  askMenuOption(0, 2, Size).

menu_player_choose(Player) :- 
  printPlayerMenu,
  askMenuOption(0, 2, Player).

menu_difficulty_choose(Difficulty) :- 
  printDifficultyMenu,
  askMenuOption(0, 2, Difficulty).


manage_option(0) :-
  write('\nThank you for Playing! Exiting...\n\n').

manage_option(1) :-
  asserta(player(1, 'Player')),
  asserta(player(2, 'Player')),
  menu_board_size(Size),
  clear, start_game_pp(Size), clear.

manage_option(2) :-
  menu_board_size(Size),
  clear, menu_pc(Size), clear.

manage_option(3) :-
  menu_board_size(Size),
  clear, menu_cc(Size), clear.

start_game_pp (0) :-
  main_menu.

start_game_pp (Number) :-
  option_size(Option, Size),
    initial_state(Size,0),
    asserta(turn(-1)),
    game_loop,
    start_game_pp (Number)

menu_pc(0) :-
  main_menu.

menu_choose_player(1) :-
  menu_choose_player(Player),
  menu_choose_difficulty











% manageOption(Number)
% Given option chosen by user in mainMenu, takes action by exiting or entering playerMenu/boardMenu
manageOption(0) :-      
  write('\nExiting...\n\n').
manageOption(2) :-      
  clear,
  playerMenu(2).
manageOption(Mode) :-
  clear,
  boardMenu(0, Mode).

% playerMenu(Mode)
% Prints playerMenu taken into consideration the game mode chosen in the mainMenu. 
% Asks user input for which player to choose.
playerMenu(Mode) :-
  printPlayerMenu,
  askMenuOption(0, 2, Player),
  managePlayerOption(Player, Mode).
 
% managePlayerOption(Player, Mode)
% Given option chosen by user in playerMenu, takes action by going back to main menu or entering boardMenu with 
% game mode and player already chosen.
managePlayerOption(0, _) :-
  clear,
  mainMenu. 
managePlayerOption(Player, Mode) :-
  clear,
  boardMenu(Player, Mode).

% boardMenu(Player, Mode)
% Prints boardMenu taken into consideration game mode and player chosen. Asks user input for game board size.
boardMenu(Player, Mode) :-
  printBoardMenu,
  askMenuOption(0, 2, Size),
  manageBoardOption(Size, Player, Mode).

% manageBoardOption(Size, Player, Mode)
% Given option chosen by user in boardMenu and previous menus: if option 0 is chosen, takes action by going back to
% playerMenu if game mode is Player vs Computer and mainMenu otherwise; if other option is chosen, starts game if 
% game mode is player vs player otherwise enters difficultyMenu with game mode, player chosen and board size taken
% into consideration.
manageBoardOption(0, _, 2) :-
  clear,
  playerMenu(2).
manageBoardOption(0, _, Mode) :-
  clear,
  mainMenu.
manageBoardOption(Size, Player, 1) :-
  clear,
  startGame(0, Size, Player, 1).
manageBoardOption(Size, Player, Mode) :-
  clear,
  difficultyMenu(Size, Player, Mode).

% difficultyMenu(Size, Player, Mode)
% Prints difficultyMenu taken into consideration game mode, player chosen and board size. Asks user input 
% for difficulty level.
difficultyMenu(Size, Player, Mode) :-
  printDifficultyMenu,
  askMenuOption(0, 2, Difficulty),
  manageDifficultyOption(Difficulty, Size, Player, Mode).

% manageDifficultyOption(Difficulty, Size, Player, Mode)
% Given option chosen by user in difficultyMenu, takes action by going back to boardMenu or starting the game
% with all variables: game mode, player chosen, board size and difficulty already filled.
manageDifficultyOption(0, _, Player, Mode) :-
  clear, 
  boardMenu(Player, Mode).
manageDifficultyOption(Difficulty, Size, Player, Mode) :-
  startGame(Difficulty, Size, Player, Mode).

% printMenu/0
% prints menu to choose game mode 
printMenu :-
write(' _______________________________________________________________________ \n'),
write('|                                                                       |\n'), 
write('|                                                                       |\n'),
write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
write('|               -----------------------------------------               |\n'),
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
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').

% printPlayerMenu/0
% prints menu to choose player 
printPlayerMenu :-
write(' _______________________________________________________________________ \n'),
write('|                                                                       |\n'), 
write('|                                                                       |\n'),
write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
write('|               -----------------------------------------               |\n'),
write('|                                                                       |\n'),
write('|                       Choose a Player:                                |\n'),
write('|                                                                       |\n'),
write('|                       1. x - Player 1  (Starts First)                 |\n'),
write('|                                                                       |\n'),
write('|                       2. o - Player 2                                 |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back                                      |\n'),
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').

% printBoardMenu/0
% prints menu for board size
printBoardMenu :-
write(' _______________________________________________________________________ \n'),
write('|                                                                       |\n'), 
write('|                                                                       |\n'),
write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
write('|               -----------------------------------------               |\n'),
write('|                                                                       |\n'),
write('|                       Choose a Board Size:                            |\n'),
write('|                                                                       |\n'),
write('|                       1. 5x5                                          |\n'),
write('|                                                                       |\n'),
write('|                       2. 7x7                                          |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back                                      |\n'),
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').

% printDifficultyMenu/0
% prints menu for difficulty level
printDifficultyMenu :-
write(' _______________________________________________________________________ \n'),
write('|                                                                       |\n'), 
write('|                                                                       |\n'),
write('|                 *   *  ***  ****   ****   ***   **   *                |\n'),
write('|                 *   * *   * *   *  *   * *   *  * *  *                |\n'),
write('|                 ***** ***** *    * ****  *   *  *  * *                |\n'),
write('|                 *   * *   * *   *  * *   *   *  *   **                |\n'),
write('|                 *   * *   *  ***   *  *   ***   *    *                |\n'),
write('|               -----------------------------------------               |\n'),
write('|                                                                       |\n'),
write('|                       Choose a Difficulty Level:                      |\n'),
write('|                                                                       |\n'),
write('|                       1. Easy                                         |\n'),
write('|                                                                       |\n'),
write('|                       2. Normal                                       |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back                                      |\n'),
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').

