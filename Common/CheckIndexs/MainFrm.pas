unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

type
  TFrmMain = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    H1: TMenuItem;
    SQLServer1: TMenuItem;
    SQL1: TMenuItem;
    H2: TMenuItem;
    X1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetForm(AClass: TComponentClass): TComponent;
  end;

var
  FrmMain: TFrmMain;

implementation

uses CheckIndexsFrm, RebuildIndexsFrm;

{$R *.dfm}

function TFrmMain.GetForm(AClass: TComponentClass): TComponent;
begin
  Result := AClass.Create(Self);
  if Result is TForm then
  begin
    TForm(Result).WindowState := wsMaximized;
    TForm(Result).Show;
  end;
end;

procedure TFrmMain.N2Click(Sender: TObject);
begin
  GetForm(TFrmCheckIndexs);
end;

procedure TFrmMain.N3Click(Sender: TObject);
begin
  GetForm(TFrmRebuildIndexs);
end;

end.
