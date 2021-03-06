unit uGrafos;

interface
uses uElem, uLista, uConjuntos3, uPila, uColas;

	type
		tNodo = record
			e:tElem;
			lista:tLista; // lista de adyacencias
			sig:^tNodo;
		end;

		tGrafo = ^tNodo;

		procedure CrearGrafoVacio(var g:tGrafo);
		procedure InsertarOrigen(origen:tElem; var g:tGrafo);
		procedure InsertarDestino(destino:tElem; origen:tElem; var g:tGrafo);
		function Contains(e:tElem; g:tGrafo):boolean;
		function EsVacio(g:tGrafo):boolean;
		function ContainsDestinos(e, origen:tElem; g:tGrafo):boolean;
		procedure GetListaAdyacencia(e:tElem; g:tGrafo; var l:tLista);
		procedure ImprimirGrafo(g:tGrafo);
		procedure RecorridoProfundidad(g:tGrafo; origen:tElem; var l:tLista);
		PROCEDURE RecorridoAnchura(g: TGrafo; origen: TElem; VAR l:TLista);
		FUNCTION Tamano(g:tGrafo):integer;
		procedure Camino(origen, destino:tElem; g:tGrafo; var l:tLista);

implementation

	procedure CrearGrafoVacio(var g:tGrafo);
	begin
		g:=nil;
	end;

	procedure InsertarOrigen(origen:tElem; var g:tGrafo);
	var
		nuevoNodo:tGrafo;
	begin
		if not Contains(origen, g) then begin
			new(nuevoNodo);
			Asignar(nuevoNodo^.e, origen);
			uLista.CrearListaVacia(nuevoNodo^.lista);
			nuevoNodo^.sig:=g;
			g:=nuevoNodo;
		end;
	end;

	procedure InsertarDestino(destino:tElem; origen:tElem; var g:tGrafo);
	var
		aux:tGrafo;
	begin
		if not ContainsDestinos(destino, origen, g) then begin
			aux:=g;
			while (aux <> nil) and (not Equals(aux^.e, origen)) do
				aux:=aux^.sig;
			if (aux <> nil) then
				uLista.ConstruirLista(destino, aux^.lista);
		end;
	end;

	function Contains(e:tElem; g:tGrafo):boolean;
	begin
		if EsVacio(g) then
			Contains:=false
		else begin
			if Equals(e,g^.e) then
				Contains:=true
			else
				Contains:=Contains(e, g^.sig);
		end;
	end;

	function EsVacio(g:tGrafo):boolean;
	begin
		EsVacio:= g = nil;
	end;

	function ContainsDestinos(e, origen:tElem; g:tGrafo):boolean;
	var
		aux:tGrafo;
	begin
		if EsVacio(g) then
			ContainsDestinos:=false
		else begin
			aux:=g;
			while (aux <> nil) and (not Equals(aux^.e, origen)) do
				aux:=aux^.sig;
			if (aux <> nil) then
				ContainsDestinos:=uLista.Pertenece(aux^.lista, e)
			else
				ContainsDestinos:=false;
		end;
	end;

	procedure GetListaAdyacencia(e:tElem; g:tGrafo; var l:tLista);
	var
		aux:tGrafo;
	begin
		if EsVacio(g) then
			CrearListaVacia(l)
		else begin
			aux:=g;
			while (aux <> nil) and (not Equals(aux^.e, e)) do
				aux:=aux^.sig;
			if (aux <> nil) then
				uLista.Copiar(aux^.lista, l)
			else
				CrearListaVacia(l);
		end;
	end;

	procedure ImprimirGrafo(g:tGrafo);
	var
		i:integer;
	begin
		i:=1;
		while g <> nil do begin
			writeln('***');
			write('OR: ');
			uElem.Mostrar(g^.e);
			writeln(i);
			i:=i+1;
			uLista.ImprimirLista(g^.lista);
			writeln('***');
			g:=g^.sig;
		end;
	end;

	FUNCTION Tamano(g:tGrafo):integer;
	BEGIN
		if(EsVacio(g))then
			Tamano:=0
		else
			Tamano:= 1 + Tamano(g^.sig);;
	END;

	procedure RecorridoProfundidad(g:tGrafo; origen:tElem; var l:tLista);
	var
		pila:tPila;
		visitados:tConjunto;
		e:tElem;
		adyacentes:tLista;
	begin
		if Contains(origen, g) then begin
			CrearPilaVacia(pila);
			CrearConjuntoVacio(visitados);
			CrearListaVacia(l);
			Asignar(e, origen);
			Apilar(e, pila);
			while (not uPila.EsVacia(pila)) do begin
				if (not Pertenece(e, visitados)) then begin
					Desapilar(pila);
					Poner(e, visitados);
					ConstruirLista(e, l);
					GetListaAdyacencia(e, g, adyacentes);
					while not uLista.EsVacia(adyacentes) do begin
						uLista.PrimerElemento(adyacentes, e);
						Apilar(e, pila);
						uLista.Resto(adyacentes, adyacentes);
					end;
					Cima(e, pila);
				end
				else begin
					Desapilar(pila);
					Cima(e, pila);
				end;
