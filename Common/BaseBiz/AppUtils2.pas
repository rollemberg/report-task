unit AppUtils2;
{$I ERPVersion.Inc}

interface

uses
  Classes, SysUtils, Variants, ApConst, uBaseIntf, DBClient,
  DSConnect, SqlExpr, Forms, Windows, ExtCtrls, DB, Dialogs,
  SOUtils2, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, Controls, ZjhCtrls, InfoBox, ADODB, AppDB2;

type
  //专用于单据前后台数据传递
  IHttpObject = interface
    ['{38E464FE-5D35-4CA4-B8AA-DEC49AE71D84}']
    function Post(dataIn: ISuperObject): Boolean;
    function getDataOut: ISuperObject;
    function getMessages: string;
    property dataOut: ISuperObject read getDataOut;
    property Messages: string read getMessages;
  end;
  THttpObject = class(TInterfacedObject, IHttpObject)
  private
    dataOut: ISuperObject;
    FUrl: string;
    FMessages: string;
    procedure SetUrl(const Value: string);
  public
    function Post(dataIn: ISuperObject): Boolean;
    function getDataOut: ISuperObject;
    function getMessages: string;
    property Url: string read FUrl write SetUrl;
  end;
  IAppService = interface(IOutputMessage2)
    function Exec: Boolean;
    function GetDataIn: TAppDataSet;
    function GetDataOut: TAppDataSet;
    function GetService: String;
    function GetMessages: String;
    function GetDatabase: String;
    procedure SetDatabase(const Value: String);
    procedure SetService(const Value: String);
    property DataIn: TAppDataSet read GetDataIn;
    property DataOut: TAppDataSet read GetDataOut;
    property Database: String read GetDatabase write SetDatabase;
    property Service: String read GetService write SetService;
    property Messages: String read GetMessages;
  end;
  TWebServiceState = (wssNone, wssSending, wssOK, wssError);
  TAppService3 = class(TInterfacedObject, IAppService, IOutputMessage2)
  private
    FOwner: TComponent;
    FList: TList;
    FConnected: Boolean;
    FSessionID: string;
    FDatabase: string;
    FDataIn: TAppDataSet;
    FDataOut: TAppDataSet;
    FOnReturn: TNotifyEvent;
    FMessages: string;
    FService: string;
    FState: TWebServiceState;
    FTimeOut: Int64;
    FServerPort: string;
    function GetServerPort: string;
    procedure SetConnected(const Value: Boolean);
    procedure SetSessionID(const Value: string);
    procedure SetOnReturn(const Value: TNotifyEvent);
    procedure SetService(const Value: string);
    procedure SetTimeOut(const Value: Int64);
    function GetDataIn: TAppDataSet;
    function GetDataOut: TAppDataSet;
    function GetService: String;
    procedure SetDataIn(const Value: TAppDataSet);
    procedure SetDataOut(const Value: TAppDataSet);
    function GetMessages: String;
    function GetDatabase: String;
    procedure SetDatabase(const Value: String);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function Exec: Boolean;
    //IOutputMessage2
    procedure OutputMessage(Sender: TObject; const Value: String;
      MsgLevel: TMsgLevelOption);
    function Login(const AUserCode, APassword: string;
      const AMachineID: string = ''): Boolean;
  public
    property SessionID: string read FSessionID write SetSessionID;
    property DataIn: TAppDataSet read GetDataIn write SetDataIn;
    property DataOut: TAppDataSet read GetDataOut write SetDataOut;
    property Service: String read GetService write SetService;
    property Messages: String read GetMessages;
    property ServerPort: string read GetServerPort;
    property Connected: Boolean read FConnected write SetConnected;
    property OnReturn: TNotifyEvent read FOnReturn write SetOnReturn;
    property TimeOut: Int64 read FTimeOut write SetTimeOut;
    property State: TWebServiceState read FState;
  end;
  function Service(const AService: string): IAppService;
  procedure ServiceLog(const AService: string; TickCount: Int64);
  function HttpObject(const service: string): IHttpObject;
  //登录到地藤系统，可重复调用
  function loginToVine: Boolean; overload;
  function loginToVine(Account,Password: String): Boolean; overload;

  //写入日志
  procedure WriteLog(const AText: string);

