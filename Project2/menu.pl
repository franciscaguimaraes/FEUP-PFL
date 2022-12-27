% option_dif(+Code, -Difficulty)
% Gives the Difficulty associated with the code provided as an option
option_dif(1, 'Easy').
option_dif(2, 'Normal').

mode(1, 'PP').
mode(2, 'PC').
mode(3, 'CC').

board(1, '5x5').
board(2, '7x7').

% clear/0
% Clears the screen, for better user experience (UX)
clear :- write('\33\[2J').

backMainMenu(0) :-
  mainMenu. 

mainMenu :-
  printMenu,
  askMenuOption(0, 3, Number),
  manageOption(Number).

manageOption(0) :-      
  write('\nExiting...\n\n').
manageOption(Number) :-
  clear,
  mode(Number, Mode),
  printBoardMenu,
  askMenuOption(0, 2, Size),
  manageBoardOption(Size, Mode).

manageBoardOption(0, _) :-
  mainMenu. 
manageBoardOption(Size, Mode) :-
  clear,
  printDifficultyMenu,
  askMenuOption(0, 2, Number),
  backMainMenu(Number),
  option_dif(Number, Difficulty),
  startGame(Mode, Size, Difficulty).

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
write('|                         Choose a Board Size                           |\n'),
write('|                                                                       |\n'),
write('|                       1. 5x5                                          |\n'),
write('|                                                                       |\n'),
write('|                       2. 7x7                                          |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Main Menu                         |\n'),
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').

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
write('|                         Choose a Board Size                           |\n'),
write('|                                                                       |\n'),
write('|                       1. Easy                                         |\n'),
write('|                                                                       |\n'),
write('|                       2. Normal                                       |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Main Menu                         |\n'),
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').