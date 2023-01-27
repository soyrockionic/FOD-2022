program Ej3P2;
Uses crt;
const
  valorAlto = 9999;
  dimf = 30;
type

  producto = record
    codigo : integer;
    nombre : String[50];
    descrip : String[50];
    stockDisp : integer;
    stockMin : integer;
    precio : real;
  end;

  venta = record
    codigo : integer;
    cantVen : integer;
  end;

  maestro = file of producto;
  detalle = file of venta;

  vector = array[1..dimf] of detalle;
  vectorVentas = array[1..dimf] of venta;

procedure crearArchivoMaestro(var mae : maestro);
var
  reg : producto;
  prod : text;
begin

  assign(prod, 'productos.txt');

  reset(prod);
  rewrite(mae);
  while(not eof(prod)) do begin
    readln(prod, reg.codigo);
    readln(prod, reg.nombre);
    readln(prod, reg.descrip);
    readln(prod, reg.stockDisp, reg.stockMin, reg.precio);
    write(mae, reg);
  end;
  close(prod);
  close(mae);

end;

procedure leerVenta(var reg : venta);
begin
  write('Ingrese codigo ');
  readln(reg.codigo);
  if(reg.codigo <> -1) then begin
    write('Ingrese cantidad vendida ');
    readln(reg.cantVen);
  end;
end;

procedure cargarDetalle(var arch : detalle);
var
  reg : venta;
begin
  rewrite(arch);
  leerVenta(reg);
  while(reg.codigo <> -1) do begin
    write(arch,reg);
    leerVenta(reg);
  end;
  close(arch);
end;

procedure crearDetalles(var vd : vector);
var
  i : integer;
  det : detalle;
  a : String;
begin
  for i := 1 to dimf do begin
    writeln('Cargo detalle sucursal ',i);
    Str(i,a);
    assign(vd[i], 'sucursal '+a);
    cargarDetalle(vd[i]);
  end;
end;

procedure leer(var arch : detalle; var reg : venta);
begin
  if(not eof(arch)) then
    read(arch,reg)
  else
    reg.codigo := valorAlto;
end;

procedure minimo(var vd : vector; var act : vectorVentas; var min : venta);
var
  i, pos : integer;
begin
  min.codigo := valorAlto;
  for i := 1 to dimf do begin
    if(act[i].codigo < min.codigo) then begin
      min := act[i];
      pos := i;
    end;
  end;
  if(min.codigo <> valorAlto) then
    leer(vd[pos],act[pos]);
end;

procedure actualizarMaestro(var mae : maestro; vd : vector);
var
  i : integer;
  reg : producto;
  act : vectorVentas;
  min : venta;
  a : String;
  cant, aux : integer;
begin
   reset(mae);
   for i := 1 to dimf do begin
     Str(i,a);
     assign(vd[i], 'sucursal '+a);
     reset(vd[i]);
     leer(vd[i],act[i]);
   end;

   minimo(vd,act,min);
   while(min.codigo <> valorAlto) do begin
     aux := min.codigo;
     cant := 0;

     while(reg.codigo = min.codigo) do begin
       cant := cant + min.cantVen;
       minimo(vd,act,min);
     end;
     while(reg.codigo <> aux) do
       read(mae, reg);
     reg.stockDisp := reg.stockDisp - cant;
     seek(mae, filepos(mae)-1);
     write(mae,reg);

   end;

   for i := 1 to dimf do begin
     close(vd[i]);
   end;
   close(mae);
end;

procedure leeer(var arch : maestro; var reg : producto);
begin
  if(not eof(arch)) then
    read(arch,reg)
  else
    reg.codigo := valorAlto;
end;

procedure reporteStockMenor(var mae : maestro);
var
  reg : producto;
  repo : text;
begin

  assign(repo, 'reporteStockMenor.txt');

  reset(mae);
  rewrite(repo);

  leeer(mae,reg);
  while(reg.codigo <> valorAlto) do begin
    if(reg.stockDisp < reg.stockMin) then begin
      write(repo, reg.nombre, ' ',reg.descrip,' ',reg.stockDisp,' ',reg.precio:2:2);
      writeln(repo,' ');
    end;
    leeer(mae,reg);
  end;

  close(mae);
  close(repo);

end;

var
  mae : maestro;
  vd : vector;
  op : char;
  reg : producto;
begin
  clrscr;

  assign(mae, 'productos');

  writeln('a : Crear archivo maestro');
  writeln('b : Crear archivos detalle');
  writeln('c : Actualizar archivo maestro');
  writeln('d : Reporte con stock menor al minimo');
  readln(op);

  case op of
    'a' : crearArchivoMaestro(mae);
    'b' : crearDetalles(vd);
    'c' : actualizarMaestro(mae,vd);
    'd' : reporteStockMenor(mae);
  end;

  reset(mae);
  while(not eof(mae)) do begin
    read(mae, reg);
    writeln(reg.codigo,' ',reg.nombre,' ',reg.descrip,' ',reg.stockDisp,' ',reg.stockMin);
  end;
  close(mae);

  readln;
end.