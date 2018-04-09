unit uHRIP;

interface

uses
  Classes, Forms, SysUtils, MainData, ApConst, uBaseIntf, uBuffer;

type
  THRIPManager = class(TComponent)
  private
    FDatabase: String;
    FParam: String;
    FObjName: String;
    FGroupBuff, FBuff: TErpBuffer;
    procedure SetDatabase(const Value: String);
    procedure SetParam(const Value: String);
    procedure SetObjName(const Value: String);
    function GetActive: Boolean;
  public
    function UpdateAddress(const sAddress: String; var sServer: String): Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    property Active: Boolean read GetActive;
    property Database: String read FDatabase write SetDatabase;
    property ObjName: String read FObjName write SetObjName;
    property Param: String read FParam write SetParam;
    property Buff: TErpBuffer read FBuff;
    property GroupBuff: TErpBuffer read FGroupBuff;
  end;

var
  HRIP: THRIPManager;

implementation

uses ErpTools;

{ THRIPManager }

constructor THRIPManager.Create(AOwner: TComponent);
begin
  inherited;
  //FServer := '127.0.0.1';
  FDatabase := 'Common';
  FObjName := '';
  FGroupBuff := TErpBuffer.Create(Self);
  FGroupBuff.IsGroupData := True;
  FGroupBuff.Database := 'Common';
  FBuff := TErpBuffer.Create(Self);
  FBuff.IsGroupData := False;
end;

destructor THRIPManager.Destroy;
begin
  FBuff.Free;
  FGroupBuff.Free;
  inherited;
end;

function THRIPManager.GetActive: Boolean;
begin
  Result := DM.DCOM.Connected;
end;
//
//function THRIPManager.GetServer: String;
//begin
//  Result := DM.ServerIP;
//end;

procedure THRIPManager.SetDatabase(const Value: String);
begin
  if AnsiCompareText(FDatabase, Value) <> 0 then
  begin
    if Value = '' then
      FDatabase := 'Common'
    else
      FDatabase := Value;
  end;
end;

procedure THRIPManager.SetObjName(const Value: String);
begin
  if FObjName <> Value then
    FObjName := Value;
end;

procedure THRIPManager.SetParam(const Value: String);
begin
  FParam := Value;
end;

function THRIPManager.UpdateAddress(const sAddress: String; var sServer: String): Boolean;
var
  sTemp: string;
  iPos: Integer;
begin
  Result := False;
  sTemp := sAddress;
  if (Pos(':', sAddress) = 0) and VarIsGuid(sAddress) then
    sTemp := 'HRIP:' + sAddress
  else
    if Copy(sAddress, 1, 1) = 'T' then
    begin
      sTemp := 'HRIP:' + sAddress;
    end;

  if Pos('HRIP:', UpperCase(sAddress)) = 0 then
  begin
    Result := False;
    Exit;
  end;

  //取Server
  if Pos('HRIP:', UpperCase(sTemp)) > 0 then
  begin
    HRIP.Param := '';
    iPos := Pos('?', sTemp);
    if iPos > 0 then
    begin
      HRIP.Param := Copy(sTemp, iPos + 1, Length(sTemp));
      sTemp := Copy(sTemp, 1, iPos - 1);
    end;
    sTemp := Copy(sTemp, 6, Length(sTemp));
    if Pos('//', sTemp) > 0 then
    begin
      sTemp := Copy(sTemp, 3, Length(sTemp));
      if Pos('/', sTemp) > 0 then
      begin
        sServer := Copy(sTemp, 1, Pos('/', sTemp) - 1);
        sTemp := Copy(sTemp, Pos('/', sTemp) + 1, Length(sTemp));
      end
      else
      begin
        sServer := sTemp;
        Result := True;
        Exit;
      end;
    end
    else
    begin
      HRIP.ObjName := sTemp;
      Result := True;
      Exit;
    end;
  end
  else
    Exit;
  //取数据库
  if Pos('/', sTemp) > 0 then
  begin
    HRIP.Database := Copy(sTemp, 1, Pos('/', sTemp) - 1);
    sTemp := Copy(sTemp , Pos('/', sTemp) + 1, Length(sTemp));
  end;
  //取类名
  if Pos('?', sTemp) > 0 then
    begin
      HRIP.ObjName := Copy(sTemp, 1, Pos('?', sTemp) - 1);
      HRIP.Param := Copy(sTemp, Pos('?', sTemp) + 1, Length(sTemp));
    end
  else
    HRIP.ObjName := sTemp;
  Result := True;
end;

initialization
  HRIP := THRIPManager.Create(nil);

finalization
  FreeAndNil(HRIP);

end.
