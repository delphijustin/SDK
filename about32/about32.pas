unit about32;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,shellapi,
  Buttons, ExtCtrls,math;

type
TVersionUpdate=record
apiversion,flags1:dword;
buildcount:dword;
compiletime:TDateTime;
v1:byte;
end;
PVersionUpdate=^TVersionUpdate;
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Image1: TImage;
    Label1: TLabel;
    AppType: TLabel;
    Bevel1: TBevel;
    CharType: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ProgramIconClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private
  fmtName:String;
  lpURL:pchar;
    { Private declarations }
  public
  versionException:Exception;
  procedure Display(const appname,scomments,url:String;v1:THandle;v2,v3,v4:Byte;
  options1:DWord);
    { Public declarations }
  end;
const default_url='https://delphijustin.biz/';
lastver_pas='lastver.pas';
compiletime_name='compiletime:tdatetime';
buildcount_name='compilecount:dword';
WIDECHAR_NAME='WIDE-Char';
VER_WIDECHAR_BY_DEFAULT=1;
VER_WIDECHAR_BY_SIZEOF=2;
VER_V1_TYPECAST_POINTER=4;
ver_allow_donations=8;
var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}
procedure taboutbox.Display;
var VUP:PVersionUpdate;
begin
image2.Visible:=(Options1 and ver_allow_donations>0);
image3.Visible:=image2.Visible;
image4.Visible:=image2.Visible;
if image2.Visible then
Label1.Caption:='If you like this app then support me by donating';
CharType.Caption :='ANSI-Char';
if options1 and ver_widechar_by_default>0then CharType.Caption :=WIDECHAR_NAME;
if(sizeof(char)=2)and(options1 and ver_widechar_by_sizeof>0)then
CharType.Caption :=WIDECHAR_NAME;
productname.Caption :=format(fmtname,[appname]);
version.Caption :=format('Version %u.%u.%u.%u',[v1,v2,v3,v4]);
if VER_V1_TYPECAST_POINTER and Options1>0 then begin vup:=Pointer(v1);
if vup.buildcount >0then Version.Caption :=Format('Build#%.0n',[vup.buildcount/1]);
if vup.compiletime>0then version.Caption :='Compiled on '+Datetimetostr(
vup.compiletime);
 end;
comments.Caption :=scomments;
if lpurl<>Nil then strdispose(lpurl);
lpurl:=strcopy(stralloc(1+length(default_url+url)),default_url);
strpcopy(Strend(lpurl),url);
show;
end;
procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
close;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
var thisfile:array[0..max_path]of char;
versionunit:tstringlist;
I,builderror:integer;
currentbuild:dword;
res:TResourceStream;
SLAbout:TStringlist;
begin
lpurl:=nil;
fmtname:=productname.Caption;
getmodulefilename(hinstance,thisfile,high(Thisfile));
apptype.Caption :=format(apptype.caption,[8*Sizeof(pointer)]);
apptype.Hint := image1.Hint;
versionexception:=nil;
programicon.Picture.Icon.Handle :=ExtractIcon(HINSTANCE,thisfile,0);
for I:=1to paramcount do
if comparetext('/delphiup',paramstr(I))=0 Then begin
versionunit:=tstringlist.Create;
if fileexists(lastver_pas)then versionunit.LoadFromFile(lastver_pas);
if versionunit.IndexOfName(compiletime_name)>0then
versionunit.Values[compiletime_name]:=format('%g;',[now]);
val(versionunit.Values[buildcount_name],currentbuild,builderror);
inc(currentbuild);
if pos(';',versionunit.Values[buildcount_name])>0then versionunit.Values[
buildcount_name]:=format('$%x;',[currentbuild]);
if versionunit.Count>0then try versionunit.SaveToFile(lastver_pas);
except on E:Exception do versionexception:=e;end;versionunit.Free;
end;
res:=nil;
if findresource(hinstance,MakeIntResource(1),'ABOUT')<>0 then res:=
tresourcestream.CreateFromID(hinstance,1,'ABOUT');
if assigned(res) then begin
slabout:=tstringlist.Create;slabout.LoadFromStream(res);res.Free;
productname.Caption:=format(productname.Caption,[slabout.values['Name']]);
comments.Caption:=slabout.Values['Comments'];
version.Caption:=slabout.Values['Version'];
if slabout.IndexOfName('slug')>-1then begin
lpurl:=strcopy(stralloc(256),default_url);strpcopy(strend(lpurl),slabout.Values[
'slug']);
end;
visible:=(application.MainForm=self);
end;
end;

procedure TAboutBox.Image1Click(Sender: TObject);
begin
shellexecute(handle,nil,default_Url,nil,nil,sw_normal);
end;

procedure TAboutBox.ProgramIconClick(Sender: TObject);
begin
shellexecute(handle,nil,lpurl,nil,nil,sw_normal);
end;

procedure TAboutBox.Image2Click(Sender: TObject);
begin
shellexecute(handle,nil,'https://www.paypal.com/paypalme/delphijustin',nil,nil,
sw_normal);
end;

procedure TAboutBox.Image3Click(Sender: TObject);
begin
shellexecute(handle,nil,'https://cash.app/$delphijustin',nil,nil,sw_normal);
end;

procedure TAboutBox.Image4Click(Sender: TObject);
begin
shellexecute(handle,nil,'https://app.ens.domains/delphijustin.eth',Nil,nil,SW_NORMAL);
end;

end.

