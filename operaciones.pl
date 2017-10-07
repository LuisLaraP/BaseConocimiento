% =============================================================================
% Universidad Nacional Autónoma de México
% Inteligencia Artificial
%
% Proyecto 1 - Representación del comocimiento
%
% Luis Alejandro Lara Patiño
% Roberto Monroy Argumedo
% Alejandro Ehecatl Morales Huitrón
%
% operaciones.pl
% Operaciones realizables sobre la base de conocimiento.
% =============================================================================

:- op(800, xfx, '=>').

% Agregar información ---------------------------------------------------------

agregarPropiedadObjetos([], _, _, Base, Base).
agregarPropiedadObjetos([objeto(N, P, Props, R) | Rs], Propiedad, nil, Base, NBase) :-
	agregar(Propiedad, Props, NuevasProps), !,
	reemplazar(objeto(N, P, Props, R), objeto(N, P, NuevasProps, R), Base, Temp),
	agregarPropiedadObjetos(Rs, Propiedad, nil, Temp, NBase).
agregarPropiedadObjetos([objeto(N, P, Props, R) | Rs], Propiedad, Valor, Base, NBase) :-
	agregar(Propiedad => Valor, Props, NuevasProps), !,
	reemplazar(objeto(N, P, Props, R), objeto(N, P, NuevasProps, R), Base, Temp),
	agregarPropiedadObjetos(Rs, Propiedad, Valor, Temp, NBase).

errorNuevaClase(clase(_, nil, _, _), Base, Mensaje) :-
	buscar(clase(_, nil, _, _), Base, _),
	Mensaje = ['No puede haber más de una clase raíz.'].
errorNuevaClase(clase(_, Padre, _, _), Base, Mensaje) :-
	Padre \= nil,
	\+ existeClase(Padre, Base),
	Mensaje = ['No se conoce la clase ', Padre, '.'].
errorNuevaClase(clase(Nombre, _, _, _), Base, Mensaje) :-
	existeClase(Nombre, Base),
	Mensaje = ['Ya existe la clase ', Nombre, '.'].

errorNuevaPropiedadClase(Nombre, _, Base, Mensaje) :-
	\+ existeClase(Nombre, Base),
	Mensaje = ['No se conoce la clase ', Nombre, '.'].
errorNuevaPropiedadClase(Nombre, Propiedad, Base, Mensaje) :-
	buscar(clase(Nombre, _, _, _), Base, Clase),
	claseTienePropiedad(Propiedad, Clase),
	Mensaje = ['La clase ', Nombre, ' ya tiene la propiedad ', Propiedad].
errorNuevaPropiedadClase(Nombre, not(Propiedad), Base, Mensaje) :-
	buscar(clase(Nombre, _, _, _), Base, Clase),
	claseTienePropiedad(Propiedad, Clase),
	Mensaje = ['La clase ', Nombre, ' ya tiene la propiedad ', Propiedad].
errorNuevaPropiedadClase(Nombre, Propiedad, Base, Mensaje) :-
	buscar(clase(Nombre, _, _, _), Base, Clase),
	claseTienePropiedad(not(Propiedad), Clase),
	Mensaje = ['La clase ', Nombre, ' ya tiene la propiedad ', Propiedad,
		' en forma negada'].

errorNuevoObjeto(objeto(_, Padre, _, _), Base, Mensaje) :-
	\+ existeClase(Padre, Base),
	Mensaje = ['No se conoce la clase ', Padre, '.'].

errorNuevaPropiedadObjeto(Nombre, _, Base, Mensaje) :-
	\+ existeObjeto(Nombre, Base),
	Mensaje = ['No se conoce el objeto ', Nombre, '.'].
errorNuevaPropiedadObjeto(Nombre, Propiedad, Base, Mensaje) :-
	filtrar(objetoSeLlama(Nombre), Base, Objetos),
	filtrar(objetoTienePropiedad(Propiedad), Objetos, Filtrada),
	Filtrada \= [],
	Mensaje = ['Los siguientes objetos ya tienen la propiedad ', Propiedad,
		': ', Filtrada].

% Eliminar información --------------------------------------------------------

errorEliminarClase(Nombre, Base, Mensaje) :-
	\+ existeClase(Nombre, Base),
	Mensaje = ['No se conoce la clase ', Nombre, '.'].

errorEliminarObjeto(Nombres, Base, Mensaje) :-
	\+ existeObjeto(Nombres, Base),
	Mensaje = ['No se conoce ningún objeto llamado ', Nombres, '.'].

errorEliminarPropiedadClase(Nombre, Propiedad, Base, Mensaje) :-
	buscar(clase(Nombre, _, _, _), Base, Clase),
	\+ claseTienePropiedad(Propiedad, Clase),
	Mensaje = ['La clase ', Nombre, ' no tiene la propiedad ', Propiedad, '.'].

% Consultas -------------------------------------------------------------------

clasesHijasDe(Nombre, Base, Hijos) :-
	filtrar(claseTienePadre(Nombre), Base, Hijos).

existeClase(Nombre, Base) :-
	estaEn(Base, clase(Nombre, _, _, _)).

existeObjeto(Nombre, Base) :-
	filtrar(objetoSeLlama(Nombre), Base, Resultado),
	Resultado \= [].

