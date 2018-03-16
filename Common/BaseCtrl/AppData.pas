unit AppData;

interface

uses
  Classes, DB, TypInfo, XmlIntf, Variants, SysUtils;

type
  TAppData = class(TPersistent)
  private
    FVersion: Integer;
    procedure SetVersion(const Value: Integer);
  published
  public
    function CheckClass: Boolean; Virtual;
    function CheckVersion: Boolean; Virtual;
    function GetVersion: Integer; Virtual;
    procedure SetVariant(const Value: Variant); Virtual;
    function GetVariant: Variant; Virtual;
  published
    property Version: Integer read FVersion write SetVersion;
  end;

  TZLPropList = class(TObject)
  private
    FPropCount: Integer;
    FPropList: PPropList;
  protected
    Function GetPropName(aIndex: Integer): ShortString;
    function GetProp(aIndex: Integer): PPropInfo;
  public
    constructor Create(aObj: TPersistent);
    destructor Destroy; override;
    property PropCount: Integer read FPropCount;
    property PropNames[aIndex: Integer]: ShortString read GetPropName;
    property Props[aIndex: Integer]: PPropInfo read GetProp;
  end;

  TZLDataSetProxy = class(TPersistent)
  private
    FDataSet: TDataSet;
    FPropList: TZLPropList;
    FLooping: Boolean;
    procedure LoadFromXML(aNode: IXMLNode);
    procedure SaveToXML(aNode: IXMLNode);
  protected
    procedure beginEdit;
    procedure endEdit;
    Function GetInteger(aIndex: Integer): Integer; Virtual;
    function GetFloat(aIndex: Integer): Double; Virtual;
    function GetString(aIndex: Integer): String; Virtual;
    function GetVariant(aIndex: Integer): Variant; Virtual;
    procedure SetInteger(aIndex: Integer; aValue: Integer); Virtual;
    procedure SetFloat(aIndex: Integer; aValue: Double); Virtual;
    procedure SetString(aIndex: Integer; aValue: String); Virtual;
    procedure SetVariant(aIndex: Integer; aValue: Variant); Virtual;
  public
    constructor Create(aDataSet: TDataSet);
    destructor Destroy; override;
    procedure AfterConstruction; Override;
    function ForEach: Boolean;
    property DataSet: TDataSet read FDataSet;
  end;

  TZLXMLPersistent = class(TObject)
  public
    class procedure LoadObjFromXML(aNode: IXMLNode; aObj: TPersistent);
    class procedure SaveObjToXML(aNode: IXMLNode; aObj: TPersistent);
  end;
  TAppSession_DataIn = class(TAppData)
  private
    FClientLangID: Integer;
    FID: String;
    FCostDept: String;
    FClientIP: String;
    FClientVersion: String;
    FClientName: String;
    FCurrCorp: String;
    procedure SetClientIP(const Value: String);
    procedure SetClientLangID(const Value: Integer);
    procedure SetClientName(const Value: String);
    procedure SetClientVersion(const Value: String);
    procedure SetCostDept(const Value: String);
    procedure SetID(const Value: String);
    procedure SetCurrCorp(const Value: String);
  published
    property ID: String read FID write SetID;
    property CurrCorp: String read FCurrCorp write SetCurrCorp;
    property CostDept: String read FCostDept write SetCostDept;
    property ClientIP: String read FClientIP write SetClientIP;
    property ClientName: String read FClientName write SetClientName;
    property ClientLangID: Integer read FClientLangID write SetClientLangID;
    property ClientVersion: String read FClientVersion write SetClientVersion;
  end;
  TAppSession_DataOut = class(TAppData)
  private
    FCurrCorp: String;
    FCostDept: String;
    FCostDeptEnabled: Boolean;
    FUserCorp: String;
    FGroupCorpEnabled: Boolean;
    FUserCode: String;
    FUserID: String;
    procedure SetCostDept(const Value: String);
    procedure SetCostDeptEnabled(const Value: Boolean);
    procedure SetCurrCorp(const Value: String);
    procedure SetGroupCorpEnabled(const Value: Boolean);
    procedure SetUserCorp(const Value: String);
    procedure SetUserCode(const Value: String);
    procedure SetUserID(const Value: String);
  published
  published
    property UserID: String read FUserID write SetUserID;
    property UserCode: String read FUserCode write SetUserCode;
    property UserCorp: String read FUserCorp write SetUserCorp;
    property CurrCorp: String read FCurrCorp write SetCurrCorp;
    property CostDept: String read FCostDept write SetCostDept;
    property GroupCorpEnabled: Boolean read FGroupCorpEnabled write SetGroupCorpEnabled;
    property CostDeptEnabled: Boolean read FCostDeptEnabled write SetCostDeptEnabled;
  end;
  TAppSessionData = class(TAppData)
  private
    FClientLangID: Integer;
    FSessionID: String;
    FCostDept: String;
    FClientVersion: String;
    FCurrCorp: String;
    FUserID: String;
    FLoginTime: TDateTime;
    FUserName: String;
    FUserCode: String;
    FClientName: String;
    FServerIP: String;
    FBufferCount: Integer;
    FDatabase: String;
    FClientIP: String;
    FUserCorp: String;
    FCostDeptEnabled: Boolean;
    FGroupCorpEnabled: Boolean;
    procedure SetCostDept(const Value: String);
    procedure SetClientLangID(const Value: Integer);
    procedure SetSessionID(const Value: String);
    procedure SetClientVersion(const Value: String);
    procedure SetCurrCorp(const Value: String);
    procedure SetUserCode(const Value: String);
    procedure SetClientName(const Value: String);
    procedure SetLoginTime(const Value: TDateTime);
    procedure SetUserID(const Value: String);
    procedure SetUserName(const Value: String);
    procedure SetServerIP(const Value: String);
    procedure SetBufferCount(const Value: Integer);
    procedure SetDatabase(const Value: String);
    procedure SetClientIP(const Value: String);
    procedure SetUserCorp(const Value: String);
    procedure SetCostDeptEnabled(const Value: Boolean);
    procedure SetGroupCorpEnabled(const Value: Boolean);
  public
    constructor Create;
    function CheckClass: Boolean; override;
    function CheckVersion: Boolean; override;
  published
    //由工作站提供，送至服务器
    property ID: String read FSessionID write SetSessionID;
    property ClientIP: String read FClientIP write SetClientIP;
    property ClientName: String read FClientName write SetClientName;
    property ClientLangID: Integer read FClientLangID write SetClientLangID;
    property ClientVersion: String read FClientVersion write SetClientVersion;
    //由服务器提供，返回工作站
    property UserID: String read FUserID write SetUserID;
    property UserCode: String read FUserCode write SetUserCode;
    property UserName: String read FUserName write SetUserName;
    property UserCorp: String read FUserCorp write SetUserCorp;
    property LoginTime: TDateTime read FLoginTime write SetLoginTime;
    property ServerIP: String read FServerIP write SetServerIP;
    property BufferCount: Integer read FBufferCount write SetBufferCount;
    property Database: String read FDatabase write SetDatabase;
    property GroupCorpEnabled: Boolean read FGroupCorpEnabled write SetGroupCorpEnabled;
    property CostDeptEnabled: Boolean read FCostDeptEnabled write SetCostDeptEnabled;
    property CurrCorp: String read FCurrCorp write SetCurrCorp;
    property CostDept: String read FCostDept write SetCostDept;
  end;
  TAppRecordSet_DataIn = class(TAppData)
  private
    FItems: array of String;
  public
    destructor Destroy; override;
    procedure SetVariant(const Value: Variant); override;
    function GetVariant: Variant; override;
    function GetItem(Index: Integer): String;
    function ItemCount: Integer;
    procedure InitItems(const iLength: Integer);
    procedure SetItem(Index: Integer; const Value: String);
  end;
  TAppRecordSet_DataOut = class(TAppData)
  private
    FItems: array of Variant;
  public
    destructor Destroy; override;
    procedure SetVariant(const Value: Variant); override;
    function GetVariant: Variant; override;
    function GetItem(Index: Integer): Variant;
    function ItemCount: Integer;
    procedure InitItems(const iLength: Integer);
    procedure SetItem(Index: Integer; const Value: Variant);
  end;

