program cargarDetalle;
type

  venta = record
    codigo : integer;
    precio : real;
    fecha : integer;
  end;

  detalle = file of venta;


procedure leerReg(var c : Text; var reg : venta);
begin
  readln(cargaM, reg.codigo);
  readln(cargaM, reg.precio);
  readln(cargaM, reg.fecha);
end;

procedure cargarDetalle(var mae : detalle);
  cargaM : Text;
  reg : venta;
begin

  writeln('A Cargo el archivo maestro');
  assign(cargaM, 'veentas.txt');
  reset(cargaM);
  rewrite(mae);

  while(not eof(cargaM)) do begin

    leerReg(cargaM,reg);

    write(mae, reg);
  end;

  close(mae);
  close(cargaM);

end;



var
  mae : detalle;
begin
  assign(mae,'Detalle1);
  cargarDetalle(mae);
end.