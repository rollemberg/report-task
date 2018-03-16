unit PluginsSearch_Demo;

interface

uses
  Classes, ApConst, InfoBox, uBaseIntf, Buttons, SysUtils, DBGrids, ErpTools,
  Controls, Forms, Dialogs, XmlIntf, StdCtrls, ExtCtrls;

type
  {$I '..\..\Include\plugins.h'}
  TFrmFAToDA_Demo = class(TComponent, IPlugins, IZLSearchService)
  private
    //计划要改变的组件
    Panel11: TPanel;
    btnFind: TBitBtn;
    //
    chkMN: TCheckBox;
    edtMN: TEdit;
  public
    procedure Init(Root: IXmlNode);
    function CheckEnvironment: Boolean;
    procedure Install(Sender: TObject);
    procedure SearchService(Sender: TComponent; SQLWhere: TObject);
  end;

implementation

{ TFrmFAToDA_Demo }

procedure TFrmFAToDA_Demo.Init(Root: IXmlNode);
begin

end;

function TFrmFAToDA_Demo.CheckEnvironment: Boolean;
var
  AIntf: IBaseForm;
begin
  Result := False;
  AIntf := Owner as IBaseForm;
  try
    Panel11 := AIntf.GetControl('Panel11') as TPanel;
    if not Assigned(Panel11) then
      Exit;
    btnFind := AIntf.GetControl('btnFind') as TBitBtn;
    if not Assigned(btnFind) then
      Exit;
    Result := True;
  finally
    AIntf := nil;
  end;
end;

procedure TFrmFAToDA_Demo.Install(Sender: TObject);
begin
  chkMN := TCheckBox.Create(Self);
  with chkMN do
  begin
    Parent := Self.Panel11;
    Left := 497;
    Top := 81;
    Width := 69;
    Height := 17;
    Caption := Chinese.AsString('MN 单号');
    Visible := True;
  end;
  //
  edtMN := TEdit.Create(Self);
  with edtMN do
  begin
    Parent := Self.Panel11;
    Left := 573;
    Top := 79;
    Width := 68;
    Height := 22;
    Visible := True;
  end;
end;

procedure TFrmFAToDA_Demo.SearchService(Sender: TComponent;
  SQLWhere: TObject);
var
  f: TCreateSQLWhere;
begin
  f := SQLWhere as TCreateSQLWhere;
  //识别是哪一个按钮中的TCreateSQLWhere
  if Sender = btnFind then
  begin
    if chkMN.Checked then
      f.AddParamStr('B.MrpNo_', edtMN.Text);
  end;
end;

initialization
  RegClass(TFrmFAToDA_Demo);

finalization
  UnRegClass(TFrmFAToDA_Demo);

end.
