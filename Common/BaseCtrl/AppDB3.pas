unit AppDB3;

interface

uses
  Classes, SysUtils, Variants, DB, ApConst, uBaseIntf, Math,
  SOUtils3, TypInfo, XmlIntf;

type
  TVarArray = array of Variant;
  TStrArray = array of String;
  PStrArray = ^TStrArray;
  //数据字段
  TAppField = class
  private
    FFieldCode: String;
    FProxyRecord: TObject;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsString(const Value: String);
    procedure SetFieldCode(const Value: String);
    function GetAsBoolean: Boolean;
    function GetAsDateTime: TDateTime;
    function GetAsInteger: Integer;
    function GetAsString: String;
    procedure SetProxyRecord(const Value: TObject);
    procedure SetAsFloat(const Value: Double);
    function GetAsFloat: Double;
    function GetValue: Variant;
    procedure SetValue(const Value: Variant);
  public
//    constructor Create;
    function IsNull: Boolean;
    function IsEmpty: Boolean;
    property ProxyRecord: TObject read FProxyRecord write SetProxyRecord;
    property AsString: String read GetAsString write SetAsString;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property Value: Variant read GetValue write SetValue;
    property FieldCode: String read FFieldCode write SetFieldCode;
  end;
  //数据字段集
  TAppFieldDefs = class
  private
    FNames: TStrArray;
    FProxyRecord: TObject;
    FFields: TStringList;
    FAutoMode: Boolean;
    procedure SetProxy(const Value: TObject);
    procedure SetAutoMode(const Value: Boolean);
    function GetJSON: ISuperObject;
    procedure SetJSON(const Value: ISuperObject);
  public
    constructor Create;
    destructor Destroy; override;
    function FindField(const AField: String): Integer;
    //function ExistsField(const AField: String): Boolean;
    function GetValue(AIndex: Integer): Variant;
    procedure SetValue(AIndex: Integer; const Value: Variant);
    function GetVariant: Variant;
    procedure SetVariant(const ANames: Variant);
    function Count: Integer;
    procedure AddField(const AField: String);
    procedure AddFields(DataSet: TDataSet); overload;
    procedure AddFields(AFields: array of String); overload;
    procedure SetFields(AFields: array of String);
    function FieldByName(const AField: String): TAppField;
    function Exists(const AField: string): Boolean;
    property ProxyRecord: TObject read FProxyRecord write SetProxy;
    property AutoMode: Boolean read FAutoMode write SetAutoMode;
    property Names: TStrArray read FNames;
    property JSON: ISuperObject read GetJSON write SetJSON;
  end;
  //数据记录
  TAppRecord = class
  private
    FDatas: array of Variant;
    FFieldDefs: TAppFieldDefs;
    FOwnerDefine: Boolean;
    procedure CheckInit;
    function GetValue(Index: String): Variant;
    procedure SetValue(Index: String; const Value: Variant);
    procedure SetJSON(const Value: ISuperObject);
    function GetJSON: ISuperObject;
  public
    constructor Create(ADefine: TAppFieldDefs);
    destructor Destroy; override;
    function GetVariant: Variant;
    procedure SetVariant(const ADatas: Variant);
    procedure CopyFrom(DataSet: TDataSet); overload;
    procedure CopyFrom(DataSet: TDataSet; AFields: array of String); overload;
    procedure CopyTo(DataSet: TDataSet); overload;
    procedure CopyTo(DataSet: TDataSet; AFields: array of String); overload;
    function Count: Integer;
    function FieldByName(const AField: String): TAppField;
    property Values[Index: String]: Variant read GetValue write SetValue; default;
    property FieldDefs: TAppFieldDefs read FFieldDefs;
    property JSON: ISuperObject read GetJSON write SetJSON;
  end;
  TVirtualProduct = record
    Caption: string;
    UPControl: Integer;
    UnitPrice: Double;
    function IsVirtual(const ACode: string): Boolean;
  end;
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
  public
    function CorpNo: string;
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
    FRoleCode: String;
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
    procedure SetRoleCode(const Value: String);
  public
    constructor Create;
    function CheckClass: Boolean; override;
    function CheckVersion: Boolean; override;
    function CorpNo: string;
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
    property RoleCode: String read FRoleCode write SetRoleCode;
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
  //数据集
  TAppDataSet = class(TAppData)
  private
    FItems: TList;
    FFieldDefs: TAppFieldDefs;
    FRecNo: Integer;
    FHead: TAppRecord;
    function GetRecords(Index: Integer): TAppRecord;
    procedure CheckNames;
    procedure SetFieldDefs(const Value: TAppFieldDefs);
    procedure SetRecNo(const Value: Integer);
    function GetHeadData: Variant;
    procedure SetHeadData(const AValues: Variant);
    function GetJSON: ISuperObject;
    procedure SetJSON(const Value: ISuperObject);
  public
    procedure First;
    procedure Next;
    function Eof: Boolean;
    function RecordCount: Integer;
    function Current: TAppRecord;
    function FieldByName(const AField: String): TAppField;
    procedure Post;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetVariant(const Value: Variant); override;
    function GetVariant: Variant; override;
    function Append(Values: array of Variant): TAppRecord; overload;
    function Append: TAppRecord; overload;
    function Head: TAppRecord;
    procedure LoadFrom(DataSet: TDataSet); overload;
    procedure LoadFrom(DataSet: TDataSet; AFields: array of String); overload;
    procedure SaveTo(DataSet: TDataSet); overload;
    procedure SaveTo(DataSet: TDataSet; AFields: array of String); overload;
    function Locate(const AField: String; const AValue: Variant): Boolean;
    procedure OutputDebugInfo(AOwner: IOutputMessage2);
    property Records[Index: Integer]: TAppRecord read GetRecords;
    property FieldDefs: TAppFieldDefs read FFieldDefs write SetFieldDefs;
    property RecNo: Integer read FRecNo write SetRecNo;
    property JSON: ISuperObject read GetJSON write SetJSON;
  end;
  function ExistsFieldDef(AFields: TAppFieldDefs; const AField: String): Boolean;
  function SOToVar(Item: ISuperObject): OleVariant;
  function VarToSO(const Value: OleVariant): ISuperObject;
  function JSONToVar(AText: string): OleVariant;
  function VarToJSON(const Value: OleVariant): string;

