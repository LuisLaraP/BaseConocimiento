% =============================================================================
% Universidad Nacional Autónoma de México
% Inteligencia Artificial
%
% Proyecto 1 - Representación del comocimiento
%
% Luis Alejandro Lara Patiño
% Roberto Monroy Argumedo
% Alejandro Morales Huitrón
%
% interprete.pl
% Intérprete de comandos básico implementado en Prolog. Permite realizar
% operaciones sobre la base de conocimiento.
% =============================================================================

interprete :-
	repeat,
	read(Comando),
	(Comando \= end_of_file, Comando \= salir ->
		kb(Base),
		call(comando(Comando), Base, NuevaBase),
		retract(kb(Base)),
		assert(kb(NuevaBase)),
		fail;
		!
	).
