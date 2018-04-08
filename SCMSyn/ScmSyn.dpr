program ScmSyn;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {FrmMain},
  SetConnFrm in 'SetConnFrm.pas' {FrmSetConn},
  AppSync in 'AppSync.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
