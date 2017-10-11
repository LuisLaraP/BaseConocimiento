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
% consultas.pl
% Predicados para consultas.
% =============================================================================


% Predicados para la extensión de una clase-----------------------------------

% Obtiene objetos de una clase, declarados directamente.
%	Arg. 1 - La clase en cuestión.
%	Arg. 2 - La base de conocimiento.
%	Arg. 3 - Los objetos de la clase, declarados directamente
obClase(_,[],[]).
obClase(Clase,[objeto(X,Clase,_,_)|N],[X|T]):-
	obClase(Clase,N,T),!.
obClase(Clase,[_|T1],L):-
	obClase(Clase,T1,L).

% Lista de subclases de una clase
%	Arg. 1 - La clase en cuestión.
%	Arg. 2 - La base de conocimiento.
%	Arg. 3 - Lista de sus subclases
subclases(_,[],[]).
subclases(Clase,[clase(N,Clase,_,_)|T],[N|C]):-
	subclases(Clase,T,C),!.
subclases(Clase,[_|T],L):-
	subclases(Clase,T,L).

% Lista de subclases de una clase bajo la relacion de herencia
todasSubclases(Clase,KB,P):-
	subclases(Clase,KB,S),
	intermedia(S,KB,P).

intermedia([],_,[]).
intermedia([H|T],KB,[H|P]):-
	todasSubclases(H,KB,P1),
	intermedia(T,KB,P2),
	concatena(P1,P2,P).

extensionClase(Clase,KB,E):-
	obClase(Clase,KB,O),
	todasSubclases(Clase,KB,S),
	auxiliarExtensionClase(S,KB,A),
	concatena(O,A,E).

auxiliarExtensionClase([],_,[]).
auxiliarExtensionClase([H|T],KB,R):-
	obClase(H,KB,O),
	auxiliarExtensionClase(T,KB,P),
	concatena(O,P,R).

% Extension de una propiedad---------------------------------------------

% Obtiene la lista de clases que cumplen una propiedad
listPropClas(_,[],[]).
listPropClas(Prop,[clase(Nom,_,L,_)|TB],LR) :-
	listPropAux(Prop,Nom,L,S),
        concatena(S,TR,LR),
	listPropClas(Prop,TB,TR),!.
listPropClas(Prop,[_|TB],LR) :-
	listPropClas(Prop,TB,LR).

% Obtinene la lista de objetos que cumplen una propiedad
listPropObj(_,[],[]).
listPropObj(Prop,[objeto(Nom,_,L,_)|TB],LR) :-
	listPropAux(Prop,Nom,L,S),
        concatena(S,TR,LR),
	listPropObj(Prop,TB,TR),!.
listPropObj(Prop,[_|TB],LR) :-
	listPropObj(Prop,TB,LR).

% Verifica si una clase u objeto en particular tiene una propiedad
listPropAux(_,_,[],[]).
listPropAux(Prop,Nom,[Prop|T],[Nom:si|R]) :-
	listPropAux(Prop,Nom,T,R),!.
listPropAux(Prop,Nom,[not(Prop)|T],[Nom:no|R]) :-
	listPropAux(Prop,Nom,T,R),!.
listPropAux(Prop,Nom,[Prop=>X|T],[Nom:X|R]) :-
	listPropAux(Prop,Nom,T,R),!.
listPropAux(Prop,Nom,[not(Prop=>X)|T],[no(Nom:X)|R]) :-
	listPropAux(Prop,Nom,T,R),!.
listPropAux(Prop,Nom,[_|T],R) :-
	listPropAux(Prop,Nom,T,R),!.

% Revisa las clases que cumplen una propiedad o relación bajo herencia
propHer(_,[],[]).
propHer(KB,[Clase:si|R],L) :-
       extensionClase(Clase,KB,S),
       ponSi(S,S1),
       propHer(KB,R,P),
       actualiza(P,S1,L),!.
propHer(KB,[Clase:no|R],L) :-
       extensionClase(Clase,KB,S),
       ponNo(S,S1),
       propHer(KB,R,P),
       actualiza(P,S1,L),!.
propHer(KB,[Clase:X|R],L) :-
       extensionClase(Clase,KB,S),
       ponClase(S,X,S1),
       propHer(KB,R,P),
       actualiza(P,S1,L),!.
propHer(KB,[no(Clase:X)|R],L) :-
       extensionClase(Clase,KB,S),
       ponClaseNo(S,X,S1),
       propHer(KB,R,P),
       actualiza(P,S1,L),!.

eProp(Prop,KB,L) :-
	listPropObj(Prop,KB,R1),
	listPropClas(Prop,KB,R2),
	propHer(KB,R2,R3),
	concatena(R1,R3,R4),
	revisaDefaults(R4,L).

% Extensión de una relación--------------------------------------------

% Obtiene la lista de clases que cumplen una relación
listRelClas(_,[],[]).
listRelClas(Rel,[clase(Nom,_,_,L)|TB],LR) :-
	listRelAux(Rel,Nom,L,S),
        concatena(S,TR,LR),
	listRelClas(Rel,TB,TR),!.
listRelClas(Rel,[_|TB],LR) :-
	listRelClas(Rel,TB,LR).

% Obtinene la lista de objetos que cumplen una relación
listRelObj(_,[],[]).
listRelObj(Rel,[objeto(Nom,_,_,L)|TB],LR) :-
	listRelAux(Rel,Nom,L,S),
        concatena(S,TR,LR),
	listRelObj(Rel,TB,TR),!.
listRelObj(Rel,[_|TB],LR) :-
	listRelObj(Rel,TB,LR).

% Verifica si una clase u objeto en particular tiene una relación
listRelAux(_,_,[],[]).
listRelAux(Rel,Nom,[Rel=>X|T],[Nom:X|R]) :-
	listPropAux(Rel,Nom,T,R),!.
listRelAux(Rel,Nom,[not(Rel=>X)|T],[no(Nom:X)|R]) :-
	listPropAux(Rel,Nom,T,R),!.
listRelAux(Rel,Nom,[_|T],R) :-
	listPropAux(Rel,Nom,T,R),!.

eRel(Rel,KB,L) :-
	listRelObj(Rel,KB,R1),
	listRelClas(Rel,KB,R2),
	propHer(KB,R2,R3),
	concatena(R1,R3,R4),
	revisaDefaults(R4,L).


% Clases a las que pertenece un objeto-----------------------------

% Devuelve el camino de ancestros hasta la raíz (top)
clasesObjeto(objeto(_,Clase,_,_),KB,R):-
	buscar(clase(Clase,_,_,_),KB,Linea),
	buscaAncestros(Linea,KB,R).

buscaAncestros(clase(top,_,_,_),_,[top]).
buscaAncestros(clase(Clase,Ancestro,_,_),KB,[Clase|R]):-
	buscar(clase(Ancestro,_,_,_),KB,B),!,
	buscaAncestros(B,KB,R).
	

% Listados de propiedades y relaciones--------------------------

propiedadesObjeto(objeto(_,_,Props,_),Props).

propiedadesClase(clase(_,_,Props,_),Props).

relacionesObjeto(objeto(_,_,_,Rels),Rels).

relacionesClase(clase(_,_,_,Rels),Rels).
