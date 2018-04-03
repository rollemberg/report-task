unit MakeParamFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB, DBClient, ZjhCtrls, StdCtrls, Mask, DBCtrls, ExtCtrls,
  Buttons,  uBaseIntf;

type
  TFraMakeParam = class(TFrame)
    cdsView: TZjhDataSet;
    dsView: TDataSource;
    cdsViewTBNo_: TWideStringField;
    cdsViewPartCode_: TWideStringField;
    cdsViewType_: TWideStringField;
    cdsViewAppUser_: TWideStringField;
    cdsViewAppDate_: TDateTimeField;
    cdsViewUpdateKey_: TGuidField;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    sbAppend: TSpeedButton;
    cboType: TComboBox;
    cdsViewCode_: TWideStringField;
    cdsViewName_: TWideStringField;
    sbSave: TSpeedButton;
    cdsViewTBID_: TGuidField;
    sbDelete: TSpeedButton;
    procedure cdsViewBeforeInsert(DataSet: TDataSet);
    procedure cdsViewType_GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure cdsViewType_SetText(Sender: TField; const Text: String);
    procedure DBGrid1EditButtonClick(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure sbAppendClick(Sender: TObject);
  private
    { Private declarations }
    FActive: Boolean;
    FReadOnly: Boolean;
    FPartCode: String;
    FTBNo: String;
    FTBID: String;
    procedure SetActive(const Value: Boolean);
    procedure SetReadOnly(const Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure RefreshView(const Flag: Boolean);
    //function PostMessage(MsgType: Integer; Msg: Variant): Variant; override; //add by jrlee 2006/5/17
  public
    { Public declarations }
    property Active: Boolean read FActive write SetActive;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property TBID: String read FTBID;
    property TBNo: String read FTBNo;
    property PartCode: String read FPartCode;
  public
    procedure SetParam(const ATBID, ATBNo, APartCode: String);
    procedure Save;
  end;

implementation

uses ApConst, ErpTools, MainData, SelCodeFrm;

{$R *.dfm}

{ TFraPartPackage }

procedure TFraMakeParam.RefreshView(const Flag: Boolean);
begin
  if Flag then
    begin
      with cdsView do
      begin
        Active := False;
        if TBID <> '' then
        begin
          CommandText := Format('Select * From WL_MakeParam '
            + 'Where TBID_=''%s'' Order by Type_',[TBID]);
          Open;
          if PartCode <> '' then
          begin
            while not Eof do
            begin
              if not ((FieldByName('TBNo_').AsString = TBNo)
                and (FieldByName('PartCode_').AsString = PartCode)) then
              begin
                Edit;
                FieldByName('TBNo_').AsString := TBNo;
                FieldByName('PartCode_').AsString := PartCode;
                Post;
              end;
              Next;
            end;
            First;
          end;
        end;
      end;
    end
  else
    begin
      with cdsView do
      begin
        if not Active then Exit;
        if State in [dsInsert, dsEdit] then Post;
        if (ChangeCount > 0) and (MessageDlg(Chinese.AsString('当前数据没有保存，您真的要保存并退出吗？'),mtConfirmation,
          [mbYes,mbNo,mbCancel],0) = mrYes) then PostPro(0);
      end;
    end;
end;

procedure TFraMakeParam.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraMakeParam.SetParam(const ATBID, ATBNo, APartCode: String);
begin
  if FTBID <> ATBID then
  begin
    FTBID := ATBID;
    FTBNo := ATBNo;
    FPartCode := APartCode;
    if FActive then RefreshView(True);
  end;
end;

procedure TFraMakeParam.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  cdsView.ReadOnly := Value;
  sbAppend.Visible := not Value;
  sbSave.Visible := not Value;
  sbDelete.Visible := not Value;
end;

procedure TFraMakeParam.cdsViewBeforeInsert(DataSet: TDataSet);
begin
  if DataSet.Tag = 0 then Abort;
end;

procedure TFraMakeParam.cdsViewType_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
var
  i: Integer;
begin
  for i := 0 to cboType.Items.Count - 1 do
  begin
    if Copy(cboType.Items.Strings[i],1,1) = Sender.AsString then
      Text := cboType.Items.Strings[i];
  end;
end;

procedure TFraMakeParam.cdsViewType_SetText(Sender: TField;
  const Text: String);
begin
  Sender.AsString := Copy(Text,1,1);
end;

procedure TFraMakeParam.DBGrid1EditButtonClick(Sender: TObject);
var
  str: String;
  SQLCmd: String;
  Child: TSelectDialog;
begin
  str := cdsView.FieldByName('Type_').AsString;
  if str = '' then
  begin
    MsgBox(Chinese.AsString('请先输入类别！'));
    Exit;
  end;
  SQLCmd := Format('Select B.Order_,P.Desc_ From PartBom B inner join Part P '
    + 'on B.PartCode_=P.Code_ Where (B.PID_=''%s'') and (ParentCode_=''%s'') '
    + 'and (Order_ like ''%s%%'')', [GuidNull,PartCode,str]);
  Child := TSelectDialog.Create(Self);
  with Child do
  try
    OpenCommand(SQLCmd);
    AddTitle(0, 75, Chinese.AsString('制造参数'));
    AddTitle(1, 125, Chinese.AsString('制造说明'));
    if ShowModal() = mrOk then
    begin
      cdsView.Edit;
      CopyFields(cdsView, ['Code_','Name_'], cdsSource, ['Order_', 'Desc_']);
      cdsView.Post;
    end;
  finally
    Free;
  end;
end;

procedure TFraMakeParam.Save;
begin
  with cdsView do
  begin
    if Active and (not ReadOnly) then PostPro(0);
  end;
end;

procedure TFraMakeParam.sbSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TFraMakeParam.sbDeleteClick(Sender: TObject);
begin
  with cdsView do
  begin
    if Active and (RecordCount > 0) then
      Delete;
  end;
end;

procedure TFraMakeParam.sbAppendClick(Sender: TObject);
var
  Child: TForm;
  AIntf: IBaseForm;
  cdsCache: TZjhDataSet;
begin
  if not cdsView.Active then Exit;
  if PartCode = '' then
  begin
    MsgBox(Chinese.AsString('料号为空，无法增加制造参数！'));
    Exit;
  end;
  //
  Child := CreateClass('TDlgMakeParam',Self) as TForm;
  try
    AIntf := Child as IBaseForm;
    if not AIntf.PostMessage(CONST_DEFAULT,
      PartCode) then
    begin
      MsgBox(Chinese.AsString('产品(%s)没有设置好制造参数，无法选择！'),[PartCode]);
      Exit;
    end;
    cdsCache := AIntf.GetControl('cdsCache') as TZjhDataSet;
    with cdsView do
    begin
      First;
      while not Eof do
      begin
        cdsCache.Append;
        ZjhCtrls.CopyFields(cdsCache,cdsView,['Type_','Code_','Name_']);
        Next;
      end;
    end;
    cdsCache.First;
    if Child.ShowModal = mrOk then
    begin
      with cdsCache do
      begin
        First;
        while not Eof do
        begin
          if not cdsView.Locate('Type_',FieldByName('Type_').AsString,[]) then
            begin
              try
                cdsView.Tag := 1;
                cdsView.Append;
                cdsView.FieldByName('TBID_').AsString := TBID;
                cdsView.FieldByName('TBNo_').AsString := TBNo;
                cdsView.FieldByName('PartCode_').AsString := PartCode;
                cdsView.FieldByName('AppUser_').AsString := DM.Account;
                cdsView.FieldByName('AppDate_').AsDateTime := Now();
                ZjhCtrls.CopyFields(cdsView,cdsCache,['Type_','Code_','Name_']);
                cdsView.Post;
              finally
                cdsView.Tag := 0;
              end;
            end
          else
            begin
              cdsView.Edit;
              ZjhCtrls.CopyFields(cdsView,cdsCache,['Type_','Code_','Name_']);
              cdsView.Post;
            end;
          begin
          end;
          Next;
        end;
      end;
    end;
  finally
    AIntf := nil;
    FreeAndNil(Child);
  end;
end;

{function TFraMakeParam.PostMessage(MsgType: Integer;
  Msg: Variant): Variant;
var
  i: Integer;
begin
  case MsgType of
    CONST_CREATEPARAM:
    begin
      FTBID := '';
      FReadOnly := cdsView.ReadOnly;
      sbAppend.Visible := not FReadOnly;
      sbSave.Visible := not ReadOnly;
      sbDelete.Visible := not ReadOnly;
      cboType.Items.Text := nreg.ReadData(NREG_01_0003);
      for i := 0 to DBGrid1.Columns.Count - 1 do
      begin
        if DBGrid1.Columns[i].Field = cdsView.FieldByName('Type_') then
        begin
          DBGrid1.Columns[i].PickList.Assign(cboType.Items);
          Break;
        end;
      end;
    end;
  end;
end;}

constructor TFraMakeParam.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited;
  FTBID := '';
  FReadOnly := cdsView.ReadOnly;
  sbAppend.Visible := not FReadOnly;
  sbSave.Visible := not ReadOnly;
  sbDelete.Visible := not ReadOnly;
  cboType.Items.Text := nreg.ReadData(NREG_01_0003);
  for i := 0 to DBGrid1.Columns.Count - 1 do
  begin
    if DBGrid1.Columns[i].Field = cdsView.FieldByName('Type_') then
    begin
      DBGrid1.Columns[i].PickList.Assign(cboType.Items);
      Break;
    end;
  end;
end;

initialization
  RegClass(TFraMakeParam);

finalization
  UnRegClass(TFraMakeParam);

end.
