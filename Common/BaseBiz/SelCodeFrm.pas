unit SelCodeFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Buttons, Grids, DBGrids, ZjhCtrls, DBClient,
  ExtCtrls, DBForms, uBaseIntf, uSelect, uBuffer;

type
  TSelectDialog = class(TDBForm, ISelectDialog)
    dsSource: TDataSource;
    s: TZjhSkin;
    cdsSource: TZjhDataSet;
    Panel1: TPanel;
    dg1: TDBGrid;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure dg1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    m_FieldKey: String;
    FResultColumnNo: Integer;
    function GetResultValue: Variant;
    procedure SetFieldKey(const Value: String);
    function GetMultiSelect: boolean;
    function GetHasValue: boolean;
    procedure SetMultiSelect(const Value: boolean);
    procedure SetResultColumnNo(const Value: Integer);
    procedure MemoGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure OpenBufferData(const Index: String; IsCommon: Boolean);
  public
    { Public declarations }
    function Sec: TZjhTool; override;
    property MultiSelect: boolean read GetMultiSelect write SetMultiSelect;
    property FieldKey: String read m_FieldKey write SetFieldKey;
    property HasValue: boolean read GetHasValue;
    property ResultValue: Variant read GetResultValue;
    function ResultValues: TStrings;
    //
    procedure AddTitle(const ColumnNo, ASize: Integer; const ACaption: String);
    procedure OpenCommand(strSQL: String);
    procedure OpenBuffer(const Index: String);
    property ResultColumnNo: Integer read FResultColumnNo write SetResultColumnNo;
    procedure Display(const Sender: TObject; const Param: Variant);
    function Execute(const Args: array of TObject; const Param: Variant): Variant;
    function PostMessage(MsgType: Integer; Msg: Variant): Variant; override;
  end;

implementation

uses MainData, ErpTools, ApConst, InfoBox;

{$R *.dfm}

procedure TSelectDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TSelectDialog.FormCreate(Sender: TObject);
begin
  m_FieldKey := '';
  MultiSelect := False;
  FResultColumnNo := 0;
  cdsSource.RemoteServer := DM.DCOM;
  TZoomWindow.RefreshForm(Self);
end;

procedure TSelectDialog.SetFieldKey(const Value: String);
begin
  if Value <> m_FieldKey then
    m_FieldKey := Value;
end;

function TSelectDialog.GetMultiSelect: boolean;
begin
  Result := dgMultiSelect in dg1.Options;
end;

procedure TSelectDialog.SetMultiSelect(const Value: boolean);
begin
  if GetMultiSelect() <> Value then
  begin
    if Value then
      dg1.Options := dg1.Options + [dgMultiSelect]
    else
      dg1.Options := dg1.Options - [dgMultiSelect];
  end;
end;

procedure TSelectDialog.dg1DblClick(Sender: TObject);
begin
  ModalResult := mrOk;
  BitBtn1Click(Self);
end;

function TSelectDialog.GetHasValue: Boolean;
begin
  with dg1.DataSource.DataSet do
    Result := Active and (not Eof);
end;

function TSelectDialog.GetResultValue: Variant;
begin
  Result := cdsSource.FieldByName(m_FieldKey).Value;
end;

function TSelectDialog.ResultValues: TStrings;
var
  i: Integer;
begin
  Result := TStringList.Create;
  if MultiSelect then
    begin
      with dg1.DataSource.DataSet do
      begin
        for i:=0 to dg1.SelectedRows.Count-1 do
        begin
          GotoBookMark(pointer(dg1.SelectedRows.Items[i]));
          Result.Add(cdsSource.FieldByName(FieldKey).Value);
        end;
      end;
    end
  else
    if HasValue then Result.Add(ResultValue);
end;

procedure TSelectDialog.FormShow(Sender: TObject);
var
  i: Integer;
begin
  ComboBox1.Clear;
  for i := 0 to dg1.Columns.Count - 1 do
    ComboBox1.Items.Add(dg1.Columns[i].Title.Caption);
  if ComboBox1.Items.Count > 0 then ComboBox1.ItemIndex := 0;
  cdsSource.IndexFieldNames := dg1.Columns[0].FieldName;
end;

procedure TSelectDialog.Edit1Change(Sender: TObject);
var
  strText, strField: String;
