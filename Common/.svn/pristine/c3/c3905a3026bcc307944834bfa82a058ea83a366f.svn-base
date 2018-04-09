unit AppDB;

interface

uses
  Classes, SysUtils, AppData, Variants, DB, ApConst, uBaseIntf, AppBean;

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
    property ProxyRecord: TObject read FProxyRecord write SetProxy;
    property AutoMode: Boolean read FAutoMode write SetAutoMode;
    property Names: TStrArray read FNames;
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
  public
    constructor Create(ADefine: TAppFieldDefs);
    destructor Destroy; override;
    function ToString: String; override;
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
  end;
  //专用于单据前后台数据传递
  IAppVersion = interface
    ['{CCB5F77A-6F02-4090-9B52-E0A3C00AC301}']
    function GetVersion: string;
    function GetMessages: string;
  end;
  TAppFunc = function: Boolean of object;
  TAppBean2 = class(TAppBean, IOutputMessage2, IAppVersion)
  private
    FMessages: TStringList;
  public
    DataIn, DataOut: TAppDataSet;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    function Exec(const AFirstParam: String): Boolean; virtual;
    //IOutputMessage2
    procedure OutputMessage(Sender: TObject; const Value: String;
      MsgLevel: TMsgLevelOption);
    //IAppVersion
    function GetVersion: string;
    function GetMessages: string;
  end;
  function ExistsFieldDef(AFields: TAppFieldDefs; const AField: String): Boolean;

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
  if (High(FFieldDefs.FNames) = -1)
    and ((not Assigned(FHead)) or (High(FHead.FFieldDefs.FNames) = -1)) then
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
      if not VarIsEmpty(FDatas[i]) then
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

function TAppRecord.ToString: String;
var
  i: Integer;
begin
  CheckInit;
  Result := '';
  for i := 0 to FFieldDefs.Count - 1 do
    Result := Result + Format('%s=%s', [FFieldDefs.FNames[i], VarToStr(FDatas[i])]) + ', ';
  if Result <> '' then
    Result := Copy(Result, 1, Length(Result) - 2);
  if Self.Count = 0 then
    Result := 'record is null';
end;

procedure TAppRecord.SetValue(Index: String; const Value: Variant);
begin
  CheckInit;
  FDatas[FFieldDefs.FindField(Index)] := Value;
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
    if FNames[i] = AField then
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
begin
  Val := TAppRecord(Self.FProxyRecord).Values[FFieldCode];
  if not VarIsNull(Val) then
    Result := Val
  else
    Result := 0;
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

{ TAppBean2 }

constructor TAppBean2.Create(AOwner: TComponent);
begin
  inherited;
  FMessages := TStringList.Create;
  DataIn := TAppDataSet.Create;
  DataIn.Head.FieldDefs.AutoMode := True;
  DataIn.FieldDefs.AutoMode := True;
  DataOut := TAppDataSet.Create;
  DataOut.Head.FieldDefs.AutoMode := True;
  DataOut.FieldDefs.AutoMode := True;
end;

destructor TAppBean2.Destroy;
begin
  FreeAndNil(DataOut);
  FreeAndNil(DataIn);
  FMessages.Free;
  inherited;
end;

function TAppBean2.Exec(const AFirstParam: String): Boolean;
var
  pt: TMethod;
  MyFunc: TAppFunc;
begin
  pt.Data := Pointer(Self);
  pt.Code := Self.MethodAddress(AFirstParam);
  if Assigned(pt.Code) then
    begin
      MyFunc := TAppFunc(pt);
      Result := MyFunc();
    end
  else
    raise Exception.CreateFmt('没有提供服务：%s.%s', [Self.ClassName, AFirstParam]);
end;

function TAppBean2.Execute(const Param: OleVariant; var Data: OleVariant): Boolean;
begin
  try
    AppWriteInfo(Self, 'start');
    DataIn.SetVariant(Param[1]);
    if Exec(Param[0]) then
      begin
        Data := DataOut.GetVariant();
        Result := True;
      end
    else
      begin
        if FMessages.Count = 0 then
        begin
          OutputMessage(Self, Format('%s: 执行失败，且编写这个程式的人员有点懒，竟没有说明原因！',
            [Self.ClassName]), MSG_WARING);
        end;
        Result := False;
      end;
  finally
    AppWriteInfo(Self, 'end');
  end;
end;

procedure TAppBean2.OutputMessage(Sender: TObject; const Value: String;
  MsgLevel: TMsgLevelOption);
begin
  Self.FMessages.Add(Value);
  if Supports(Self.Owner, IOutputMessage2) then
    (Self.Owner as IOutputMessage2).OutputMessage(Sender, VAlue, MsgLevel);
end;

function TAppBean2.GetMessages: string;
begin
  Result := FMessages.Text;
end;

function TAppBean2.GetVersion: string;
begin
  Result := '2014';
end;

end.