const csAppServer = 'AppSvr';

var
  __ServerIP: string;
  __SessionID: string;
  __LogSwitch: Integer = 0;
  __JavaHost: Integer = -1;

implementation

var
  __OCS_Server: string;

{ TAppService3 }

constructor TAppService3.Create(AOwner: TComponent);
begin
  FOwner := AOwner;
  FServerPort := sreg.ReadString('WebService', 'ServerPort', '80');
  FSessionID := __SessionID;
  FList := TList.Create;
  FState := wssNone;
  FTimeOut := 5000;
end;

destructor TAppService3.Destroy;
var
  i: Integer;
  Item: TAppDataSet;
begin
  for i := 0 to FList.Count - 1 do
  begin
    Item := FList.Items[i];
    Item.Free;
  end;
  FList.Free;
  if FConnected then
    Connected := False;
  inherited;
end;

function TAppService3.Exec: Boolean;
var
  http: IHttpObject;
  data, Item: ISuperObject;
  FetchFinish: boolean;
  check: Integer;
  offset, maximum, total, FetchCount: Integer;
  def: TCursor;
begin
  Result := False;
  if FService = '' then
    raise Exception.Create('Service 不允许为空！');
  FState := wssSending;
  DataOut.JSON := nil;

  http := HttpObject(Self.Service);
  data := SO();
  //data.S['param'] := AppBean.Base64Encode(Self.DataIn.JSON.AsJSon());

  def := Screen.Cursor;
  try
    offset := 0;
    if DataIn.Head.FieldDefs.Exists('MaxRecord_') then
      begin
        total := DataIn.Head.FieldByName('MaxRecord_').AsInteger;
        if total > 5000 then
          begin
            Screen.Cursor := crHourGlass;
            maximum := 5000;
          end
        else
          maximum := total;
      end
    else
      begin
        total := -1;
        maximum := 5000;
      end;
    DataIn.Head.FieldByName('MaxRecord_').AsInteger := maximum;
    
    FetchCount := 0;
    while true do
    begin
      Inc(FetchCount);
      Result := False;
      check := DataOut.RecordCount;
      if http.Post(Self.DataIn.JSON) then
      begin      
        Result := http.dataOut.B['result'];
        if http.dataOut.AsObject.Find('data', Item) then
          DataOut.JSON := Item;
      end;
      FMessages := http.Messages;

      if not Result then
        Break;
      if check = DataOut.RecordCount then
        Break;

      //判断是否有全部取出数据
      FetchFinish := true;
      if DataOut.Head.FieldDefs.Exists('__finish__') then
        FetchFinish := DataOut.Head.FieldByName('__finish__').AsBoolean;
      if FetchFinish then
        Break;

      if (total > -1) and (DataOut.RecordCount >= total) then
        Break;

      offset := offset + maximum;
      DataIn.Head.FieldByName('__offset__').AsInteger := offset;
      
      if (total > -1) and (maximum > (total - DataOut.RecordCount)) then
        DataIn.Head.FieldByName('MaxRecord_').AsInteger := total - DataOut.RecordCount;
      ibox.Text('已取出 %d 条数据，开始取第 %d 次数据，请稍等！',
        [DataOut.RecordCount, FetchCount]);

      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      Sleep(300);
      if FetchCount >= 50 then    
      begin
        MsgBox('对不起，系统最多允许一次导出25万笔数据，详情请与客服联系！');
        Break;
      end;
    end;
    if FetchCount > 1 then
      ibox.Text('数据全部取出，共执行 %d 次，总计 %d 笔！',
        [FetchCount, DataOut.RecordCount]);
  finally
    Screen.Cursor := def;
  end;
