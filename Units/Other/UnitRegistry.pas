unit UnitRegistry;


interface
uses Registry, windows,ShlObj,IoUtils,System.Types;

procedure WriteBool(id:integer; value:boolean);
Function ReadBool(id:integer):boolean;
procedure Writeint(id:integer; value:integer);
Function Readint(id:integer):integer;
function GetSpecialPath(CSIDL: word): string;
function SearchFiles(const Path,SearchPattern:String;LookInSubFolders:boolean):TStringDynArray;

const
rg_COMPANY='AT-Control'; //!!!��������, ��� ��������� ���������, ����� �������� ������. � ��. ������!!!
rg_APPNAME='ATCSS1'; //!!!��������, ��� ��������� ���������, ����� �������� ������. � ��. ������!!!

//rg_Check_updates_on_startup=10; //��������� �� ���������� ��� ������� ���������

var
v_Root_Key_current_user:Boolean;
v_Key_Path:string;
v_Key_Name:string;
V_Def_Val_Bool:boolean;
V_Def_Val_int:integer;
const

  // ��������� �������������� ������� � ������ ShlObj:
  CSIDL_DESKTOP                       = $0000;
  // ����������� �������, �������������� ������� ����. (������ � ����������)
  CSIDL_INTERNET                      = $0001;
  // ����������� ������� ��� Internet Explorer.
  CSIDL_PROGRAMS                      = $0002;
  // ���� ���� -> ���������
  CSIDL_CONTROLS                      = $0003;
  // ����������� �������, ���������� ������ ������� ������ ����������
  CSIDL_PRINTERS                      = $0004;
  // ����������� �������, ���������� ������������� ��������
  CSIDL_PERSONAL                      = $0005;
  // ����������� �������, �������������� ����� "��� ���������"
  // �� Vista �������� �� �������� "��� ���������" �� ������ �����
  CSIDL_FAVORITES                     = $0006;
  // ���������. (������ C:\Documents and Settings\username\Favorites)
  CSIDL_STARTUP                       = $0007;
  // ���� -> ��������� -> ������������
  CSIDL_RECENT                        = $0008;
  // �������� ��������� (������ C:\Documents and Settings\username\My Recent Documents
  // ��� ���������� ������ ��������� ����������� SHAddToRecentDocs
  CSIDL_SENDTO                        = $0009;
  // �����, ���������� ������ ���� "���������" (Sent to...) (������ C:\Documents and Settings\username\SendTo)
  CSIDL_BITBUCKET                     = $000a;
  // ����������� �������, ���������� ����� � ������� �������� ������������
  CSIDL_STARTMENU                     = $000b;
  // �������� ���� ���� �������� ������������ (������ C:\Documents and Settings\username\Start Menu)
  CSIDL_DESKTOPDIRECTORY              = $0010;
  // ������� ���� �������� ������������ (������ C:\Documents and Settings\username\Desktop)
  CSIDL_DRIVES                        = $0011;
  // ����������� �������, �������������� ����� "��� ���������"
  CSIDL_NETWORK                       = $0012;
  // ����������� �������, �������������� "������� ���������"
  CSIDL_NETHOOD                       = $0013;
  // ����� "My Nethood Places" (������ C:\Documents and Settings\username\NetHood)
  // � �� ������ �� ��������� ����������� �������
  CSIDL_FONTS                         = $0014;
  // �����, ���������� ������������� ������. (������ C:\Windows\Fonts)
  CSIDL_TEMPLATES                     = $0015;
  // ������� ����������. (������ Settings\username\Templates)
  CSIDL_COMMON_STARTMENU              = $0016;
  // �������� ���� ���� ��� ���� �������������. (������ C:\Documents and Settings\All Users\Start Menu)
  // ���������, ������������ �� CSIDL_COMMON_ ���������� ������ � NT �������
  CSIDL_COMMON_PROGRAMS               = $0017;
  // ���� ���� -> ��������� ��� ���� ������������� (������ C:\Documents and Settings\All Users\Start Menu\Programs)
  CSIDL_COMMON_STARTUP                = $0018;
  // ���� ���� -> ��������� -> ������������ ��� ���� ������������� (������ C:\Documents and Settings\All Users\Start Menu\Programs\Startup)
  CSIDL_COMMON_DESKTOPDIRECTORY       = $0019;
  // �������� �������� ����� ��� ���� ������������� (������ C:\Documents and Settings\All Users\Desktop)
  CSIDL_APPDATA                       = $001a;
  // �����, � ������� �������� ������ ������� ���� ������(C:\Documents and Settings\username\Application Data)
  CSIDL_PRINTHOOD                     = $001b;
  // ������������� ��������. (������ C:\Documents and Settings\username\PrintHood)
  CSIDL_ALTSTARTUP                = $001d;         // DBCS
  // user's nonlocalized Startup program group. ��������.
  CSIDL_COMMON_ALTSTARTUP         = $001e;         // DBCS
  // ��������
  CSIDL_COMMON_FAVORITES          = $001f;
  // ������ "���������" ��� ���� �������������
  CSIDL_INTERNET_CACHE            = $0020;
  // ��������� Internet ����� (������ C:\Documents and Settings\username\Local Settings\Temporary Internet Files)
  CSIDL_COOKIES                   = $0021;
  // ����� ��� �������� Cookies (������ C:\Documents and Settings\username\Cookies)
  CSIDL_HISTORY                   = $0022;
  // ������ ������ �������� ������� IE

  // ��������� ��������������� ��� � ShlObj:
  CSIDL_ADMINTOOLS                = $30;
  // ���������������� ����������� �������� ������������ (�������� ������� MMC). Win2000+

  CSIDL_CDBURN_AREA               = $3b;
  // ����� ��� ������, �������������� � ������ �� CD/DVD
  // (������ C:\Documents and Settings\username\Local Settings\Application Data\Microsoft\CD Burning)

  CSIDL_COMMON_ADMINTOOLS         = $2f;
  // �����, ���������� ����������� �����������������

  CSIDL_COMMON_APPDATA            = $23;
  // ������ AppData ��� ���� �������������. (������ C:\Documents and Settings\All Users\Application Data)

  CSIDL_COMMON_DOCUMENTS          = $2e;
  // ����� "����� ���������" (������ C:\Documents and Settings\All Users\Documents)

  CSIDL_COMMON_TEMPLATES          = $2d;
  // ����� �������� ���������� ��� ���� ������������� (������ C:\Documents and Settings\All Users\Templates)

  CSIDL_COMMON_MUSIC              = $35;
  // ����� "��� ������" ��� ���� �������������. (������ C:\Documents and Settings\All Users\Documents\My Music)

  CSIDL_COMMON_PICTURES           = $36;
  // ����� "��� �������" ��� ���� �������������. (������ C:\Documents and Settings\All Users\Documents\My Pictures)

  CSIDL_COMMON_VIDEO              = $37;
  // ����� "�� �����" ��� ���� ������������� (C:\Documents and Settings\All Users\Documents\My Videos)

  CSIDL_COMPUTERSNEARME           = $3d;
  // ����������� �����, ������������ ������ ����������� � ����� ������� ������

  CSIDL_CONNECTIONS               = $31;
  // ����������� �����, ������������ ������ ������� �����������

  CSIDL_LOCAL_APPDATA             = $1c;
  // AppData ��� ����������, ������� �� ����������� �� ������ ��������� (������ C:\Documents and Settings\username\Local Settings\Application Data)

  CSIDL_MYDOCUMENTS               = $0c;
  // ����������� �������, �������������� ����� "��� ���������"

  CSIDL_MYMUSIC                   = $0d;
  // ����� "��� ������"

  CSIDL_MYPICTURES                = $27;
  // ����� "��� ��������"

  CSIDL_MYVIDEO                   = $0e;
  // ����� "�� �����"

  CSIDL_PROFILE                   = $28;
  // ����� ������������ (������ C:\Documents and Settings\username)

  CSIDL_PROGRAM_FILES             = $26;
  // ����� Program Files (������ C:\Program Files)

  CSIDL_PROGRAM_FILESX86          = $2a;

  CSIDL_PROGRAM_FILES_COMMON      = $2b;
  // ����� Program Files\Common (������ C:\Program Files\Common)

  CSIDL_PROGRAM_FILES_COMMONX86   = $2c;

  CSIDL_RESOURCES                 = $38;
  // ����� ��� ��������. Vista � ���� (������ C:\Windows\Resources)

  CSIDL_RESOURCES_LOCALIZED       = $39;

  CSIDL_SYSTEM                    = $25;
  // ������ System (������ C:\Windows\System32 ��� C:\Windows\System)

  CSIDL_SYSTEMX86                 = $29;

  CSIDL_WINDOWS                   = $24;
  // ����� Windows. ��� �� %windir% ��� %SYSTEMROOT% (������ C:\Windows)
