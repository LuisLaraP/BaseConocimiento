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

eliminarPropiedadObjetos([], _, Base, Base).
eliminarPropiedadObjetos([objeto(N, P, Props, R) | Rs], Propiedad, Base, NuevaBase) :-
	eliminar(Propiedad, Props, T1),
	eliminar(Propiedad => _, T1, T2),
	reemplazar(objeto(N, P, Props, R), objeto(N, P, T2, R), Base, Temp),
	eliminarPropiedadObjetos(Rs, Propiedad, Temp, NuevaBase).

errorEliminarClase(Nombre, Base, Mensaje) :-
	\+ existeClase(Nombre, Base),
	Mensaje = ['No se conoce la clase ', Nombre, '.'].

errorEliminarObjeto(Nombres, Base, Mensaje) :-
	\+ existeObjeto(Nombres, Base),
	Mensaje = ['No se conoce ningún objeto llamado ', Nombres, '.'].

errorEliminarPropiedadClase(Nombre, _, Base, Mensaje) :-
	\+ existeClase(Nombre, Base),
	Mensaje = ['No se conoce la clase ', Nombre, '.'].
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