end;

function TAppService3.Login(const AUserCode, APassword, AMachineID: string): Boolean;
begin
  Self.Service := 'TAppLogin.Check';
  with Self.DataIn.Head do
  begin
    FieldByName('Account_').AsString := AUserCode;
    FieldByName('Password_').AsString := APassword;
    if AMachineID <> '' then
      FieldByName('MachineID_').AsString := AMachineID
    else
      FieldByName('MachineID_').AsString := NBGetVolumnNo();
  end;
  Result := Exec;
end;

function TAppService3.GetDatabase: String;
begin
  Result := FDatabase;
end;

function TAppService3.GetDataIn: TAppDataSet;
begin
  if not Assigned(FDataIn) then
  begin
    FDataIn := TAppDataSet.Create;
    FList.Add(FDataIn);
  end;
  Result := FDataIn;
end;

function TAppService3.GetDataOut: TAppDataSet;
begin
  if not Assigned(FDataOut) then
  begin
    FDataOut := TAppDataSet.Create;
    FList.Add(FDataOut);
  end;
  Result := FDataOut;
end;

function TAppService3.GetMessages: String;
begin
  Result := FMessages;
end;

function TAppService3.GetServerPort: string;
begin
  Result := FServerPort;
end;

function TAppService3.GetService: String;
begin
  Result := FService;
end;

procedure TAppService3.OutputMessage(Sender: TObject; const Value: String;
  MsgLevel: TMsgLevelOption);
begin
  if MsgLevel = MSG_DEBUG then
  begin
    if not ibox.Debug then
      Exit;
  end;
  if Supports(Self.FOwner, IOutputMessage2) then
    (Self.FOwner as IOutputMessage2).OutputMessage(Sender, Value, MsgLevel)
  else if MsgLevel <> MSG_DEBUG then
    MsgBox(Value);
end;

procedure TAppService3.SetConnected(const Value: Boolean);
begin
  FConnected := Value;
end;

procedure TAppService3.SetDatabase(const Value: String);
begin
  FDatabase := Value;
end;

procedure TAppService3.SetDataIn(const Value: TAppDataSet);
var
  i: Integer;
begin
  if FDataIn <> Value then
  begin
    i := FList.IndexOf(FDataIn);
    if i > -1 then
    begin
      FDataIn.Free;
      FList.Delete(i);
    end;
    FDataIn := Value;
  end;
end;

procedure TAppService3.SetDataOut(const Value: TAppDataSet);
var
  i: Integer;
begin
  if FDataOut <> Value then
  begin
    i := FList.IndexOf(FDataOut);
    if i > -1 then
    begin
      FDataIn.Free;
      FList.Delete(i);
    end;
    FDataOut := Value;
  end;
end;

procedure TAppService3.SetOnReturn(const Value: TNotifyEvent);
begin
  FOnReturn := Value;
end;

procedure TAppService3.SetService(const Value: string);
begin
  if FService <> Value then
  begin
    if Pos('.', Value) = 0 then
      raise Exception.Create('Service的格式必须为：TAppXXX.XXX!');
    FService := Value;
  end;
end;

procedure TAppService3.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TAppService3.SetTimeOut(const Value: Int64);
begin
  FTimeOut := Value;
end;

function Service(const AService: string): IAppService;
var
  app3: TAppService3;
begin
  app3 := TAppService3.Create(nil);
  app3.Service := AService;
  Result := app3;
end;

procedure ServiceLog(const AService: string; TickCount: Int64);
var
  f: TextFile;
  LogFile, str: string;
begin
  if __LogSwitch = 0 then
  begin
    if ureg.ReadBool('system', 'WriteLog', True) then
      __LogSwitch := 1
    else
      __LogSwitch := 2;
  end;
  if __LogSwitch <> 1 then
    Exit;
  LogFile := SystemRootPath() + 'Client\vine.log';
  str := Format('%s,%s,%s,%s,%s', ['131001', AService, IntToStr(TickCount),
    '', DateTimeToStr(Now())]);
  AssignFile(f, LogFile);
  try
    if FileExists(LogFile) then
      Append(f)
    else
      Rewrite(f);
    Writeln(f, str);
  finally
    CloseFile(f);
  end;
