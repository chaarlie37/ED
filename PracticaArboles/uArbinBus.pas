UNIT uArbinBus;
INTERFACE
	USES uElem, uArbolBinario, uLista;
	TYPE
		tArbinBus = tArbin;

	procedure CrearArbolVacio(VAR a:tArbinBus);
	procedure Insertar(e:tElem; VAR a:tArbinBus);
	procedure HijoIzquierdo(VAR izq:tArbinBus; a:tArbinBus);
	procedure HijoDerecho(VAR der:tArbinBus; a:tArbinBus);
	procedure Raiz(VAR r:tElem; a:tArbinBus);
	FUNCTION EsVacio(a:tArbinBus):boolean;
	FUNCTION Pertenece(e:tElem; a:tArbinBus):boolean;
	FUNCTION Igual(a1, a2:tArbinBus):boolean;
	FUNCTION Profundidad(a:tArbinBus):integer;
	function NivelElemento(e:tElem; a:tArbinBus):integer;
	function NumeroNodos(a:tArbinBus):integer;
	function Compensado(a:tArbinBus):boolean;
	function Equilibrado(a:tArbinBus):boolean;
	procedure Preorden(a:tArbin; VAR l:tLista);
	PROCEDURE Imprimir(a:tArbinBus);
	procedure BuscarElemento(s:string; a:tArbinBus; var e:tElem);
	procedure AnadirTwitNodo(s:string; t:string; var a:tArbinBus);

IMPLEMENTATION

	procedure CrearArbolVacio(VAR a:tArbinBus);
	begin
		uArbolBinario.CrearArbolVacio(a);
	end;

	procedure Insertar(e:tElem; VAR a:tArbinBus);
	var
		izq, der, vacio, aux:tArbinBus;
		r:tElem;
	begin
		if EsVacio(a) then begin
			CrearArbolVacio(vacio);
			ConstruirArbolBin(vacio, vacio, e, a);
		end
		else begin
			if not Pertenece(e,a) then begin
				Raiz(r, a);
				HijoIzquierdo(izq, a);
				HijoDerecho(der, a);
				if uElem.EsMenor(e,r) then begin
					Insertar(e, izq);
					if EsHoja(izq) then begin
						InsertarHijoIzq(izq, a);
					end;
				end
				else if uElem.EsMayor(e,r) then begin
					Insertar(e, der);
					if EsHoja(der) then begin
						InsertarHijoDer(der, a);
					end;
				end;
			end;
		end;
	end;

	procedure HijoIzquierdo(VAR izq:tArbinBus; a:tArbinBus);
	begin
		uArbolBinario.HijoIzquierdo(izq, a);
	end;

	procedure HijoDerecho(VAR der:tArbinBus; a:tArbinBus);
	begin
		uArbolBinario.HijoDerecho(der, a);
	end;

	procedure Raiz(VAR r:tElem; a:tArbinBus);
	begin
		uArbolBinario.Raiz(r,a);
	end;

	FUNCTION EsVacio(a:tArbinBus):boolean;
	begin
		EsVacio:=uArbolBinario.EsVacio(a);
	end;

	FUNCTION Pertenece(e:tElem; a:tArbinBus):boolean;
	VAR
		hijo:tArbinBus;
		r:tElem;
	begin
		//write('I');
		if EsVacio(a) then
			Pertenece:=false
		else begin
			Raiz(r, a);
			if Equals(e,r) then
				Pertenece:=true
			else if EsMenor(e,r) then begin
				HijoIzquierdo(hijo,a);
				Pertenece:=Pertenece(e,hijo);
			end
			else if EsMayor(e,r) then begin
				HijoDerecho(hijo, a);
				Pertenece:=Pertenece(e, hijo);
			end;
		end;
	end;

	procedure BuscarElemento(s:string; a:tArbinBus; var e:tElem);
	VAR
		hijo:tArbinBus;
		r,aux2:tElem;
		aux:string;
	begin
		//write('I');
		if not EsVacio(a) then begin
			Raiz(r, a);
			uElem.Hashtag(r, aux);
			if s = aux then
				Asignar(e,r)
			else if s < aux then begin
				HijoIzquierdo(hijo,a);
				BuscarElemento(s, hijo, e);
			end
			else if s > aux then begin
				HijoDerecho(hijo, a);
				BuscarElemento(s, hijo, e);
			end;
		end;
	end;


	procedure AnadirTwitNodo(s:string; t:string; var a:tArbinBus);
	VAR
		hijo:tArbinBus;
		r:tElem;
		aux:string;
	begin
		//write('I');
		if not EsVacio(a) then begin
			Raiz(r, a);
			uElem.Hashtag(r, aux);
			if s = aux then begin
				uElem.SetTweet(t,r);
				uArbolBinario.SetRaiz(r,a);
			end
			else if s < aux then begin
				HijoIzquierdo(hijo,a);
				AnadirTwitNodo(s, t, hijo);
			end
			else if s > aux then begin
				HijoDerecho(hijo, a);
				AnadirTwitNodo(s, t, hijo);
			end;
		end;

	end;


	FUNCTION Igual(a1, a2:tArbinBus):boolean;
	begin
		Igual:=uArbolBinario.Igual(a1,a2);
	end;

	FUNCTION Profundidad(a:tArbinBus):integer;
	begin
		Profundidad:=uArbolBinario.Profundidad(a);
	end;


	function NivelElemento(e:tElem; a:tArbinBus):integer;
	begin
		NivelElemento:=-1;
	end;


	function NumeroNodos(a:tArbinBus):integer;
	begin
		NumeroNodos:=uArbolBinario.NumeroNodos(a);
	end;

	function Compensado(a:tArbinBus):boolean;
	begin
		Compensado:=uArbolBinario.Compensado(a);
	end;

	function Equilibrado(a:tArbinBus):boolean;
	begin
		Equilibrado:=uArbolBinario.Equilibrado(a);
	end;

	procedure Preorden(a:tArbin; VAR l:tLista);
	begin
		uArbolBinario.Preorden(a,l);
	end;

	PROCEDURE Imprimir(a:tArbinBus);
	begin
		uArbolBinario.Imprimir(a);
	end;
end.
