unit AppBean;
{$I ERPVersion.inc}

interface

uses
  Classes, ADODB, Variants, ApConst, SysUtils, Windows, IniFiles, Math,
  uBuffer, AppData, DB, uBaseIntf, SQLServer;

type
  TServiceSession = class(TAppSessionData)
  public
    Connection: TADOConnection;
    Buffer: TObjectBuffer;
  end;
  TServiceReadme = class
  private
    FService: String;
    FAuthor: String;
    FVersion: String;
    FParams: TStringList;
    FDatas: TStringList;
    FRemark: String;
    FHasSecurity: Boolean;
    procedure SetAuthor(const Value: String);
    procedure SetVersion(const Value: String);
    function GetParams: TStrings;
    procedure SetRemark(const Value: String);
    function GetDatas: TStrings;
    function StringsToString(Value: TStrings): String;
    procedure SetHasSecurity(const Value: Boolean);
  public
    constructor Create(AOwner: TObject);
    destructor Destroy; override;
    procedure addParam(const Value: String);
    procedure addData(const Value: String);
    function ToString(): String; override;
    function checkParam(const Param: OleVariant): Boolean;
  public
    property Service: String read FService write FService;
    property Author: String read FAuthor write SetAuthor;
    property Version: String read FVersion write SetVersion;
    property HasSecurity: Boolean read FHasSecurity write SetHasSecurity;
    property Params: TStrings read GetParams;
    property Datas: TStrings read GetDatas;
    property Remark: String read FRemark write SetRemark;
  end;
  TObjectFactory = class
  private
    FItems: TList;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateObject(AClass: TClass): TObject;
  end;
  TAppRequest = class
  private
    FNames: TStringList;
    FDatas: array of OleVariant;
    function GetNames(Index: Integer): String;
    function GetDatas(Index: String): Variant;
    function GetCount: Integer;
  public
    constructor Create(Value: Variant);
    destructor Destroy; override;
    function Exists(const AName: String): Boolean;
    property Count: Integer read GetCount;
    property Names[Index: Integer]: String read GetNames;
    property Datas[Index: String]: Variant read GetDatas; default;
  end;
  TAppResponse = class
  private
    FNames: array of String;
    FDatas: array of Variant;
  public
    destructor Destroy; override;
    procedure Clear;
    procedure Write(const AID: String; Value: Variant);
    function GetVariant: Variant;
  end;
  TAppBean = class(TComponent, IAppBean)
  private
    FReadme: TServiceReadme;
    FSession: TServiceSession;
    FStartTransaction: Boolean;
    function GetReadme: TServiceReadme;
    function getResource(const AKey, ADefault: String): String;
  protected
    Request: TAppRequest;
    function Connection: TADOConnection;
    function GetSession: TServiceSession;
    procedure SetSession(const Value: TServiceSession); virtual;
    function GetUserInfo(const AUserCode, ResultField: String): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; virtual; abstract;
    function ChineseAsString(const AKey, ADefault: String): String; virtual;
    function UnitDigit(Value: Double; const AUnit: String): Double;
    function FixDecimal_AsCurrency(const ACurrency: String; const Value: Double): Double;
    procedure StartTrans;
    procedure CommitTrans;
    procedure CloseTrans;
    procedure CreateRequest(Param: OleVariant);
    procedure WriteReadme(This: TServiceReadme); virtual;
    procedure SetSessionObject(Value: TObject);
    property Readme: TServiceReadme read GetReadme;
    property Session: TServiceSession read GetSession write SetSession;
    property StartTransaction: Boolean read FStartTransaction;
  end;
  TAppQuery = class(TADOQuery)
  private
    function GetCommandText: String;
    procedure SetCommandText(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    property CommandText: String read GetCommandText write SetCommandText;
  end;
  //
  procedure RegClass(const AClass: TComponentClass);
  procedure UnRegClass(const AClass: TComponentClass);
  procedure AppWriteInfo(Sender: TAppBean; const sFlag: String);
  function FixDecimal_AsLocalCurrency(Sender: TAppBean; const Value: Double): Double;

implementation

procedure RegClass(const AClass: TComponentClass);
begin
  if Assigned(PKGManger) then
    PKGManger.RegClass(AClass);
end;

procedure UnRegClass(const AClass: TComponentClass);
begin
  if Assigned(PKGManger) then
    PKGManger.UnRegClass(AClass)
end;

function ChineseAsString(Value: string): string;
begin
  Result := Value;
end;

procedure AppWriteInfo(Sender: TAppBean; const sFlag: String);
begin
  ureg.WriteInteger(Sender.ClassName + '.info', IntToStr(Integer(Pointer(Sender))) + '.' + sFlag,
    GetTickCount());
end;

{ TAppRequest }

constructor TAppRequest.Create(Value: Variant);
var
  i: Integer;
  FCount: Integer;
  bPass: Boolean;
  Item: Variant;
begin
  FNames := TStringList.Create;
  bPass := False;
  FCount := -1;
  //检查传入的参数是否合适
  if VarIsArray(Value) and (VarArrayDimCount(Value) = 1) then //必须是一维数组
  if VarArrayHighBound(Value, 1) > 0 then                     //必须至少有二个成员
  begin
    Item := Value[0];
    if (not VarIsArray(Item)) and VarIsNumeric(Item) then     //第一个成员必须为数值
    begin
      FCount := Item;
      if VarArrayHighBound(Value, 1) = FCount then            //总成员数必须等于Value[0]
      begin
        bPass := True;
        for i := 1 to FCount do
        begin
          Item := Value[i];
          //每个成员必须为一维数组，且每个成员只有二个元素
          if not (VarIsArray(Item) and (VarArrayDimCount(Item) = 1)
            and (VarArrayHighBound(Item, 1) = 1)) then
          begin
            bPass := False;
            Break;
          end;
        end;
      end;
    end;
  end;
  //若通过检查才予赋值
  if bPass then
  begin
    SetLength(FDatas, FCount);
    for i := 1 to FCount do
    begin
      FNames.Add(Value[i][0]);
      FDatas[i-1] := Value[i][1];
    end;
  end;
end;

destructor TAppRequest.Destroy;
begin
  FDatas := nil;
  FNames.Free;
  inherited;
end;

function TAppRequest.Exists(const AName: String): Boolean;
begin
  Result := FNames.IndexOf(AName) > -1;
end;

function TAppRequest.GetCount: Integer;
begin
  Result := High(FDatas) + 1;
end;

function TAppRequest.GetDatas(Index: String): Variant;
var
  i: Integer;
begin
  i := FNames.IndexOf(Index);
  if i > -1 then
    Result := FDatas[i]
  else
    raise Exception.CreateFmt('List index out of bounds (%s)', [Index]);
end;

function TAppRequest.GetNames(Index: Integer): String;
begin
  if (Index > -1) and (Index < FNames.Count) then
    Result := FNames[Index]
  else
    raise Exception.CreateFmt('List index out of bounds (%d)', [Index]);
end;

{ TAppResponse }

procedure TAppResponse.Write(const AID: String; Value: Variant);
var
  i: Integer;
begin
  i := High(FNames);
  i := i + 1;
  SetLength(FNames, i + 1);
  SetLength(FDatas, i + 1);
  FNames[i] := AID;
  FDatas[i] := Value;
end;

function TAppResponse.GetVariant: Variant;
var
  i: Integer;
begin
  if High(FDatas) > - 1 then
    begin
      Result := VarArrayCreate([Low(FDatas), High(FDatas) + 1], VarVariant);
      Result[0] := High(FDatas) + 1;
      for i := Low(FDatas) to High(FDatas) do
        Result[i+1] := VarArrayOf([FNames[i], FDatas[i]]);
    end
  else
    Result := NULL;
end;

procedure TAppResponse.Clear;
begin
  FNames := nil;
  FDatas := nil;
end;

destructor TAppResponse.Destroy;
begin
  Clear;
  inherited;
end;

{ TAppBean }

function TAppBean.GetReadme: TServiceReadme;
begin
  if not Assigned(FReadme) then
  begin
    FReadme := TServiceReadme.Create(Self);
    WriteReadme(FReadme);
  end;
  Result := FReadme;
end;

destructor TAppBean.Destroy;
begin
  Self.CloseTrans;
  if Assigned(FReadme) then
    FReadme.Free;
  if Assigned(Request) then
    Request.Free;
  inherited;
end;

function TAppBean.FixDecimal_AsCurrency(const ACurrency: String;
  const Value: Double): Double;
var
  Decimal: Integer;
  cdsMoney: TAppQuery;
  sBuff: String;
  sTmp1, nValue: Double;
  nFlag: Boolean;
begin
  Decimal := 2;
  cdsMoney := TAppQuery.Create(nil);
  try
    with cdsMoney do
    begin
      Connection := Self.Session.Connection;
      {$IFDEF ERP2011}
      SQL.Text := 'Select Code_,Decimal_ From Money Where StartDate_ is Null';
      {$ELSE}
      SQL.Text := 'Select Code_,Decimal_ From MoneyUnit';
      {$ENDIF}
      Open;
      if (not Eof) and Locate('Code_', ACurrency, [loCaseInsensitive]) then
        Decimal := FieldByName('Decimal_').AsInteger;
    end;
  finally
    FreeAndNil(cdsMoney);
  end;
  nFlag := False;
  if Value < 0 then
    nFlag := True;
  nValue := ABS(Value);
  sTmp1 := StrToFloat(Format('10e%d', [Decimal - 1]));
  sBuff := FloatToStr(nValue * sTmp1);
  if Pos('.', sBuff) > 0 then
  begin
    sBuff := Copy(sBuff, 1, Pos('.', sBuff) + 1);
    if sBuff[Length(sBuff)] >= '5' then
      sBuff := FloatToStr((StrToFloat(sBuff) + 1));
    sBuff := Copy(sBuff, 1, Pos('.', sBuff) - 1);
  end;
  if nFlag then
    Result := -(StrToFloat(sBuff) / sTmp1)
  else
    Result := StrToFloat(sBuff) / sTmp1;
end;

procedure TAppBean.WriteReadme(This: TServiceReadme);
begin
end;

function TAppBean.GetSession: TServiceSession;
begin
  Result := FSession;
end;

procedure TAppBean.SetSession(const Value: TServiceSession);
begin
  FSession := Value;
end;

procedure TAppBean.SetSessionObject(Value: TObject);
begin
  FSession := Value as TServiceSession;
end;

//取得指定用户之ID_
function TAppBean.GetUserInfo(const AUserCode, ResultField: String): String;
var
  ss: TSQLServer;
  cdsTmp: TAppQuery;
begin
  Result := '';
  ss := TSQLServer.Create();
  cdsTmp := TAppQuery.Create(nil);
  try
    if ss.Open('Common') then
    begin
      cdsTmp.Connection := ss.Connection;
      with cdsTmp do
      begin
        SQL.Text := Format('Select %s From Account Where Code_=''%s''',
            [ResultField, AUserCode]);
        Open;
        if not Eof then
          Result := Trim(FieldByName(ResultField).AsString);
      end;
    end;
  finally
    cdsTmp.Free;
    ss.Free;
  end;
end;

function TAppBean.getResource(const AKey, ADefault: String): String;
var
  Ini: TIniFile;
  strFile: String;
  Obj: TClass;
begin
  Result := ADefault;
  Obj := Self.ClassType;
  while not Obj.ClassNameIs('TAppBean') do
  begin
    if Self.Session.Version = 2008 then
      strFile := Format('%s%d\%s.xml', [ExtractFilePath(ParamStr(0)),
        GetSystemDefaultLangID(), Obj.ClassName])
    else
      strFile := Format('%s%d\%s.xml', [ExtractFilePath(ParamStr(0)),
        Session.ClientLangID, Obj.ClassName]);
    if FileExists(strFile) then
    begin
      Ini := TIniFile.Create(strFile);
      try
        if Ini.ValueExists('Resource', AKey) then
        begin
          Result := Ini.ReadString('Resource', AKey, ADefault);
          Break;
        end;
      finally
        FreeAndNil(Ini);
      end;
    end;
    Obj := Obj.ClassParent;
  end;
end;

procedure TAppBean.StartTrans;
begin
  if not Self.Connection.Connected then
    Self.Connection.Connected := True;
  if not Self.Connection.InTransaction then
  begin
    Self.Connection.BeginTrans;
    FStartTransaction := True;
  end;
end;

procedure TAppBean.CommitTrans;
begin
  if FStartTransaction then
  begin
    Self.Connection.CommitTrans;
    FStartTransaction := False;
  end;
end;

procedure TAppBean.CloseTrans;
begin
  if FStartTransaction then
  begin
    Self.Connection.RollbackTrans;
    FStartTransaction := False;
  end;
end;

function TAppBean.ChineseAsString(const AKey, ADefault: String): String;
begin
  Result := getResource(AKey, ADefault);
end;

function TAppBean.UnitDigit(Value: Double; const AUnit: String): Double;
var
  Digits: Integer;
  cdsDigit: TAppQuery;
begin
  Digits := 4;
  cdsDigit := TAppQuery.Create(nil);
  try
    with cdsDigit do
    begin
      Connection := Self.Session.Connection;
  	  {$IFDEF ERP2011}
      SQL.Text := Format('Select * From PartPurRate Where Unit_=''%s''',[AUnit]);
      Open;
      if Eof then
        begin
          Append;
          FieldByName('ID_').AsString := NewGuid;
          FieldByName('Unit_').AsString := AUnit;
          FieldByName('PurUnit_').AsString := AUnit;
          FieldByName('PurRate_').AsInteger := 1;
          FieldByName('AccDigit_').AsInteger := Digits;
          FieldByName('UpdateKey_').AsString := NewGuid;
          Post;
        end
      else
        Digits := FieldByName('AccDigit_').AsInteger;
      {$ELSE}
      SQL.Text := Format('select Digit_ from NumericUnit where Code_=N''%s'' ',[AUnit]);
      Open;
      if Eof then
        raise Exception.CreateFmt('单位名称[%s]不存在，请检查！', [AUnit])
      else
        Digits := FieldByName('Digit_').AsInteger;
      {$ENDIF}
    end;
  finally
    FreeAndNil(cdsDigit);
  end;
  if Digits = 0 then
    Result := Ceil(Value)
  else
    Result := RoundTo(Value, -Digits);
end;

function TAppBean.Connection: TADOConnection;
begin
  if Assigned(FSession) then
    Result := FSession.Connection
  else
    Result := nil;
end;

constructor TAppBean.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TAppBean then
    Self.Session := TAppBean(AOwner).Session;
  Self.FStartTransaction := False;
end;

procedure TAppBean.CreateRequest(Param: OleVariant);
begin
  Request := TAppRequest.Create(Param);
end;

{ TServiceReadme }

procedure TServiceReadme.addParam(const Value: String);
begin
  FParams.Add(Value);
end;

procedure TServiceReadme.addData(const Value: String);
begin
  FDatas.Add(Value);
end;

constructor TServiceReadme.Create(AOwner: TObject);
begin
  if Assigned(AOwner) then
    FService := AOwner.ClassName;
  FParams := TStringList.Create;
  FDatas := TStringList.Create;
  FHasSecurity := True;
end;

destructor TServiceReadme.Destroy;
begin
  FDatas.Free;
  FParams.Free;
  inherited;
end;

function TServiceReadme.GetParams: TStrings;
begin
  Result := FParams;
end;

function TServiceReadme.GetDatas: TStrings;
begin
  Result := FDatas;
end;

procedure TServiceReadme.SetAuthor(const Value: String);
begin
  FAuthor := Value;
end;

procedure TServiceReadme.SetRemark(const Value: String);
begin
  FRemark := Value;
end;

procedure TServiceReadme.SetVersion(const Value: String);
begin
  FVersion := Value;
end;

function TServiceReadme.toString: String;
begin
  Result := ChineseAsString('服务代码：') + FService + vbCrLf;
  if HasSecurity then
    Result := Result+ ChineseAsString('安全认证：需要登录系统后方可使用') + vbCrLf
  else
    Result := Result + ChineseAsString('安全认证：可匿名使用') + vbCrLf;
  Result := Result + ChineseAsString('执行参数：') + StringsToString(Self.Params) + vbCrLf;
  Result := Result + ChineseAsString('返回数据：') + StringsToString(Self.Datas) + vbCrLf;
  Result := Result + ChineseAsString('备注讯息：') + Self.Remark + vbCrLf;
  Result := Result + ChineseAsString('版本日期：') + Self.Version + vbCrLf;
  Result := Result + ChineseAsString('主要作者：') + Self.Author;
end;

function TServiceReadme.StringsToString(Value: TStrings): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Value.Count - 1 do
  begin
    if i = 0 then
      Result := Value.Strings[i]
    else
      Result := Result + ', ' + Value.Strings[i];
  end;
end;

procedure TServiceReadme.SetHasSecurity(const Value: Boolean);
begin
  FHasSecurity := Value;
end;

function TServiceReadme.CheckParam(const Param: OleVariant): Boolean;
begin
  if Params.Count = 0 then
  begin //没有注册参数讯息，无法判断
    Result := True;
    Exit;
  end;
  if Params.Count = 1 then
  begin
    if not VarIsArray(Param) then
    begin
      Result := True;
      Exit;
    end;
  end;
  if Params.Count > 1 then
  begin
    if VarIsArray(Param) then
    if (VarArrayHighBound(Param, 1) + 1) >= Params.Count then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

{ TAppQuery }

constructor TAppQuery.Create(AOwner: TComponent);
begin
  inherited;
  Self.EnableBCD := false; //处理小数点超过4位的问题
  if AOwner is TAppBean then
     Self.Connection := TAppBean(AOwner).Connection;
end;

function TAppQuery.GetCommandText: String;
begin
  Result := SQL.Text;
end;

procedure TAppQuery.SetCommandText(const Value: String);
begin
  SQL.Text := Value;
end;

{ TObjectFactory }

constructor TObjectFactory.Create;
begin
  FItems := TList.Create;
end;

function TObjectFactory.CreateObject(AClass: TClass): TObject;
begin
  Result := AClass.Create;
  FItems.Add(Result);
end;

destructor TObjectFactory.Destroy;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    TObject(FItems.Items[i]).Free;
  FItems.Free;
  inherited;
end;

function FixDecimal_AsLocalCurrency(Sender: TAppBean; const Value: Double): Double;
var
  Decimal: Integer;
  cdsMoney: TAppQuery;
  sBuff: String;
  sTmp1, nValue: Double;
  nFlag: Boolean;
begin
  Decimal := 2;
  cdsMoney := TAppQuery.Create(nil);
  try
    with cdsMoney do
    begin
      Connection := Sender.Session.Connection;
      {$IFDEF ERP2011}
      SQL.Text := 'Select Code_,Decimal_,Rate_ From Money Where StartDate_ is Null and Rate_=1';
      {$ELSE}
      SQL.Text := 'Select Code_,Decimal_,LocalDefault_ From MoneyUnit where LocalDefault_=1';
      {$ENDIF}
      Open;
      if not Eof then Decimal := FieldByName('Decimal_').AsInteger;
    end;
  finally
    FreeAndNil(cdsMoney);
  end;
  nFlag := False;
  if Value < 0 then
    nFlag := True;
  nValue := ABS(Value);
  sTmp1 := StrToFloat(Format('10e%d', [Decimal - 1]));
  sBuff := FloatToStr(nValue * sTmp1);
  if Pos('.', sBuff) > 0 then
  begin
    sBuff := Copy(sBuff, 1, Pos('.', sBuff) + 1);
    if sBuff[Length(sBuff)] >= '5' then
      sBuff := FloatToStr((StrToFloat(sBuff) + 1));
    sBuff := Copy(sBuff, 1, Pos('.', sBuff) - 1);
  end;
  if nFlag then
    Result := -(StrToFloat(sBuff) / sTmp1)
  else
    Result := StrToFloat(sBuff) / sTmp1;
end;

end.
