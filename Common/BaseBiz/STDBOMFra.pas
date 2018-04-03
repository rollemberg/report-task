unit STDBOMFra;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB, DBClient, ZjhCtrls, StdCtrls, ExtCtrls, Variants;

type
  TFraSTDBOM = class(TFrame)
    DBGrid1: TDBGrid; 
    Panel2: TPanel;
    lblStatus: TLabel;
    CheckBox2: TCheckBox;
    cdsView: TZjhDataSet;
    cdsViewParentCode_: TWideStringField;
    cdsViewID_: TGuidField;
    cdsViewIt_: TAutoIncField;
    cdsViewPartCode_: TWideStringField;
    cdsViewAssNum_: TFloatField;
    cdsViewBaseNum_: TIntegerField;
    cdsViewLossRate_: TFloatField;
    cdsViewAppDate_: TDateTimeField;
    cdsViewStartDate_: TDateTimeField;
    cdsViewEndDate_: TDateTimeField;
    cdsViewStatus_: TIntegerField;
    cdsViewLevel_: TIntegerField;
    cdsViewTitem_: TIntegerField;
    cdsViewRemark_: TWideStringField;
    cdsViewDesc: TWideStringField;
    cdsViewSpec: TWideStringField;
    cdsViewPosition_: TWideMemoField;
    dsView: TDataSource;
    cdsViewUnit: TWideStringField;
    procedure CheckBox2Click(Sender: TObject);
    procedure cdsViewAfterScroll(DataSet: TDataSet);
    procedure cdsViewCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FActive: Boolean;
    FReadOnly: Boolean;
    FTT: String;
    FPartCode: String;
    procedure SetActive(const Value: Boolean);
    procedure SetPartCode(const Value: String);
    procedure SetReadOnly(const Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure RefreshView(const Flag: Boolean);
  public
    { Public declarations }
    property TT: String read FTT write FTT;
    property Active: Boolean read FActive write SetActive;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property PartCode: String read FPartCode write SetPartCode;
  end;

implementation

uses ApConst, ErpTools, MainData, InfoBox, uBaseIntf;

{$R *.dfm}

{ TFraPartPackage }

constructor TFraSTDBOM.Create(AOwner: TComponent);
begin
  inherited;
  cdsView.RemoteServer := DM.DCOM;
  TT := GuidNull;
  FReadOnly := cdsView.ReadOnly;
end;

procedure TFraSTDBOM.RefreshView(const Flag: Boolean);
begin
  if Flag then
    begin
      with cdsView do
      begin
        Active := False;
        if PartCode <> '' then
        begin
          CommandText := Format('Execute ExtendBom ''%s'',''%s'',%d',[TT,PartCode,
            iif(CheckBox2.Checked,10,1)]);;
          Open;
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

procedure TFraSTDBOM.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraSTDBOM.SetPartCode(const Value: String);
begin
  if FPartCode <> Value then
  begin
    FPartCode := Value;
    if FActive then RefreshView(True);
  end;
end;

procedure TFraSTDBOM.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  cdsView.ReadOnly := Value;
end;

procedure TFraSTDBOM.CheckBox2Click(Sender: TObject);
begin
  RefreshView(True);
end;

procedure TFraSTDBOM.cdsViewAfterScroll(DataSet: TDataSet);
begin
  DisplayRecTotal(DataSet,lblStatus);
end;

procedure TFraSTDBOM.cdsViewCalcFields(DataSet: TDataSet);
var
  R: Variant;
begin
  with DataSet do
  begin
    R := Buff.Read('Part',FieldByName('PartCode_').AsString,['Desc_','Spec_','Unit_']);
    if not VarIsNull(R) then
    begin
      FieldByName('Desc').Value := R[0];
      FieldByName('Spec').Value := R[1];
      FieldByName('Unit').Value := R[2];
    end;    //Modify by jrlee at 2006/6/5 增加旧料号的显示！
    FieldByName('ReMark_').Value := CM.DBRead(Format('Select DrawingNo_ From'
      + ' Part Where Code_=''%s''',[FieldByName('PartCode_').AsString]),'');
  end;
end;

initialization
  RegClass(TFraSTDBOM);

finalization
  UnRegClass(TFraSTDBOM);

end.
