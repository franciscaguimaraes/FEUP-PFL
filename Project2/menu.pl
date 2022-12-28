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
  playerMenu(Number).

playerMenu(Mode) :-
  printPlayerMenu,
  askMenuOption(0, 2, Player),
  managePlayerOption(Player, Mode).
 
managePlayerOption(0, _) :-
  clear,
  mainMenu. 
managePlayerOption(Player, Mode) :-
  clear,
  boardMenu(Player, Mode).

boardMenu(Player, Mode) :-
  printBoardMenu,
  askMenuOption(0, 2, Size),
  manageBoardOption(Size, Player, Mode).

manageBoardOption(0, _, Mode) :-
  clear,
  playerMenu(Mode).
manageBoardOption(Size, Player, Mode) :-
  clear,
  difficultyMenu(Size, Player, Mode).

difficultyMenu(Size, Player, Mode) :-
  printDifficultyMenu,
  askMenuOption(0, 2, Difficulty),
  manageDifficultyOption(Difficulty, Size, Player, Mode).

manageDifficultyOption(0, _, Player, Mode) :-
  clear, 
  boardMenu(Player, Mode).
manageDifficultyOption(Difficulty, Size, Player, Mode) :-
  startGame(Difficulty, Size, Player, Mode).

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
  write('|                       1. x - Player 1 (Starts First)                  |\n'),
  write('|                                                                       |\n'),
  write('|                       2. o - Player 2                                 |\n'),
  write('|                                                                       |\n'),
  write('|                       0. Go Back to Main Menu                         |\n'),
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
write('|                       Choose a Board Size:                            |\n'),
write('|                                                                       |\n'),
write('|                       1. 5x5                                          |\n'),
write('|                                                                       |\n'),
write('|                       2. 7x7                                          |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Player Menu                       |\n'),
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
write('|                       Choose a Difficulty Level:                      |\n'),
write('|                                                                       |\n'),
write('|                       1. Easy (Random)                                |\n'),
write('|                                                                       |\n'),
write('|                       2. Normal (Greedy)                              |\n'),
write('|                                                                       |\n'),
write('|                       0. Go Back to Board Menu                        |\n'),
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').