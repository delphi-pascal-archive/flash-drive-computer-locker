program fdcl;

uses
  Forms,windows,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

function keystate(key1: word): boolean;
begin
  if (getkeystate(key1) = -128) or
    (getkeystate(key1) = -127) then
    result := true
  else
    result := false;
end;

begin
  If keystate(18)=true then exit;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