const
  DefaultFilter: TTypeKinds = [tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkWChar, tkLString, tkWString, tkInt64];

implementation

function ExistsFieldDef(AFields: TAppFieldDefs; const AField: String): Boolean;
var
  i: Integer;
begin
  {$message '此处为不影响所有bpl而预以外置此函数，下次框架大修时须融入。Jason by 2013/11/04'}
  Result := False;
  for i := 0 to High(AFields.FNames) do
  begin
    if AFields.Names[i] = AField then
    begin
      Result := True;
      Break;
    end;
  end;
end;

{ TAppDataSet }

procedure TAppDataSet.CheckNames;
begin
  if High(FFieldDefs.FNames) = -1 then
    raise Exception.Create('您必须先定义 Fields ！');
end;

function TAppDataSet.Append(Values: array of Variant): TAppRecord;
var
  i: Integer;
begin
  CheckNames;
  Result := TAppRecord.Create(Self.FFieldDefs);
  FItems.Add(Result);
  for i := Low(Values) to High(Values) do
    Result.FDatas[i] := Values[i];
  FRecNo := Self.RecordCount;
end;
//
function TAppDataSet.Append: TAppRecord;
begin
  if not FFieldDefs.AutoMode then
    CheckNames;
  Result := TAppRecord.Create(Self.FFieldDefs);
  FItems.Add(Result);
  FRecNo := Self.RecordCount;
//  Result.SetVariant(Value);
end;

constructor TAppDataSet.Create;
begin
  inherited;
  FItems := TList.Create;
  FFieldDefs := TAppFieldDefs.Create;
  FHead := TAppRecord.Create(nil);
  Self.Version := 1;
end;

function TAppDataSet.Current: TAppRecord;
begin
  if (FRecNo >= 1) and (FRecNo <= Self.RecordCount) then
    Result := Self.GetRecords(FRecNo - 1)
  else
    Result := nil;
end;

destructor TAppDataSet.Destroy;
var
  i: Integer;
  Item: TObject;
