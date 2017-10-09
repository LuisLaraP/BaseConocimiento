:- op(800, xfx, '=>').

% Modificar el nombre de una clase.
modificarNombreClase(AntiguoNom, NuevoNom, Base, NuevaBase) :- mnc(AntiguoNom, NuevoNom, Base, NB) , mrs(AntiguoNom, NuevoNom, NB, NuevaBase).

% Modificar el nombre de un objeto.
modificarNombreObjeto(AntiguoNom, NuevoNom, Base, NuevaBase) :- mno(AntiguoNom, NuevoNom, Base, NB), mrs(AntiguoNom, NuevoNom, NB, NuevaBase).

% Modificar propiedad.
modificaPropiedad(Propiedad, NuevoValor, Base, NuevaBase) :- mp(Propiedad, NuevoValor, Base, NuevaBase).

% Modifica relacion.
modificaRelacion(Relacion, NuevoValor, Base, NuevaBase) :- mr(Relacion, NuevoValor, Base, NuevaBase).

% Auxiliar: Modificar el nombre de una clase en los campos: Nombre de la clase, padre de una clase o clase de un objeto.
mnc(_, _, [], []).
mnc(AntiguoNom, NuevoNom, [clase(AntiguoNom, Pa, Pr, Re) | T], [clase(NuevoNom, Pa, Pr, Re) | NT]) :-
	mnc(AntiguoNom, NuevoNom, T, NT).
mnc(AntiguoNom, NuevoNom, [clase(No, AntiguoNom, Pr, Re) | T], [clase(No, NuevoNom, Pr, Re) | NT]) :-
	mnc(AntiguoNom, NuevoNom, T, NT).
mnc(AntiguoNom, NuevoNom, [objeto(No, AntiguoNom, Pr, Re) | T], [objeto(No, NuevoNom, Pr, Re) | NT]) :-
	mnc(AntiguoNom, NuevoNom, T, NT).
mnc(AntiguoNom, NuevoNom, [H|T], [H|NT]) :-
	mnc(AntiguoNom, NuevoNom, T, NT).

% Auxiliar: Modificar el nombre de un objeto o clase en una relacion.
mrs(_, _, [], []).
mrs(Relacion, NuevaRelacion, [clase(No, Pa, Pr, Re) | T], [clase(No, Pa, Pr, NRe) | NT]) :-
	mod_lista_rel_sust(Relacion, NuevaRelacion, Re, NRe), mrs(Relacion, NuevaRelacion, T, NT).
mrs(Relacion, NuevaRelacion, [objeto(No, Pa, Pr, Re) | T], [objeto(No, Pa, Pr, NRe) | NT]) :-
	mod_lista_rel_sust(Relacion, NuevaRelacion, Re, NRe), mrs(Relacion, NuevaRelacion, T, NT).

% Auxiliar: Modificar el nombre de un objeto o clase en una lista de relaciones.
mod_lista_rel_sust(_, _, [], []).
mod_lista_rel_sust(Relacion, NuevaRelacion, [R=>Relacion | T], [R=>NuevaRelacion | NT]) :-
	mod_lista_rel_sust(Relacion, NuevaRelacion, T, NT).
mod_lista_rel_sust(Relacion, NuevaRelacion, [not(R=>Relacion) | T], [not(R=>NuevaRelacion) | NT]) :-
	mod_lista_rel_sust(Relacion, NuevaRelacion, T, NT).
mod_lista_rel_sust(Relacion, NuevaRelacion, [R | T], [R | NT]) :-
	mod_lista_rel_sust(Relacion, NuevaRelacion, T, NT).

% Auxiliar: Modificar el nombre de un objeto.
mno(_, _, [], []).
mno(AntiguoNom, NuevoNom, [objeto(ID, Cl, Pr, Re) | T], [objeto(NID, Cl, Pr, Re) | NT]) :-
	mno(AntiguoNom, NuevoNom, T, NT), mod_lista_nom(AntiguoNom, NuevoNom, ID, NID).
