unit WorkFlows;
{$I ERPVersion.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, DB, ADODB, Grids, DBGrids, ComCtrls, ApConst,
  StdCtrls, Buttons, DateUtils, Math, CalMrpNum_class, AppBean, NetRegistry,
  MailBox_class;

type
  // WorkFlow ����
  TWorkFlow = class(TAppBean)
  private
    FInit: Boolean;
    FNetRegister: TNetRegistry;
    FNumOperator: Integer;
    FErrors: TStringList;
    FMrpNum: THRCalMrpNum;
    FTableID: String;
    FFlowClass: Integer;
    FFlowCode: String;
    procedure SetTableID(const Value: String);
    procedure SetFlowCode(const Value: String);
    procedure SetFlowClass(const Value: Integer);
  protected
    function GetFieldSize(Field: TField): Integer;
    function Space(Size: Integer; TemplateChar: Char = ' '): String;
    function SysReadInit(const Root, Key: String; Default: Integer = 0): Integer;
    function DBRead(const SQLCmd: String; const Default: Variant): Variant;
    function Exists(const SQLCmd: String): Boolean;
    //����״̬����Ϊ���������
    function ChangeStatus: Boolean;
    function GetDataSetString(DataSet: TDataSet; vFields,
      vCaptions: OleVariant; const FormCode: String = ''): String;
  protected
    MailBox: TMailBox;
    CurStatus, NewStatus: Integer;
    UpdateMode, FGenHistory: Boolean; //����ģʽ�� True: ǩ�˺����
    TBID,AppUser,TableName: String;
    function nreg: TNetRegistry;
    procedure OutputError(const ErrorInfo: String; Default: Boolean = False);
    //ִ��һ��SQLָ��
    function ExecSQL(const SQLCmd: String): Boolean; virtual;
    //ȡ��ָ����֮�����ֶΣ��ֶ������ų� strFields ��ָ�����ֶΡ�
    function GetFields(const strTable, strFields: String): String;
    // ��״̬�� 1->0 ʱ������ WorkFlow ��¼��
    function UnSendForm(const AID: String): Boolean;
    //����һ���µ��춯����
    function CreateTBNo(const TB: String; const TBDate: String = ''): String; virtual;
    //ִ����ɺ󱣴�NewStatus״̬
    procedure SaveStatus; virtual;
    //ִ��������ҵ
    procedure UpdateToLation; virtual;
    //
    procedure CopyFields(Target: TDataSet; const Args1: array of String;
      Source: TDataSet; const Args2: array of String);
  public
    //VipCard: ^TAccountCard;
    DataSetH, DataSetB: TAppQuery;
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    procedure Init;
    function AllOK: Boolean;
    property Errors: TStringList read FErrors write FErrors;
    //
    property FlowClass: Integer read FFlowClass write SetFlowClass;
    property FlowCode: String read FFlowCode write SetFlowCode;
    property TableID: String read FTableID write SetTableID;
  protected
    // ��鵥�𣬵�ID�����������Ƿ�Ϸ�
    function OpenDataSet: Boolean; virtual; abstract;
    // ���� Table�����������
    function RepairTable: Boolean; virtual; abstract;
    // ���������� WorkFlow ���Թ�ǩ��
    function SendToWorkflow: Boolean; virtual; abstract;
    //������ʷ�汾
    function CreateHistory: Boolean; virtual; abstract;
    //ִ�����ݱ�������춯
    procedure ApplyChanged; virtual; abstract;
    {
    // ���������йصĲ��֣�������״̬
    function ChangeNum: Boolean; virtual; abstract;
    // �������������йصĲ��֣�������״̬
    function UnChangeNum: Boolean; virtual; abstract;
    }
    // ����Ƿ������ɺ�׼��Ϊ�ݸ�
    function AllowUpdateStatus: Boolean; virtual;
  public
    // ��������ǩ�˹���
    function Execute2007(const AID: String;
      ACurStatus,ANewStatus: Integer; var TimeCount: Cardinal): Boolean;
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
    property MrpNum: THRCalMrpNum read FMrpNum;
    property NumOperator: Integer read FNumOperator;
  end;

const
  WF_TRIGGER: Integer = -101; //��ֵ�Ѿ��̶��������޸�����ͬ WorkFlow.Exe
  WF_SOURCE: Integer = -102;
  WF_CONFIRM = -103;
  WF_DELETE = -103;
  WF_WAIT: Integer = -99999;
  vbCrLf: String = #13 + #10;

implementation

uses AppResource, IniFiles, BuilderTBNo_class;

{ TWorkFlow }

procedure TWorkFlow.OutputError(const ErrorInfo: String; Default: Boolean);
begin
  if Default and (Errors.Count > 0) then Exit;
  Errors.Add(ErrorInfo);
end;

constructor TWorkFlow.Create(AOwner: TComponent);
begin
  Init;
end;

destructor TWorkFlow.Destroy;
begin
  if Assigned(DataSetH) then
  begin
    DataSetH.Active := False;
    FreeAndNil(DataSetH);
  end;
  if Assigned(DataSetB) then
  begin
    DataSetB.Active := False;
    FreeAndNil(DataSetB);
  end;
  //
  if Assigned(FNetRegister) then
    FreeAndNil(FNetRegister);
  if Assigned(FErrors) then
    FreeAndNil(FErrors);
  if Assigned(MailBox) then
    FreeAndNil(MailBox);
  //
  FreeAndNil(FMrpNum);
  inherited;
end;

function TWorkFlow.GetFields(const strTable,strFields: String): String;
var
  i: Integer;
  oRs: _Recordset;
begin
  Result := '';
  oRs := Connection.Execute(Format('Select top 0 * from %s',[strTable]));
  for i:=0 to oRs.Fields.Count - 1 do
  begin
    if Pos(UpperCase(oRs.Fields[i].Name),UpperCase(strFields)) = 0 then
      Result := Result + oRs.Fields[i].Name + ',';
  end;
  oRs.Close;
end;

function TWorkFlow.DBRead(const SQLCmd: String;
  const Default: Variant): Variant;
var
  cdsTmp: TAppQuery;
begin
  Result := Default;
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Connection;
      SQL.Text := SQLCmd;
      Open;
      if not Eof then
        Result := Fields[0].Value;
    end;
  finally
    FreeAndNil(cdsTmp);
  end;
end;

function TWorkFlow.ExecSQL(const SQLCmd: String): Boolean;
begin
  Result := False;
  try
    Connection.Execute(SQLCmd);
    Result := True;
  except
    OutputError('Execute SQLCmd Error. [' + SQLCmd + ']');
  end;
end;

function TWorkFlow.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  R: Cardinal;
begin
  Init;
  MrpNum.Session := Self.Session;
  MailBox.Session := Self.Session;
  if VarIsNumeric(Param[3]) then
    Self.FlowClass := Param[3]
  else
    Self.FlowCode := Param[3];
  if Execute2007(Param[0],Param[1],Param[2],R) then
    begin
      Data := 'Execute Time: ' + IntToStr(R);
      Result := True;
    end
  else
    begin
      Data := Format('WorkFlow Error[ID=%s].',[Param[0]]) + vbCrLf + Errors.Text;
      Result := False;
    end;
end;

function TWorkFlow.Execute2007(const AID: String;
  ACurStatus, ANewStatus: Integer; var TimeCount: Cardinal): Boolean;
var
  lStart: Cardinal;
  StartTrans: Boolean;
begin
  Init;
  MrpNum.Session := Self.Session;
  MailBox.Session := Self.Session;
  try
    Result := False;
    lStart       := GetTickCount;
    Self.TBID    := AID;
    CurStatus    := ACurStatus;
    NewStatus    := ANewStatus;
    //��ʼ����������
    if not Connection.Connected then
      Connection.Open;
    DataSetH.Connection := Self.Connection;
    DataSetB.Connection := Self.Connection;
    if not Connection.InTransaction then
      begin
        Connection.BeginTrans;
        StartTrans := True;
      end
    else
      StartTrans := False;
    try
      try
        if not ChangeStatus() then
          OutputError('ChangeStatus Error.',True);
      except
        on E: Exception do OutputError(E.Message);
      end;
      // �����������, ���ύ��ع�
      if StartTrans then
      begin
        if AllOK() then
          Connection.CommitTrans
        else
          Connection.RollbackTrans;
      end;
      Result    := AllOK();
    finally
      TimeCount := GetTickCount - lStart
    end;
  finally
    FreeAndNil(MailBox);
  end;
end;

function TWorkFlow.ChangeStatus: Boolean;
var
  nStatus: Integer;
begin
  // ���ϵͳ����
  nStatus := 0;
  if not OpenDataSet() then
  begin
    OutputError('CheckParam Error.',True);
    Result := False;
    Exit;
  end;
  if DataSetH.FieldByName('Status_').AsInteger <> CurStatus then
  begin
    OutputError(ChineseAsString('SRA04', '��ǰ�����ѱ������޸ģ�����״̬�Ѹı䣬�����²�ѯ��'));
    Exit;
  end;
  if UpdateMode then
    nStatus := 2;
  //�Ӳݸ嵽�ݸ壬�������ڱ��沢��������
  if (CurStatus = 0) and (NewStatus = 0) then
    begin
      // ������ǰ����
      if not RepairTable() then
        OutputError('RepairTable Error.',True);
    end
  // �ӡ��ݸ� -> ȷ�ϡ�ת����
  else
  if (CurStatus = 0) and (NewStatus = 1) then
    begin
      FNumOperator := 1;
      // ������ǰ����
      if not RepairTable() then
        OutputError('RepairTable Error.',True);
      //�����ݷ��͵� WorkFlow ��
      if Self.UpdateMode then  //ֻ����ǩ��ģʽ�²���Ҫ���ô�ģʽ. Add by jrlee at 2007/10/19
      begin
        if not SendToWorkflow() then
          OutputError('Execute SendForm Error.',True);
      end;
      // �ȼ�����ǩ��
      if (not UpdateMode) then
        ApplyChanged;
    end
  // �ӡ�ȷ�� -> ��׼��ת����
  else if (CurStatus = 1) and (NewStatus = 2) then
    begin
      FNumOperator := 1;
      // ��ǩ���ټ���
      if UpdateMode then
        ApplyChanged;
    end
  // �ӡ���׼ -> ȷ�ϡ�ת����
  else if (CurStatus = 2) and (NewStatus = 1) then
    begin
      FNumOperator := -1;
      // ��ǩ���ټ���
      if UpdateMode then
      begin
        ApplyChanged;
      end;
    end
  // �ӡ�ȷ�� -> �ݸ塷ת����
  else if (CurStatus = 1) and (NewStatus = 0) then
    begin
      FNumOperator := -1;
      // �ȼ�����ǩ��
      if (not UpdateMode) or (UpdateMode and DataSetH.FieldByName('Final_').AsBoolean) then
        ApplyChanged;
      if (not UpdateMode) and (AllOK()) and FGenHistory then
      begin
        if not CreateHistory() then
          OutputError('Execute CreateCorrect Error.',True);
      end;
      if not UnSendForm(DataSetH.FieldByName('ID_').AsString) then
        OutputError('Execute UnSendForm Error.',True);
    end
  // �ӡ��ݸ� -> ���ϡ�ת����
  else if (CurStatus = 0) and (NewStatus = -1) then
    begin
      UpdateToLation;
    end
  // �ӡ����� -> �ݸ塷ת����
  else if (CurStatus = -1) and (NewStatus = 0) then
    begin
    end
  // �ӡ���׼ -> �ݸ塷ת����
  else if (CurStatus = 2) and (NewStatus = 0) then
    begin
      FNumOperator := -1;
      {$message '�˴���Ҫ�ڲ�����Ϊ��ȡ����Ӧ�����Իָ���Jason at 2010/9/13'}
      //if AllowUpdateStatus() then   //Rem by jrlee at 2007/10/17
      begin
        ApplyChanged;
        if (AllOK()) and FGenHistory then
        begin
          if not CreateHistory() then
            OutputError('Execute CreateCorrect Error.',True);
        end;
        if not UnsendForm(DataSetH.FieldByName('ID_').AsString) then
          OutputError('Execute UnsendForm Error.',True);
      end;
    end
  else //�Ƿ�״̬ת��
    OutputError(Format(STR_02042,[CurStatus,NewStatus]),True);
  // ���û�з����κδ�������µ���״ֵ̬��
  if (nStatus = 2) and (NewStatus = 1) and (not UpdateMode) then
    NewStatus := 2;
  if AllOK() then
    SaveStatus;
  Result := AllOK();
end;

function TWorkFlow.Space(Size: Integer; TemplateChar: Char): String;
var
  i: Integer;
begin
  for i := 1 to Size do Result := Result + TemplateChar;
end;

function TWorkFlow.GetFieldSize(Field: TField): Integer;
begin
  case Field.DataType of
  ftString: Result := Field.Size;
  ftSmallint: Result := 6;
  ftInteger: Result := 12;
  ftWord: Result := 12;
  ftBoolean: Result := 2;
  ftFloat: Result := 12;
  ftCurrency: Result := 12;
  ftDate: Result := 10;
  ftTime: Result := 8;
  ftDateTime: Result := 20;
  ftAutoInc: Result := 12;
  ftLargeint: Result := 16;
  ftGuid: Result := 36;
  else Result := 12;
  end;
end;

{
function TWorkFlow.GetDataSetString(DataSet: TDataSet; vFields,vCaptions: OleVariant): String;
var
  i,Size,SizeTotal: Integer;
  Field: TField;
begin
  SizeTotal := 0;
  for i := VarArrayLowBound(vCaptions,1) to VarArrayHighBound(vCaptions,1) do
  begin
    Field := DataSet.FieldByName(vFields[i]);
    Size := Max(GetFieldSize(Field),Length(vCaptions[i]));
    SizeTotal := SizeTotal + Size;
    Result := Result + Copy(vCaptions[i] + Space(Size),1,Size) + ' ';
  end;
  Result := Space(SizeTotal,'=') + vbCrLf + Result + vbCrLf + Space(SizeTotal,'=') + vbCrLf;
  DataSet.First;
  while not DataSet.Eof do
  begin
    for i := VarArrayLowBound(vFields,1) to VarArrayHighBound(vFields,1) do
    begin
      Field := DataSet.FieldByName(vFields[i]);
      Size := Max(GetFieldSize(Field),Length(vCaptions[i]));
      Result := Result + Copy(Field.AsString + Space(Size),1,Size) + ' ';
    end;
    Result := Result + vbCrLf;
    DataSet.Next;
  end;
  Result := Result + Space(SizeTotal,'=') + vbCrLf;
end;
}

//Modify by Jason 2006/10/19
function TWorkFlow.GetDataSetString(DataSet: TDataSet;
  vFields, vCaptions: OleVariant; const FormCode: String): String;
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Add('<table border="0" style="font-size: 12px" cellspacing="0" cellpadding="3">');
    sl.Add('<tr bgcolor="#FFFFFF">');
    if FormCode <> '' then
      sl.Add(Format(ChineseAsString('SRA01', '<td><a href="hrip:%s?%s">����</a>�������£�</td>'), [FormCode, Self.TBID]))
    else
      sl.Add(ChineseAsString('SRA02', '<td>�����������£�</td>'));
    sl.Add('</tr>');
    sl.Add('</table>');
    //
    sl.Add('<table BORDER=0 style="font-size: 12px;table-layout:fixed" cellspacing="1" cellpadding="3" bgcolor="#808080">');
    sl.Add('<tr bgcolor="#FFFFFF">');
    for i := VarArrayLowBound(vCaptions,1) to VarArrayHighBound(vCaptions,1) do
    begin
      if Pos('>',vCaptions[i]) > 0 then
        sl.Add(Format('<td bgcolor="#00FF99" align="center" %s</td>', [vCaptions[i]]))
      else sl.Add(Format('<td bgcolor="#00FF99" align="center">%s</td>', [vCaptions[i]]));
    end;
    sl.Add('</tr>');
    //����
    DataSet.First;
    while not DataSet.Eof do
    begin
      sl.Add('<tr bgcolor="#FFFFFF">');
      for i := VarArrayLowBound(vFields,1) to VarArrayHighBound(vFields,1) do
      begin
        sl.Add(Format('<td>%s</td>', [DataSet.FieldByName(vFields[i]).AsString]));
      end;
      sl.Add('</tr>');
      Result := Result + vbCrLf;
      DataSet.Next;
    end;
    sl.Add('</table>');
    Result := '';
    for i := 0 to sl.Count - 1 do
    begin
      Result := Result + sl.Strings[i];
    end;
  finally
    sl.Free;
  end;
end;

function TWorkFlow.UnSendForm(const AID: String): Boolean;
begin
  Connection.Execute('delete FileIncept where PID_=''' + AID + '''');
  Connection.Execute('delete FileData where ID_=''' + AID + '''');
  Result := True;
end;

function TWorkFlow.SysReadInit(const Root, Key: String;
  Default: Integer): Integer;
var
  nreg: TNetRegistry;
begin
  nreg := TNetRegistry.Create(Self);
  try
    Result := nreg.ReadInit(Root, Key, Default);
  finally
    nreg.Free;
  end;
end;

function TWorkFlow.nreg: TNetRegistry;
begin
  if not Assigned(FNetRegister) then
    FNetRegister := TNetRegistry.Create(Self);
  Result := FNetRegister;
end;
{
function TWorkFlow.ChangeNum: Boolean;
begin
  //���µ�ͷ
  with DataSetH do
  begin
    if Active then
    begin
      FieldByName('Final_').AsBoolean := True;
    end;
  end;
  //���µ���
  with DataSetB do
  begin
    if Active then
    begin
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('Final_').AsBoolean := True;
        Next;
      end;
      if State in [dsInsert,dsEdit] then Post;
    end;
  end;
  Result := True;
end;

function TWorkFlow.UnChangeNum: Boolean;
begin
  //���µ�ͷ
  with DataSetH do
  begin
    if Active then
    begin
      FieldByName('Final_').AsBoolean := False;
    end;
  end;
  //���µ���
  with DataSetB do
  begin
    if Active then
    begin
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('Final_').AsBoolean := False;
        Next;
      end;
      if State in [dsEdit,dsInsert] then Post;
    end;
  end;
  Result := True;
end;
}
{
procedure TWorkFlow.ApplyChanged;
begin
  //�˺������ᱻִ������, Author: Jason, 2006/7/2
  if NumOperator =  1 then
    begin
      if not ChangeNum() then
        OutputError('Execute ChangeNum Error.',True);
    end
  else if NumOperator = -1 then
    begin
      if not UnChangeNum() then
        OutputError('Execute UnChangeNum Error.',True);
    end
  else
    raise Exception.CreateFmt('Error: NumOperator = %d', [NumOperator]);
end;
}

procedure TWorkFlow.SaveStatus;
begin
  //�������µ�״̬
  Self.ExecSQL(Format('Update %sH Set Status_=%d, UpdateUser_=''%s'', UpdateDate_=GetDate() Where ID_=''%s''',
    [TableName, NewStatus, Self.Session.UserCode, DataSetH.FieldByName('ID_').AsString]));
