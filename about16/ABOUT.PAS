unit About;
{$R C:\DONGWA16.res}
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,MENUS,
 Buttons, ExtCtrls,Sysutils,WINDOS,shellapi;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Comments: TLabel;
    Image1: TImage;
    ExeType: TLabel;
    Label1: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1Click(Sender: TObject);
    procedure ProgramIconClick(Sender: TObject);
  private
  URL:String;
  function getPlatform:Byte;
     { Private declarations }
  public
  procedure Donate(clicked:TMenuItem;Price:real);
  procedure Display(AppName,Remarks,slug:string;v1,v2,v3,v4:Byte);
  Procedure OpenWebSite(Url:string);
  property AppBits:byte read getplatform;
    { Public declarations }
  end;
CONST URL_DELPHIJUSTIN='https://delphijustin.biz';
var
  AboutBox: TAboutBox;
abCaptions:TStringlist;
implementation

{$R *.DFM}
function TAboutbox.getplatform;
begin
result:=sizeof(integer)*8;
if result=16 then exit;
result:=sizeof(pointer)*8;
end;
Type TReplaceFlags=Set of(rfReplaceAll,rfIgnoreCase);
Function StringReplace(S, OldPattern, NewPattern: string;
  Flags: TReplaceFlags): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;
Procedure TAboutBox.Donate;
VAR Cost:string;
Begin
Cost:=FormatFloat('0.00',PRICE);
IF Pos('PAYPAL',uppercase(Clicked.Caption))>0THEN
OpenWebsite('https://www.paypal.com/paypalme/delphijustin/'+Cost)ELSE
IF Pos('CASHAPP',uppercase(Clicked.Caption))>0THEN
OpenWebsite('https://cash.app/$delphijustin/'+Cost);
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
close;
end;
Procedure TAboutbox.OpenWebSite;
var urlparam:Pchar;
windir:array[byte]of char;
begin
URLPARAM:=Stralloc(LENGTH(URL)+255);
GetWindowsDirectory(Windir,256);
if(Not fileexists(format('%s\system\kernel32.dll',[windir])))and(Not fileexists(
format('%s\system32\kernel32.dll',[windir])))then begin messagebox(0,STRFMT(
URLPARAM,'Website links don'#39't work on windows 3.1 or older'#13#10'%s',[
URL]),NIL,mb_iconstop);STRDISPOSE(URLPARAM);
exit; end;
Shellexecute(handle,nil,GetEnvVar('COMSPEC'),strfmt(urlparam,'/C Start %s',[url])
,nil,SW_NORMAL);
STRDISPOSE(URLPARAM);
end;
procedure TAboutBox.FormCreate(Sender: TObject);
var I:Integer;
begin
exetype.caption:=format(exetype.caption,[AppBits]);
abcaptions:=TStringlist.create;
Image1.Picture.Bitmap.Handle:=loadbitmap(HInstance,'DONGWA');
for I:=0 to componentcount-1 do
if components[I].Classname='TLabel' then
abcaptions.values[TLabel(Components[I]).Name]:=TLabel(Components[I]).Caption;
end;

procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action:=CAHIDE;
end;
procedure TAboutBox.Display;
var ThisFile:Array[0..260]of char;
begin
productname.Caption:=format(AbCaptions.values['productname'],[appname]);
comments.Caption:=remarks;
version.Caption:=format(AbCaptions.values['Version'],[v1,v2,v3,v4]);
url:=slug;
getmodulefilename(hinstance,thisfile,261);
programicon.picture.icon.handle:=extracticon(hinstance,thisfile,0);
show;
end;
procedure TAboutBox.Image1Click(Sender: TObject);
begin
Openwebsite(URL_DELPHIJUSTIN);
end;

procedure TAboutBox.ProgramIconClick(Sender: TObject);
begin
OpenWebsite(URL_DELPHIJUSTIN+URL+'?Verlabel16='+StringReplace(Version.Caption,#32,
'+',[RFREPLACEALL]));
end;

end.

