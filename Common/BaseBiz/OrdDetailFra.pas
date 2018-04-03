unit OrdDetailFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB, DBClient, ZjhCtrls, Variants, uBaseIntf;

type
  TFraOrdDetail = class(TFrame)
    cdsView: TZjhDataSet;
    cdsViewPID_: TGuidField;
    cdsViewID_: TGuidField;
    cdsViewTBNo_: TWideStringField;
    cdsViewOrdCode_: TWideStringField;
    cdsViewPartCode_: TWideStringField;
    cdsViewWHCode_: TWideStringField;
    cdsViewIt_: TIntegerField;
    cdsViewOutDate_: TDateTimeField;
    cdsViewNum_: TFloatField;
    cdsViewSpareNum_: TFloatField;
    cdsViewDisCount_: TFloatField;
    cdsViewUnit_: TWideStringField;
    cdsViewDesc_: TWideStringField;
    cdsViewSpec_: TWideStringField;
    cdsViewCostUP_: TFloatField;
    cdsViewPINO_: TWideStringField;
    cdsViewOriUP_: TFloatField;
    cdsViewCusModle_: TWideStringField;
    cdsViewFinish_: TSmallintField;
    cdsViewFinishDate_: TDateTimeField;
    cdsViewUpdateKey_: TGuidField;
    cdsViewOutNum_: TFloatField;
    cdsViewAmount: TFloatField;
    cdsViewBewrite: TWideStringField;
    dsView: TDataSource;
    DBGrid1: TDBGrid;
    cdsViewTBDate_: TDateTimeField;
    cdsViewCusCode_: TWideStringField;
    procedure cdsViewCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FActive: Boolean;
    FReadOnly: Boolean;
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
    property Active: Boolean read FActive write SetActive;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property PartCode: String read FPartCode write SetPartCode;
  end;

implementation

uses ApConst, ErpTools, MainData;

{$R *.dfm}

{ TFraPartPackage }

constructor TFraOrdDetail.Create(AOwner: TComponent);
begin
  inherited;
  FReadOnly := cdsView.ReadOnly;
end;

procedure TFraOrdDetail.RefreshView(const Flag: Boolean);
begin
  if Flag then
    begin
      with cdsView do
      begin
        Active := False;
        if PartCode <> '' then
        begin
          CommandText := Format('Select * from OrdB Where PartCode_=''%s'' '
            + 'and Final_=1 Order by TBNo_ DESC,It_',[PartCode]);
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

procedure TFraOrdDetail.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraOrdDetail.SetPartCode(const Value: String);
begin
  if FPartCode <> Value then
  begin
    FPartCode := Value;
    if FActive then RefreshView(True);
  end;
end;

procedure TFraOrdDetail.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  cdsView.ReadOnly := Value;
end;

procedure TFraOrdDetail.cdsViewCalcFields(DataSet: TDataSet);
var
  R: Variant;
  PayNum: Double;
begin
  inherited;
  with DataSet do
  begin
    PayNum := FieldByName('Num_').AsFloat - FieldByName('SpareNum_').AsFloat;
    FieldByName('Amount').AsCurrency := PayNum * FieldByName('OriUP_').AsCurrency;
    R := Buff.Read('Part',FieldByName('PartCode_').AsString,['Bewrite_']);
    if not VarIsNull(R) then FieldByName('Bewrite').AsString := R[0];
  end;
end;

initialization
  RegClass(TFraOrdDetail);

finalization
  UnRegclass(TFraOrdDetail);

end.