const
  DefaultFilter: TTypeKinds = [tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkWChar, tkLString, tkWString, tkInt64];

implementation

{ TZLPropList }

constructor TZLPropList.Create(aObj: TPersistent);
begin
  FPropCount := GetTypeData(aObj.ClassInfo)^.PropCount;
  FPropList := Nil;
  if FPropCount > 0 then
  begin
    GetMem(FPropList, FPropCount * SizeOf(Pointer));
    GetPropInfos(aObj.ClassInfo, FPropList);
  end;
end;

destructor TZLPropList.Destroy;
begin
  if Assigned(FPropList) then
    FreeMem(FPropList);
  inherited;
end;

function TZLPropList.GetProp(aIndex: Integer): PPropInfo;
begin
  Result := Nil;
  if (Assigned(FPropList)) then
    Result := FPropList[aIndex];
end;

function TZLPropList.GetPropName(aIndex: Integer): ShortString;
begin
  Result := GetProp(aIndex)^.Name;
end;

{ TAppData }

function TAppData.CheckClass: Boolean;
begin
  Result := True;
end;

function TAppData.CheckVersion: Boolean;
begin
  Result := True;
end;

function TAppData.GetVariant: Variant;
var
  i: Integer;
  pInfo: PPropInfo;
  pList: TZLPropList;
