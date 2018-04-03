unit CusPartUPFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB, DBClient, ZjhCtrls;

type
  TFraCusPartUP = class(TFrame)
    dsView: TDataSource;
    cdsView: TZjhDataSet;
    cdsViewID_: TGuidField;
    cdsViewTBNo_: TWideStringField;
    cdsViewIt_: TIntegerField;
    cdsViewTBDate_: TDateTimeField;
    cdsViewReasonCode_: TWideStringField;
    cdsViewType_: TSmallintField;
    cdsViewCusCode_: TWideStringField;
    cdsViewPartCode_: TWideStringField;
    cdsViewUnit_: TWideStringField;
    cdsViewCurrency_: TWideStringField;
    cdsViewDiscount_: TFloatField;
    cdsViewLotMinNum_: TFloatField;
    cdsViewLotMaxNum_: TFloatField;
    cdsViewEnabledTimeFm_: TDateTimeField;
    cdsViewEnabledTimeTo_: TDateTimeField;
    cdsViewEnabledStatus_: TBooleanField;
    cdsViewFinal_: TBooleanField;
    cdsViewCusName_: TWideStringField;
    cdsViewDesc_: TWideStringField;
    cdsViewSpec_: TWideStringField;
    DBGrid5: TZjhDBGrid;
    cdsViewTaxUP_: TFloatField;
    procedure cdsViewCalcFields(DataSet: TDataSet);
    procedure cdsViewType_GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure cdsViewEnabledStatus_GetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
  private
    { Private declarations }
    FActive: Boolean;
    FReadOnly: Boolean;
    FPartCode, slText: String;
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

uses ApConst, ErpTools, MainData, InfoBox, uBaseIntf;

{$R *.dfm}

{ TFraPartPackage }

constructor TFraCusPartUP.Create(AOwner: TComponent);
begin
  inherited;
  FReadOnly := cdsView.ReadOnly;
  slText := nreg.ReadString('public','SYS00017','');
end;

procedure TFraCusPartUP.RefreshView(const Flag: Boolean);
begin
  if Flag then
    begin
      with cdsView do
      begin
        Active := False;
        if PartCode <> '' then
        begin
          CommandText := Format('Select S.*,C.ShortName_ as CusName_,C.Currency_,P.Desc_, '
            + 'P.Spec_ From PartSaleB S Left Join Part P on S.PartCode_=P.Code_ '
            + 'Left Join CusSup C on S.CusCode_=C.Code_ Where S.PartCode_=''%s'' '
            + 'and S.EnabledStatus_=1 and S.Final_=1 Order by S.CusCode_',[PartCode]);
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

procedure TFraCusPartUP.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraCusPartUP.SetPartCode(const Value: String);
begin
  if FPartCode <> Value then
  begin
    FPartCode := Value;
    if FActive then RefreshView(True);
  end;
end;

procedure TFraCusPartUP.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  cdsView.ReadOnly := Value;
end;

procedure TFraCusPartUP.cdsViewCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('SupName').Value := Buff.ReadValue('Corp',
      FieldByName('SupCode_').AsString,'Name_');
    FieldByName('Desc').Value := Buff.ReadValue('Part',
      FieldByName('PartCode_').AsString,'Desc_');
    FieldByName('Spec').Value := Buff.ReadValue('Part',
      FieldByName('PartCode_').AsString,'Spec_');
  end;
end;

procedure TFraCusPartUP.cdsViewType_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Text := slText;
    Text := StrField(sl,Sender);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TFraCusPartUP.cdsViewEnabledStatus_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := iif(Sender.AsBoolean,'Y','N');
end;

initialization
  RegClass(TFraCusPartUP);

finalization
  UnRegClass(TFraCusPartUP);

end.
