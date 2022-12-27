% clear/0
% Clears the screen, for better user experience (UX)
clear :- write('\33\[2J').

menu :-
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
write('|                       0. Exit                                         |\n'),
write('|                                                                       |\n'),
write('|_______________________________________________________________________|\n').
