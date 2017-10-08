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
% comandos.pl
% Contiene los comandos que sirven de interfaz al usuario en el intérprete.
% =============================================================================

:- op(800, xfx, '=>').

% Comandos para agregar -------------------------------------------------------

% Agrega una nueva clase a la base de conocimiento. Versión simple.
%	Nombre - Nombre de la clase.
%	Padre - Clase de la cual hereda la nueva clase.
comando(nuevaClase(Nombre, Padre), Base, Base) :-
	\+ verificarNuevaClase(clase(Nombre, Padre, [], []), Base).
comando(nuevaClase(Nombre, Padre), Base, NuevaBase) :- !,
	agregar(clase(Nombre, Padre, [], []), Base, NuevaBase).

% Agrega una nueva propiedad simple a una clase. No puede agregar una pareja
% propiedad => valor.
%	Nombre - Nombre de la clase a modificar.
%	Propiedad - Nombre de la nueva propiedad.
comando(nuevaPropClase(Nombre, Propiedad), Base, Base) :-
	\+ verificarNuevaPropiedadClase(Nombre, Propiedad, Base).
comando(nuevaPropClase(Nombre, Propiedad), Base, NuevaBase) :-
	buscar(clase(Nombre, _, _, _), Base, clase(_, Padre, Props, Rels)),
	agregar(Propiedad, Props, NuevasProps),
	reemplazar(
		clase(Nombre, Padre, Props, Rels),
		clase(Nombre, Padre, NuevasProps, Rels),
		Base, NuevaBase
	).

% Agrega una nueva pareja propiedad => valor a la clase especificada.
%	Nombre - Nombre de la clase a modificar.
%	Propiedad - Nombre de la nueva propiedad.
%	Valor - Valor de la nueva propiedad.
comando(nuevaPropClase(Nombre, Propiedad, _), Base, Base) :-
	\+ verificarNuevaPropiedadClase(Nombre, Propiedad, Base).
comando(nuevaPropClase(Nombre, Propiedad, Valor), Base, NuevaBase) :-
	buscar(clase(Nombre, _, _, _), Base, clase(_, Padre, Props, Rels)),
	agregar(Propiedad => Valor, Props, NuevasProps),
	reemplazar(
		clase(Nombre, Padre, Props, Rels),
		clase(Nombre, Padre, NuevasProps, Rels),
		Base, NuevaBase
	).

% Agrega un nuevo objeto a la base de conocimiento. Versión simple.
%	Nombre - Identificador para el objeto.
%	Padre - Clase a la cual pertenece el nuevo objeto.
comando(nuevoObjeto(Nombre, Padre), Base, Base) :-
	\+ verificarNuevoObjeto(objeto([Nombre], Padre, [], []), Base).
comando(nuevoObjeto(nil, Padre), Base, NuevaBase) :-
	agregar(objeto([], Padre, [], []), Base, NuevaBase), !.
comando(nuevoObjeto(Nombre, Padre), Base, NuevaBase) :-
	is_list(Nombre), !,
	agregar(objeto(Nombre, Padre, [], []), Base, NuevaBase).
comando(nuevoObjeto(Nombre, Padre), Base, NuevaBase) :-
	agregar(objeto([Nombre], Padre, [], []), Base, NuevaBase).

% Agrega una nueva propiedad simple a un objeto. No puede agregar una pareja
% propiedad => valor.
%	Nombre - Nombre de la clase a modificar.
%	Propiedad - Nombre de la nueva propiedad.
comando(nuevaPropObjeto(Nombre, Propiedad), Base, Base) :-
	\+ verificarNuevaPropiedadObjeto(Nombre, Propiedad, Base).
comando(nuevaPropObjeto(Nombre, Propiedad), Base, NuevaBase) :-
	filtrar(objetoSeLlama(Nombre), Base, Objetos),
	agregarPropiedadObjetos(Objetos, Propiedad, nil, Base, NuevaBase).

