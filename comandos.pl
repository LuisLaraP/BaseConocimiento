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

% Comandos para agregar -------------------------------------------------------

% Agrega una nueva clase a la base de conocimiento. Versión simple.
%	Nombre - Nombre de la clase.
%	Padre - Clase de la cual hereda la nueva clase.
comando(nuevaClase(Nombre, Padre), Base, Base) :-
	errorNuevaClase(clase(Nombre, Padre, [], []), Base, Mensaje),
	escribir(['Operación fallida: ' | Mensaje]), !.
comando(nuevaClase(Nombre, Padre), Base, NuevaBase) :-
	agregar(clase(Nombre, Padre, [], []), Base, NuevaBase).


% Agrega un nuevo objeto a la base de conocimiento. Versión simple.
%	Nombre - Identificador para el objeto.
%	Padre - Clase a la cual pertenece el nuevo objeto.
comando(nuevoObjeto(Nombre, Padre), Base, Base) :-
	errorNuevoObjeto(objeto([Nombre], Padre, [], []), Base, Mensaje),
	escribir(['Operación fallida: ' | Mensaje]), !.
comando(nuevoObjeto(nil, Padre), Base, NuevaBase) :-
	agregar(objeto([], Padre, [], []), Base, NuevaBase), !.
comando(nuevoObjeto(Nombre, Padre), Base, NuevaBase) :-
	is_list(Nombre), !,
	agregar(objeto(Nombre, Padre, [], []), Base, NuevaBase).
comando(nuevoObjeto(Nombre, Padre), Base, NuevaBase) :-
	agregar(objeto([Nombre], Padre, [], []), Base, NuevaBase).

% Comandos para eliminar ------------------------------------------------------

% Elimina de la base de conocimiento la clase con el nombre dado.
%	Nombre - Nombre de la clase a eliminar.
comando(borrarClase(Nombre), Base, Base) :-
	errorEliminarClase(Nombre, Base, Mensaje),
	escribir(['Operación fallida: ' | Mensaje]), !.
comando(borrarClase(Nombre), Base, NuevaBase) :-
	buscar(clase(Nombre, Padre, _, _), Base, Clase),
	clasesHijasDe(Nombre, Base, ClasesHijas),
	cambiarPadre(Padre, ClasesHijas, Base, Temp1),
	objetosHijosDe(Nombre, Base, ObjetosHijos),
	cambiarPadre(Padre, ObjetosHijos, Temp1, Temp2),
	eliminar(Clase, Temp2, NuevaBase).

% Elimina de la base de conocimiento todos los objetos que tengan el nombre
% dado.
%	Nombre - Nombre de los objetos a eliminar.
comando(borrarObjeto(Nombre), Base, Base) :-
	errorEliminarObjeto(Nombre, Base, Mensaje),
	escribir(['Operación fallida: ' | Mensaje]), !.
comando(borrarObjeto(Nombre), Base, NuevaBase) :-
	filtrar(objetoSeLlama(Nombre), Base, ListaObjetos),
	eliminarTodos(ListaObjetos, Base, NuevaBase).

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

comando(ver, Base, Base) :-
	imprimirLista(Base).

comando(prueba(P), Base, Base) :-
	call(P).
