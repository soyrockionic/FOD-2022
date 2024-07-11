program CreateSortedTestFiles;
uses crt, sysutils;
const
  df = 10;
  num_records = 10;
type
  farmaco = record
    cod_farmaco : integer;
    nombre : string[30];
    fecha : string[10];
    cant_vendida : integer;
    forma_pago : string[7];
  end;

  archivo = file of farmaco;

var
  v : array[1..df] of archivo;
  i, j : integer;
  a : String[2];
  f : farmaco;
  records : array[1..num_records] of farmaco;

procedure SortRecords(var records: array of farmaco; n: integer);
var
  i, j : integer;
  temp : farmaco;
begin
  for i := 0 to n-2 do
    for j := i+1 to n-1 do
      if records[i].cod_farmaco > records[j].cod_farmaco then
      begin
        temp := records[i];
        records[i] := records[j];
        records[j] := temp;
      end;
end;

begin
  clrscr;

  // Initialize the files
  for i := 1 to df do
  begin
    Str(i, a);
    assign(v[i], '001sucursal' + a);
    rewrite(v[i]);
    
    // Populate the array with dummy data
    for j := 1 to num_records do
    begin
      records[j].cod_farmaco := Random(100) + 1;  // Random code between 1 and 100
      records[j].nombre := 'Farmaco' + IntToStr(records[j].cod_farmaco);
      records[j].fecha := '2024/06/' + IntToStr(Random(30) + 1);  // Random date in June 2024
      records[j].cant_vendida := Random(100) + 1;  // Random quantity between 1 and 100
      records[j].forma_pago := 'Contado';  // Example payment method
    end;
    
    // Sort the records
    SortRecords(records, num_records);
    
    // Write the sorted records to the file
    for j := 1 to num_records do
    begin
      write(v[i], records[j]);
    end;

    close(v[i]);
  end;

  writeln('Sorted test files created successfully.');
  readln;
end.