begin
  if Assigned(FHead) then
    FHead.Free;
  FFieldDefs.Free;
  for i := 0 to FItems.Count - 1 do
  begin
    Item := FItems.Items[i];
    Item.Free;
  end;
  FItems.Free;
  inherited;
end;

function TAppDataSet.Eof: Boolean;
begin
  Result := (FRecNo < 1) or (FRecNo > Self.RecordCount);
end;

function TAppDataSet.FieldByName(const AField: String): TAppField;
begin
  Self.FFieldDefs.FProxyRecord := Current;
  if Assigned(Self.FFieldDefs.FProxyRecord) then
    Result := Self.FieldDefs.FieldByName(AField)
  else
    raise Exception.CreateFmt('Current is nil, FieldByName(%s) 不能使用！.', [AField]);
end;

procedure TAppDataSet.First;
begin
  if Self.RecordCount > 0 then
    FRecNo := 1
  else
    FRecNo := 0;
end;

function TAppDataSet.GetRecords(Index: Integer): TAppRecord;
begin
  if not Self.FFieldDefs.FAutoMode then
    CheckNames;
  Result := FItems[Index];
end;

function TAppDataSet.RecordCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TAppDataSet.LoadFrom(DataSet: TDataSet);
var
  Flag: Boolean;
begin
  Flag := DataSet.ControlsDisabled;
  with DataSet do
  try
    if not Flag then
      DisableControls;
    First;
    while not Eof do
    begin
      Self.Append.CopyFrom(DataSet);
      Next;
    end;
    First;
  finally
    if not Flag then
      EnableControls;
  end;
end;

procedure TAppDataSet.LoadFrom(DataSet: TDataSet; AFields: array of String);
var
  Flag: Boolean;
begin
  Flag := DataSet.ControlsDisabled;
  with DataSet do
  try
    if not Flag then
      DisableControls;
    First;
    while not Eof do
    begin
      Self.Append.CopyFrom(DataSet, AFields);
      Next;
    end;
    First;
  finally
    if not Flag then
      EnableControls;
  end;
end;

function TAppDataSet.Locate(const AField: String;
  const AValue: Variant): Boolean;
begin
  Result := False;
  First;
  while not Eof do
  begin
    if Current.GetValue(AField) = AValue then
    begin
      Result := True;
      Break;
    end;
    Next;
  end;
end;

procedure TAppDataSet.SaveTo(DataSet: TDataSet);
var
  Flag: Boolean;
begin
  Flag := DataSet.ControlsDisabled;
  try
    if not Flag then
      DataSet.DisableControls;
    First;
    while not Eof do
    begin
      DataSet.Append;
      Current.CopyTo(DataSet);
      DataSet.Post;
      Next;
    end;
    DataSet.First;
  finally
    if not Flag then
      DataSet.EnableControls;
  end;
end;

procedure TAppDataSet.SaveTo(DataSet: TDataSet; AFields: array of String);
var
  Flag: Boolean;
begin
  Flag := DataSet.ControlsDisabled;
  try
    if not Flag then
      DataSet.DisableControls;
    First;
    while not Eof do
    begin
      DataSet.Append;
      Current.CopyTo(DataSet, AFields);
      DataSet.Post;
      Next;
    end;
    DataSet.First;
  finally
    if not Flag then
      DataSet.EnableControls;
  end;
end;

procedure TAppDataSet.Next;
begin
  if not Eof then
    Inc(FRecNo);
end;

procedure TAppDataSet.OutputDebugInfo(AOwner: IOutputMessage2);
begin
  AOwner.OutputMessage(Self, Head.ToString(), MSG_HINT);
  First;
  while not Eof do
  begin
    AOwner.OutputMessage(Self, Current.ToString(), MSG_HINT);
    Next;
  end;
end;

procedure TAppDataSet.Post;
begin
  //此字段不需要此函数！
end;

procedure TAppDataSet.SetFieldDefs(const Value: TAppFieldDefs);
begin
  if FItems.Count <> 0 then
    raise Exception.Create('在已存在数据的情况不允许修改数据定义！');
  if Assigned(FFieldDefs) then
    FFieldDefs.Free;
  FFieldDefs := Value;
end;

procedure TAppDataSet.SetRecNo(const Value: Integer);
begin
  FRecNo := Value;
