unit HRDirectory;

interface

uses
  Classes, SysUtils, Forms;

type
  //目录管理器
  THRDirectory = class
  private
    FDirectory: String;
    FFilter: string;   //当前所有文件
    FFolders: TStringList; //当前所有子目录
    FFiles: TStringList;
    procedure Clear;
    function GetFiles: TStrings;
    procedure SetDirectory(const Value: String);
    function GetItem(Index: Integer): String;
    function GetFolders: TStrings;
    procedure SetFilter(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure Refresh;
    function ItemCount: Integer;
    property Items[Index: Integer]: String read GetItem; default;
    property Folders: TStrings read GetFolders;
    property Files: TStrings read GetFiles;
    property Directory: String read FDirectory write SetDirectory;
    property Filter: string read FFilter write SetFilter;
  end;

implementation

{ THRDirectory }

constructor THRDirectory.Create;
begin
  FFilter := '*.*';
  FDirectory := ExtractFilePath(Application.ExeName);
  FFolders := TStringList.Create;
  FFiles := TStringList.Create;
  Refresh;
end;

destructor THRDirectory.Destroy;
begin
  FreeAndNil(FFiles);
  FreeAndNil(FFolders);
  inherited;
end;

procedure THRDirectory.Clear;
begin
  FFolders.Clear;
  FFiles.Clear;
end;

function THRDirectory.GetFolders: TStrings;
begin
  Result := FFolders;
end;

function THRDirectory.GetFiles: TStrings;
begin
  Result := FFiles;
end;

function THRDirectory.ItemCount: Integer;
begin
  Result := FFiles.Count + FFolders.Count;
end;

function THRDirectory.GetItem(Index: Integer): String;
begin
  if (Index > -1) and (Index < ItemCount) then
    begin
      if Index < FFolders.Count then
        Result := FFolders.Strings[Index]
      else
        Result := FFiles.Strings[Index - FFolders.Count];
    end
  else
    Raise Exception.CreateFmt('List index out of bounds (%d)', [Index]);
end;

procedure THRDirectory.SetDirectory(const Value: String);
begin
  if FDirectory <> Value then
  begin
    FDirectory := Value;
    Refresh;
  end;
end;

procedure THRDirectory.SetFilter(const Value: string);
begin
  if FFilter <> Value then
  begin
    FFilter := Value;
    Refresh;
  end;
end;

procedure THRDirectory.Refresh;
var
  sr: TSearchRec;
begin
  Clear;
  if FDirectory <> '' then
  begin
    //取所有符合条件的文件.
    if FindFirst(FDirectory + FFilter, faAnyFile, sr) = 0 then
    begin
      repeat
        if FileExists(FDirectory + sr.Name) then
          FFiles.Add(FDirectory + sr.Name)
        else if (sr.Name <> '.') and (sr.Name <> '..')
          and DirectoryExists(FDirectory + sr.Name) then
          FFolders.Add(FDirectory + sr.Name);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;
end;

end.
