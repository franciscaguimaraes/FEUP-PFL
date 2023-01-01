/* Necessary Files */
:- consult('display.pl').
:- consult('play.pl').
:- consult('menu.pl').
:- consult('inputs.pl').
:- consult('logic.pl').
:- consult('computer.pl').
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).

% Start predicate
hadron :-
  play.