end;

function TAppDataSet.Head: TAppRecord;
begin
  if not Assigned(FHead) then
    FHead := TAppRecord.Create(nil);
  Result := FHead;
end;

function TAppDataSet.GetHeadData: Variant;
begin
  Result := NULL;
  if Assigned(FHead) and (FHead.Count > 0) then
    Result := VarArrayOf([FHead.FFieldDefs.GetVariant(), FHead.GetVariant()]);
end;

function TAppDataSet.GetJSON: ISuperObject;
var
  i: Integer;
  Item: TAppRecord;
  List: TSuperArray;
  Body, Child: ISuperObject;
begin
  Result := SA([]);
  //
  if FFieldDefs.Count > 0 then
  begin
    Body := SA([FFieldDefs.JSON]);
    for i := 0 to RecordCount - 1 do
    begin
      Item := FItems.Items[i];
      Body.AsArray.Add(Item.JSON);
    end;
  end;
  if FHead.FieldDefs.Count > 0 then
  begin
    Child := SO();
    for i := 0 to FHead.FieldDefs.Count - 1 do
      Child.O[FHead.FieldDefs.FNames[i]] := VarToSO(FHead.FDatas[i]);
  end;
  //
  List := Result.AsArray;
  if (FHead.FieldDefs.Count > 0) and (FFieldDefs.Count > 0) then
    begin
      List.Add(SO(['head', Child, 'dataset', Body]))
      //List.Add(SO(['head', Child]));
      //List.Add(SO(['dataset', Body]));
    end
  else if FFieldDefs.Count > 0 then
    List.Add(SO(['dataset', Body]))
  else if FHead.Count > 0 then
    List.Add(SO(['head', Child]))
  else
    begin
    end;
end;

procedure TAppDataSet.SetJSON(const Value: ISuperObject);
var
  i, j: Integer;
  Item, Body: ISuperObject;
  List, Key, Val: TSuperArray;
  ite: TSuperAvlIterator;
begin
  SetLength(FHead.FDatas, 0);
  SetLength(FHead.FieldDefs.FNames, 0);
  if not Assigned(Value) then
    Exit;
  if Value.IsType(stArray) then
    begin
      List := Value.AsArray;
      for i := 0 to List.Length - 1 do
      begin
         ite := List.O[i].AsObject.GetEnumerator;
         try
           while ite.MoveNext do
           begin
              //MsgBox('%s : %s', [ite.Current.Name, ite.Current.Value.AsString]);
              if ite.Current.Name = 'head' then
              begin
                Item := ite.Current.Value;
                Key := Item.AsObject.GetNames.AsArray;
                Val := Item.AsObject.GetValues.AsArray;
                for j := 0 to Key.Length - 1 do
                  FHead.FieldByName(Key.O[j].AsString).Value := SOToVar(Val.O[j]);
              end;
              if ite.Current.Name = 'dataset' then
              begin
                Body := ite.Current.Value;
                FieldDefs.JSON := Body.AsArray.O[0];
                if Body.AsArray.Length > 1 then
                begin
                  for j := 1 to Body.AsArray.Length - 1 do
                    Append.JSON := Body.AsArray.O[j];
                end;
                Self.First;
              end;
           end;
         finally
           ite.Free;
         end;
      end;
    end
  else if not Value.IsType(stNull) then
    raise Exception.Create('TAppDatSet.JSON 赋值错误！');
end;

procedure TAppDataSet.SetHeadData(const AValues: Variant);
begin
  if (not VarIsNull(AValues)) and VarIsArray(AValues) then
  begin
    Head.FieldDefs.SetVariant(AValues[0]);
    Head.SetVariant(AValues[1]);
  end;
end;

function TAppDataSet.GetVariant: Variant;
var
  i: Integer;
  Keys: Variant;
  Item: TAppRecord;
