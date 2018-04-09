unit MakeProcessFra;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB, DBClient, ZjhCtrls, uBaseIntf;

type
  TFraMakeProcess = class(TFrame, IBaseFrame)
    cdsView: TZjhDataSet;
    dsView: TDataSource;
    DBGrid1: TDBGrid;
    cdsViewWordName: TWideStringField;
    cdsViewParentCode_: TWideStringField;
    cdsViewWaitTime_: TFloatField;
    cdsViewWorkTime_: TFloatField;
    cdsViewBalanceTime_: TFloatField;
    cdsViewUsePerson_: TFloatField;
    cdsViewRemark_: TWideStringField;
    cdsViewCode_: TWideStringField;
    cdsViewIt_: TIntegerField;
    procedure cdsViewCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FActive: Boolean;
    FPartCode: String;
  public
    { Public declarations }
    procedure RefreshView(const Flag: Boolean);
    function GetMasterKey: Variant;
    function GetReadOnly: Boolean;
    function GetActive: Boolean;
    procedure SetMasterKey(const Value: Variant);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetActive(const Value: Boolean);
    procedure UpdateParent(const AOwner: TObject; const Param: Variant);
    function PostMessage(MsgType: Integer; Msg: Variant): Variant; virtual;
    function GetControl(ControlName: string): TObject;  virtual;   //取窗口上的控件
  end;

implementation

uses ApConst, ErpTools, MainData;

{$R *.dfm}

{ TFraPartPackage }

function TFraMakeProcess.GetActive: Boolean;
begin
  Result := FActive;
end;

function TFraMakeProcess.GetMasterKey: Variant;
begin
  Result := FPartCode;
end;

function TFraMakeProcess.GetReadOnly: Boolean;
begin
  Result := cdsView.ReadOnly;
end;

procedure TFraMakeProcess.RefreshView(const Flag: Boolean);
begin
  if Flag then
    begin
      with cdsView do
      begin
        Active := False;
        if FPartCode <> '' then
        begin
          CommandText := Format('Select * From WL_MakeProcess '
            + 'Where ParentCode_=''%s'' Order by Code_',[FPartCode]);
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

procedure TFraMakeProcess.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraMakeProcess.SetMasterKey(const Value: Variant);
begin
  if FPartCode <> Value then
  begin
    FPartCode := Value;
    if FActive then RefreshView(True);
  end;
end;

procedure TFraMakeProcess.UpdateParent(const AOwner: TObject;
  const Param: Variant);
begin
  Self.Parent := AOwner as TWinControl;
end;

procedure TFraMakeProcess.SetReadOnly(const Value: Boolean);
begin
  cdsView.ReadOnly := Value;
end;

function TFraMakeProcess.GetControl(ControlName: string): TObject;
var
  i: integer;
begin
  Result := nil;
  if Trim(ControlName) <> '' then
    for i := 0 to ComponentCount - 1 do begin
      if AnsiCompareText(Components[i].Name, ControlName) = 0 then begin
        Result := Components[i];
        break;
      end;
    end
  else
    Result := Self;
end;

function TFraMakeProcess.PostMessage(MsgType: Integer;
  Msg: Variant): Variant;
begin
  Result := EMPTY_VARIANT;
end;

procedure TFraMakeProcess.cdsViewCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('WorkName').Value := Buff.ReadValue('WL_WorkCode',DataSet.FieldByName('Code_').AsString);
end;

initialization
  RegClass(TFraMakeProcess);

finalization
  UnRegclass(TFraMakeProcess);

end.
