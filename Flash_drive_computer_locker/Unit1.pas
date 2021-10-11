unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,tlhelp32,buttons,registry;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormPaint2(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  stop:boolean;
  pass:string;

procedure BlockInput; external user32;

implementation

uses Unit2;

{$R *.dfm}

function GetpidByname(sl:string):cardinal;
var
  h: HWND;
  snap: tprocessentry32;
begin
result:=0;    
  h := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, cardinal(-1));
  snap.dwSize := SizeOf(ProcessEntry32);
  if process32first(h, snap) = true then
  repeat
             if lowercase(sl)=lowercase(snap.szExeFile)then
             begin
                  result:=snap.th32ProcessID;
                  break;
             end;
  until process32next(h,snap)<>true;
  closehandle(h);
end;

procedure Block(s:boolean);
var
p:cardinal;
begin
if s=true then
begin
asm
   push 1
   call blockinput;
end;
p:=getpidbyname('taskmgr.exe');
if p<>0 then
   begin
        p:=Openprocess(PROCESS_TERMINATE,true,p);
        terminateprocess(p,1);
        closehandle(p);
   end;
setwindowpos(form1.handle,HWND_TOPMOST,0,0,0,0,swp_nomove or swp_nosize);
end else
begin
asm
   push 0
   call blockinput;
end;
end;
end;

procedure Scan;
var
j:word;
a:array[1..512]of byte;
s:string;
readed:cardinal;
f:cardinal;
begin
     for j:=ord('A')  to ord('Z') do
     if getdrivetype(pchar(chr(j)+':\'))=DRIVE_REMOVABLE then
     begin
          f:=createfile(pchar('\\.\'+chr(j)+':'),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_FLAG_RANDOM_ACCESS,0);
          if f<>INVALID_HANDLE_VALUE then
          begin
          setfilepointer(f,512*4,nil,0);
          readfile(f,a,sizeof(a),readed,nil);
          readed:=1;
          while (a[readed]<>0) do
          begin
               s:=s+chr(a[readed]);
               inc(readed);
          end;
          if s=pass then
             begin
                  block(false);
                  winexec(pchar('"'+paramstr(0)+'" -d '+chr(j)),sw_show);
                  exitprocess(1);
             end;
         closehandle(f);
         end;
     end;
end;

procedure DoBlock;
begin
stop:=false;
while stop<>true do
      begin
           block(true);
           scan;
           application.ProcessMessages;
      end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
showcursor(false);
onpaint:=formpaint2;
left:=0;
top:=0;
button1.Hide;
button2.Hide;
button3.Hide;
showcursor(false);
color:=clBlack;
width:=screen.Width;
height:=screen.Height;
doblock;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
exitprocess(1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
with TRegistry.Create(KEY_READ)do
begin
     rootkey:=HKEY_CURRENT_USER;
     if openkey('software\microsoft\windows\currentversion\Run',false)=true then
        form2.CheckBox1.Checked:=valueexists('fdcl');
     closekey;
     free;
end;
form2.Show;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
buttons.DrawButtonFace(canvas,clientrect,3,bsNew,true,false,false);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
left:=screen.Width-width;
top:=screen.WorkAreaHeight-height;
with TRegistry.Create(KEY_READ)do
begin
     rootkey:=HKEY_CURRENT_USER;
     if openkey('SOFTWARE',false)=true then
     if valueexists('fdcl')then
        pass:=readstring('fdcl');
     closekey;
     free;
end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
showwindow(application.Handle,sw_hide);
if paramstr(1)='-lock'then button1.Click;
if paramstr(1)='-d'then
begin
   while windows.GetDriveType(pchar(paramstr(2)+':\'))=DRIVE_REMOVABLE do
         application.ProcessMessages;
   button1.Click;
end;
end;

procedure TForm1.FormPaint2(Sender: TObject);
begin
canvas.Font.Color:=clLime;
canvas.Font.Name:='Times New Roman';
canvas.font.Size:=30;
canvas.TextOut(0,0,'Unlock with Key-Flash');
end;

end.