begin
  if (FFieldDefs.Count = 0) and (FHead.FieldDefs.Count = 0) then
  begin
    Result := NULL;
    Exit;
  end;
  if High(FFieldDefs.FNames) > -1 then
    DynArrayToVariant(Keys, FFieldDefs.FNames, TypeInfo(TStrArray))
  else
    Keys := NULL;
  Result := VarArrayCreate([0, FItems.Count + 3], VarVariant);
  Result[0] := VarArrayOf([Self.ClassName, Self.GetVersion()]);
  Result[1] := Self.GetHeadData();
  Result[2] := Keys;
  Result[3] := FItems.Count; //第一个1代表第一版
  for i := 0 to RecordCount - 1 do
  begin
    Item := FItems.Items[i];
    Result[i + 4] := Item.GetVariant();
  end;
end;

procedure TAppDataSet.SetVariant(const Value: Variant);
var
  i: Integer;
begin
  if not VarIsArray(Value) then
    Exit
  else if (Value[0][0] = Self.ClassName) then
    begin
      if Value[0][1] = Self.GetVersion() then
        begin
          SetHeadData(Value[1]);
          if not VarIsNull(Value[2]) then
            DynArrayFromVariant(Pointer(FFieldDefs.FNames), Value[2] ,TypeInfo(TStrArray));
          for i := 0 to Value[3] - 1 do
            Append.SetVariant(Value[i + 4]);
        end
      else
        raise Exception.CreateFmt('%s调用错误，其前后台执行档版本号不一致[%s<>%d]！',
          [Self.ClassName, VarToStr(Value[0][1]), Self.GetVersion()]);
    end
  else
    raise Exception.CreateFmt('%s调用错误，其前后台调用类型不一致！', [Self.ClassName]);
end;

{ TAppRecord }

constructor TAppRecord.Create(ADefine: TAppFieldDefs);
begin
  if Assigned(ADefine) then
    begin
      FOwnerDefine := True;
      FFieldDefs := ADefine;
      if FFieldDefs.Count > 0 then
        SetLength(FDatas, FFieldDefs.Count);
    end
  else
    begin
      FOwnerDefine := False;
      FFieldDefs := TAppFieldDefs.Create;
    end;
end;

destructor TAppRecord.Destroy;
begin
  SetLength(FDatas, 0);
  if not FOwnerDefine then
    FFieldDefs.Free;
  inherited;
end;

function TAppRecord.FieldByName(const AField: String): TAppField;
begin
  Self.FFieldDefs.FProxyRecord := Self;
  Result := Self.FFieldDefs.FieldByName(AField);
end;

procedure TAppRecord.CheckInit;
begin
  if Self.Count <> FFieldDefs.Count then
  begin
    if not FFieldDefs.FAutoMode then
    begin
      if Self.Count <> 0 then
        raise Exception.Create('不能在初始化后，再改变字段定义数目！');
    end;
    SetLength(FDatas, FFieldDefs.Count);
  end;
end;

function TAppRecord.GetVariant: Variant;
begin
  CheckInit;
  DynArrayToVariant(Result, FDatas, TypeInfo(TVarArray));
end;

procedure TAppRecord.CopyFrom(DataSet: TDataSet);
var
  i: Integer;
  fd: TField;
begin
  if Self.FFieldDefs.AutoMode then
    begin
      for i := 0 to DataSet.Fields.Count - 1 do
      begin
        fd := DataSet.Fields[i];
        FFieldDefs.FindField(fd.FullName);
        Self.SetValue(fd.FullName, fd.Value);
      end;
    end
  else
    begin
      CheckInit;
      for i := 0 to FFieldDefs.Count - 1 do
      begin
        fd := DataSet.FindField(FFieldDefs.FNames[i]);
        if Assigned(fd) then
          FDatas[i] := fd.Value;
      end;
    end;
end;

procedure TAppRecord.CopyFrom(DataSet: TDataSet; AFields: array of String);
var
  AField: String;
begin
  if Self.FFieldDefs.AutoMode then
    begin
      for AField in AFields do
      begin
        FFieldDefs.FindField(AField);
        SetValue(AField, DataSet.FieldByName(AField).Value);
      end;
    end
  else
    begin
      for AField in AFields do
        SetValue(AField, DataSet.FieldByName(AField).Value);
    end;
end;

procedure TAppRecord.CopyTo(DataSet: TDataSet);
var
  i: Integer;
  fd: TField;
