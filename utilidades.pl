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
% utilidades.pl
% Predicados para realizar operaciones misceláneas.
% =============================================================================

escribir(Lista) :-
	paraCada(Lista, write), nl.
