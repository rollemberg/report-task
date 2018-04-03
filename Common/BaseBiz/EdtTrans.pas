unit EdtTrans;
{$I ERPVersion.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZjhCtrls, ExtCtrls, StdCtrls, ComCtrls, DBClient, ErpTools,
  ApConst, DBForms, uSelect, uBaseIntf;

type
  TEdtTran = class(TDBForm, IReportSource)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    DataSetH,DataSetB: TZjhDataSet;
    FAllow: Boolean;
    FIsAssign: Boolean;
    OldReconcileError: TReconcileErrorEvent;
  protected
    m_TB: TTBRecord;
    //DataSetM: TZjhDataSet; //cdsTranH,cdsTranB,cdsRemark;
    DataSourceH,DataSourceB: TDataSource;
    function GetVerUpdate(cdsSource, cdsTarget: TZjhDataSet;
      const DateField: String): String;
  protected
    CaclH,CaclT: OleVariant;
    procedure PartWHCode_Validate(Sender: TField);
    procedure DataSetB_AfterInsert(DataSet: TDataSet);
    //procedure DataSetBCaclFields(DataSet: TDataSet);
    //procedure DataSetHCaclFields(DataSet: TDataSet);
    //procedure DataSetTCaclFields(DataSet: TDataSet);
    procedure qhFind(Sender: TObject);
    procedure qhUpdateStatus(Sender: TObject; doAction: QDefaultOption;
      var Allow: Boolean);
    procedure qhBeforeExecute(Sender: TObject; doAction: QDefaultOption;
      var Allow: Boolean);
    procedure qhRecordMove(Sender: TObject; rmAction: TRecordMoveOption;
      var DoDefault: Boolean);
    procedure pcChange(Sender: TObject);
    procedure DataSetHReasonCode_Validate(Sender: TField);
    procedure DataSetHDeptCode_Validate(Sender: TField);
    procedure SetDataSource(dsH,dsB: TDataSource);
    function GetStatusResID: Integer;
    function FindVacancy(DataSet: TDataSet; const WHCode,
      PartCode: String): Boolean; virtual;
    //IReportSource
    procedure GetReportSource(Sender: TObject; Items: TList); virtual;
    //
    procedure NewReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
  public
    { Public declarations }
    Coat: TFormCoat;
    property TB: TTBRecord read m_TB;
    procedure CheckValue(strError: TStrings); virtual; abstract;
  end;

implementation

uses MainData, InfoBox;

{$R *.dfm}

{$R ErpRes.res}

procedure TEdtTran.DataSetB_AfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('PID_').AsString := DataSetH.FieldByName('ID_').AsString;
  Dataset.FieldByName('ID_').AsString := NewGuid();
  DataSet.Post;
  DataSet.Edit;
  DataSet.FieldByName('It_').AsInteger := DataSet.RecNo;
end;

procedure TEdtTran.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(DataSetH) then
    with DataSetH do if State in [dsInsert,dsEdit] then Post;
  if Assigned(DataSetB) then
    with DataSetB do if State in [dsInsert,dsEdit] then Post;
  if (Assigned(DataSetH) and (DataSetH.ChangeCount > 0))
    or (Assigned(DataSetB) and (DataSetB.ChangeCount > 0)) then
  begin
    case MessageDlg(Chinese.AsString('��ǰ����û�б��棬�����Ҫ���沢�˳���'),mtConfirmation,[mbYes,mbNo,mbCancel],0) of
      mrYes: Sec.Save;
      mrCancel:
      begin
        CanClose := False;
        Abort;
      end;
    else CanClose := True;
    end;
  end;
end;

{
procedure TEdtTran.DataSetHCaclFields(DataSet: TDataSet);
begin
  CM.UpdateTranField(DataSet,CaclH);
end;

procedure TEdtTran.DataSetTCaclFields(DataSet: TDataSet);
begin
  CM.UpdateTranField(DataSet,CaclT);
end;
}

procedure TEdtTran.qhUpdateStatus(Sender: TObject;
  doAction: QDefaultOption; var Allow: Boolean);
begin
  inherited;
  with DataSetH do
  case doAction of
  doEdit,doSave:
    Allow := Active and (not ReadOnly) and (FieldByName('Status_').AsInteger = 0);
  doDelete:
    Allow := Active and (not ReadOnly) and (Length(Trim(FieldByName('TBNo_').AsString)) < 3);
  doConfirm:
    Allow := Active and (FieldByName('Status_').AsInteger = 0);
  doUnChange:
    begin
      //Modify by Jason 2006/10/19: �˺󵥾ݿ��Գ���
      Allow := Active and (FieldByName('Status_').AsInteger >= 1) and
        (Assigned(FindField('Ver_')) and (FieldByName('Ver_').AsInteger <= 0));
    end;
  doCancelLation:
    Allow := Active and (Length(Trim(FieldByName('TBNo_').AsString)) > 2) and
      (FieldByName('Status_').AsInteger = 0);
  doAppend,doFind:
    Allow := not TB.History;
  end;
end;

procedure TEdtTran.qhBeforeExecute(Sender: TObject;
  doAction: QDefaultOption; var Allow: Boolean);
var
  strError: TStringList;
begin
  //�������ݼ�������Ϣ
  FAllow := True;
  if not FIsAssign then
  begin
    OldReconcileError := DataSetH.OnReconcileError;
    DataSetH.OnReconcileError := NewReconcileError;
    FIsAssign := True;
  end;
  //
  case doAction of
  doSave:
    begin
      DataSetB.DisableControls;
      strError := TStringList.Create;
      try
        CheckValue(strError);
        if strError.Count > 0 then
        begin
          if strError.Count = 1 then
            MsgBox(strError.Text)
          else
            ShowErrorWind(strError,Chinese.AsString('�޷�����')); //'�޷�����'
          Allow := False;
          Exit;
        end;
        with DataSetH do
        begin
          if TB.InitNo and (FindField('TBNo_') <> nil) then
          begin
            if Length(FieldByName('TBNo_').AsString) = Length(TB.Name) then
            begin
              Edit;
              FieldByName('TBNo_').AsString := CM.CreateTBNo(TB,
                FieldByName('TBDate_').AsDateTime);
            end;
          end;
        end;
      finally
        DataSetB.EnableControls;
        strError.Free;
      end;
    end;
  doConfirm:
    Allow := Sec.Save and FAllow;
  doUnChange:
    Allow := FAllow;
  doCancelLation:
    Allow := FAllow;
  end;
end;

procedure TEdtTran.qhRecordMove(Sender: TObject;
  rmAction: TRecordMoveOption; var DoDefault: Boolean);
var
  AIntf: IBaseForm;
  SchSec: TZjhTool;
  SchDataSet: TDataSet;
  strError: String;
begin
  inherited;
  if Assigned(Coat) then
    AIntf := Coat.GetForm(1) as IBaseForm
  else
    AIntf := MainIntf.GetForm('TSch' + TB.Table + '&' + TB.Name, True);
  if Assigned(AIntf) then
  begin
    SchSec := TZjhTool(AIntf.ISec);
    SchDataSet := SchSec.DataSource.DataSet;
    if (SchDataSet.Active) and (SchDataSet.RecordCount > 0) then
    begin
      SchSec.DataTool.RecordMove(SchSec.DataSource,rmAction,strError);
      PostMessage(CONST_GOTORECORD, SchDataSet.FieldByName('ID_').AsString);
    end;
  end;                                                                 
end;

procedure TEdtTran.qhFind(Sender: TObject);
var
  AIntf: IBaseForm;
begin
  AIntf := MainIntf.GetForm('TSch' + TB.Table + TB.Name, True);
  if Assigned(AIntf) then
    AIntf.ShowForm(CONST_FORM_SHOW, TEMP_VARIANT);
end;

procedure TEdtTran.pcChange(Sender: TObject);
begin
  DataSetH.RequestScroll;
end;

procedure TEdtTran.DataSetHReasonCode_Validate(Sender: TField);
var
  R: Variant;
begin
  inherited;
  if Trim(Sender.AsString) = '' then Exit;
  R := Buff.ReadValue('Reason', Sender.AsString, 'DefTB_');
  {$IFDEF ERP2011}
  if VarIsNull(R) or (UpperCase(TB.Name) <> UpperCase(VarToStr(R))) then
  {$ELSE}
  if VarIsNull(R) or (UpperCase(TB.SysTB) <> UpperCase(VarToStr(R))) then
  {$ENDIF}
  begin
    MsgBox(Chinese.AsString('������춯ԭ�򲻴���!'));
    Abort();
  end;
end;

procedure TEdtTran.DataSetHDeptCode_Validate(Sender: TField);
begin
  inherited;
  if Trim(Sender.AsString) = '' then Exit;
  if not Buff.ValueExists('Dept',Sender.AsString) then
  begin
    MsgBox(Chinese.AsString('����Ĳ��Ŵ��벻����! '));
    Abort();
  end;
end;

procedure TEdtTran.SetDataSource(dsH, dsB: TDataSource);
begin
  DataSourceH := dsH;
  DataSourceB := dsB;
  DataSetH := dsH.DataSet as TZjhDataSet;
  DataSetB := dsB.DataSet as TZjhDataSet;
end;

procedure TEdtTran.PartWHCode_Validate(Sender: TField);
var
  R: Variant;
begin
  R := Buff.Read('PartWH',Sender.AsString,['Name_']);
  if VarIsNull(R) then
  begin
    MsgBox(Chinese.AsString('������������!'));
    Abort();
  end;
end;

procedure TEdtTran.GetReportSource(Sender: TObject; Items: TList);
begin
  Items.Add(DataSourceH);
  Items.Add(DataSourceB);
end;

function TEdtTran.GetStatusResID: Integer;
var
  Status: Integer;
begin
  if DataSetH.Active then
    begin
      Status := DataSetH.FieldByName('Status_').AsInteger;
      if TB.History then
        Result := 1004
      else if Status = -1 then
        Result := 1003
      else
        Result := 1000 + Status;
    end
  else
    Result := 0;
end;

function TEdtTran.FindVacancy(DataSet: TDataSet;
  const WHCode, PartCode: String): Boolean;
begin
  Result := False;   with DataSet do
  try
    DisableControls;
    First;
    while not Eof do
    begin
      if (Trim(FieldByName('PartCode_').AsString) = '')
        or ((Trim(FieldByName('PartCode_').AsString) = Trim(PartCode))
        and (Trim(FieldByName('WHCode_').AsString) = Trim(WHCode))) then
      begin
        Result := True;
        Break;
      end;
      Next;
    end;
  finally
    EnableControls;
  end;
end;

function TEdtTran.GetVerUpdate(cdsSource, cdsTarget: TZjhDataSet;
  const DateField: String): String;
var
  sl: TStringList;
  procedure AddBaseInfo(cdsDataSet: TZjhDataSet; const Text: String);
  begin
    with cdsDataSet do
    begin
      sl.Add(Text);
      sl.Add(Chinese.AsString(Format('�����ϡ�Ʒ��%s��%s��%s',[
        FieldByName('PartCode_').AsString, FieldByName('Desc_').AsString,
        FieldByName('Spec_').AsString])));
    end;
  end;
  procedure AddProdInfo(cdsDataSet: TZjhDataSet; const Text: String);
  begin
    with cdsDataSet do
    begin
      if FindField('OriUP_') <> nil then
        sl.Add(Chinese.AsString(Format('����%s%f %s�����ڣ�%s�����ۣ�%s %s',[Text,
          FieldByName('Num_').AsFloat, FieldByName('Unit_').AsString,
          FormatDateTime('YYYY/MM/DD',FieldByName(DateField).AsDateTime),
          FieldByName('OriUP_').AsString,FieldByName('Currency_').AsString])))
      else
        sl.Add(Chinese.AsString(Format('����%s%f %s�����ڣ�%s',[Text,
          FieldByName('Num_').AsFloat, FieldByName('Unit_').AsString,
          FormatDateTime('YYYY/MM/DD',FieldByName(DateField).AsDateTime)])))
    end;
  end;
begin
  sl := TStringList.Create;
  try
    //���ɾ��
    with cdsTarget do
    begin
      First;
      while not Eof do
      begin
        if not cdsSource.Locate('PartCode_',FieldByName('PartCode_').AsString,
          [loCaseInsensitive]) then
        begin
            AddBaseInfo(cdsTarget, Chinese.AsString('ȡ����Ŀ��'));
            AddProdInfo(cdsTarget, Chinese.AsString('��������'));
        end;
        Next;
      end;
    end;
    //������ӡ����
    with cdsSource do
    begin
      First;
      while not Eof do
      begin
        if not cdsTarget.Locate('PartCode_',FieldByName('PartCode_').AsString,
          [loCaseInsensitive]) then
          begin
            AddBaseInfo(cdsSource, Chinese.AsString('������Ŀ��'));
            AddProdInfo(cdsSource, Chinese.AsString('��������'));
          end
        else if FieldByName('Num_').AsFloat <> cdsTarget.FieldByName('Num_').AsFloat then
          begin
            AddBaseInfo(cdsSource, Chinese.AsString('���������'));
            AddProdInfo(cdsTarget, Chinese.AsString('��������'));
            AddProdInfo(cdsSource, Chinese.AsString('���Ϊ��'));
          end
        else if FieldByName(DateField).AsDateTime <> cdsTarget.FieldByName(DateField).AsDateTime then
          begin
            AddBaseInfo(cdsSource, Chinese.AsString('������ڣ�'));
            AddProdInfo(cdsTarget, Chinese.AsString('��������'));
            AddProdInfo(cdsSource, Chinese.AsString('���Ϊ��'));
         end
        else if (FindField('OriUP_') <> nil) and
          (FieldByName('OriUP_').AsCurrency <> cdsTarget.FieldByName('OriUP_').AsCurrency) then
          begin
            AddBaseInfo(cdsSource, Chinese.AsString('������ۣ�'));
            AddProdInfo(cdsTarget, Chinese.AsString('��������'));
            AddProdInfo(cdsSource, Chinese.AsString('���Ϊ��'));
          end;
        Next;
      end;
    end;
    //���ر��
    Result := sl.Text;
  finally
    FreeAndNil(sl);
  end;
end;

procedure TEdtTran.NewReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  if Action in [raAbort, raCancel] then
    FAllow := False;
  if Pos('Record not found or changed by another user', E.Message) > 0 then
    MsgBox(Chinese.AsString('�˵��ݲ����ڻ��ѱ������޸ģ������²�ѯ��'))
  else if Assigned(OldReconcileError) then
    OldReconcileError(DataSet, E, UpdateKind, Action)
  else
    raise Exception.Create(Chinese.AsString('���޸ı��浽������û�гɹ�����Ҫԭ��') + vbCrLf + E.Message);
end;

end.