begin
  CheckInit;
  for i := 0 to FFieldDefs.Count - 1 do
  begin
    fd := DataSet.FindField(FFieldDefs.FNames[i]);
    if Assigned(fd) then
    begin
      if VarIsEmpty(FDatas[i]) then
        fd.Value := null
      else if VarIsNull(FDatas[i]) then
        fd.Value := null
      else if VarToStr(FDatas[i]) = '{}' then
        fd.Value := null
      else if (not fd.IsNull) and (fd.DataType = ftFloat) then
        fd.Value := RoundTo(FDatas[i],-6)
      else
        fd.Value := FDatas[i];
    end;
  end;
end;

procedure TAppRecord.CopyTo(DataSet: TDataSet; AFields: array of String);
var
  AField: String;
begin
  for AField in AFields do
    DataSet.FieldByName(AField).Value := Self.GetValue(AField);
end;

procedure TAppRecord.SetVariant(const ADatas: Variant);
var
  i: Integer;
begin
  CheckInit;
  for i := 0 to FFieldDefs.Count - 1 do
    FDatas[i] := ADatas[i];
end;

procedure TAppRecord.SetValue(Index: String; const Value: Variant);
begin
  CheckInit;
  FDatas[FFieldDefs.FindField(Index)] := Value;
end;

function TAppRecord.GetJSON: ISuperObject;
begin
  Result := VarToSO(FDatas);
end;

procedure TAppRecord.SetJSON(const Value: ISuperObject);
begin
  if Value.AsJSon <> 'null' then
    FDatas := SOToVar(Value)
  else
    SetLength(FDatas, 0);
end;

function TAppRecord.GetValue(Index: String): Variant;
begin
  CheckInit;
  Result := FDatas[FFieldDefs.FindField(Index)]
end;

function TAppRecord.Count: Integer;
begin
  Result := High(Self.FDatas) + 1;
end;

{ TAppFieldDefs }

procedure TAppFieldDefs.AddFields(DataSet: TDataSet);
var
  i: Integer;
begin
  for i := 0 to DataSet.FieldCount - 1 do
    Self.AddField(DataSet.Fields[i].FullName);
end;

procedure TAppFieldDefs.AddFields(AFields: array of String);
var
  i: Integer;
begin
  for i := Low(AFields) to High(AFields) do
    AddField(AFields[i]);
end;

function TAppFieldDefs.Count: Integer;
begin
  Result := High(Self.FNames) + 1;
end;

constructor TAppFieldDefs.Create;
begin
  FFields := TStringList.Create;
  FAutoMode := True;
end;

destructor TAppFieldDefs.Destroy;
var
  i: Integer;
begin
  for i := 0 to FFields.Count - 1 do
    FFields.Objects[i].Free;
  FFields.Free;
  SetLength(FNames, 0);
  inherited;
end;

