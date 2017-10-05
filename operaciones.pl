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
% operaciones.pl
% Operaciones realizables sobre la base de conocimiento.
% =============================================================================

:- op(800, xfx, '=>').

% Agregar información ---------------------------------------------------------

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

errorNuevoObjeto(objeto(_, Padre, _, _), Base, Mensaje) :-
	\+ existeClase(Padre, Base),
	Mensaje = ['No se conoce la clase ', Padre, '.'].

% Eliminar información --------------------------------------------------------

errorEliminarClase(Nombre, Base, Mensaje) :-
	\+ existeClase(Nombre, Base),
	Mensaje = ['No se conoce la clase ', Nombre, '.'].

errorEliminarObjeto(Nombres, Base, Mensaje) :-
	\+ existeObjeto(Nombres, Base),
	Mensaje = ['No se conoce ningún objeto llamado ', Nombres, '.'].

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
