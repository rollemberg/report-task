unit AppService;

interface

uses
  Classes, SysUtils, Variants, ApConst, InfoBox, uBaseIntf, DBClient,
  DSConnect, SqlExpr, AppDB, Forms, MainData, Windows, ExtCtrls;

type
  {$message '注意：此对象若需要修改，须同时改动AppBean.pas'}
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
  TAppServiceState = (appNone, appReady, appError);
  TAppService = class(TComponent)
  private
    FDatabase: String;
    FService: String;
    FParam: OleVariant;
    FState: TAppServiceState;
    FRemoteServer: TCustomRemoteServer;
    procedure SetDatabase(const Value: String);
    procedure SetParam(const Value: OleVariant);
    procedure SetState(const Value: TAppServiceState);
    function GetParam: OleVariant;
    function GetService: String;
    function GetDatabase: String;
    procedure SetService(const Value: String);
    function GetMessages: String;
    function GetState: TAppServiceState;
    procedure SetRemoteServer(const Value: TCustomRemoteServer);
  protected
    FData: OleVariant;
    FError: OleVariant;
  public
    Response: TAppResponse;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; virtual;
  public
    property RemoteServer: TCustomRemoteServer read FRemoteServer write SetRemoteServer;
    property Database: String read GetDatabase write SetDatabase;
    property Service: String read GetService write SetService;
    property Param: OleVariant read GetParam write SetParam;
    property State: TAppServiceState read GetState write SetState;
    property Data: OleVariant read FData;
    property Error: OleVariant read FError;
    property Messages: String read GetMessages;
  end;
  TProxyWorkflow = class(TComponent)
  private
    FErrors: TStringList;
    FViewClass: String;
    FServiceName: String;
    FDatabase: String;
    procedure SetViewClass(const Value: String);
    procedure SetServiceName(const Value: String);
    procedure SetDatabase(const Value: String);
    function GetErrors: TStrings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowErrors;
    function Execute(const TBID: String; CurStatus,
      NewStatus: Integer): Boolean;
    property ViewClass: String read FViewClass write SetViewClass;
    property ServiceName: String read FServiceName write SetServiceName;
    property Database: String read FDatabase write SetDatabase;
    property Errors: TStrings read GetErrors;
  end;
  TAppService2 = class(TAppService)
  private
    FDataIn: TAppDataSet;
    FDataOut: TAppDataSet;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Exec(const AFirstParam: String): Boolean;
    property DataIn: TAppDataSet read FDataIn;
    property DataOut: TAppDataSet read FDataOut;
  end;

implementation

uses ErpTools;

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

{ TAppService }

procedure TAppService.SetDatabase(const Value: String);
begin
  FDatabase := Value;
end;

procedure TAppService.SetParam(const Value: OleVariant);
begin
  FParam := Value;
  State := appNone;
  FError := NULL;
end;

procedure TAppService.SetState(const Value: TAppServiceState);
begin
  FState := Value;
end;

function TAppService.Execute: Boolean;
var
  R: OleVariant;
  Val: OleVariant;
  CurSessionID: String;
  CurCorpCode: String;
  CurCostDept: String;
  LastTick: Cardinal;
  MessageObj: TObject;
  CheckMessage: TTimer;
  ReConnected: Boolean;
  RemoteConnection: TSQLConnection;
  Obj: TSQLServerMethod;
const
  CONST_DATABASE_UPDATE  = 987654321;
