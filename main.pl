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
% main.pl
% Punto de entrada a la aplicación. Para ejecutar este programa, realizar la
% consulta 'iniciar.' desde la interfaz de Prolog. O bien, ejecutar el
% siguiente comando en una terminal:
%     swipl -f run.pl -g "iniciar, halt."
% =============================================================================

:- [comandos].
:- [interprete].
:- [listas].
:- [operaciones].
:- [utilidades].
:- [consultas].
:- [modificar].
	
:- op(800, xfx, '=>').

iniciar :-
	assert(kb([])),
	interprete.