implementation


function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
end;
Procedure Get_from_db(id:integer);

begin
case id of
0: //���� !!!��������, ��� ��������� ���������, ����� �������� ������. � ��. ������!!!
begin
    v_Root_Key_current_user:=true;
    v_Key_Path:='software\'+ rg_COMPANY+'\'+ rg_APPNAME;
    v_Key_Name:='Lang';
    V_Def_Val_int:=0;
    exit;
end;

10:  //��������� ���������� ��� ��������
  begin
    //��� - boolean
    v_Root_Key_current_user:=true;
    v_Key_Path:='software\'+ rg_COMPANY+'\'+ rg_APPNAME;
    v_Key_Name:='Check_updates_on_startup';
    V_Def_Val_Bool:=true;
    exit;
  end;

end;
end;

//Boolean
procedure WriteBool(id:integer; value:boolean);
 var Registry: TRegistry;
 begin
    Registry := TRegistry.Create();
    Get_from_db(id);
   { ������������� �������� ����; ������� hkey_local_machine ��� hkey_current_user }
   if v_Root_Key_current_user then Registry.RootKey:=hkey_current_user  else Registry.RootKey:=hkey_local_machine;
   Registry.OpenKey(v_Key_Path,true);
   registry.WriteBool(v_Key_Name,value);
   { ��������� � ����������� ���� }
   Registry.CloseKey;
   Registry.Free;