begin
  //令系统可以支持Response对象
  if VarIsNull(FParam) then
    begin
      if FDatabase = '' then
        Val := Response.GetVariant()
      else
        Val := VarArrayOf([CONST_DATABASE_UPDATE, FDatabase, Response.GetVariant()]);
    end
  else
    begin
      if FDatabase = '' then
        Val := FParam
      else
        Val := VarArrayOf([CONST_DATABASE_UPDATE, FDatabase, FParam]);
    end;
  //开始调用后台
  try
    CheckMessage := nil;
    ibox.DebugText('APS_EXECUTE: ' + FService);
    if FRemoteServer is TDSProviderConnection then
      begin
        MessageObj := nil;
        if MainIntf <> nil then
          MessageObj := MainIntf.GetControl('CheckMessage');
        if Assigned(MessageObj) then
        begin
          if MessageObj is TTimer then
          begin
            CheckMessage := (MessageObj as TTimer);
            CheckMessage.Enabled := False;
          end;
        end;
        Obj := TSQLServerMethod.Create(Self);
        try
          RemoteConnection  := TDSProviderConnection(FRemoteServer).SQLConnection;
          Obj.SQLConnection := RemoteConnection;
          try
            Obj.ServerMethodName := 'TCERCERP.Execute';
            Obj.Params[0].AsString := FService;
            Obj.Params[1].Value := Val;
            Obj.ExecuteMethod;
            R := Obj.Params[2].Value;
          except
            CurSessionID := DM.SessionID;
            CurCorpCode  := DM.CurrCorp;
            CurCostDept  := DM.CostDept;
            RemoteConnection.Close;
            ReConnected := False;
            LastTick := GetTickCount();
            while (not RemoteConnection.Connected) and (GetTickCount() - LastTick < 15000) do
            begin
              Application.ProcessMessages;
              try
                RemoteConnection.Open;
                if RemoteConnection.Connected then
                begin
                  //服务器端关闭之前的socket连接后，需要更新SessionID
                  DM.SessionID := GUIDNULL;
                  DM.SessionID := CurSessionID;
                  //更新当前所在公司别
                  if DM.MultiBookEnabled then
                  begin
                    Obj.ServerMethodName := 'TCERCERP.Update_CurrCorp';
                    Obj.Params[0].AsString := CurCorpCode;
                    Obj.ExecuteMethod;
                  end;
                  //更新当前所在成本中心
                  if not DM.CostDeptDisabled then
                  begin
                    Obj.ServerMethodName := 'TCERCERP.UpdateSession';
                    Obj.Params[0].AsString := 'CostDept';
                    Obj.Params[1].Value := CurCostDept;
                    Obj.ExecuteMethod;
                  end;
                  DM.CurrCorp := CurCorpCode;
                  DM.CostDept := CurCostDept;
                  ReConnected := True;
                end;
              except

              end;
            end;
            if ReConnected and (RemoteConnection.Connected) then
              begin
                Obj.ServerMethodName := 'TCERCERP.Execute';
                Obj.Params[0].AsString := FService;
                Obj.Params[1].Value := Val;
                Obj.ExecuteMethod;
                R := Obj.Params[2].Value;
              end
            else
              begin
                MsgBox(Chinese.AsString('非常抱歉！暂时无法连接应用服务器，请检查您的网络连接后再尝试重新登录系统！'));
                ErpTools.DestroyVirForm;
                Application.Terminate;
              end;
          end;
        finally
          Obj.Free;
        end;
      end
    else
      begin
        if not Assigned(RemoteServer) then
          raise Exception.CreateFmt('Error: TAppService.RemoteServer is nil, ServiceName=%s!', [FService]);
        R := RemoteServer.AppServer.Execute(FService, Val);
      end;
    FState := appReady;
    case VarArrayHighBound(R, 1) of
    1: //老版本，返回2个参数
      begin
        Result := R[0] = RET_OK;
        if Result then
          begin
            FData := R[1];
            FError := NULL;
          end
        else
          begin
            FData := NULL;
            FError := R[1];
          end;
      end;
    3: //新版本，返回3个参数
      begin
        Result := R[0] = RET_OK;
        //FAppVersion := R[1];
        FData := R[2];
        FError := R[3];
      end;
    else
      raise Exception.CreateFmt('AppBean 返回的参数数组数目(%d)不支持！', [VarArrayHighBound(R, 1)]);
    end;
    if Assigned(CheckMessage) then
      CheckMessage.Enabled := True;
  except
    on E: Exception do
    begin
      FState := appError;
      FError := Self.ClassName + ':' + E.Message;
      Result := False;
      //raise;
    end;
  end;
end;