(*
				writeln();
				writeln('Pila:');
				ImprimirPila(pila);
				writeln();
				writeln('Conjunto:');
				ImprimirConjunto(visitados);
				writeln();
				writeln('Lista:');
				ImprimirLista(l);
				writeln(uLista.Longitud(l));
				writeln();
				*)
			end;
		end;
	end;

	procedure Camino(origen, destino:tElem; g:tGrafo; var l:tLista);
	var
		pila:tPila;
		visitados:tConjunto;
		e:tElem;
		adyacentes:tLista;
	begin
		if Contains(origen, g) and Contains(destino, g) then begin
			CrearPilaVacia(pila);
			CrearConjuntoVacio(visitados);
			CrearListaVacia(l);
			Asignar(e, origen);
			Apilar(e, pila);
			while (not uPila.EsVacia(pila)) and (not Pertenece(destino, visitados)) do begin
				if (not Pertenece(e, visitados)) then begin
					Desapilar(pila);
					Poner(e, visitados);
					InsertarFinal(e, l);
					GetListaAdyacencia(e, g, adyacentes);
					while not uLista.EsVacia(adyacentes) do begin
						uLista.PrimerElemento(adyacentes, e);
						Apilar(e, pila);
						uLista.Resto(adyacentes, adyacentes);
					end;
					Cima(e, pila);
				end
				else begin
					Desapilar(pila);
					Cima(e, pila);
				end;
			end;
		end;
	end;

	PROCEDURE RecorridoAnchura(g: TGrafo; origen: TElem; VAR l:TLista);
	VAR
		c: tCola;
		visitados: TConjunto;
		aux: TGrafo;
		e: TElem;
		adyacentes: TLista;
	BEGIN
		IF uGrafos.Contains(origen, g) THEN BEGIN
			uLista.CrearListaVacia (l);
			uConjuntos3.CrearConjuntoVacio(visitados);
			uColas.CrearColaVacia(c);
			uElem.Asignar(e, origen);
			uColas.Insertar(e,c);
			WHILE NOT uColas.EsVacia(c) DO BEGIN
				IF NOT uConjuntos3.Pertenece(e, visitados) THEN BEGIN
					uColas.Eliminar(c);
					uConjuntos3.Poner(e, visitados);
					uLista.ConstruirLista(e, l);
					GetListaAdyacencia(e, g, adyacentes);
					WHILE NOT uLista.EsVacia(adyacentes) DO BEGIN
						uLista.PrimerElemento(adyacentes, e);
						uColas.Insertar(e,c);
						uLista.Resto(adyacentes, adyacentes);
					END;
					uColas.Primero(e,c);
				END
				ELSE BEGIN
					uColas.Eliminar(c);
					uColas.Primero(e,c);
				END;
			END;
		END;
	END;


end.
