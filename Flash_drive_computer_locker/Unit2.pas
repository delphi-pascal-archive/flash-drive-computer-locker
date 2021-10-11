unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,registry;

type
  TForm2 = class(TForm)
    drives: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    procedure drivesDropDown(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.drivesDropDown(Sender: TObject);
var
j:cardinal;
begin
drives.Clear;
for j:=ord('A')  to ord('Z') do
    if Getdrivetype(pchar(chr(j)+':\'))=DRIVE_REMOVABLE then
       drives.Items.Add(chr(j));
end;

procedure TForm2.Button1Click(Sender: TObject);
var
f:cardinal;
s:string;
w:cardinal;
a:array[1..512]of byte;
begin
with TREgistry.Create(KEY_WRITE)do
begin
     rootkey:=HKEY_CURRENT_USER;
     if openkey('software\microsoft\windows\currentversion\Run',false)=true then
     begin
          if checkbox1.Checked=true then
             writestring('fdcl','"'+paramstr(0)+'" -lock')else
             deletevalue('fdcl');
     end;
     closekey;
     free;
end;
if edit1.Text=''then
   begin
        showmessage('Input password, max length is 500');
        exit;
   end;
if drives.Text<>''then
   begin
        f:=createfile(pchar('\\.\'+drives.Text+':'),GENERIC_WRITE,FILE_SHARE_WRITE,nil,OPEN_EXISTING,FILE_FLAG_RANDOM_ACCESS,0);
        if f<>INVALID_HANDLE_VALUE then
           begin
                setfilepointer(f,512*4,nil,0);
                for w:=1  to 512 do
                    a[w]:=0;
                s:=edit1.Text;
                for w:=1 to length(s)do
                    a[w]:=ord(s[w]);
                writefile(f,a,sizeof(a),w,nil);
                with TRegistry.Create(KEY_WRITE)do
                begin
                     rootkey:=HKEY_CURRENT_USER;
                     if openkey('SOFTWARE',false)=true then
                        writestring('fdcl',s);
                     closekey;
                     free;
                end;
           closehandle(f);
           end;
   end;
close;
winexec(pchar(paramstr(0)),sw_show);
exitprocess(1);
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
close;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
j:cardinal;
s:string;
begin
randomize;
for j:=1  to edit1.MaxLength do
    s:=s+chr(random(126-32)+32);
edit1.Text:=s;
end;

end.