begin
  pList := TZLPropList.Create(Self);
  try
    Result := VarArrayCreate([0, pList.PropCount], VarVariant);
    Result[0] := VarArrayOf([Self.ClassName, Self.GetVersion()]);
    for i := 0 to pList.PropCount - 1 do
    begin
      pInfo := pList.GetProp(i);
      Result[i + 1] := GetPropValue(Self, pInfo^.Name);
    end;
  finally
    pList.Free;
  end;
end;

procedure TAppData.SetVariant(const Value: Variant);
var
  i: Integer;
  pInfo: PPropInfo;
  pList: TZLPropList;
begin
  {$message '注意：此函数未做ChineseAsString处理！Jason 2010/7/21'}
  pList := TZLPropList.Create(Self);
  try
    if (not CheckClass()) or (Value[0][0] = Self.ClassName) then
      begin
        if (not CheckVersion()) or (Value[0][1] = Self.GetVersion()) then
        begin
          for i := 0 to pList.PropCount - 1 do
          begin
            pInfo := pList.GetProp(i);
            SetPropValue(Self, pInfo^.Name, Value[i + 1]);
          end;
        end
        else
          raise Exception.CreateFmt('%s调用错误，其前后台执行档版本号不一致！', [Self.ClassName]);
      end
    else
      raise Exception.CreateFmt('%s调用错误，其前后台调用类型不一致！', [Self.ClassName]);
  finally
    pList.Free;
  end;
end;

procedure TAppData.SetVersion(const Value: Integer);
begin
  FVersion := Value;
end;

function TAppData.GetVersion: Integer;
begin
  Result := FVersion;
end;

{ TZLDataSetProxy }

constructor TZLDataSetProxy.Create(aDataSet: TDataSet);
begin
  Inherited Create;
  FDataSet := aDataSet;
  FDataSet.Open;
  FLooping := False;
end;

destructor TZLDataSetProxy.Destroy;
begin
  FPropList.Free;
  if Assigned(FDataSet) then
    FDataSet.Close;
  inherited;
end;

procedure TZLDataSetProxy.AfterConstruction;
begin
  inherited;
  FPropList := TZLPropList.Create(Self);
end;

procedure TZLDataSetProxy.beginEdit;
begin
  if (FDataSet.State <> dsEdit) and (FDataSet.State <> dsInsert) then
    FDataSet.Edit;
end;

procedure TZLDataSetProxy.endEdit;
begin
  if (FDataSet.State = dsEdit) or (FDataSet.State = dsInsert) then
    FDataSet.Post;
end;

function TZLDataSetProxy.GetInteger(aIndex: Integer): Integer;
begin
  Result := FDataSet.FieldByName(FPropList.PropNames[aIndex]).AsInteger;
end;