% Agrega una nueva pareja propiedad => valor a la clase especificada.
%	Nombre - Nombre de la clase a modificar.
%	Propiedad - Nombre de la nueva propiedad.
%	Valor - Valor de la nueva propiedad.
comando(nuevaPropObjeto(Nombre, Propiedad), Base, Base) :-
	errorNuevaPropiedadObjeto(Nombre, Propiedad, Base, Mensaje),
	error(Mensaje), !.
comando(nuevaPropObjeto(Nombre, Propiedad, Valor), Base, NuevaBase) :-
	filtrar(objetoSeLlama(Nombre), Base, Objetos),
	agregarPropiedadObjetos(Objetos, Propiedad, Valor, Base, NuevaBase).

% Comandos para eliminar ------------------------------------------------------

% Elimina de la base de conocimiento la clase con el nombre dado.
%	Nombre - Nombre de la clase a eliminar.
comando(borrarClase(Nombre), Base, Base) :-
	\+ verificarEliminarClase(Nombre, Base).
comando(borrarClase(Nombre), Base, NuevaBase) :-
	buscar(clase(Nombre, Padre, _, _), Base, Clase),
	clasesHijasDe(Nombre, Base, ClasesHijas),
	cambiarPadre(Padre, ClasesHijas, Base, Temp1),
	objetosHijosDe(Nombre, Base, ObjetosHijos),
	cambiarPadre(Padre, ObjetosHijos, Temp1, Temp2),
	eliminar(Clase, Temp2, NuevaBase).

% Elimina la propiedad especificada de la clase.
%	Nombre - Nombre de la clase a modificar.
%	Propiedad - Nombre de la propiedad a eliminar.
comando(borrarPropClase(Nombre, Propiedad), Base, Base) :-
	\+ verificarEliminarPropiedadClase(Nombre, Propiedad, Base).
comando(borrarPropClase(Nombre, Propiedad), Base, NuevaBase) :-
	buscar(clase(Nombre, _, _, _), Base, clase(_, Padre, Props, Rels)),
	eliminar(Propiedad, Props, NuevasProps),
	reemplazar(
		clase(Nombre, Padre, Props, Rels),
		clase(Nombre, Padre, NuevasProps, Rels),
		Base, NuevaBase
	).

% Elimina de la base de conocimiento todos los objetos que tengan el nombre
% dado.
%	Nombre - Nombre de los objetos a eliminar.
comando(borrarObjeto(Nombre), Base, Base) :-
	\+ verificarEliminarObjeto(Nombre, Base).
comando(borrarObjeto(Nombre), Base, NuevaBase) :-
	filtrar(objetoSeLlama(Nombre), Base, ListaObjetos),
	eliminarTodos(ListaObjetos, Base, NuevaBase).

% Elimina la propiedad especificada de todos los objetos con el nombre dado.
%	Nombre - Nombre del objeto a modificar.
%	Propiedad - Nombre de la propiedad a eliminar.
comando(borrarPropObjeto(Nombre, Propiedad), Base, Base) :-
	\+ verificarEliminarPropiedadObjeto(Nombre, Propiedad, Base).
comando(borrarPropObjeto(Nombre, Propiedad), Base, NuevaBase) :-
	filtrar(objetoSeLlama(Nombre), Base, Objetos),
	eliminarPropiedadObjetos(Objetos, Propiedad, Base, NuevaBase).

% Utilidades ------------------------------------------------------------------

% Lee una base desde el archivo dado.
%	Ruta: Ruta del archivo a leer.
comando(cargar(Ruta), _, NuevaBase) :-
	open(Ruta, read, Archivo),
	read(Archivo, NuevaBase),
	close(Archivo).

% Escribe la base actual en el archivo dado. Si el archivo no existe, se
% creará. Si ya existe, todo su contenido se sobreescribirá.
%	Ruta: Ruta del archivo a escribir.
comando(guardar(Ruta), Base, Base) :-
	open(Ruta, write, Archivo),
	writeq(Archivo, Base),
	put_char(Archivo, .),
	close(Archivo).

% Imprime todos los objetos actualmente almacenados en la base de conocimiento.
comando(ver, Base, Base) :-
	imprimirLista(Base).