end;

function TWorkFlow.Exists(const SQLCmd: String): Boolean;
var
  cdsTmpExist: TAppQuery;
begin
  cdsTmpExist := TAppQuery.Create(nil);
  try
    with cdsTmpExist do
    begin
      Connection := Self.Connection;
      SQL.Text := SQLCmd;
      Open;
      Result := not Eof;
    end;
  finally
    FreeAndNil(cdsTmpExist);
  end;
end;

function TWorkFlow.AllowUpdateStatus: Boolean;
begin
  Result := True;
end;

function TWorkFlow.AllOK: Boolean;
begin
  Result := Errors.Count = 0;
end;

procedure TWorkFlow.SetTableID(const Value: String);
begin
  FTableID := Value;
  MailBox.TableID := Value;
end;

procedure TWorkFlow.SetFlowCode(const Value: String);
begin
  FFlowCode := Value;
  MailBox.FlowCode := Value;
end;

procedure TWorkFlow.SetFlowClass(const Value: Integer);
begin
  FFlowClass := Value;
  MailBox.FlowClass := Value;
end;

function TWorkFlow.CreateTBNo(const TB, TBDate: String): String;
var
  btb: THRBuilderTBNo;
begin
  btb := THRBuilderTBNo.Create(nil);
  try
    try
      btb.Session := Self.Session;
      btb.TB := TB;
      if TBDate = '' then
        begin
          if (TB = 'AM') then
            btb.TBDate := DataSetH.FieldByName('QCTBDate_').AsDateTime
          else
            btb.TBDate := DataSetH.FieldByName('TBDate_').AsDateTime;
        end
      else
        btb.TBDate := StrToDate(TBDate);
      Result := btb.CreateOfID(TableID);
    except
      on E: Exception do
      begin
        OutputError(E.Message);
        Result := Space(btb.MaxLength, '0');
      end;
    end;
  finally
    FreeAndNil(btb);
  end;