objetosHijosDe(Nombre, Base, Hijos) :-
	filtrar(objetoTienePadre(Nombre), Base, Hijos).

% Propiedades de clases --------------------------------------------------------

cambiarPadre(_, [], Base, Base).
cambiarPadre(Padre, [clase(Nombre, Viejo, Props, Rels)| R], Base, NuevaBase) :-
	reemplazar(
		clase(Nombre, Viejo, Props, Rels),
		clase(Nombre, Padre, Props, Rels), Base, Temp),
	cambiarPadre(Padre, R, Temp, NuevaBase).
cambiarPadre(Padre, [objeto(Nombres, Viejo, Props, Rels)| R], Base, NuevaBase) :-
	reemplazar(
		objeto(Nombres, Viejo, Props, Rels),
		objeto(Nombres, Padre, Props, Rels), Base, Temp),
	cambiarPadre(Padre, R, Temp, NuevaBase).

claseTienePadre(Padre, clase(_, Padre, _ , _)).

claseTienePropiedad(Propiedad, clase(_, _, Props, _)) :-
	estaEn(Props, Propiedad).
claseTienePropiedad(Propiedad, clase(_, _, Props, _)) :-
	estaEn(Props, Propiedad => _).

% Propiedades de objetos -------------------------------------------------------

objetoSeLlama(Nombres, objeto(ListaNombres, _, _, _)) :-
	is_list(Nombres), !,
	paraCada(Nombres, estaEn(ListaNombres)).
objetoSeLlama(Nombre, objeto(ListaNombres, _, _, _)) :-
	estaEn(ListaNombres, Nombre).

objetoTienePadre(Padre, objeto(_, Padre, _, _)).

objetoTienePropiedad(Propiedad, objeto(_, _, Props, _)) :-
	estaEn(Props, Propiedad).
objetoTienePropiedad(Propiedad, objeto(_, _, Props, _)) :-
	estaEn(Props, Propiedad => _).
	
	
% Extensión de una clase-----------------------------------------------

% Obtiene objetos de una clase dada, declarados directamente
obClase(_,[],[]).
obClase(Clase,[objeto(X,Clase,_,_)|N],[X|T]):-
	obClase(Clase,N,T),!.
obClase(Clase,[_|T1],L):-
	obClase(Clase,T1,L).

% Lista de subclases de una clase
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
	listPropClas(Prop,TB,TR).
listPropClas(Prop,[_|TB],LR) :-
	listPropClas(Prop,TB,LR).

% Obtinene la lista de objetos que cumplen una propiedad
listPropObj(_,[],[]).
listPropObj(Prop,[objeto(Nom,_,L,_)|TB],LR) :-
	listPropAux(Prop,Nom,L,S),
        concatena(S,TR,LR),
	listPropObj(Prop,TB,TR).
listPropObj(Prop,[_|TB],LR) :-
	listPropObj(Prop,TB,LR).

% Verifica si una clase u objeto en particular tiene una propiedad
listPropAux(_,_,[],[]).
listPropAux(Prop,Nom,[Prop|T],[Nom:si|R]) :-
	listPropAux(Prop,Nom,T,R),!.
listPropAux(Prop,Nom,[no(Prop)|T],[Nom:no|R]) :-
	listPropAux(Prop,Nom,T,R),!.
listPropAux(Prop,Nom,[Prop=>X|T],[Nom:X|R]) :-
	listPropAux(Prop,Nom,T,R),!.
listPropAux(Prop,Nom,[no(Prop=>X)|T],[no(Nom:X)|R]) :-
	listPropAux(Prop,Nom,T,R),!.
listPropAux(Prop,Nom,[_|T],R) :-
	listPropAux(Prop,Nom,T,R).

% Revisa las clases que cumplen una propiedad bajo herencia
propHer(Prop,KB,[],[]).
propHer(KB,[Clase:si|R],L) :-
       extensionClase(Clase,KB,S),
       ponSi(S,S1),
       propHer(KB,R,P),
       concatena(S1,P,P1),
       verifica(P1,L).
propHer(KB,[Clase:no|R],L) :-
       extensionClase(Clase,KB,S),
       ponNo(S,S1),
       propHer(KB,R,P),
       concatena(S1,P,P1),
       verifica(P1,L).
propHer(KB,[Clase:X|R],L) :-
       extensionClase(Clase,KB,S),
       ponClase(S,X,S1),
       propHer(KB,R,P),
       concatena(S1,P,P1),
       verifica(P1,L).
propHer(KB,[no(Clase:X)|R],L) :-
       extensionClase(Clase,KB,S),
       ponClaseNo(S,X,S1),
       propHer(KB,R,P),
       concatena(S1,P,P1),
       verifica(P1,L).
	

eProp(Prop,KB,L) :-
	listPropObj(Prop,KB,R1),
	listPropClas(Prop,KB,R2),
	propHer(KB,R2,R3),
	concatena(R1,R3,R4),
	verifica(R4,L).


% Clases a las que pertenece un objeto


% Listados de propiedades y relaciones

propiedadesObjeto(objeto(_,_,Props,_),Props).

propiedadesClase(clase(_,_,Props,_),Props).

relacionesObjeto(objeto(_,_,_,Rels),Rels).

relacionesClase(clase(_,_,_,Rels),Rels).