end;

function loginToVine: Boolean;
var
  app: IAppService;
  corpNo: String;
begin
  if __SessionID <> '' then
  begin
    Result := True;
    Exit;
  end;
  app := Service('TAppLogin.Check');
  app.DataIn.Head.FieldByName('Account_').AsString := sreg.ReadString('SyncERP', 'Account', '91200401');
  app.DataIn.Head.FieldByName('Password_').AsString := sreg.ReadString('SyncERP', 'Password', '123456');
  app.DataIn.Head.FieldByName('MachineID_').AsString := NBGetVolumnNo();
  app.DataIn.Head.FieldByName('ClientName_').AsString := 'ERP系统';
  if app.Exec then
    begin
      corpNo := app.DataOut.Head.FieldByName('CorpNo_').AsString;
      if corpNo <> '912004' then
        raise Exception.Create('公司别有误，登录失败！');
      __SessionID := app.DataOut.Head.FieldByName('SessionID_').AsString;
      Result := true;
    end
  else
    raise Exception.Create(app.Messages);
end;

function loginToVine(Account,Password:String): Boolean;
var
  app: IAppService;
  corpNo: String;
begin
  if __SessionID <> '' then
  begin
    Result := True;
    Exit;
  end;
  app := Service('TAppLogin.Check');
  app.DataIn.Head.FieldByName('Account_').AsString := Account;
  app.DataIn.Head.FieldByName('Password_').AsString := Password;
  app.DataIn.Head.FieldByName('MachineID_').AsString := NBGetVolumnNo();
  app.DataIn.Head.FieldByName('ClientName_').AsString := 'ERP系统';
  if app.Exec then
    begin
      corpNo := app.DataOut.Head.FieldByName('CorpNo_').AsString;
      __SessionID := app.DataOut.Head.FieldByName('SessionID_').AsString;
      Result := true;
    end
  else
    raise Exception.Create(app.Messages);
end;

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

{ THttpObject }

function THttpObject.getDataOut: ISuperObject;
begin
  Result := Self.dataOut;
end;

function THttpObject.getMessages: string;
begin
  Result := Self.FMessages;
end;
//
//function THttpObject.URLDecode(const S: string): string;
//var
//  Idx: Integer;   // loops thru chars in string
//  Hex: string;    // string of hex characters
//  Code: Integer;  // hex character code (-1 on error)
//begin
//  // Intialise result and string index
//  Result := '';
//  Idx := 1;
//  // Loop thru string decoding each character
//  while Idx <= Length(S) do
//  begin
//    case S[Idx] of
//      '%':
//      begin
//        // % should be followed by two hex digits - exception otherwise
//        if Idx <= Length(S) - 2 then
//        begin
//          // there are sufficient digits - try to decode hex digits
//          Hex := S[Idx+1] + S[Idx+2];
//          Code := SysUtils.StrToIntDef('$' + Hex, -1);
//          Inc(Idx, 2);
//        end
//        else
//          // insufficient digits - error
//          Code := -1;
//        // check for error and raise exception if found
//        if Code = -1 then
//          raise SysUtils.EConvertError.Create(
//            'Invalid hex digit in URL'
//          );
//        // decoded OK - add character to result
//        Result := Result + Chr(Code);
//      end;
//      '+':
//        // + is decoded as a space
//        Result := Result + ' '
//      else
//        // All other characters pass thru unchanged
//        Result := Result + S[Idx];
//    end;
//    Inc(Idx);
//  end;
//end;
//
//
//function THttpObject.URLEncode(const S: string; const InQueryString: Boolean): string;
//var
//  Idx: Integer; // loops thru characters in string
//begin
//  Result := '';
//  for Idx := 1 to Length(S) do
//  begin
//    case S[Idx] of
//      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
//        Result := Result + S[Idx];
//      ' ':
//        if InQueryString then
//          Result := Result + '+'
//        else
//          Result := Result + '%20';
//      else
//        Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
//    end;
//  end;
//end;

