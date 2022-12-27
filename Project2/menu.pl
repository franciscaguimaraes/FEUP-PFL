% clear/0
% Clears the screen, for better user experience (UX)
clear :- write('\33\[2J').

mainMenu :-
  printMenu,
  askMenuOption(0, 3, Number),
  manageOption(Number).

manageOption(0) :-      
  write('\nExiting...\n\n').
manageOption(Number) :-
  clear,
  boardMenu(Number).

boardMenu(Mode) :-
  printBoardMenu,
  askMenuOption(0, 2, Size),
  manageBoardOption(Size, Mode).
 
manageBoardOption(0, _) :-
  clear,
  mainMenu. 
manageBoardOption(Size, Mode) :-
  clear,
  difficultyMenu(Size, Mode).

difficultyMenu(Size, Mode) :-
  printDifficultyMenu,
  askMenuOption(0, 2, Difficulty),
  manageDifficultyOption(Difficulty, Size, Mode).

manageDifficultyOption(0, _, Mode) :-
  clear,
  boardMenu(Mode).
manageDifficultyOption(Difficulty, Size, Mode) :-
  startGame(Difficulty, Size, Mode).

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
write('|                       Choose a Difficulty Level                       |\n'),
write('|                                                                       |\n'),
write('|                       1. Easy                                         |\n'),
write('|                                                                       |\n'),
write('|                       2. Normal                                       |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Board Menu                        |\n'),
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').