mno(AntiguoNom, NuevoNom, [H | T], [H | NT]) :- 
	mno(AntiguoNom, NuevoNom, T, NT).

% Auxiliar: Modifica el nombre en una lista de nombres.
mod_lista_nom(_, _, [], []).
mod_lista_nom(AntiguoNombre, NuevoNombre, [AntiguoNombre | T], [NuevoNombre | NT]) :-
	mod_lista_nom(AntiguoNombre, NuevoNombre, T, NT).
mod_lista_nom(AntiguoNombre, NuevoNombre, [N | T], [N | NT]) :-
	mod_lista_nom(AntiguoNombre, NuevoNombre, T, NT).

% Auxiliar: Modicar una propiedad de una clase u objeto.
mp(_, _, [], []).
mp(Propiedad, NuevaPropiedad, [clase(No, Pa, Pr, Re) | T], [clase(No, Pa, NPr, Re) | NT]) :-
	mod_lista_prop(Propiedad, NuevaPropiedad, Pr, NPr), mp(Propiedad, NuevaPropiedad, T, NT).
mp(Propiedad, NuevaPropiedad, [objeto(No, Pa, Pr, Re) | T], [objeto(No, Pa, NPr, Re) | NT]) :-
	mod_lista_prop(Propiedad, NuevaPropiedad, Pr, NPr), mp(Propiedad, NuevaPropiedad, T, NT).

% Auxiliar: Modifica una lista de propiedades.
mod_lista_prop(_, _, [], []).
mod_lista_prop(Propiedad, NuevaPropiedad, [Propiedad=>_ | T], [Propiedad=>NuevaPropiedad | NT]) :-
	mod_lista_prop(Propiedad, NuevaPropiedad, T, NT).
mod_lista_prop(Propiedad, NuevaPropiedad, [not(Propiedad=>_) | T], [not(Propiedad=>NuevaPropiedad) | NT]) :-
	mod_lista_prop(Propiedad, NuevaPropiedad, T, NT).
mod_lista_prop(Propiedad, NuevaPropiedad, [Propiedad | T], [NuevaPropiedad | NT]) :-
	mod_lista_prop(Propiedad, NuevaPropiedad, T, NT).
mod_lista_prop(Propiedad, NuevaPropiedad, [P | T], [P | NT]) :-
	mod_lista_prop(Propiedad, NuevaPropiedad, T, NT).

% Auxiliar: Modifiar una relacion.
mr(_, _, [], []).
mr(Relacion, NuevaRelacion, [clase(No, Pa, Pr, Re) | T], [clase(No, Pa, Pr, NRe) | NT]) :-
	mod_lista_rel(Relacion, NuevaRelacion, Re, NRe), mr(Relacion, NuevaRelacion, T, NT).
mr(Relacion, NuevaRelacion, [objeto(No, Pa, Pr, Re) | T], [objeto(No, Pa, Pr, NRe) | NT]) :-
	mod_lista_rel(Relacion, NuevaRelacion, Re, NRe), mr(Relacion, NuevaRelacion, T, NT).

% Auxiliar: Modifica una lista de relaciones.
mod_lista_rel(_, _, [], []).
mod_lista_rel(Relacion, NuevaRelacion, [Relacion=>_ | T], [Relacion=>NuevaRelacion | NT]) :-
	mod_lista_rel(Relacion, NuevaRelacion, T, NT).
mod_lista_rel(Relacion, NuevaRelacion, [not(Relacion=>_) | T], [not(Relacion=>NuevaRelacion) | NT]) :-
	mod_lista_rel(Relacion, NuevaRelacion, T, NT).
mod_lista_rel(Relacion, NuevaRelacion, [R | T], [R | NT]) :-
	mod_lista_rel(Relacion, NuevaRelacion, T, NT).
