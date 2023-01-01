% Include's of the necessary files
:-consult('board.pl').
:-consult('play.pl').
:-consult('logic.pl').
:-consult('bot.pl').
:-consult('menus.pl').
:-consult('inputs.pl').
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(samsort)).
:- use_module(library(system)).

:- dynamic gameboard/1. 

% play/0
% Start predicate
play :-
	clear_screen,
	menu.