function TZLDataSetProxy.GetFloat(aIndex: Integer): Double;
begin
  Result := FDataSet.FieldByName(FPropList.PropNames[aIndex]).AsFloat;
end;

function TZLDataSetProxy.GetString(aIndex: Integer): String;
begin
  Result := FDataSet.FieldByName(FPropList.PropNames[aIndex]).AsString;
end;

function TZLDataSetProxy.GetVariant(aIndex: Integer): Variant;
begin
  Result := FDataSet.FieldByName(FPropList.PropNames[aIndex]).Value;
end;

procedure TZLDataSetProxy.SetInteger(aIndex, aValue: Integer);
begin
  beginEdit;
  FDataSet.FieldByName(FPropList.PropNames[aIndex]).AsInteger := aValue;
end;

procedure TZLDataSetProxy.SetFloat(aIndex: Integer; aValue: Double);
begin
  beginEdit;
  FDataSet.FieldByName(FPropList.PropNames[aIndex]).AsFloat := aValue;
end;

procedure TZLDataSetProxy.SetString(aIndex: Integer; aValue: String);
begin
  beginEdit;
  FDataSet.FieldByName(FPropList.PropNames[aIndex]).AsString := aValue;
end;

procedure TZLDataSetProxy.SetVariant(aIndex: Integer; aValue: Variant);
begin
  beginEdit;
  FDataSet.FieldByName(FPropList.PropNames[aIndex]).Value := aValue;
end;

function TZLDataSetProxy.ForEach: Boolean;
begin
  Result := not FDataSet.Eof;
  if FLooping then
  begin
    endEdit;
    FDataSet.Next;
    Result := not FDataSet.Eof;
    if not Result then
    begin
      FDataSet.First;
      FLooping := False;
    end;
  end
  else if Result then
    FLooping := True;
end;

procedure TZLDataSetProxy.LoadFromXML(aNode: IXMLNode);
Var
  i, j: Integer;
  pInfo: PPropInfo;
  pRow: IXMLNode;
begin
  for j := 0 to aNode.ChildNodes.Count - 1 Do
  begin
    FDataSet.Append;
    pRow := aNode.ChildNodes[j];
    for i := 0 to FPropList.PropCount - 1 Do
    begin
      pInfo := FPropList.Props[i];
      If (pInfo^.PropType^.Kind In DefaultFilter) then
        SetVariant(i, String(pRow.ChildNodes[WideString(pInfo^.Name)].Text));
    end;
    endEdit;
  end;
  FDataSet.First;
end;

procedure TZLDataSetProxy.SaveToXML(aNode: IXMLNode);
Var
  i: Integer;
  pInfo: PPropInfo;
  pRow: IXMLNode;
begin
  while ForEach Do
  begin
    pRow := aNode.AddChild('''Row''');
    for i := 0 to FPropList.PropCount - 1 Do
    begin
      pInfo := FPropList.Props[i];
      If (pInfo^.PropType^.Kind In DefaultFilter) then
        pRow.AddChild(WideString(pInfo^.Name)).Text := GetVariant(i);
    end;
  end;
end;

{ TZLXMLPersistent }

class procedure TZLXMLPersistent.LoadObjFromXML(aNode: IXMLNode;
  aObj: TPersistent);
var
  i: Integer;
  pList: TZLPropList;
  pInfo: PPropInfo;
  tmpObj: TObject;
begin
  if (aObj Is TZLDataSetProxy) then (aObj as TZLDataSetProxy)
    .LoadFromXML(aNode)
  else
  begin
    pList := TZLPropList.Create(aObj);
    try
      for i := 0 to pList.PropCount - 1 Do
      begin
        pInfo := pList.Props[i];
        if (pInfo^.PropType^.Kind = tkClass) then
        begin
          tmpObj := TObject(Integer(GetPropValue(aObj, pInfo^.Name)));
          If (Assigned(tmpObj) and (tmpObj is TPersistent)) then
            LoadObjFromXML(aNode.ChildNodes[WideString(pInfo^.Name)],
              tmpObj as TPersistent);
        end
        else if (pInfo^.PropType^.Kind In DefaultFilter) then
          SetPropValue(aObj, pInfo^.Name,
            String(aNode.ChildNodes[WideString(pInfo^.Name)].Text));
      end;
    finally
      pList.Free;
    end;
  end;
