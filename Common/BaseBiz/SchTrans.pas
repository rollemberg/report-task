unit SchTrans;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZjhCtrls, DBForms, uBaseIntf;

type
  TSchTran = class(TDBForm)
  private
    { Private declarations }
    m_TT: String;
  protected
  public
    { Public declarations }
    Coat: TFormCoat;
    property TT: String read m_TT write m_TT;
    //function Sec: TZjhTool; virtual; abstract;
    procedure ShowEditForm(const PID: String); virtual;
    function RecordMove(rmAction: TRecordMoveOption;
      var NID: String): Boolean; virtual;
    //function SetCaption(const Value: String): Boolean; virtual; abstract;
    //constructor Create(AOwner: TComponent; const ATT: String); reintroduce;
  end;

implementation

uses ErpTools, ApConst, InfoBox;

{$R *.dfm}

{ TDBForm }

{
constructor TSchTran.Create(AOwner: TComponent; const ATT: String);
begin
  if AOwner is TFormCoat then Coat := AOwner as TFormCoat;
  inherited Create(AOwner);
  if SetCaption(ATT) then m_TT := ATT else MsgBox(Chinese.AsString('传入单别为空或者非法！'));
end;
}

function TSchTran.RecordMove(rmAction: TRecordMoveOption;
  var NID: String): Boolean;
begin
  Result := False;
  if Sec.RecordMove(rmAction) then
  begin
    NID := Sec.DataSource.DataSet.FieldByName('ID_').AsString;
    Result := NID <> '';
  end;
end;

procedure TSchTran.ShowEditForm(const PID: String);
var
  Child: IBaseForm;
begin
  if Assigned(Coat) then
    Child := Coat.GetForm(0) as IBaseForm
  else
    Child := MainIntf.GetForm('TFrmTran' + TT,False) as IBaseForm;
  if Assigned(Child) then begin
    Child.PostMessage(CONST_GOTORECORD, PID);
    if Assigned(Coat) then
      Coat.ShowTab(0)
    else
      Child.ShowForm(CONST_FORM_SHOW, TEMP_VARIANT);
  end;
end;

end.