end;

procedure TWorkFlow.CopyFields(Target: TDataSet;
  const Args1: array of String; Source: TDataSet;
  const Args2: array of String);
var
  i: Integer;
begin
  for i := Low(Args1) to High(Args1) do
    Target.FieldByName(Args1[i]).Value := Source.FieldByName(Args2[i]).Value;
end;

procedure TWorkFlow.Init;
begin
  if not FInit then
  begin
    FInit := True;
    FErrors := TStringList.Create;
    DataSetH := TAppQuery.Create(Application);
    DataSetB := TAppQuery.Create(Application);
    DataSetH.LockType :=  ltOptimistic;
    DataSetB.LockType :=  ltOptimistic;
    FMrpNum := THRCalMrpNum.Create(nil);
    MailBox := TMailBox.Create(Self);
    FFlowClass := 0;
    FFlowCode := '';
  end;
end;

procedure TWorkFlow.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.addParam('String TBID');
  This.addParam('Integer CurStatus');
  This.addParam('Integer NewStatus');
  This.addParam('String FlowCode');
  This.AddData('String ExecuteTime');
  This.Remark := ChineseAsString('SRA03', '���е��ݵ�ȷ�ϼ�������ҵ��');
end;

procedure TWorkFlow.UpdateToLation;
begin
  ;
end;

end.
