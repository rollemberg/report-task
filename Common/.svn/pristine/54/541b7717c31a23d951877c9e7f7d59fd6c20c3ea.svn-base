unit SupPartUPFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB, DBClient, ZjhCtrls;

type
  TFraSupPartUP = class(TFrame)
    cdsView: TZjhDataSet;
    cdsViewPID_: TGuidField;
    cdsViewID_: TGuidField;
    cdsViewIndex_: TSmallintField;
    cdsViewType_: TSmallintField;
    cdsViewSupCode_: TWideStringField;
    cdsViewPartCode_: TWideStringField;
    cdsViewCurrency_: TWideStringField;
    cdsViewUP_: TFloatField;
    cdsViewLotMinNum_: TFloatField;
    cdsViewLotMaxNum_: TFloatField;
    cdsViewEnabledTimeFm_: TDateTimeField;
    cdsViewEnabledTimeTo_: TDateTimeField;
    cdsViewEnabledStatus_: TBooleanField;
    cdsViewUpdateKey_: TGuidField;
    cdsViewSupName: TWideStringField;
    cdsViewDelivaryDays_: TSmallintField;
    cdsViewStartTBNo_: TWideStringField;
    cdsViewUnit_: TWideStringField;
    cdsViewDiscount_: TFloatField;
    cdsViewMaterialCost_: TFloatField;
    cdsViewLabCost_: TFloatField;
    cdsViewManuCost_: TFloatField;
    cdsViewFinal_: TBooleanField;
    cdsViewIt_: TIntegerField;
    cdsViewDesc: TWideStringField;
    cdsViewSpec: TWideStringField;
    dsView: TDataSource;
    DBGrid4: TDBGrid;
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

constructor TFraSupPartUP.Create(AOwner: TComponent);
begin
  inherited;
  cdsView.RemoteServer := DM.DCOM;
  FReadOnly := cdsView.ReadOnly;
  slText := nreg.ReadString('public','SYS00042','');
end;

procedure TFraSupPartUP.RefreshView(const Flag: Boolean);
begin
  if Flag then
    begin
      with cdsView do
      begin
        Active := False;
        if PartCode <> '' then
        begin
          CommandText := Format('Select * From PartSupply where PartCode_=''%s'' '
            + 'and EnabledStatus_=1 and Final_=1 Order By SupCode_',[PartCode]);
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

procedure TFraSupPartUP.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraSupPartUP.SetPartCode(const Value: String);
begin
  if FPartCode <> Value then
  begin
    FPartCode := Value;
    if FActive then RefreshView(True);
  end;
end;

procedure TFraSupPartUP.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  cdsView.ReadOnly := Value;
end;

procedure TFraSupPartUP.cdsViewCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('SupName').Value := Buff.ReadValue('Corp',
      FieldByName('SupCode_').AsString,'ShortName_');
    FieldByName('Desc').Value := Buff.ReadValue('Part',
      FieldByName('PartCode_').AsString,'Desc_');
    FieldByName('Spec').Value := Buff.ReadValue('Part',
      FieldByName('PartCode_').AsString,'Spec_');
  end;
end;

procedure TFraSupPartUP.cdsViewType_GetText(Sender: TField;
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

procedure TFraSupPartUP.cdsViewEnabledStatus_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := iif(Sender.AsBoolean,'Y','N');
end;

initialization
  RegClass(TFraSupPartUP);

finalization
  UnRegClass(TFraSupPartUP);

end.
