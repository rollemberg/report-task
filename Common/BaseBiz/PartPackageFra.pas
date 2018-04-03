unit PartPackageFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB, DBClient, ZjhCtrls, uBaseIntf;

type
  TFraPartPackage = class(TFrame)
    cdsView: TZjhDataSet;
    cdsViewPartCode_: TWideStringField;
    cdsViewCode_: TWideStringField;
    cdsViewName_: TWideStringField;
    cdsViewRemark_: TWideStringField;
    cdsViewInner_: TIntegerField;
    cdsViewBox_: TIntegerField;
    cdsViewGrossW_: TFloatField;
    cdsViewNetW_: TFloatField;
    cdsViewCapasorty_: TFloatField;
    cdsViewInnerCode_: TWideStringField;
    cdsViewBoxCode_: TWideStringField;
    cdsViewUP_: TFloatField;
    cdsViewUpdateKey_: TGuidField;
    dsView: TDataSource;
    DBGrid1: TDBGrid;
    cdsViewEnabled_: TBooleanField;
    procedure cdsViewPurFinal_GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure cdsViewPurFinal_SetText(Sender: TField; const Text: String);
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

uses ApConst, ErpTools;

{$R *.dfm}

{ TFraPartPackage }

constructor TFraPartPackage.Create(AOwner: TComponent);
begin
  inherited;
  FReadOnly := cdsView.ReadOnly;
end;

procedure TFraPartPackage.RefreshView(const Flag: Boolean);
begin
  if Flag then
    begin
      with cdsView do
      begin
        Active := False;
        if PartCode <> '' then
        begin
          CommandText := Format('Select * from WL_Package '
            + 'Where PartCode_=''%s''',[PartCode]);
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

procedure TFraPartPackage.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraPartPackage.SetPartCode(const Value: String);
begin
  if FPartCode <> Value then
  begin
    FPartCode := Value;
    if FActive then RefreshView(True);
  end;
end;

procedure TFraPartPackage.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  cdsView.ReadOnly := Value;
end;

procedure TFraPartPackage.cdsViewPurFinal_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := iif(Sender.AsBoolean, 'ok','');
end;

procedure TFraPartPackage.cdsViewPurFinal_SetText(Sender: TField;
  const Text: String);
begin
  Sender.AsBoolean := UpperCase(Text) = 'OK';
end;

initialization
  RegClass(TFraPartPackage);

finalization
  UnRegClass(TFraPartPackage);

end.