function THttpObject.Post(dataIn: ISuperObject): Boolean;
var
  IdHTTP: TIdHTTP;
  sl: TStringStream;
  str, site: string;
begin
  Result := False;
  IdHTTP := TIdHTTP.Create(nil);
  sl := TStringStream.Create;
  try
    IdHTTP.ReadTimeout := 0;
    IdHTTP.AllowCookies := True;
    IdHTTP.ProxyParams.BasicAuthentication := False;
    IdHTTP.ProxyParams.ProxyPort := 0;
    IdHTTP.Request.ContentLength := -1;
    IdHTTP.Request.ContentRangeEnd := 0;
    IdHTTP.Request.ContentRangeStart := 0;
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.Accept := 'text/html, */*';
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.UserAgent := 'Mozilla/3.0 (compatible; Indy Library)';
    IdHTTP.HTTPOptions := [hoForceEncodeParams];
    if Assigned(dataIn) then
    begin
      sl.WriteString(dataIn.AsJSon());
      //sl.WriteString(URLEncode(dataIn.AsJSon(), False));
      //sl.WriteString(Base64Encode(dataIn.AsJSon()));
    end;
    while True do
    begin
      try
        FMessages := '';
        site := Self.FUrl;
//        if Pos('?', Self.FUrl) > 0 then
//          site := Self.FUrl + '&encode=base64'
//        else
//          site := Self.FUrl + '?encode=base64';
        str := IdHTTP.Post(site, sl);
        dataOut := SO(str);
        if Assigned(dataOut) and dataOut.IsType(stObject) then
          begin
            FMessages := dataOut.S['message'];
            Result := dataOut.B['result'];
            Break;
          end
        else
          begin
            WriteLog('HttpObject Data Error: ' + str);
            Application.ProcessMessages;
          end;
      except
        on E: Exception do
        begin
          WriteLog('HttpObject[' + e.ClassName + '] Error:' + e.Message);
          FMessages := e.Message;
          Result := False;
          if MessageDlg('糟糕，您的网络质量不佳，系统已与云端断开连接！'
            + vbCrLf + '您计划是：Yes = 重试一次(建议过1分钟后再试)，No = 退出系统！',
            mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
          begin
            MsgBox(Chinese.AsString('非常抱歉！暂时无法连接应用服务器，请检查您的网络连接后再尝试重新登录系统！'));
            Application.Terminate;
            Break;
          end;
        end;
      end;
    end;
  finally
    sl.Free;
    IdHTTP.Free;
  end;
end;

procedure THttpObject.SetUrl(const Value: string);
begin
  FUrl := Value;
end;

function HttpObject(const service: string): IHttpObject;
var
  obj: THttpObject;
  host, url: String;
begin
  obj := THttpObject.Create;
  if Copy(service, 1, 7) <> 'http://' then
    begin
      host := __ServerIP;
      url := Format('http://%s/service/%s', [host, service]);
      if __SessionID <> '' then
        url := url + '?sid=' + __SessionID;
    end
  else
    url := service;
  obj.Url := url;
  Result := obj;
end;

procedure WriteLog(const AText: string);
var
  f: TextFile;
  LogFile, str: string;
begin
  LogFile := ChangeFileExt(Application.ExeName, '.log');
  str := Format('%s,%s', [DateTimeToStr(Now()), AText]);
  AssignFile(f, LogFile);
  try
    if FileExists(LogFile) then
      Append(f)
    else
      Rewrite(f);
    Writeln(f, str);
  finally
    CloseFile(f);
  end;
end;

initialization
  __SessionID := '';
  __ServerIP := 't2.knowall.cn';

finalization

end.
