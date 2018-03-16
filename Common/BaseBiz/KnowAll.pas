unit KnowAll;

interface

uses
  Classes, Variants, DB, ApConst, ADODB, SysUtils, uBaseIntf,
  Windows;

type
  TKeyValue = record
    ID: Variant;
    Data: Variant;
  end;
  TArrayKeyValue = array of TKeyValue;
  TArrayRecord = class
  private
    FFields: array of TKeyValue;
  public
    procedure AddField(const AID: String; AData: OleVariant);
    function getValue: Variant;
  end;
  TArrayTable = class
  private
    FItems: TList;
    FTableCode: String;
    procedure SetTableCode(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    function AddRecord: TArrayRecord;
    function getValue: Variant;
    property TableCode: String read FTableCode write SetTableCode;
  end;
  TArrayDatabase = class
  private
    FItems: TList;
  public
    constructor Create;
    destructor Destroy; override;
    function AddTable(const ATableCode: String): TArrayTable;
    function getValue: Variant;
  end;
  TKnowAll = class(TComponent, IOutputMessage2)
  private
    FConnection: TADOConnection;
    procedure SetConnection(const Value: TADOConnection);
  public
    //检查任务进度
    procedure OutputMessage(Sender: TObject; const Value: String; MsgLevel: TMsgLevelOption);
    property Connection: TADOConnection read FConnection write SetConnection;
  end;
  TKAPostJob = class(TKnowAll)
  private
    //批次提交任务
    function ParamByPostJob(const JobType, TypeName, SendUser, JobID, JobSubject,
      JobBody: String; Flows: array of TKeyValue): Variant;
  public
    function Execute(const JobType, TypeName, SendUser, JobID, JobSubject,
      JobBody: String; Users: array of TKeyValue): Boolean;
  end;
  TKACheckJob = class(TKnowAll)
  private
    FItems: TStringList;
    FDatas: array of TKeyValue;
    function GetDatas(Index: Integer): TKeyValue;
    function ParamByCheckJob(Items: TStrings): Variant;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    function DataCount: Integer;
    procedure AddItem(const JobID: String);
    property Items: TStringList read FItems;
    property Datas[Index: Integer]: TKeyValue read GetDatas;
  end;
  TKAPostUser = class(TKnowAll)
  private
    FItems: array of TArrayKeyValue;
    function ParamByPostUsers(): Variant;
  public
    procedure AddItem(UserInfo: array of TKeyValue);
    function Execute: Boolean;
  end;
  TKAPostDept = class(TKnowAll)
  private
    FItems: array of TArrayKeyValue;
    function ParamByPostDepts(): Variant;
  public
    procedure AddItem(DeptInfo: array of TKeyValue);
    function Execute: Boolean;
  end;

  function PhpGuid(const Value: String): String;
  function KV(ID, Data: Variant): TKeyValue;
  function Echo(Items: array of TArrayKeyValue): String; overload;
  function Echo(Items: array of TKeyValue): String; overload;
  function Echo(Item: TKeyValue): String; overload;

implementation

uses phpService;

function PhpGuid(const Value: String): String;
begin
  if(Copy(Value, 1, 1) = '{') then
    Result := Copy(Value, 2, Length(Value) - 2)
  else
    Result := Value;
end;

function KV(ID, Data: Variant): TKeyValue;
begin
  Result.ID := ID;
  Result.Data := Data;
end;

function Echo(Items: array of TArrayKeyValue): String;
var
  i: Integer;
begin
  Result := 'array (' + vbCrLf;
  for i := 0 to High(Items) do
    Result := Result + Echo(Items[i]);
  Result := Result + ')';
end;

function Echo(Items: array of TKeyValue): String; overload;
var
  i: Integer;
begin
  Result := 'array (' + vbCrLf;
  for i := 0 to High(Items) do
    Result := Result + Echo(Items[i]);
  Result := Result + ')' + vbCrLf;
end;

function Echo(Item: TKeyValue): String; overload;
begin
  Result := Format('Key=%s, Value=%s',
    [VarToStr(Item.ID), VarToStr(Item.Data)]) + vbCrLf;
end;

{ TKnowAll }

procedure TKnowAll.OutputMessage(Sender: TObject; const Value: String; MsgLevel: TMsgLevelOption);
begin
  if Supports(Self.Owner, IOutputMessage2) then
    (Self.Owner as IOutputMessage2).OutputMessage(Sender, Value, MsgLevel);
end;

procedure TKnowAll.SetConnection(const Value: TADOConnection);
begin
  FConnection := Value;
end;

{ TKAPostJob }

function TKAPostJob.Execute(const JobType, TypeName, SendUser, JobID, JobSubject,
  JobBody: String; Users: array of TKeyValue): Boolean;
var
  ps: TPhpService;
begin
  ps := TPhpService.Create(Self);
  try
    ps.Database := 'ERPV61';
    ps.Service := 'PostJob';
    ps.Param := ParamByPostJob(JobType, TypeName, SendUser, JobID, JobSubject, JobBody, Users);
    Result := ps.Execute();
    ps.OutError(Self);
  finally
    ps.Free;
  end;
end;

function TKAPostJob.ParamByPostJob(const JobType, TypeName, SendUser, JobID, JobSubject,
  JobBody: String; Flows: array of TKeyValue): Variant;
var
  i: Integer;
  table1, table2, table3: Variant;
  varRecords, varFields: Variant;
begin
  //签核的类别
  varRecords := VarArrayCreate([0, 0], VarVariant);
  varFields := VarArrayCreate([0, 1], VarVariant);
  varFields[0] := VarArrayOf(['TypeID_', PhpGuid(JobType)]);
  varFields[1] := VarArrayOf(['TypeName_', TypeName]);
  varRecords[0] := varFields;
  table1 := VarArrayOf(['WF_JobType', varRecords]);
  //要签核的内容
  varRecords := VarArrayCreate([0, 0], VarVariant);
  varFields := VarArrayCreate([0, 5], VarVariant);
  varFields[0] := VarArrayOf(['TypeID_', PhpGuid(JobType)]);
  varFields[1] := VarArrayOf(['ID_', PhpGuid(JobID)]);
  varFields[2] := VarArrayOf(['Subject_', JobSubject]);
  varFields[3] := VarArrayOf(['Body_', JobBody]);
  varFields[4] := VarArrayOf(['default_flow', High(Flows) = -1]);
  varFields[5] := VarArrayOf(['SendUser_', SendUser]);
  varRecords[0] := varFields;
  table2 := VarArrayOf(['WF_JobRecord', varRecords]);
  if(High(Flows) = -1) then
    begin
      Result := VarArrayOf([table1, table2]);
    end
  else
    begin
      //自定义流程
      varRecords := VarArrayCreate([0, High(Flows)], VarVariant);
      for i := 0 to High(Flows) do
      begin
        varFields := VarArrayCreate([0, 2], VarVariant);
        varFields[0] := VarArrayOf(['JobID_', PhpGuid(JobID)]);
        varFields[1] := VarArrayOf(['Type_', Flows[i].ID]);
        varFields[2] := VarArrayOf(['User_', Flows[i].Data]);
        //MsgBox('%s => %s', [KeyName(Flows[i]), KeyValue(Flows[i])]);
        varRecords[i] := varFields;
      end;
      table3 := VarArrayOf(['WF_JobDetail', varRecords]);
      //提交任务
      Result := VarArrayOf([table1, table2, table3]);
    end;
end;

{ TKACheckJob }

procedure TKACheckJob.AddItem(const JobID: String);
begin
  Self.FItems.Add(JobID);
end;

constructor TKACheckJob.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TStringList.Create;
end;

function TKACheckJob.DataCount: Integer;
begin
  Result := High(Self.FDatas);
end;

destructor TKACheckJob.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TKACheckJob.Execute: Boolean;
var
  ps: TPhpService;
  i: Integer;
  Item: Variant;
begin
  ps := TPhpService.Create(Self);
  try
    Result := False;
    if Self.FItems.Count > 0 then
      begin
        ps.Database := 'ERPV61';
        ps.Service := 'CheckJob'; ps.Param := ParamByCheckJob(FItems);
        Result := ps.Execute();
        ps.OutError(Self);
        if Result then
        begin
          SetLength(Self.FDatas, VarArrayHighBound(ps.Data, 1)+1);
          for i := 0 to VarArrayHighBound(ps.Data, 1) do
          begin
            item := ps.Data[i];
            Self.FDatas[i] := KV('{' + item[0] + '}',  + item[1]);
          end;
        end;
      end
    else
      OutputMessage(Self, Chinese.AsString('未找到需要签核的记录'), MSG_HINT);
  finally
    ps.Free;
  end;
end;

function TKACheckJob.GetDatas(Index: Integer): TKeyValue;
begin
  Result := Self.FDatas[Index];
end;

function TKACheckJob.ParamByCheckJob(Items: TStrings): Variant;
var
  i: Integer;
  db: TArrayDatabase;
  table: TArrayTable;
  rec: TArrayRecord;
begin
  db := TArrayDatabase.Create;
  try
    table := db.AddTable('WF_JobRecord');
    for i := 0 to Items.Count - 1 do
    begin
      rec := table.AddRecord;
      rec.AddField('ID', PhpGuid(Items.Strings[i]));
    end;
    Result := db.getValue;
  finally
    db.Free;
  end;
  {
  //检查任务
  varRecords := VarArrayCreate([0, Items.Count - 1], VarVariant);
  for i := 0 to Items.Count - 1 do
  begin
    varFields := VarArrayCreate([0, 0], VarVariant);
    varFields[0] := VarArrayOf(['ID', PhpGuid(Items.Strings[i])]);
    varRecords[i] := varFields;
  end;
  Result := VarArrayOf([VarArrayOf(['WF_JobRecord', varRecords])]);
  }
end;

{ TKAPostUser }

procedure TKAPostUser.AddItem(UserInfo: array of TKeyValue);
var
  i: Integer;
  It: Integer;
begin
  It := High(FItems) + 1;
  SetLength(FItems, It + 1);
  SetLength(FItems[It], High(UserInfo) + 1);
  for i := 0 to High(UserInfo) do
  begin
    FItems[It][i].ID := UserInfo[i].ID;
    FItems[It][i].Data := UserInfo[i].Data;
  end;
end;

function TKAPostUser.Execute: Boolean;
var
  s1, s2: String;
  ps: TPhpService;
begin
  ps := TPhpService.Create(Self);
  try
    Result := False;
    ps.Database := 'ERPV61';
    ps.Service := 'PostUsers';
    ps.Param := ParamByPostUsers();
    Result := ps.Execute();
    ps.OutError(Self);
    if Result then
    begin
      s1 := ps.Data[0];
      s2 := ps.Data[1];
      OutputMessage(Self, Format(Chinese.AsString('共成功增加用户 %s 个, 更新用户 %s 个'),
        [s1, s2]), MSG_HINT);
    end;
  finally
    ps.Free;
  end;
end;

function TKAPostUser.ParamByPostUsers(): Variant;
var
  i, j: Integer;
  UserInfo: TArrayKeyValue;
  db: TArrayDatabase;
  tb: TArrayTable;
  rec: TArrayRecord;
begin
  db := TArrayDatabase.Create;
  try
    tb := db.AddTable('WF_UserInfo');
    for i := 0 to High(FItems) do
    begin
      UserInfo := FItems[i];
      rec := tb.AddRecord;
      for j := 0 to High(UserInfo) do
        rec.AddField(UserInfo[j].ID, UserInfo[j].Data);
    end;
    Result := db.getValue;
  finally
    db.Free;
  end;
end;

{ TArrayDatabase }

function TArrayDatabase.AddTable(const ATableCode: String): TArrayTable;
begin
  Result := TArrayTable.Create;
  Result.TableCode := ATableCode;
  FItems.Add(Result);
end;

function TArrayDatabase.getValue: Variant;
var
  i: Integer;
  Table: TArrayTable;
begin
  Result := VarArrayCreate([0, FItems.Count - 1], VarVariant);
  for i := 0 to FItems.Count - 1 do
  begin
    Table := TArrayTable(FItems.Items[i]);
    Result[i] := VarArrayOf([Table.TableCode, Table.getValue]);
  end;
end;

constructor TArrayDatabase.Create;
begin
  FItems := TList.Create;
end;

destructor TArrayDatabase.Destroy;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    TArrayTable(FItems[i]).Free;
  FItems.Free;
  inherited;
end;

{ TArrayRecord }

procedure TArrayRecord.AddField(const AID: String; AData: OleVariant);
var
  i: Integer;
begin
  i := High(FFields) + 1;
  SetLength(FFields, i + 1);
  FFields[i].ID := AID;
  FFields[i].Data := AData;
end;

function TArrayRecord.getValue: Variant;
var
  i: Integer;
begin
  Result := VarArrayCreate([0, High(FFields)], VarVariant);
  for i := 0 to High(FFields) do
    Result[i] := VarArrayOf([FFields[i].ID, FFields[i].Data]);
end;

{ TArrayTable }

function TArrayTable.AddRecord: TArrayRecord;
begin
  Result := TArrayRecord.Create;
  FItems.Add(Result);
end;

constructor TArrayTable.Create;
begin
  inherited;
  FItems := TList.Create;
end;

destructor TArrayTable.Destroy;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    TArrayRecord(FItems[i]).Free;
  FItems.Free;
  inherited;
end;

function TArrayTable.getValue: Variant;
var
  i: Integer;
begin
  //提交用户
  Result := VarArrayCreate([0, FItems.Count - 1], VarVariant);
  for i := 0 to FItems.Count - 1 do
    Result[i] := TArrayRecord(FItems[i]).getValue;
end;

procedure TArrayTable.SetTableCode(const Value: String);
begin
  FTableCode := Value;
end;

{ TKAPostDept }

procedure TKAPostDept.AddItem(DeptInfo: array of TKeyValue);
var
  i: Integer;
  It: Integer;
begin
  It := High(FItems) + 1;
  SetLength(FItems, It + 1);
  SetLength(FItems[It], High(DeptInfo) + 1);
  for i := 0 to High(DeptInfo) do
  begin
    FItems[It][i].ID := DeptInfo[i].ID;
    FItems[It][i].Data := DeptInfo[i].Data;
  end;
end;

function TKAPostDept.Execute: Boolean;
var
  ps: TPhpService;
  s1, s2: String;
begin
  ps := TPhpService.Create(Self);
  try
    Result := False;
    ps.Database := 'ERPV61';
    ps.Service := 'KACDept';
    ps.Param := ParamByPostDepts();
    Result := ps.Execute();
    ps.OutError(Self);
    if Result then
    begin
      s1 := ps.Data[0];
      s2 := ps.Data[1];
      OutputMessage(Self, Format(Chinese.AsString('共成功增加部门 %s 个, 更新部门 %s 个'),
        [s1, s2]), MSG_HINT);
    end;
  finally
    ps.Free;
  end;
end;

function TKAPostDept.ParamByPostDepts: Variant;
var
  i, j: Integer;
  DeptInfo: TArrayKeyValue;
  db: TArrayDatabase;
  tb: TArrayTable;
  rec: TArrayRecord;
begin
  db := TArrayDatabase.Create;
  try
    tb := db.AddTable('WF_Dept');
    for i := 0 to High(FItems) do
    begin
      DeptInfo := FItems[i];
      rec := tb.AddRecord;
      for j := 0 to High(DeptInfo) do
        rec.AddField(DeptInfo[j].ID, DeptInfo[j].Data);
    end;
    Result := db.getValue;
  finally
    db.Free;
  end;
end;

end.
