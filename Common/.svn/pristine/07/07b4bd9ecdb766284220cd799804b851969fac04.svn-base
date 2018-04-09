unit FlowFra;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DB, DBClient, ZjhCtrls,
  DBCtrls, ComCtrls, Tabs, Jpeg, Variants, uBaseIntf, ErpTools;

type
  TFraFlow = class(TFrame, IFraFlow)
    Panel1: TPanel;
    cdsFileIncept: TZjhDataSet;
    dsFileIncept: TDataSource;
    cdsFileInceptPID_: TGuidField;
    cdsFileInceptAccount_: TWideStringField;
    cdsFileInceptReadTime_: TDateTimeField;
    cdsFileInceptDelTime_: TDateTimeField;
    cdsFileInceptOrder_: TSmallintField;
    cdsFileInceptStatus_: TSmallintField;
    cdsFileInceptRemark_: TWideMemoField;
    cdsFileInceptUpdateKey_: TGuidField;
    s: TZjhSkin;
    cdsFileInceptType_: TIntegerField;
    cdsFileInceptStartTime_: TDateTimeField;
    cdsFileInceptStopTime_: TSmallintField;
    cdsFileInceptTimeOut_: TSmallintField;
    cdsFileInceptMemo_: TWideMemoField;
    cdsFileInceptTag_: TIntegerField;
    cdsFileInceptSign_: TBlobField;
    Panel6: TPanel;
    Splitter2: TSplitter;
    Panel10: TPanel;
    Notebook1: TNotebook;
    DBMemo3: TDBMemo;
    Image1: TImage;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    DBMemo2: TDBMemo;
    TabSet1: TTabSet;
    Panel3: TPanel;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    sbAppend: TSpeedButton;
    sbDelete: TSpeedButton;
    sbSave: TSpeedButton;
    procedure cdsFileInceptAccount_GetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure cdsFileInceptStatus_GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure cdsFileInceptType_GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure sbAppendClick(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure cdsFileInceptAfterScroll(DataSet: TDataSet);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
  private
    { Private declarations }
    FSec: TZjhTool;
    m_Key: String;
    FReadOnly: Boolean;
    procedure RefreshImage;
    procedure SetReadOnly(const Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetMasterKey(const Value: String);
    function GetMasterKey: String;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Init(ASec: TObject);
  public
    property MasterKey: String read GetMasterKey write SetMasterKey;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    function GotoRecord(const AKey: Variant): Boolean; overload;
    function GotoRecord(ADataSet: TObject; const AField: Variant): Boolean; overload;
    procedure DeleteRecord(const AKey: String);
    procedure SaveRecord;
    function own: TFrame;
  end;

implementation

uses MainData, ApConst, InfoBox;

{$R *.dfm}

procedure TFraFlow.cdsFileInceptAccount_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := VarToStr(GroupBuff.ReadValue('Account',Sender.AsString));
end;

procedure TFraFlow.cdsFileInceptStatus_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if cdsFileIncept.RecordCount < 1 then Exit;
  case Sender.AsInteger of
   1: Text := Chinese.AsString('已核准');
   2: Text := Chinese.AsString('未核准');
   3: Text := Chinese.AsString('签核过期');
  else
    Text := Chinese.AsString('等待签核');
  end;
end;

procedure TFraFlow.DeleteRecord(const AKey: String);
var
  dt: TDataTool;
begin
  if MasterKey <> AKey then MasterKey := AKey;
  dt := TDataTool.Create;
  try
    dt.DataSource := dsFileIncept;
    dt.Delete;
  finally
    dt.Free;
  end;
end;

function TFraFlow.GotoRecord(const AKey: Variant): Boolean;
begin
  SetMasterKey(AKey);
  Result := True;
end;

function TFraFlow.GotoRecord(ADataSet: TObject; const AField: Variant): Boolean;
var
  MDataSet: TZjhDataSet; 
begin
  MDataSet := TZjhDataSet(ADataSet);
  if MDataSet.Active then
    SetMasterKey(MDataSet.FieldByName(AField).AsString)
  else
    cdsFileIncept.Active := False;
  SetReadOnly(MDataSet.ReadOnly);
  Result := True;
end;

procedure TFraFlow.SaveRecord;
var
  i, j: Integer;
  StartTime: TDateTime;
begin
  if not cdsFileIncept.Active then Exit;
  j := -99999;
  StartTime := Now();
  with cdsFileIncept do
  begin
    IndexFieldNames := 'Order_;Account_';
    for i := 1 to RecordCount do
    begin
      RecNo := i;
      if j = -99999 then j := FieldByName('Order_').AsInteger;
      if FieldByName('Order_').AsInteger = j then
      begin
        Edit;
        FieldByName('StartTime_').AsDateTime := StartTime;
        FieldByName('TimeOut_').AsInteger := CM.GetTimeout(StartTime,FieldByName('StopTime_').AsInteger);
        Post;
      end;
    end;
  end;
  cdsFileIncept.PostPro(0);
end;

procedure TFraFlow.SetMasterKey(const Value: String);
begin
  if m_Key = Value then
    Exit;
  m_Key := Value;
  if m_Key = '' then
  begin
    if cdsFileIncept.Active then cdsFileIncept.Close;
    Exit;
  end;
  with cdsFileIncept do
  begin
    Close;
    CommandText := 'Select * from FileIncept Where PID_=''' + m_Key + '''';
    Open;
  end;
end;

procedure TFraFlow.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  Panel2.Visible := not Value;
end;

procedure TFraFlow.cdsFileInceptType_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if cdsFileIncept.RecordCount < 1 then Exit;
  case Sender.AsInteger of
  0: Text := Chinese.AsString('通知');
  1: Text := Chinese.AsString('签核');
  2: Text := Chinese.AsString('主控');
  else
    Text := Chinese.AsString('其它');
  end;
end;

procedure TFraFlow.sbAppendClick(Sender: TObject);
var
  strUser: String;
//  dlg: TSelectDialog;
  dlg: IBaseForm;
begin
  if MasterKey = '' then
    Raise Exception.Create(Chinese.AsString('数据源没有打开，无法执行！'));
  if not (Assigned(FSec) and FSec.Pass('FreeFlow',False)) then
    Raise Exception.CreateFmt(Chinese.AsString('执行[%s]权限不足，不允许继续！'),['FreeFlow']);
{
  dlg := TSelectDialog.Create(Self);
  try
    dlg.OpenCommand('Select Code_, Name_ from Account Order by Code_');
    dlg.AddTitle(0,  85, Chinese.AsString('用户帐号'));
    dlg.AddTitle(1, 120, Chinese.AsString('用户名称'));
    if dlg.ShowModal() <> mrOk then Exit;
    strUser := dlg.cdsSource.FieldByName('Code_').AsString;
  finally
    dlg.Free;
  end;
}
  dlg := CreateClass('TSelectDialog') as IBaseForm;
  if Assigned(dlg) then begin
    try
      dlg.PostMessage(CONST_SELECTDIALOG_OPENCOMMAND, 'Select Code_, Name_ from Account Order by Code_');
      dlg.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0,  85, Chinese.AsString('用户帐号')]));
      dlg.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([1, 120, Chinese.AsString('用户名称')]));
      if dlg.ShowForm(CONST_FORM_SHOWMODAL, TEMP_VARIANT) <> mrOk then Exit;
      strUser := TClientDataSet(dlg.GetControl('cdsSource')).FieldByName('Code_').AsString;
    finally
      dlg := nil;
    end;
  end;
  // 增加用户
  with cdsFileIncept do
  begin
    if not Active then Open;
    if ReadOnly then ReadOnly := False;
    Tag := 1;
    try
      Append;
      FieldByName('PID_').AsString := Self.MasterKey;
      FieldByName('Type_').AsInteger := 1; //签准型
      FieldByName('Order_').AsInteger := RecordCount + 1;
      FieldByName('Account_').AsString := strUser;
      FieldByName('StopTime_').AsInteger := 24;
      Post;
    finally
      Tag := 0;
    end;
  end;
end;

procedure TFraFlow.sbSaveClick(Sender: TObject);
begin
  if not (Assigned(FSec) and FSec.Pass('FreeFlow',False)) then
    Raise Exception.CreateFmt(Chinese.AsString('执行[%s]权限不足，不允许继续！'),['FreeFlow']);
  SaveRecord;
end;

procedure TFraFlow.sbDeleteClick(Sender: TObject);
begin
  if not (Assigned(FSec) and FSec.Pass('FreeFlow',False)) then
    Raise Exception.CreateFmt(Chinese.AsString('执行[%s]权限不足，不允许继续！'),['FreeFlow']);
  DeleteRecord(MasterKey);
end;

procedure TFraFlow.cdsFileInceptAfterScroll(DataSet: TDataSet);
begin
  if Self.TabSet1.TabIndex = 1 then RefreshImage;
end;

procedure TFraFlow.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  Self.Notebook1.PageIndex := NewTab;
  if NewTab = 1 then RefreshImage;
end;

procedure TFraFlow.RefreshImage;
var
  jpg: TJpegImage;
begin
  Image1.Top := 0;
  Image1.Left := 0;
  ScrollBar1.Position := 0;
  ScrollBar2.Position := 0;
  ScrollBar1.Visible := False;
  ScrollBar2.Visible := False;
  jpg := TJpegImage.Create;
  try
    if not cdsFileInceptSign_.IsNull then
      begin
        jpg.Assign(cdsFileInceptSign_);
        Image1.Picture.Assign(jpg);
        Image1.Visible := True;
        ScrollBar1.Visible := Image1.Width > Notebook1.Width;
        ScrollBar2.Visible := Image1.Height > Notebook1.Height;
        if ScrollBar1.Visible then
          ScrollBar1.Max := Image1.Width - Notebook1.Width
            + iif(ScrollBar2.Visible,ScrollBar2.Width,0);
        if ScrollBar2.Visible then
          ScrollBar2.Max := Image1.Height - Notebook1.Height
            + iif(ScrollBar1.Visible,ScrollBar2.Height,0);
      end
    else
      Image1.Visible := False;
  finally
    jpg.Free;
  end;
end;

procedure TFraFlow.ScrollBar1Change(Sender: TObject);
begin
  Image1.Left := - ScrollBar1.Position;
end;

procedure TFraFlow.ScrollBar2Change(Sender: TObject);
begin
  Image1.Top := - ScrollBar2.Position;
end;

procedure TFraFlow.Image1DblClick(Sender: TObject);
begin
  if Panel10.Parent = Self.Panel6 then
    FullScreenShow(Panel10,TabSet1.Tabs[1],True);
end;

function TFraFlow.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

function TFraFlow.GetMasterKey: String;
begin
  Result := m_Key;
end;

constructor TFraFlow.Create(AOwner: TComponent);
begin
  inherited;
  Self.Parent := AOwner as TWinControl;
  cdsFileIncept.RemoteServer := DM.DCOM;
  Self.Align := alClient;
  Self.Visible := True;
end;

procedure TFraFlow.Init(ASec: TObject);
begin
  FSec := ASec as TZjhTool;
end;

function TFraFlow.own: TFrame;
begin
  Result := Self;
end;

initialization
  RegClass(TFraFlow);

finalization
  UnRegClass(TFraFlow);

end.

