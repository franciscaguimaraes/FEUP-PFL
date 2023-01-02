/* Files Necessary */
:- consult('display.pl').
:- consult('play.pl').
:- consult('menu.pl').
:- consult('inputs.pl').
:- consult('logic.pl').
:- consult('computer.pl').
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(samsort)).

% play/0
% Start Game
play :-
  clear,
  main_menu, !.