begin
  strText := Edit1.Text;
  if not cdsSource.Active then Exit;
  with dg1.DataSource.DataSet do
  begin
    strField := dg1.Columns[ComboBox1.ItemIndex].Field.FullName;
    if strText = '' then
      Filtered := False
    else
      begin
        Filter :=  Format(strField+' like ''%%%s%%''', [strText]);
        Filtered := True;
      end;
    //cdsSource.Locate(strField,strText,[loCaseInsensitive, loPartialKey]);
  end;
end;

procedure TSelectDialog.ComboBox1Change(Sender: TObject);
begin
  cdsSource.IndexFieldNames := dg1.Columns[ComboBox1.ItemIndex].Field.FullName;
end;

procedure TSelectDialog.SetResultColumnNo(const Value: Integer);
begin
  FResultColumnNo := Value;
end;

function TSelectDialog.Execute(const Args: array of TObject;
  const Param: Variant): Variant;
var
  i: Integer;
  Val: Variant;
begin
  if High(Args) > -1 then
    begin
      Result := False;
      if ShowModal() = mrOk then
      begin
        for i := Low(Args) to High(Args) do
        begin
          Val := cdsSource.Fields[ResultColumnNo].Value;
          if Args[i] is TField then
            begin
              if i = 0 then
                begin
                  TField(Args[i]).DataSet.Edit;
                  TField(Args[i]).Value := Val;
                end
              else if i = 1 then
                begin
                  TField(Args[i]).DataSet.Edit;
                  TField(Args[i]).Value := cdsSource.Fields[1].Value;
                end;
            end
          else if Args[i] is TLabel then
            TLabel(Args[i]).Caption := Val
          else if Args[i] is TCustomEdit then
            begin
              if (i = 2) or (i = 3) then
                TCustomEdit(Args[i]).Text := VarToStr(cdsSource.Fields[ResultColumnNo + 1].Value)
              else if (High(Args) = 1) and (Args[0] is TCustomEdit) and (Args[1] is TCustomEdit) then
                begin
                  if i = 0 then
                    TCustomEdit(Args[i]).Text := VarToStr(Val)
                  else if i = 1 then
                    TCustomEdit(Args[i]).Text := VarToStr(cdsSource.Fields[ResultColumnNo + 1].Value);
                end
              else if (High(Args) = 1) and (Args[0] is TComboBox) and (Args[1] is TCustomEdit) then
                begin
                  if i = 0 then
                    TComboBox(Args[i]).Text := VarToStr(Val)
                  else if i = 1 then
                    TCustomEdit(Args[i]).Text := VarToStr(cdsSource.Fields[ResultColumnNo + 1].Value);
                end
              else
                TCustomEdit(Args[i]).Text := VarToStr(Val);
            end
          else if Args[i] is TComboBox then
            begin
              if (i = 2) or (i = 3) then
                TComboBox(Args[i]).Text := cdsSource.Fields[ResultColumnNo + 1].Value
              else if (High(Args) = 1) and (Args[0] is TComboBox) and (Args[1] is TCustomEdit) then
                begin
                  if i = 0 then
                    TComboBox(Args[i]).Text := VarToStr(Val)
                  else if i = 1 then
                    TCustomEdit(Args[i]).Text := cdsSource.Fields[ResultColumnNo + 1].Value;
                end
              else
                TComboBox(Args[i]).Text := VarToStr(Val);
            end
          else if Args[i] is TCheckBox then
            TCheckBox(Args[i]).Checked := True
          else if Assigned(Args[i]) then
            MsgBox(Chinese.AsString('不能支持的类别：%s'),[Args[i].ClassName]);
        end;
        Result := True;
      end;
    end
  else
    begin
      if ShowModal = mrOk then
        Result := cdsSource.Fields[0].Value
      else
        Result := '';
    end;
end;

procedure TSelectDialog.AddTitle(const ColumnNo, ASize: Integer; const ACaption: String);
begin
  with dg1.Columns[ColumnNo] do
  begin
    Width := ASize;
    Title.Caption := ACaption;
    Title.Alignment := taCenter;
    Visible := True;
  end;
end;

procedure TSelectDialog.OpenBuffer(const Index: String);
begin
  OpenBufferData(Index, False);
end;

procedure TSelectDialog.OpenBufferData(const Index: String; IsCommon: Boolean);
var
  i: Integer;
