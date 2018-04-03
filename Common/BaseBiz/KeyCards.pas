unit KeyCards;

interface

uses
  Windows, Messages, Classes, SysUtils, IniFiles, Forms;

type
  TKeyCard = class(TComponent)
  private
    Ini: TMemIniFile;
    FHosts, FNames, FDatas: TStringList;
    FFileName: String;
    function GetRunPath: String;
    procedure SetRunPath(const Value: String);
    function GetDatabase: String;
    procedure SetDatabase(const Value: String);
  private
    function GetCaption: String;
    procedure SetFileName(const Value: String);
    procedure SetCaption(const Value: String);
    function GetCardNo: String;
    procedure SetCardNo(const Value: String);
  public
    procedure Save;
    function Count: Integer;
    function ReadFromFile(const AFileName: String): String;
    function WriteToFile(const AFileName, Val: String): Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Hosts: TStringList read FHosts;
    property Items: TStringList read FNames;
    property Datas: TStringList read FDatas;
    property CardNo: String read GetCardNo write SetCardNo;
    property Caption: String read GetCaption write SetCaption;
    property FileName: String read FFileName write SetFileName;
    property RunPath: String read GetRunPath write SetRunPath;
    property Database: String read GetDatabase write SetDatabase;
  end;

  TKeyCards = class(TComponent)
  private
    FPath: String;
    FActive: Boolean;
    FItems: TList;
    function GetCard(Index: Integer): TKeyCard;
    procedure SetActive(const Value: Boolean);
  public
    procedure Open;
    procedure Close;
    function ItemCount: Integer;
    property Items[Index: Integer]: TKeyCard read GetCard; default;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Active: Boolean read FActive write SetActive;
    property Path: String read FPath write FPath;
  end;


implementation

uses ApConst;

{ TKeyCard }

function TKeyCard.ReadFromFile(const AFileName: String): String;
var
  F: TFileStream;
  S: TStringStream;
begin
  S := TStringStream.Create('');
  F := TFileStream.Create(FileName,fmOpenRead);
  try
    S.CopyFrom(F,F.Size);
    Result := s.DataString;
  finally
    F.Free;
    S.Free;
  end;
end;

function TKeyCard.WriteToFile(const AFileName, Val: String): Boolean;
var
  F: TFileStream;
  S: TStringStream;
begin
  if FileExists(FileName) then DeleteFile(FileName);
  S := TStringStream.Create(Val);
  F := TFileStream.Create(FileName,fmCreate);
  try
    F.CopyFrom(S,S.Size);
    Result := True;
  finally
    F.Free;
    S.Free;
  end;
end;

constructor TKeyCard.Create(AOwner: TComponent);
begin
  inherited;
  Ini := TMemIniFile.Create('');
  FHosts := TStringList.Create;
  FNames := TStringList.Create;
  FDatas := TStringList.Create;
end;

destructor TKeyCard.Destroy;
begin
  Ini.Free;
  FHosts.Free;
  FNames.Free;
  FDatas.Free;
  inherited;
end;

procedure TKeyCard.SetFileName(const Value: String);
var
  i: Integer;
  sl: TStringList;
  str, s1, s2, s3: String;
begin
  if FFileName = Value then Exit;
  FFileName := Value;
  FHosts.Clear; FNames.Clear;
  sl := TStringList.Create;
  try
    Ini.SetStrings(sl);
    str := ReadFromFile(FFileName);
    str := Encrypt(str,SECURITY_PASSWORD,False);
    sl.Text := str;
    Ini.SetStrings(sl);
    for i := 0 to 100 do
    begin
      if Ini.ValueExists('Server' + IntToStr(i),'Address') then
      begin
        s1 := Ini.ReadString('Server' + IntToStr(i),'Address','');
        s2 := Ini.ReadString('Server' + IntToStr(i),'Name',s1);
        s3 := Ini.ReadString('Server' + IntToStr(i),'Database','');
        FHosts.Add(s1);
        FNames.Add(s2);
        FDatas.Add(s3);
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure TKeyCard.Save;
var
  str: String;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    Ini.SetStrings(sl);
    str := sl.Text;
    str := Encrypt(str,SECURITY_PASSWORD,True);
    WriteToFile(FileName,str);
  finally
    sl.Free;
  end;
end;

function TKeyCard.GetCaption: String;
begin
  Result := Ini.ReadString('Security','CardName','noname');
end;

procedure TKeyCard.SetCaption(const Value: String);
begin
  Ini.WriteString('Security','CardName',Value);
end;

function TKeyCard.GetCardNo: String;
begin
  Result := Ini.ReadString('Security','CardNo',GuidNull);
end;

procedure TKeyCard.SetCardNo(const Value: String);
begin
  Ini.WriteString('Security','CardNo',Value);
end;

function TKeyCard.Count: Integer;
begin
  Result := FHosts.Count;
end;

function TKeyCard.GetRunPath: String;
begin
  Ini.ReadString('Security','RunPath','')
end;

procedure TKeyCard.SetRunPath(const Value: String);
begin
  Ini.WriteString('Security','RunPath',Value)
end;

function TKeyCard.GetDatabase: String;
begin
  Result := Ini.ReadString('Param','Database','');
end;

procedure TKeyCard.SetDatabase(const Value: String);
begin
  Ini.WriteString('Param','Database',Value);
end;

{ TKeyCards }

constructor TKeyCards.Create(AOwner: TComponent);
begin
  inherited;
  FPath := ExtractFilePath(Application.ExeName);
  FItems := TList.Create;
end;

destructor TKeyCards.Destroy;
begin
  Close;
  inherited;
end;

procedure TKeyCards.Open;
var
  kc: TKeyCard;
  sr: TSearchRec;
begin
  if FActive then Raise Exception.Create('Open error!');
  if FindFirst(FPath + '*.Key', faAnyFile, sr) = 0 then
  begin
    repeat
      kc := TKeyCard.Create(Self);
      kc.FileName := FPath + sr.Name;
      FItems.Add(kc);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  FActive := True;
end;

procedure TKeyCards.Close;
var
  i: Integer;
  v: TKeyCard;
begin
  for i := FItems.Count - 1 downto 0 do
  begin
    v := TKeyCard(FItems.Items[i]); v.Free;
    FItems.Delete(i);
  end;
end;

procedure TKeyCards.SetActive(const Value: Boolean);
begin
  if FActive = Value then Exit;
  if Value then Open else Close; //¿ª  
  FActive := Value;
end;

function TKeyCards.ItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TKeyCards.GetCard(Index: Integer): TKeyCard;
begin
  Result := TKeyCard(FItems.Items[Index]);
end;

end.
