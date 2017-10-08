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

agregarPropiedadObjetos([], _, _, Base, Base).
agregarPropiedadObjetos([objeto(N, P, Props, R) | Rs], Propiedad, nil, Base, NBase) :-
	agregar(Propiedad, Props, NuevasProps), !,
	reemplazar(objeto(N, P, Props, R), objeto(N, P, NuevasProps, R), Base, Temp),
	agregarPropiedadObjetos(Rs, Propiedad, nil, Temp, NBase).
agregarPropiedadObjetos([objeto(N, P, Props, R) | Rs], Propiedad, Valor, Base, NBase) :-
	agregar(Propiedad => Valor, Props, NuevasProps), !,
	reemplazar(objeto(N, P, Props, R), objeto(N, P, NuevasProps, R), Base, Temp),
	agregarPropiedadObjetos(Rs, Propiedad, Valor, Temp, NBase).

verificarNuevaClase(clase(_, nil, _, _), Base) :-
	buscar(clase(_, nil, _, _), Base, _),
	error(['No puede haber más de una clase raíz.']), !, fail.
verificarNuevaClase(clase(_, Padre, _, _), Base) :-
	Padre \= nil,
	\+ existeClase(Padre, Base),
	error(['No se conoce la clase ', Padre, '.']), !, fail.
verificarNuevaClase(clase(Nombre, _, _, _), Base) :-
	existeClase(Nombre, Base),
	error(['Ya existe la clase ', Nombre, '.']), !, fail.
verificarNuevaClase(_, _).

verificarNuevaPropiedadClase(Nombre, _, Base) :-
	\+ existeClase(Nombre, Base),
	error(['No se conoce la clase ', Nombre, '.']), !, fail.
verificarNuevaPropiedadClase(Nombre, Propiedad, Base) :-
	buscar(clase(Nombre, _, _, _), Base, Clase),
	claseTienePropiedad(Propiedad, Clase),
	error(['La clase ', Nombre, ' ya tiene la propiedad ', Propiedad]), !, fail.
verificarNuevaPropiedadClase(Nombre, not(Propiedad), Base) :-
	buscar(clase(Nombre, _, _, _), Base, Clase),
	claseTienePropiedad(Propiedad, Clase),
	error(['La clase ', Nombre, ' ya tiene la propiedad ', Propiedad]), !, fail.
verificarNuevaPropiedadClase(Nombre, Propiedad, Base) :-
	buscar(clase(Nombre, _, _, _), Base, Clase),
	claseTienePropiedad(not(Propiedad), Clase),
	error(['La clase ', Nombre, ' ya tiene la propiedad ', Propiedad,
		' en forma negada']), !, fail.
verificarNuevaPropiedadClase(_, _, _).

verificarNuevoObjeto(objeto(_, Padre, _, _), Base) :-
	\+ existeClase(Padre, Base),
	error(['No se conoce la clase ', Padre, '.']), !, fail.
verificarNuevoObjeto(objeto(_, _, _, _), _).

verificarNuevaPropiedadObjeto(Nombre, _, Base) :-
	\+ existeObjeto(Nombre, Base),
	error(['No se conoce el objeto ', Nombre, '.']), !, fail.
verificarNuevaPropiedadObjeto(Nombre, Propiedad, Base) :-
	filtrar(objetoSeLlama(Nombre), Base, Objetos),
	filtrar(objetoTienePropiedad(Propiedad), Objetos, Filtrada),
	Filtrada \= [],
	error(['Los siguientes objetos ya tienen la propiedad ', Propiedad, ': ']),
	imprimirLista(Filtrada), !, fail.
verificarNuevaPropiedadObjeto(_, _, _).

% Eliminar información --------------------------------------------------------

eliminarPropiedadObjetos([], _, Base, Base).
eliminarPropiedadObjetos([objeto(N, P, Props, R) | Rs], Propiedad, Base, NuevaBase) :-
	eliminar(Propiedad, Props, T1),
	eliminar(Propiedad => _, T1, T2),
	reemplazar(objeto(N, P, Props, R), objeto(N, P, T2, R), Base, Temp),
	eliminarPropiedadObjetos(Rs, Propiedad, Temp, NuevaBase).

verificarEliminarClase(Nombre, Base) :-
	\+ existeClase(Nombre, Base),
	error(['No se conoce la clase ', Nombre, '.']), !, fail.
verificarEliminarClase(_, _).

verificarEliminarObjeto(Nombres, Base) :-
	\+ existeObjeto(Nombres, Base),
	error(['No se conoce ningún objeto llamado ', Nombres, '.']), !, fail.
verificarEliminarObjeto(_, _).

verificarEliminarPropiedadClase(Nombre, _, Base) :-
	\+ existeClase(Nombre, Base),
	error(['No se conoce la clase ', Nombre, '.']), !, fail.
verificarEliminarPropiedadClase(Nombre, Propiedad, Base) :-
	buscar(clase(Nombre, _, _, _), Base, Clase),
	\+ claseTienePropiedad(Propiedad, Clase),
	error(['La clase ', Nombre, ' no tiene la propiedad ', Propiedad, '.']), !, fail.
verificarEliminarPropiedadClase(_, _, _).

verificarEliminarPropiedadObjeto(Nombre, _, Base) :-
	\+ existeObjeto(Nombre, Base),
	error(['No se conoce ningún objeto llamado ', Nombre, '.']), !, fail.
verificarEliminarPropiedadObjeto(Nombre, Propiedad, Base) :-
	filtrar(objetoSeLlama(Nombre), Base, Objetos),
	filtrar(objetoTienePropiedad(Propiedad), Objetos, Filtrada),
	Filtrada \= Objetos,
	restar(Objetos, Filtrada, SinProp),
	advertencia(['Los siguientes objetos no tienen la propiedad ', Propiedad, ': ']),
	imprimirLista(SinProp).
verificarEliminarPropiedadObjeto(_, _, _).

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
