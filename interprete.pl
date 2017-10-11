% =============================================================================
% Universidad Nacional Autónoma de México
% Inteligencia Artificial
%
% Proyecto 1 - Representación del conocimiento
%
% Luis Alejandro Lara Patiño
% Roberto Monroy Argumedo
% Alejandro Ehecatl Morales Huitrón
%
% interprete.pl
% Intérprete de comandos básico implementado en Prolog. Permite realizar
% operaciones sobre la base de conocimiento.
% =============================================================================

interprete(Base) :-
	read(Comando),
	interprete(Base, Comando).

interprete(_, salir) :- !.

interprete(Base, Comando) :-
	comando(Comando, Base, NuevaBase), !,
	interprete(NuevaBase).

interprete(Base, Comando) :-
	escribir(['Comando inválido: ', Comando, '.']),
	interprete(Base).
