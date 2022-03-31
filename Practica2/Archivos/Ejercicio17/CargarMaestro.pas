program cargarMaestro;
Uses crt;

type

  vehiculo = record
    codigo : integer;
    nombre : string;
    descripcion : string;
    modelo : string;
    stock : integer;
  end;

  maestro = file of vehiculo;


procedure leerReg(var c : Text; var reg : vehiculo);
begin
  readln(c, reg.codigo);
  readln(c, reg.nombre);
  readln(c, reg.descripcion);
  readln(c, reg.modelo);
  readln(c, reg.stock);
end;

procedure cargarMaestro(var mae : maestro);
var
  cargaM : Text;
  reg : vehiculo;
begin

  writeln('Cargo el archivo maestro');
  assign(cargaM, 'vehiculos.txt');
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
  mae : maestro;
begin
  clrscr;

  assign(mae,'Vehiculos');
  cargarMaestro(mae);

  readln;
end.