function TAppFieldDefs.Exists(const AField: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(FNames) to High(FNames) do
  begin
    if FNames[i] = AField then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TAppFieldDefs.SetProxy(const Value: TObject);
begin
  FProxyRecord := Value;
end;

procedure TAppFieldDefs.SetAutoMode(const Value: Boolean);
begin
  FAutoMode := Value;
end;

procedure TAppFieldDefs.SetFields(AFields: array of String);
var
  i: Integer;
begin
  SetLength(FNames, High(AFields) + 1);
  for i := 0 to High(AFields) do
    FNames[i] := AFields[i];
end;

procedure TAppFieldDefs.AddField(const AField: String);
begin
  SetLength(FNames, High(FNames) + 2);
  FNames[High(FNames)] := AField;
end;

function TAppFieldDefs.FieldByName(const AField: String): TAppField;
var
  i: Integer;
begin
  if Self.FindField(AField) > -1 then
    begin
      i := Self.FFields.IndexOf(AField);
      if i = -1 then
        begin
          i := FFields.AddObject(AField, TAppField.Create);
          Result := FFields.Objects[i] as TAppField;
          Result.FFieldCode := AField;
        end
      else
        Result := FFields.Objects[i] as TAppField;
      Result.FProxyRecord := Self.FProxyRecord;
    end
  else
    Result := nil;
end;

function TAppFieldDefs.FindField(const AField: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to High(FNames) do
  begin
    if UpperCase(FNames[i]) = UpperCase(AField) then
    begin
      Result := i;
      Break;
    end;
  end;
  if Result = -1 then
  begin
    if Self.FAutoMode then
      begin
       Self.AddField(AField);
       Result := High(Self.FNames);
      end
    else
      raise Exception.CreateFmt('not find field: %s', [AField]);
  end;
end;

function TAppFieldDefs.GetJSON: ISuperObject;
begin
  Result := VarToSO(FNames);
end;

procedure TAppFieldDefs.SetJSON(const Value: ISuperObject);
var
  i: Integer;
begin
  if Value.AsString <> 'null' then
    begin
      SetLength(FNames, Value.AsArray.Length);
      for i := 0 to Value.AsArray.Length - 1 do
        FNames[i] := Value.AsArray.S[i];
    end
  else
    SetLength(FNames, 0);
end;

function TAppFieldDefs.GetValue(AIndex: Integer): Variant;
begin
  if Assigned(FProxyRecord) and (FProxyRecord is TAppRecord) then
    Result := TAppRecord(FProxyRecord).FDatas[AIndex]
  else
    raise Exception.Create('Proxy 属性未赋值！');
end;

procedure TAppFieldDefs.SetVariant(const ANames: Variant);
begin
  if VarIsArray(ANames) then
    DynArrayFromVariant(Pointer(Self.FNames), ANames, TypeInfo(TStrArray))
  else
    raise Exception.Create('TAppFieldDefs.SetVariant 的参数必须为数组！');
end;

function TAppFieldDefs.GetVariant: Variant;
begin
  DynArrayToVariant(Result, Self.FNames, TypeInfo(TStrArray));
end;

procedure TAppFieldDefs.SetValue(AIndex: Integer; const Value: Variant);
begin
  if Assigned(FProxyRecord) and (FProxyRecord is TAppRecord) then
    TAppRecord(FProxyRecord).FDatas[AIndex] := Value
  else
    raise Exception.Create('Proxy 属性未赋值！');
end;

{ TAppField }

function TAppField.GetAsBoolean: Boolean;
var
  Val: Variant;
begin
  Val := TAppRecord(Self.FProxyRecord).Values[FFieldCode];
  if not VarIsNull(Val) then
    Result := Val
  else
    Result := False;
end;

function TAppField.GetAsDateTime: TDateTime;
var
  Val: Variant;
  tmp: Word;
begin
  Result := 0;
  Val := TAppRecord(Self.FProxyRecord).Values[FFieldCode];
  if not VarIsNull(Val) then
  begin
    tmp := VarType(Val);
    if tmp = 8 then
      begin
        VineToDelphiDateTime(val, Result);
      end
    else
      Result := Val;
  end;
end;

function TAppField.GetAsFloat: Double;
var
  Val: Variant;
begin
  Val := TAppRecord(Self.FProxyRecord).Values[FFieldCode];
  if not VarIsNull(Val) then
    Result := Val
  else
    Result := 0;
end;

function TAppField.GetAsInteger: Integer;
var
  Val: Variant;
begin
  Val := TAppRecord(Self.FProxyRecord).Values[FFieldCode];
  if not VarIsNull(Val) then
    Result := Val
  else
    Result := 0;
end;

function TAppField.GetAsString: String;
var
  Val: Variant;
begin
  Val := TAppRecord(Self.FProxyRecord).Values[FFieldCode];
  if not VarIsNull(Val) then
    Result := Val
  else
    Result := '';
end;

function TAppField.GetValue: Variant;
begin
  Result := TAppRecord(Self.FProxyRecord).Values[FFieldCode];
end;

function TAppField.IsEmpty: Boolean;
begin
  Result := VarIsEmpty(TAppRecord(Self.FProxyRecord).Values[FFieldCode]);
end;

function TAppField.IsNull: Boolean;
begin
  Result := VarIsNull(TAppRecord(Self.FProxyRecord).Values[FFieldCode]);
end;

procedure TAppField.SetAsBoolean(const Value: Boolean);
begin
  TAppRecord(Self.FProxyRecord).Values[FFieldCode] := Value;
end;

procedure TAppField.SetAsDateTime(const Value: TDateTime);
begin
  TAppRecord(Self.FProxyRecord).Values[FFieldCode] := Value;
end;

procedure TAppField.SetAsFloat(const Value: Double);
begin
  TAppRecord(Self.FProxyRecord).Values[FFieldCode] := Value;
end;

procedure TAppField.SetAsInteger(const Value: Integer);
begin
  TAppRecord(Self.FProxyRecord).Values[FFieldCode] := Value;
end;

procedure TAppField.SetAsString(const Value: String);
begin
  TAppRecord(Self.FProxyRecord).Values[FFieldCode] := Value;
end;

procedure TAppField.SetFieldCode(const Value: String);
begin
  FFieldCode := Value;
end;

procedure TAppField.SetProxyRecord(const Value: TObject);
begin
  FProxyRecord := Value;
end;

procedure TAppField.SetValue(const Value: Variant);
begin
  TAppRecord(Self.FProxyRecord).Values[FFieldCode] := Value;
end;

{ TVirtualProduct }

function TVirtualProduct.IsVirtual(const ACode: string): Boolean;
begin
  if ACode = '{01}' then
    begin
      Self.Caption := '代币';
      Self.UPControl := -1;
      Self.UnitPrice := 1;
    end
  else if ACode = '{02}' then
    begin
      Self.Caption := '消费积分';
      Self.UPControl := -2;
      Self.UnitPrice := 0.01;
    end
  else if ACode = '{03}' then
    begin
      Self.Caption := '优惠金额';
      Self.UPControl := -2;
      Self.UnitPrice := 0.01;
    end
  else if ACode = '{04}' then
    begin
      Self.Caption := '优惠折扣';
      Self.UPControl := -4;
      Self.UnitPrice := -1;
    end
  else if ACode = '{05}' then
    begin
      Self.Caption := '优惠券';
      Self.UPControl := -5;
      Self.UnitPrice := -1;
    end
  else
    begin
      Self.Caption := '普通商品';
      Self.UPControl := 0;
      Self.UnitPrice := 0;
    end;
  Result := Self.UPControl < 0;
end;

function VarToSO(const Value: OleVariant): ISuperObject;
var
  i: Integer;
  function GetVarType(R: OleVariant): Integer;
  begin
    Result := Integer(FindVarData(R)^.VType);
  end;
begin
  if VarIsArray(Value) then
    begin
      Result := SA([]);
      for i := VarArrayLowBound(Value, 1) to VarArrayHighBound(Value, 1) do
      begin
        if VarIsArray(Value[i]) then
          Result.AsArray.Add(VarToSO(Value[i]))
        else
          Result.AsArray.Add(SO(Value[i]));
      end;
    end
  else if VarIsNull(Value) then
    Result := SO()
  else
    Result := SO(Value);
end;

function SOToVar(Item: ISuperObject): OleVariant;
var
  i: Integer;
  dt: TDateTime;
begin
  case Item.DataType of
  stNull: Result := NULL;
  stBoolean: Result := Item.AsBoolean;
  stDouble: Result := Item.AsDouble;
  stCurrency: Result := Item.AsCurrency;
  stInt: Result := Item.AsInteger;
  stArray:
    begin
      if Item.AsArray.Length > 0 then
        begin
          Result := VarArrayCreate([0, Item.AsArray.Length - 1], VarVariant);
          for i := 0 to Item.AsArray.Length - 1 do
            Result[i] := SOToVar(Item.AsArray.O[i]);
        end
      else
        Result := null;
    end;
  else
    begin
      if VineToDelphiDateTime(Item.AsString, dt) then
        Result := dt
      else if Item.AsString = '{}' then
        Result := null
      else
        Result := Item.AsString;
    end;
  end;
end;

function JSONToVar(AText: string): OleVariant;
var
  obj: ISuperObject;
begin
  obj := SO(AText);
  if Assigned(obj) then
    Result := SOToVar(obj)
  else
    Result := null;
end;

function VarToJSON(const Value: OleVariant): string;
begin
  Result := VarToSO(Value).AsJSon();
end;

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

function TAppSession_DataIn.CorpNo: string;
begin
  Result := FCostDept;
end;

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

procedure TAppSessionData.SetRoleCode(const Value: String);
begin
  FRoleCode := Value;
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

function TAppSessionData.CorpNo: string;
begin
  Result := Self.FCostDept;
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
