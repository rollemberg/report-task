unit phpService;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Dialogs, XmlIntf, XmlDoc,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdMultipartFormData, IdGlobalProtocols, AppService, xsdRecordSet,
  InfoBox, ApConst, ZjhCtrls, uBaseIntf;

type
  //调用Php服务方式
  TPhpService = class(TAppService)
  public
    function Execute: Boolean; override;
    procedure OutError(AOutObject: TComponent);
  end;
  //取得帮助资料之Web页面
  THelpService = class(TComponent)
  private
    IdHTTP1: TIdHTTP;
    FWebSite: String;
    procedure SetWebSite(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetHelp(const HelpID: String): String;
  published
    property WebSite: String read FWebSite write SetWebSite;
  end;
  //数据集上传下载服务
  TDataService = class(TComponent)
  private
    IdHTTP1: TIdHTTP;
    FUploadPage: String;
    FWebSite: String;
    procedure SetUploadPage(const Value: String);
    procedure SetWebSite(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetRecordSet(const phpPage: String): String;
    function PostRecordSet(const XML: IXMLDocument;
      var xmlResult: String): Boolean;
  published
    property WebSite: String read FWebSite write SetWebSite;
    property UploadPage: String read FUploadPage write SetUploadPage;
  end;
  //数据集对象
  TOnReadTableEvent = procedure(Sender: TObject; table: IXMLTable) of object;
  TOnReadRecordEvent = procedure(Sender: TObject; table: IXMLTable; rec: IXMLRecord_) of object;
  TReadRecordSet = class(TComponent)
  private
    FOnReadTable: TOnReadTableEvent;
    FOnReadRecord: TOnReadRecordEvent;
    procedure SetOnReadTable(const Value: TOnReadTableEvent);
    procedure SetOnReadRecord(const Value: TOnReadRecordEvent);
  published
  public
    procedure LoadXMLData(const XmlData: String);
    property OnReadTable: TOnReadTableEvent read FOnReadTable write SetOnReadTable;
    property OnReadRecord: TOnReadRecordEvent read FOnReadRecord write SetOnReadRecord;
  end;
  //
  procedure SetWebSite(const WebSite: String);
  procedure SetSessionID(const ASessionID: String);
  procedure SetConnection(const WebSite, Account, Password: String);
  function GetLoginSession(const AUserCode: String): String;
  function VarToXml(const Value: OleVariant): IXMLDocument;
  function XmlToVar(root: IXMLNode): OleVariant;

implementation

var
  _WebSite: String;
  _SessionID: String;

procedure SetWebSite(const WebSite: String);
begin
  _WebSite := WebSite;
end;

procedure SetSessionID(const ASessionID: String);
begin
  _SessionID := ASessionID;
end;

procedure SetConnection(const WebSite, Account, Password: String);
var
  Val: String;
begin
  if Copy(WebSite, Length(WebSite), 1) <> '/' then
    _WebSite := WebSite + '/?m=AppService'
  else
    _WebSite := WebSite + '?m=AppService';
  if Pos('@', Account) > 0 then
    Val := Copy(Account, 1, Pos('@', Account) - 1)
  else
    Val := Account;
  _SessionID := Format('%s,%s', [Account, MD5(Val + Password)]);
end;

function GetTempFile(const ExtName: String): String;
var
  i: Integer;
  Guid: TGuid;
  TmpPath,strTmp: String;
begin
  SetLength(TmpPath,MAX_PATH);SetLength(Result,MAX_PATH);
  TmpPath := Copy(TmpPath,1,GetTempPath(MAX_PATH,PChar(TmpPath)));
  if TmpPath = '' then Raise Exception.Create('Not get temp filename!');
  CreateGuid(Guid);
  Result := '';
  strTmp := GuidToString(Guid);
  for i := 2 to Length(strTmp) - 1 do
    if Copy(strTmp,i,1) <> '-' then
      Result := Result + Copy(strTmp,i,1);
  Result := TmpPath + Result + ExtName;
end;

function VarToXml(const Value: OleVariant): IXMLDocument;
var
  xml: IXMLDocument;
  root: IXMLNode;
  function GetVarType(R: OleVariant): String;
  begin
    Result := IntToStr(Integer(FindVarData(R)^.VType));
  end;
  procedure CreateXML(root: IXMLNode; const Value: OleVariant);
  var
    i: integer;
    item: IXMLNode;
  begin
    root.Attributes['type'] := GetVarType(Value);
    if VarIsArray(Value) then
      begin
        for i := VarArrayLowBound(Value, 1) to VarArrayHighBound(Value, 1) do
        begin
          if VarIsArray(Value[i]) then
            CreateXML(root.AddChild('data'), Value[i])
          else
            begin
              item := root.AddChild('data');
              item.Attributes['type'] := GetVarType(Value[i]);
              item.NodeValue := Value[i];
            end;
        end;
      end
    else
      root.NodeValue := Value;
  end;
begin
  xml := NewXMLDocument();
  xml.Encoding := 'UTF-8';
  xml.Active := True;
  root := xml.AddChild('data');
  CreateXML(root, Value);
  Result := xml;
end;

function XmlToVar(root: IXMLNode): OleVariant;
var
  i, rootCount: integer;
  item: IXMLNode;
begin
  if TVarType(root.Attributes['type']) = varArray + varVariant then
    begin
      rootCount := root.ChildNodes.Count;
      Result := VarArrayCreate([0, rootCount - 1], VarVariant);
      for i := 0 to rootCount - 1 do
      begin
        item := root.ChildNodes.Nodes[i];
        if TVarType(item.Attributes['type']) = varArray + varVariant then
          Result[i] := XmlToVar(item)
        else
          Result[i] := item.NodeValue;
      end;
    end
  else
    Result := root.NodeValue;
end;

{ TDataService }

constructor TDataService.Create(AOwner: TComponent);
begin
  inherited;
  IdHTTP1 := TIdHTTP.Create(Self);
  FWebSite := 'http://mimrc.sinaapp.com/';
  FUploadPage := 'SaveRecords.php';
end;

destructor TDataService.Destroy;
begin
  IdHTTP1.Free;
  inherited;
end;

function TDataService.GetRecordSet(const phpPage: String): String;
var
  url: String;
  Stream: TStringStream;
begin
  if Pos(':/', phpPage) = 0 then
    url := Format('%s%s', [WebSite, phpPage])
  else
    url := phpPage;
  Stream := TStringstream.Create('', TEncoding.UTF8);
  try
    IdHTTP1.Get(url, Stream); //这是UTF-8网页
    Result := Stream.DataString;
  finally
    Freeandnil(Stream);
  end;
end;

function TDataService.PostRecordSet(const XML: IXMLDocument;
  var xmlResult: String): Boolean;
var
  tmpFile: String;
  Stream: TIdMultiPartFormDataStream;
begin
  Stream := TIdMultiPartFormDataStream.Create;
  try
    tmpFile := GetTempFile('.xml');
    xml.SaveToFile(tmpFile);
    Stream.AddFile('userfile', tmpFile, GetMIMETypeFromFile(tmpFile));
    xmlResult := IdHTTP1.Post(WebSite + UploadPage, Stream);
    Result := Pos('</RecordSet>', xmlResult) > 0;
  finally
    DeleteFile(tmpFile);
    Freeandnil(Stream);
  end;
end;

procedure TDataService.SetUploadPage(const Value: String);
begin
  FUploadPage := Value;
end;

procedure TDataService.SetWebSite(const Value: String);
begin
  FWebSite := Value;
end;

{ THelpService }

constructor THelpService.Create(AOwner: TComponent);
begin
  inherited;
  IdHTTP1 := TIdHTTP.Create(Self);
  FWebSite := 'http://appdocs.sinaapp.com/';
end;

destructor THelpService.Destroy;
begin
  IdHTTP1.Free;
  inherited;
end;

function THelpService.GetHelp(const HelpID: String): String;
var
  url: String;
  ResponseStream: TStringStream;
begin
  url := Format('%shelpme.php?id=%s', [WebSite, HelpID]);
  ResponseStream := TStringstream.Create('', TEncoding.UTF8);
  try
    IdHTTP1.Get(url, ResponseStream); //这是UTF-8网页
    Result := ResponseStream.DataString;
  finally
    Freeandnil(ResponseStream);
  end;
end;

procedure THelpService.SetWebSite(const Value: String);
begin
  FWebSite := Value;
end;

{ TReadRecordSet }

procedure TReadRecordSet.LoadXMLData(const XmlData: String);
var
  xml: IXMLDocument;
  rs: IXMLRecordSet;
  ks: TDataService;
  table: IXMLTable;
  rec: IXMLRecord_;
  i, j: Integer;
begin
  ks := TDataService.Create(Self);
  try
    xml := xmlDoc.LoadXMLData(XmlData);
    rs := GetRecordSet(xml);
    for i := 0 to rs.Count - 1 do
    begin
      table := rs.Table[0];
      if Assigned(FOnReadTable) then
        FOnReadTable(Self, table);
      for j := 0 to table.Count - 1 do
      begin
        rec := table[j];
        if Assigned(FOnReadRecord) then
          FOnReadRecord(Self, table, rec);
      end;
    end;
  finally
    rs := nil;
    xml := nil;
    ks.Free;
  end;
end;

procedure TReadRecordSet.SetOnReadRecord(const Value: TOnReadRecordEvent);
begin
  FOnReadRecord := Value;
end;

procedure TReadRecordSet.SetOnReadTable(const Value: TOnReadTableEvent);
begin
  FOnReadTable := Value;
end;

{
//下载 RecordSet.xml 文件范例
procedure TForm1.Button1Click(Sender: TObject);
var
  ks: TDataService;
  xml: TReadRecordSet;
begin
  ks := TDataService.Create(Self);
  xml := TReadRecordSet.Create(Self);
  try
    //xml.OnReadTable := MyReadTable;
    xml.OnReadRecord := MyReadRecord;
    xml.LoadXMLData(ks.GetRecordSet('RecordSet.xml'));
  finally
    xml.Free;
    ks.Free;
  end;
end;

procedure TForm1.MyReadRecord(Sender: TObject; table: IXMLTableData;
  rec: IXMLRecord_);
var
  i: Integer;
  fd: IXMLRecordField;
begin
  for i := 0 to rec.Field.Count - 1 do
  begin
    fd := rec.Field[i];
    Memo1.Lines.Add(fd.Code + '.' + fd.NodeValue);
  end;
end;
}

{ TPhpService }

function TPhpService.Execute: Boolean;
var
  tmpFile, tmpData: String;
  xml: IXMLDocument;
  Stream: TIdMultiPartFormDataStream;
  val: OleVariant;
  IdHTTP1: TIdHTTP;
begin
  IdHTTP1 := TIdHTTP.Create(Self);
  Stream := TIdMultiPartFormDataStream.Create;
  try
    ibox.DebugText('APS_EXECUTE: ' + Service);
    tmpFile := GetTempFile('.xml');
    xml := VarToXml(Self.Param);
    try
      xml.SaveToFile(tmpFile);
    finally
      xml := nil;
    end;
    Stream.AddFormField('Session', _SessionID);
    Stream.AddFormField('Service', Self.Service);
    Stream.AddFormField('Database', Self.Database);
    Stream.AddFile('param', tmpFile, GetMIMETypeFromFile(tmpFile));
    if Pos('?m=AppService', _WebSite) > 0 then
      tmpData := IdHTTP1.Post(_WebSite, Stream)
    else
      tmpData := IdHTTP1.Post(_WebSite + 'AppServer.php', Stream);
    try
      if tmpData <> '' then
        begin
          xml := LoadXmlData(tmpData);
          val := XmlToVar(xml.DocumentElement);
          Result := val[0];
          Self.FData := val[1];   //Data in PHP-Appbean
          Self.FError := val[2];  //Lines[] in PHP-Appbean
        end
      else
        begin
          Result := False;
          Self.FError := '后台代码执行错误，返回值为空！';
          Self.FData := null;
        end;
    except
      on E: Exception do
      begin
        Self.FError := tmpData;
        Result := False;
      end;
    end;
  finally
    xml := nil;
    DeleteFile(tmpFile);
    Freeandnil(Stream);
    IdHTTP1.Disconnect;
    IdHTTP1.Free;
  end;
end;

procedure TPhpService.OutError(AOutObject: TComponent);
var
  i: Integer;
  AIntf1: IOutputMessage;
  AIntf2: IOutputMessage2;
begin
  if Supports(AOutObject, IOutputMessage) then
    begin
      AIntf1 := (AOutObject as IOutputMessage);
      if VarIsArray(FError) then
        begin
          for i := 0 to VarArrayHighBound(FError, 1) do
            AIntf1.OutputMessage(VarToStr(FError[i]));
        end
      else
        AIntf1.OutputMessage(VarToStr(FError));
      AIntf1 := nil;
    end
  else if Supports(AOutObject, IOutputMessage2) then
    begin
      AIntf2 := (AOutObject as IOutputMessage2);
      if VarIsArray(FError) then
        begin
          for i := 0 to VarArrayHighBound(FError, 1) do
            AIntf2.OutputMessage(Self, VarToStr(FError[i]), MSG_ERROR);
        end
      else
        AIntf2.OutputMessage(Self, VarToStr(FError), MSG_ERROR);
      AIntf2 := nil;
    end
  else if Self.Messages <> '' then
    MsgBox(Self.Messages);
end;

function GetLoginSession(const AUserCode: String): String;
var
  cc: String;
  uc: string;
  pwd: String;
  cdsTmp: TZjhDataSet;
begin
  cdsTmp := TZjhDataSet.Create(nil);
  try
    cc := '';
    uc := '';
    pwd := '';
    with cdsTmp do
    begin
      Database := 'Common';
      CommandText := Format('select CorpCode_, Code_, Password_ '
        + 'from Account where Code_=''%s''', [AUserCode]);
      Open;
      if not Eof then
      begin
        cc := FieldByName('CorpCode_').AsString;
        uc := FieldByName('Code_').AsString;
        pwd := FieldByName('Password_').AsString;
      end;
    end;
    Result := Format('%s,%s,%s', [cc, uc, pwd]);
  finally
    cdsTmp.Free;
  end;
end;

{
//调用TPhpServer范例
procedure TForm1.Button3Click(Sender: TObject);
var
  ps: TPhpService;
begin
  Memo1.Lines.Clear;
  //
  SetWebSite('http://127.0.0.1/mimrc/1/');
  SetSessionID('0000');
  //
  ps := TPhpService.Create(Self);
  try
    ps.Service := 'TAppHello';
    ps.Param := 'Jason';
    if ps.Execute() then
      Memo1.Lines.Add(VarToStr(ps.Data))
    else
      Memo1.Lines.Add(ps.Messages);
  finally
    ps.Free;
  end;
end;

//通用上传文件方法
procedure TFrmKnowAll.Button2Click(Sender: TObject);
var
  ks: TDataService;
  xml: IXMLRecordSet;
  table: IXMLTable;
  rec: IXMLRecord_;
  fd: IXMLRecordField;
  str: String;
begin
  ks := TDataService.Create(Self);
  xml := NewRecordSet();
  try
    Memo1.Lines.Clear;
    xml.OwnerDocument.Encoding := 'UTF-8';
    xml.Attributes['xmlns:xsi'] := 'http://www.w3.org/2001/XMLSchema-instance';
    xml.Attributes['xsi:noNamespaceSchemaLocation'] := 'RecordSet.xsd';
    //添加数据表
    table := xml.Add;
    table.Code := 'WF_FlowSet';
    //添加记录
    rec := table.Add;
    //添加字段
    fd := rec.Field.Add;
    fd.Code := 'Code_';
    fd.NodeValue := 'OKUMA';
    fd := rec.Field.Add;
    fd.Code := 'Name_';
    fd.NodeValue := '宝熊公司';
    //
    Memo1.Lines.Add('准备上传如下内容：');
    Memo1.Lines.Add('');
    Memo1.Lines.Add(xml.OwnerDocument.XML.Text);
    Memo1.Lines.Add('');
    if ks.PostRecordSet(xml.OwnerDocument, str) then
      Memo1.Lines.Add('上传成功，返回值如下：')
    else
      Memo1.Lines.Add('上传失败，返回值如下：');
    Memo1.Lines.Add(str);
  finally
    xml := nil;
    ks.Free;
  end;
end;

//下载文件范例

procedure TFrmKnowAll.Button1Click(Sender: TObject);
var
  ks: TDataService;
  xml: TReadRecordSet;
begin
  ks := TDataService.Create(Self);
  xml := TReadRecordSet.Create(Self);
  try
    //xml.OnReadTable := MyReadTable;
    xml.OnReadRecord := MyReadRecord;
    xml.LoadXMLData(ks.GetRecordSet(Edit1.Text));
  finally
    xml.Free;
    ks.Free;
  end;
end;

procedure TFrmKnowAll.MyReadRecord(Sender: TObject; table: IXMLTable;
  rec: IXMLRecord_);
var
  i: Integer;
  fd: IXMLRecordField;
begin
  for i := 0 to rec.Field.Count - 1 do
  begin
    fd := rec.Field[i];
    Memo1.Lines.Add(fd.Code + '.' + fd.NodeValue);
  end;
end;
}

initialization
  SetWebSite('http://127.0.0.1/mimrc/1/');
  SetSessionID('6BF22782291B4AE68B9DF14E016463C5');

end.