{
调用范例：
procedure TForm1.Button1Click;
var
  app: TAppService;
begin
  app := TAppService.Create('TAppRecordSet');
  try
    app.Database := 'CERC';
    app.Param := 'Select * From Dept';
    if app.Execute then
      Self.ZjhDataSet1.Data := app.Value
    else if app.State = appReady then
      MsgBox(Chinese.AsString('执行不成功，%s返回的讯息为：%s%s'), [app.Service, vbCrLf, app.Message])
    else
      MsgBox(Chinese.AsString('调用%s发生错误：%s%s'), [app.Service, vbCrLf, app.Message]);
  finally
    app.Free;
  end;
end;
}

function TAppService.GetService: String;
begin
  Result := FService;
end;

function TAppService.GetDatabase: String;
begin
  Result := FDatabase;
end;

procedure TAppService.SetService(const Value: String);
begin
  FService := Value;
end;

function TAppService.GetParam: OleVariant;
begin
  Result := FParam;
end;

function TAppService.GetMessages: String;
var
  i: Integer;
begin
  if VarIsArray(FError) then
    begin
      Result := '';
      for i := 0 to VarArrayHighBound(FError, 1) do
      begin
        if Result = '' then
          Result := FError[i]
        else
          Result := Result + vbCrLf + FError[i];
      end;
    end
  else
    Result := VarToStr(FError);
end;

function TAppService.GetState: TAppServiceState;
begin
  Result := FState;
end;

procedure TAppService.SetRemoteServer(const Value: TCustomRemoteServer);
begin
  FRemoteServer := Value;
end;

constructor TAppService.Create(AOwner: TComponent);
begin
  inherited;
  FParam := NULL;
  if Assigned(DM) then
    FRemoteServer := DM.DCOM;
  Response := TAppResponse.Create;
end;

destructor TAppService.Destroy;
begin
  Response.Free;
  FRemoteServer := nil;
  inherited;
end;

{ TProxyWorkflow }

function TProxyWorkflow.Execute(const TBID: String;
  CurStatus, NewStatus: Integer): Boolean;
var
  app: TAppService;
begin
  Result := False;
  FErrors.Clear;
  app := TAppService.Create(Self);
  try
    app.RemoteServer := DM.DCOM;
    app.Service := ServiceName;
    app.Database := FDatabase;
    app.Param := VarArrayOf([TBID, CurStatus, NewStatus, ViewClass]);
    if app.Execute then
      Result := True
    else
      FErrors.Text := app.Messages;
  finally
    app.Free;
  end;
end;

function TProxyWorkflow.GetErrors: TStrings;
begin
  Result := FErrors;
end;

constructor TProxyWorkflow.Create(AOwner: TComponent);
begin
  inherited;
  FErrors := TStringList.Create;
end;

destructor TProxyWorkflow.Destroy;
begin
  FErrors.Free;
  inherited;
end;

procedure TProxyWorkflow.SetDatabase(const Value: String);
begin
  FDatabase := Value;
end;

procedure TProxyWorkflow.SetServiceName(const Value: String);
begin
  FServiceName := Value;
end;

procedure TProxyWorkflow.SetViewClass(const Value: String);
begin
  FViewClass := Value;
end;

procedure TProxyWorkflow.ShowErrors;
begin
  ShowErrorWind(FErrors);
end;

{ TAppService2 }

constructor TAppService2.Create(AOwner: TComponent);
begin
  inherited;
  FDataIn := TAppDataSet.Create;
  FDataIn.Head.FieldDefs.AutoMode := True;
  FDataIn.FieldDefs.AutoMode := True;
  FDataOut := TAppDataSet.Create;
  FDataOut.Head.FieldDefs.AutoMode := True;
  FDataOut.FieldDefs.AutoMode := True;
end;

destructor TAppService2.Destroy;
begin
  FDataOut.Free;
  FDataIn.Free;
  inherited;
end;

function TAppService2.Exec(const AFirstParam: String): Boolean;
begin
  Self.Param := VarArrayOf([AFirstParam, FDataIn.GetVariant()]);
  if Self.Execute() then
    begin
      FDataOut.SetVariant(Data);
      Result := True;
    end
  else
    Result := False;
end;

initialization
  RegClass(TAppService);

finalization
  UnRegClass(TAppService);

end.
