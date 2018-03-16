unit FunctionConfig;

interface

uses
  Classes, SysUtils, Forms, XmlIntf, XmlDoc, uBaseIntf, MainData,
  ApConst;

type
  TFunctionConfig = class(TComponent)
  private
    xml: IXmlDocument;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    function LoadFromXml(const xmlFile: String): Boolean;
    function getBodyNode(const NodeName: String): IXmlNode;
    function getHeadNode(const NodeName: String): IXmlNode;
    function getNode(Root: IXmlNode; const NodeName: String): IXmlNode;
    function getValue(const Root: IXmlNode; const AName: String): OleVariant;
  end;

implementation

var
  __SYS08007: String;

{ TFunctionConfig }

constructor TFunctionConfig.Create(AOwner: TComponent);
var
  strFile: String;
begin
  inherited;
  Self.Name := 'SystemConfig';
  if __SYS08007 = '' then
    __SYS08007 := nreg.ReadData('SYS08007');
  strFile := __SYS08007;
  if strFile <> '' then
    LoadFromXml(strFile + '.xml')
  else
    raise Exception.Create(Chinese.AsString('您没有定义好系统参数(Code=SYS08007)，请检查！'));
end;

destructor TFunctionConfig.Destroy;
begin
  xml := nil;
  inherited;
end;

function TFunctionConfig.getNode(Root: IXmlNode;
  const NodeName: String): IXmlNode;
var
  Node: IXmlNode;
begin
  try
    if not Assigned(Root) then
      Node := xml.DocumentElement
    else
      Node := root;
    Result := Node.ChildNodes.FindNode(NodeName);
  finally
    Node := nil;
  end;
end;

function TFunctionConfig.getValue(const Root: IXmlNode;
  const AName: String): OleVariant;
var
  Child: IXmlNode;
begin
  Child := Root.ChildNodes.FindNode(AName);
  try
    if Assigned(Child) then
      Result := Child.NodeValue
    else
      Result := '';
  finally
    Child := nil;
  end;
end;

function TFunctionConfig.getHeadNode(const NodeName: String): IXmlNode;
var
  head: IXmlNode;
begin
  head := getNode(nil, 'head');
  try
    Result := nil;
    if Assigned(head) then
      Result := getNode(head, NodeName);
  finally
    head := nil;
  end;
end;

function TFunctionConfig.getBodyNode(const NodeName: String): IXmlNode;
var
  body: IXmlNode;
begin
  body := getNode(nil, 'body');
  try
    Result := nil;
    if Assigned(body) then
      Result := getNode(body, NodeName);
  finally
    body := nil;
  end;
end;

function TFunctionConfig.LoadFromXml(const xmlFile: String): Boolean;
var
  strFile: String;
begin
  Result := False;
  strFile := ExtractFilePath(Application.ExeName) + '2052\' + xmlFile;
  if FileExists(strFile) then
    begin
      if Assigned(xml) and (UpperCase(xml.FileName) <> UpperCase(strFile)) then
        xml := nil;
      if not Assigned(xml) then
      begin
        xml := LoadXmlDocument(strFile);
        Result := True;
      end;
    end
  else
    raise Exception.CreateFmt(Chinese.AsString('没有找到配置文件：%s'), [strFile]);
end;

end.
