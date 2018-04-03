unit StockCWFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Buttons, StdCtrls, ExtCtrls, DB, DBClient, ZjhCtrls, DBForms,
  uBaseIntf, Variants, Mask, DBCtrls, ApConst, ErpTools;

type
  TFraStockCW = class(TFrame, IFraStockCW)
    cdsStockHistoryCW: TZjhDataSet;
    dsStockHistoryCW: TDataSource;
    Panel2: TPanel;
    lblDirTitle1: TLabel;
    sbAppend: TSpeedButton;
    sbDelete: TSpeedButton;
    DBGrid3: TDBGrid;
    cdsStockHistoryCWID_: TGuidField;
    cdsStockHistoryCWID_2: TGuidField;
    cdsStockHistoryCWCode_: TWideStringField;
    cdsStockHistoryCWCWCode_: TWideStringField;
    cdsStockHistoryCWNum_: TFloatField;
    cdsStockHistoryCWCWName: TWideStringField;
    cdsStockHistoryCWTBNo_: TWideStringField;
    cdsStockHistoryCWPartCode_: TWideStringField;
    cdsStockHistoryCWID_3: TGuidField;
    cdsStockHistoryCWFinal_: TBooleanField;
    sbSave: TSpeedButton;
    cdsStockHistoryCWT: TAggregateField;
    DBEdit1: TDBEdit;
    cdsStockHistoryCWTBDate_: TDateTimeField;
    cdsStockHistoryCWCWStock: TFloatField;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    cdsStockHistoryCWTBNum_: TFloatField;
    cdsStockHistoryCWBID_: TGuidField;
    procedure cdsStockHistoryCWAfterOpen(DataSet: TDataSet);
    procedure cdsStockHistoryCWAfterClose(DataSet: TDataSet);
    procedure DBGrid3EditButtonClick(Sender: TObject);
    procedure cdsStockHistoryCWNewRecord(DataSet: TDataSet);
    procedure sbAppendClick(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure cdsStockHistoryCWCalcFields(DataSet: TDataSet);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    FNum: Double;
    FReadOnly: Boolean;
    FActive: Boolean;
    FPID: String;
    FPartCode: String;
    FWHCode: String;
    FTBNo: String;
    FTBDate: TDateTime;
    FBID: String;
  public
    { Public declarations }
    function GetActive: Boolean;
    function GetReadOnly: Boolean;
    function GetPID: String;
    function GetPartCode: String;
    function GetWHCode: String;
    function GetTBNo: String;
    function GetTBDate: TDateTime;
    function GetBID: String;
    //
    procedure SetActive(const Value: Boolean);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetPartCode(const Value: String);
    procedure SetPID(const Value: String);
    procedure SetWHCode(const Value: String);
    procedure SetTBNo(const Value: String);
    procedure SetTBDate(const Value: TDateTime);
    procedure SetBID(Const Value: String);
    //
    property Active: Boolean read GetActive write SetActive;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property PID: String read GetPID write SetPID;
    property PartCode: String read GetPartCode write SetPartCode;
    property WHCode: String read GetWHCode write SetWHCode;
    property BID: String read GetBID write SetBID;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function own: TFrame;
    procedure RefreshView(const Flag: Boolean);
    procedure DeleteAllRecord;
    procedure SaveRecord;
    function PostMessage(MsgType: Integer; Msg: Variant):Variant;
  end;

implementation

uses MainData, DocCtrls, uSelect;

{$R *.dfm}

constructor TFraStockCW.Create(AOwner: TComponent);
begin
  inherited Create(AOwner.Owner);
  Self.Parent := AOwner as TWinControl;
  Self.Align := alClient;
  Self.Visible := True;
  cdsStockHistoryCW.RemoteServer := DM.DCOM;
  //inherited;
  //lblDirTitle.Caption := Chinese.AsString('储位存放详细资料及数量');
end;

procedure TFraStockCW.cdsStockHistoryCWAfterOpen(DataSet: TDataSet);
begin
  sbAppend.Visible := DataSet.Active;
  sbDelete.Visible := DataSet.Active;
  sbSave.Visible := DataSet.Active;
end;

procedure TFraStockCW.cdsStockHistoryCWAfterClose(DataSet: TDataSet);
begin
  sbAppend.Visible := DataSet.Active;
  sbDelete.Visible := DataSet.Active;
  sbSave.Visible := DataSet.Active;
end;

procedure TFraStockCW.SetReadOnly(const Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    sbAppend.Enabled := not Value;
    sbDelete.Enabled := not Value;
    sbSave.Enabled := not Value;
    DbGrid3.ReadOnly := Value ;
    FReadOnly := Value;
  end;
end;

procedure TFraStockCW.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
  end;
end;

function TFraStockCW.GetActive: Boolean;
begin
  Result := FActive;
end;

function TFraStockCW.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

function TFraStockCW.own: TFrame;
begin
  Result := Self;
end;

procedure TFraStockCW.DBGrid3EditButtonClick(Sender: TObject);
begin
  //
  if not cdsStockHistoryCW.Active or cdsStockHistoryCW.ReadOnly  then Exit;
  SelCode([cdsStockHistoryCW.FieldByName('CWCode_')],Format('Select CWCode_,CWName_ From PartCW Where'
    + ' Code_=''%s''',[FWHCode]),80,Chinese.AsString('储位代码'),120,Chinese.AsString('储位名称'));
end;

function TFraStockCW.GetPartCode: String;
begin
  Result := FPartCode;
end;

function TFraStockCW.GetPID: String;
begin
  Result := FPID;
end;

function TFraStockCW.GetWHCode: String;
begin
  Result := FWHCode;
end;

procedure TFraStockCW.SetPartCode(const Value: String);
begin
  FPartCode := Value;
end;

procedure TFraStockCW.SetPID(const Value: String);
begin
  FPID := Value;
end;

procedure TFraStockCW.SetWHCode(const Value: String);
begin
  FWHCode := Value;
end;

procedure TFraStockCW.RefreshView(const Flag: Boolean);
begin
  with cdsStockHistoryCW do
  begin
    if Flag then
    begin
      Filtered := False;
      Filter := Format('PartCode_=''%s'' and PID_=''%s'' and WHCode_=''%s'' '
        + 'and BID_=''%s'' ', [FPartCode, FPID, FWHCode, FBID]);
      Filtered := True;
    end
    else
    begin
      if not Active then Exit;
      if State in [dsInsert, dsEdit] then Post;
      if (ChangeCount > 0) and (MessageDlg(Chinese.AsString('当前数据没有保存，您真的要保存并退出吗？'),mtConfirmation,
        [mbYes,mbNo,mbCancel],0) = mrYes) then PostPro(0);
      Active := False;
    end;
  end;
end;

procedure TFraStockCW.cdsStockHistoryCWNewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('ID_').AsString := NewGUID;
    FieldByName('WHCode_').AsString := FWHCode;
    FieldByName('PartCode_').AsString := FPartCode;
    FieldByName('PID_').AsString := FPID;
    FieldByName('TBDate_').Value := FTBDate;
    FieldByName('TBNo_').Value := FTBNo;
    FieldByName('TBNum_').Value := FNum;
    FieldByName('BID_').AsString := FBID;
  end;
end;

function TFraStockCW.PostMessage(MsgType: Integer; Msg: Variant): Variant;
begin
  case MsgType of
  CONST_VALUE:
    begin
      if VarIsArray(Msg) then
      begin
        FPID := Msg[0];
        FWHCode := Trim(Msg[1]);
        FPartCode := Msg[2];
        if VarIsNull(Msg[3]) then
          FTBNo := ''
        else
          FTBNo := Msg[3];
        if VarIsNull(Msg[4]) then
          FTBDate := Date
        else
          FTBDate := Msg[4];
        if VarIsNull(Msg[5]) then
          FNum := 0
        else
          FNum := Msg[5];
        FBID := Msg[6];
        with cdsStockHistoryCW do
        begin
          Active := False;
          CommandText := Format('Select * From StockHistoryCW Where PID_=''%s''', [FPID]);
          Open;
        end;
        Edit1.Text := FloatToStr(FNum);
      end;
    end;
  CONST_GOTORECORD:
    begin
      if VarIsArray(Msg) then
      begin
        FPID := Msg[0];
        FBID := Msg[1];
        with cdsStockHistoryCW do
        begin
          Active := False;
          CommandText := Format('Select * From StockHistoryCW Where PID_=''%s'' '
            + 'and BID_=''%s'' ', [FPID, FBID]);
          Open;
        end;
      end;
    end;
  end;
end;

procedure TFraStockCW.sbAppendClick(Sender: TObject);
var
  cdsTmp: TZjhDataSet;
begin
  if cdsStockHistoryCW.Active then
  begin
    cdsTmp := TZjhDataSet.Create(Self);
    try
      cdsTmp.RemoteServer := cdsStockHistoryCW.RemoteServer;
      with cdsTmp do
      begin
        //先加入主储位
        CommandText := Format('Select LocationCode_  From Part '
          + ' Where Code_=''%s'' and WHCode_=''%s''',[FPartCode, FWHCode]);
        Open;
        if (not Eof) and (Trim(FieldByName('LocationCode_').AsString) <> '') then
        begin
          cdsStockHistoryCW.Append;
          cdsStockHistoryCW.FieldByName('CWCode_').AsString := FieldByName('LocationCode_').AsString;
        end;
        //再加入现有储位
        Active := False;
        CommandText := Format('Select CWCode_ From StockNumCW '
          + 'Where PartCode_=''%s'' and WHCode_=''%s'' and StockNum_ <> 0', [FPartCode, FWHCode]);
        Open;
        while not Eof do
        begin
          if not cdsStockHistoryCW.Locate('CWCode_', FieldByName('CWCode_').AsString, [loCaseInsensitive]) then
          begin
            cdsStockHistoryCW.Append;
            cdsStockHistoryCW.FieldByName('CWCode_').AsString := FieldByName('CWCode_').AsString;
          end;
          Next;
        end;
        cdsStockHistoryCW.Append;
      end;
    finally
      cdsTmp.Free;
    end;
  end;
end;

procedure TFraStockCW.sbSaveClick(Sender: TObject);
begin
  if cdsStockHistoryCW.Active then
  with cdsStockHistoryCW do
  begin
    First;
    while not Eof do
    begin
      if FieldByName('Num_').AsFloat = 0 then Delete else Next;
    end;
    if State in [dsEdit,dsInsert] then Post;
    if FNum <> cdsStockHistoryCWT.Value then
      MsgBox(Chinese.AsString('当前储位总数量不符，无法保存!')) //Modfiy By Derek at 2007/06/12 原关闭此检查,重新与李顾问商讨后开启
    else
      PostPro(0);
  end;
end;

procedure TFraStockCW.sbDeleteClick(Sender: TObject);
begin
  with cdsStockHistoryCW do
  begin
    if Active and (RecordCount > 0) then
      Delete;
  end;
end;

function TFraStockCW.GetTBDate: TDateTime;
begin
  Result := FTBDate;
end;

function TFraStockCW.GetTBNo: String;
begin
  Result := FTBNo;
end;

procedure TFraStockCW.SetTBDate(const Value: TDateTime);
begin
  FTBDate := Value;
end;

procedure TFraStockCW.SetTBNo(const Value: String);
begin
  FTBNo := Value;
end;

procedure TFraStockCW.cdsStockHistoryCWCalcFields(DataSet: TDataSet);
var
  R: Variant;
  function GetCWStock(const PartCode, CWCode, WHCode: String): Double;
  var
    cdsTmp: TZjhDataSet;
  begin
    cdsTmp := TZjhDataSet.Create(Self);
    try
      with cdsTmp do
      begin
        RemoteServer := DM.DCOM;
        CommandText := Format('Select StockNum_ From StockNumCW Where '
          + ' PartCode_=''%s'' and CWCode_=''%s'' and WHCode_=''%s'' ',
          [PartCode, CWCode, WHCode]);
        Open;
        if not Eof then
          Result := FieldByName('StockNum_').AsFloat
        else
          Result := 0;
      end;
    finally
      cdsTmp.Free;
    end;
  end;
begin
  with DataSet do
  begin
    if FieldByName('CWCode_').IsNull then Exit;
    R := Buff.ReadValue('PartCW',FieldByName('CWCode_').AsString,'CWName_');
    if not VarIsNull(R) then
      FieldByName('CWName').AsString := R;
    if CheckBox1.Checked then
      FieldByName('CWStock').Value := GetCWStock(FieldByName('PartCode_').AsString,
        FieldByName('CWCode_').AsString, FieldByName('WHCode_').AsString);
  end;
end;

procedure TFraStockCW.CheckBox1Click(Sender: TObject);
begin
  if not cdsStockHistoryCW.Active then Exit; 
  cdsStockHistoryCW.Last;
  cdsStockHistoryCW.First;
end;

function TFraStockCW.GetBID: String;
begin
  Result := FBID;
end;

procedure TFraStockCW.SetBID(const Value: String);
begin
  FBID := Value;
end;

procedure TFraStockCW.DeleteAllRecord;
begin
  with cdsStockHistoryCW do
  begin
    Filtered := False;
    First;
    while not eof do Delete;
  end;
end;

procedure TFraStockCW.SaveRecord;
begin
  cdsStockHistoryCW.PostPro(0);
end;

initialization
  RegClass(TFraStockCW);

finalization
  UnRegClass(TFraStockCW);

end.