end;

Function ReadBool(id:integer):boolean;
 var Registry: TRegistry;
 begin
    Registry := TRegistry.Create();
    Get_from_db(id);
   { ������������� �������� ����; ������� hkey_local_machine ��� hkey_current_user }
   if v_Root_Key_current_user then Registry.RootKey:=hkey_current_user  else Registry.RootKey:=hkey_local_machine;
   Registry.OpenKey(v_Key_Path,true);
   if registry.ValueExists(v_Key_Name) then ReadBool:=registry.ReadBool( v_Key_Name)
   else
    begin
     registry.WriteBool(v_Key_Name,V_Def_Val_Bool);
     ReadBool:=V_Def_Val_Bool;
    end;
   { ��������� � ����������� ���� }
   Registry.CloseKey;
   Registry.Free;
end;
//Integer
procedure WriteInt(id:integer; value:integer);
 var Registry: TRegistry;
 begin
    Registry := TRegistry.Create();
    Get_from_db(id);
   { ������������� �������� ����; ������� hkey_local_machine ��� hkey_current_user }
   if v_Root_Key_current_user then Registry.RootKey:=hkey_current_user  else Registry.RootKey:=hkey_local_machine;
   Registry.OpenKey(v_Key_Path,true);
   registry.WriteInteger(v_Key_Name,value);
   { ��������� � ����������� ���� }
   Registry.CloseKey;
   Registry.Free;
end;

Function ReadInt(id:integer):integer;
 var Registry: TRegistry;
 begin
    Registry := TRegistry.Create();
    Get_from_db(id);
   { ������������� �������� ����; ������� hkey_local_machine ��� hkey_current_user }
   if v_Root_Key_current_user then Registry.RootKey:=hkey_current_user  else Registry.RootKey:=hkey_local_machine;
   Registry.OpenKey(v_Key_Path,true);
   if registry.ValueExists(v_Key_Name) then ReadInt:=registry.ReadInteger( v_Key_Name)
   else
    begin
     registry.WriteInteger(v_Key_Name,V_Def_Val_int);
     ReadInt:=V_Def_Val_int;
    end;
   { ��������� � ����������� ���� }
   Registry.CloseKey;
   Registry.Free;
end;




function SearchFiles(const Path,SearchPattern:String;LookInSubFolders:boolean):TStringDynArray;
var
sda:TStringDynArray;
begin
//TDirectory.GetFileSystemEntries(Path,TSearchOption.soAllDirectories);
if LookInSubFolders then sda:=TDirectory.GetFiles( Path,SearchPattern,TSearchOption.soAllDirectories) else sda:=TDirectory.GetFiles( Path,SearchPattern,TSearchOption.soTopDirectoryOnly) ;
SearchFiles:= sda;
end;


end.