begin
  if IsCommon then
    begin
      cdsSource.Data := GroupBuff[Index].Data;
      GroupBuff.GetBuffer(Index).SetGridTitle(dg1);
    end
  else
    begin
      cdsSource.Data := Buff[Index].Data;
      Buff.GetBuffer(Index).SetGridTitle(dg1);
    end;
  //
  //显示备注字段内容
  for i := 0 to cdsSource.FieldCount - 1 do begin
    if Assigned(cdsSource.Fields[i]) and (cdsSource.Fields[i].DataType = ftMemo) then
    begin
      cdsSource.Fields[i].OnGetText := MemoGetText;
    end;
  end;
end;

procedure TSelectDialog.OpenCommand(strSQL: String);
var
  i: Integer;
begin
  with cdsSource do
  begin
    Active := False;
    CommandText := strSQL;
    Open();
    if m_FieldKey = '' then m_FieldKey := Fields[0].FullName;
  end;
  for i := 0 to dg1.Columns.Count - 1 do
    dg1.Columns[i].Visible := False;
end;

function TSelectDialog.PostMessage(MsgType: Integer;
  Msg: Variant): Variant;
var
  AObjs: array of TObject;
  i, iHigh: integer;
  sDB, sSQL: string;
  function IsCommonDB(SQL: string): Boolean;
  var
    sTemp: string;
  begin
    // '判断是否企业版
    //if not '企业版' then Exit;
    sTemp := UpperCase(SQL);
    Result := Pos(' ACCESSGROUP', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' ACCESSGROUPT', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' ACCOUNT', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' ACCOUNTGROUP', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' CURRENTSERVER', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' CURRENTUSER', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' SYSFORM', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' SYSFORMDEF', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' SYSFORMGROUP', sTemp) > 0;
    if Result then Exit;
    Result := Pos(' SYSFUNCTION', sTemp) > 0;
    if Result then Exit;
  end;
begin
  case MsgType of
    CONST_SELECTDIALOG_SELACCOUNT: begin
      //Todo:需要仔细Debug
    end;
    CONST_SELECTDIALOG_OPENCOMMAND:
      begin
        if VarIsArray(Msg) then
          begin
            cdsSource.Active := False;
            sDB := Msg[1];
            sSQL := Msg[0];

            cdsSource.Database := sDB;
            if Trim(sDB) = '' then
            begin
              if IsCommonDB(sSQL) then
              begin
                cdsSource.Database := 'Common';
              end;
            end;
            OpenCommand(sSQL);
          end
        else
        begin
          {$Message '需要判断企业版'}
          sSQL := Msg;
          if IsCommonDB(sSQL) {and 企业版} then
          begin
            cdsSource.Database := 'Common';
          end;
          OpenCommand(sSQL);
        end;
      end;
    CONST_SELECTDIALOG_ADDTITLE: begin
      AddTitle(Msg[0], Msg[1], Msg[2]);
    end;
  CONST_SELECTDIALOG_OPENBUFFER:
    begin
      if VarIsArray(Msg) then
        OpenBufferData(Msg[0], Msg[1])
      else
        OpenBufferData(Msg, False);
    end;
    CONST_SELECTDIALOG_EXECUTE: begin
      iHigh := VarArrayHighBound(Msg, 1);
      SetLength(AObjs, iHigh + 1);
      for i := 0 to iHigh do begin
        AObjs[i] := TObject(Ptr(Integer(Msg[i])));
      end;
      Result := Execute(AObjs, EMPTY_VARIANT);
    end;
    CONST_SELECTDIALOG_SETRESULTCOLUMNNO: begin
      ResultColumnNo := Msg;
    end;
    CONST_SELECTDIALOG_MULTISELECT: begin
      MultiSelect := Msg;
    end;
  end;
end;

procedure TSelectDialog.Display(const Sender: TObject;
  const Param: Variant);
begin
  ;
end;

function TSelectDialog.Sec: TZjhTool;
begin
  Result := nil;
end;

procedure TSelectDialog.BitBtn1Click(Sender: TObject);
var
  i, iCount: integer;
  vTemp: Variant;
begin
  inherited;
  if cdsSource.Active then
  begin
    iCount := cdsSource.FieldCount;
    vTemp := VarArrayCreate([0, iCount], varVariant);
    for i := 0 to cdsSource.FieldCount - 1 do begin
      vTemp[i] := cdsSource.Fields[i].Value;
    end;
    OutputParam := vTemp;
  end;
end;

procedure TSelectDialog.MemoGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

initialization
  RegClass(TSelectDialog);

finalization
  UnRegClass(TSelectDialog);

end.