end;

class procedure TZLXMLPersistent.SaveObjToXML(aNode: IXMLNode;
  aObj: TPersistent);
Var
  i: Integer;
  pList: TZLPropList;
  pInfo: PPropInfo;
  tmpObj: TObject;
begin
  If (aObj is TZLDataSetProxy) then (aObj as TZLDataSetProxy)
    .SaveToXML(aNode)
  else
  begin
    pList := TZLPropList.Create(aObj);
    try
      for i := 0 to pList.PropCount - 1 Do
      begin
        pInfo := pList.Props[i];
        If (pInfo^.PropType^.Kind = tkClass) then
        begin
          tmpObj := TObject(Integer(GetPropValue(aObj, pInfo^.Name)));
          if (Assigned(tmpObj) and (tmpObj is TPersistent)) then
            SaveObjToXML(aNode.AddChild(WideString(pInfo^.Name)),
              tmpObj as TPersistent);
        end
        else if (pInfo^.PropType^.Kind In DefaultFilter) then
          aNode.AddChild(WideString(pInfo^.Name)).Text := GetPropValue(aObj,
            pInfo^.Name);
      end;
    finally
      pList.Free;
    end;
  end;
end;

{ TAppSession_DataIn }

procedure TAppSession_DataIn.SetClientIP(const Value: String);
begin
  FClientIP := Value;
end;

procedure TAppSession_DataIn.SetClientLangID(const Value: Integer);
begin
  FClientLangID := Value;
end;

procedure TAppSession_DataIn.SetClientName(const Value: String);
begin
  FClientName := Value;
end;

procedure TAppSession_DataIn.SetClientVersion(const Value: String);
begin
  FClientVersion := Value;
end;

procedure TAppSession_DataIn.SetCostDept(const Value: String);
begin
  FCostDept := Value;
end;

procedure TAppSession_DataIn.SetCurrCorp(const Value: String);
begin
  FCurrCorp := Value;
end;

procedure TAppSession_DataIn.SetID(const Value: String);
begin
  FID := Value;
end;

{ TAppSession_DataOut }

procedure TAppSession_DataOut.SetCostDept(const Value: String);
begin
  FCostDept := Value;
end;

procedure TAppSession_DataOut.SetCostDeptEnabled(const Value: Boolean);
begin
  FCostDeptEnabled := Value;
end;

procedure TAppSession_DataOut.SetCurrCorp(const Value: String);
begin
  FCurrCorp := Value;
end;

procedure TAppSession_DataOut.SetGroupCorpEnabled(const Value: Boolean);
begin
  FGroupCorpEnabled := Value;
end;

procedure TAppSession_DataOut.SetUserCode(const Value: String);
begin
  FUserCode := Value;
end;

procedure TAppSession_DataOut.SetUserCorp(const Value: String);
begin
  FUserCorp := Value;
end;

procedure TAppSession_DataOut.SetUserID(const Value: String);
begin
  FUserID := Value;
end;

{ TAppSessionData }

procedure TAppSessionData.SetUserCode(const Value: String);
begin
  FUserCode := Value;
end;

procedure TAppSessionData.SetBufferCount(const Value: Integer);
begin
  FBufferCount := Value;
end;

procedure TAppSessionData.SetClientIP(const Value: String);
begin
  FClientIP := Value;
end;

procedure TAppSessionData.SetClientName(const Value: String);
begin
  FClientName := Value;
end;

procedure TAppSessionData.SetClientVersion(const Value: String);
begin
  FClientVersion := Value;
end;

procedure TAppSessionData.SetCurrCorp(const Value: String);
begin
  FCurrCorp := Value;
end;

procedure TAppSessionData.SetCostDept(const Value: String);
begin
  FCostDept := Value;
end;

procedure TAppSessionData.SetCostDeptEnabled(const Value: Boolean);
begin
  FCostDeptEnabled := Value;
end;

procedure TAppSessionData.SetDatabase(const Value: String);
begin
  FDatabase := Value;
end;

procedure TAppSessionData.SetGroupCorpEnabled(const Value: Boolean);
begin
  FGroupCorpEnabled := Value;
end;

procedure TAppSessionData.SetClientLangID(const Value: Integer);
begin
  FClientLangID := Value;
end;

procedure TAppSessionData.SetLoginTime(const Value: TDateTime);
begin
  FLoginTime := Value;
end;

procedure TAppSessionData.SetServerIP(const Value: String);
begin
  FServerIP := Value;
end;

procedure TAppSessionData.SetSessionID(const Value: String);
begin
  FSessionID := Value;
end;

procedure TAppSessionData.SetUserCorp(const Value: String);
begin
  FUserCorp := Value;
end;

procedure TAppSessionData.SetUserID(const Value: String);
begin
  FUserID := Value;
end;

procedure TAppSessionData.SetUserName(const Value: String);
begin
  FUserName := Value;
end;

function TAppSessionData.CheckClass: Boolean;
begin
  Result := False;
end;

function TAppSessionData.CheckVersion: Boolean;
begin
  Result := False;
end;

constructor TAppSessionData.Create;
begin
  Version := 2008;
  ClientIP := '0.0.0.0';
end;

{ TAppRecordSet_DataIn }

procedure TAppRecordSet_DataIn.SetItem(Index: Integer; const Value: String);
begin
  FItems[Index] := Value;
end;

destructor TAppRecordSet_DataIn.Destroy;
begin
  FItems := nil;
  inherited;
end;

function TAppRecordSet_DataIn.GetItem(Index: Integer): String;
begin
  Result := FItems[Index];
end;

procedure TAppRecordSet_DataIn.InitItems(const iLength: Integer);
begin
  SetLength(FItems, iLength);
end;

function TAppRecordSet_DataIn.ItemCount: Integer;
begin
  Result := High(FItems) + 1;
end;

function TAppRecordSet_DataIn.GetVariant: Variant;
var
  i: Integer;
begin
  if High(FItems) > 0 then
    begin
      Result := VarArrayCreate([0, High(FItems) + 2], VarVariant);
      Result[0] := GetVersion();
      Result[1] := ItemCount();
      for i := 0 to High(FItems) do
        Result[i + 2] := FItems[i];
    end
  else
    Result := FItems[0];
end;

procedure TAppRecordSet_DataIn.SetVariant(const Value: Variant);
var
  i: Integer;
begin
  if VarIsArray(Value) then
    begin
      i := Value[1];
      SetLength(FItems, i);
      for i := 0 to High(FItems) do
        FItems[i] := Value[i + 2];
    end
  else
    begin
      SetLength(FItems, 1);
      FItems[0] := Value;
    end;
end;

{ TAppRecordSet_DataOut }

destructor TAppRecordSet_DataOut.Destroy;
begin
  FItems := nil;
  inherited;
end;

function TAppRecordSet_DataOut.GetItem(Index: Integer): Variant;
begin
  Result := FItems[Index];
end;

function TAppRecordSet_DataOut.ItemCount: Integer;
begin
  Result := High(FItems) + 1;
end;

procedure TAppRecordSet_DataOut.InitItems(const iLength: Integer);
begin
  SetLength(FItems, iLength);
end;

procedure TAppRecordSet_DataOut.SetItem(Index: Integer; const Value: Variant);
begin
  FItems[Index] := Value;
end;

function TAppRecordSet_DataOut.GetVariant: Variant;
var
  i: Integer;
begin
  if High(FItems) > 0 then
    begin
      Result := VarArrayCreate([0, High(FItems) + 2], VarVariant);
      Result[0] := GetVersion();
      Result[1] := ItemCount();
      for i := 0 to High(FItems) do
        Result[i + 2] := FItems[i];
    end
  else
    Result := FItems[0];
end;

procedure TAppRecordSet_DataOut.SetVariant(const Value: Variant);
var
  i: Integer;
begin
  if ItemCount() > 1 then
    begin
      i := Value[1];
      SetLength(FItems, i);
      for i := 0 to High(FItems) do
        FItems[i] := Value[i + 2];
    end
  else
    begin
      SetLength(FItems, 1);
      FItems[0] := Value;
    end;
end;

end.
