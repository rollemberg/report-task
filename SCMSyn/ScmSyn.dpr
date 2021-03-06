program ScmSyn;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {FrmMain},
  SetConnFrm in 'SetConnFrm.pas' {FrmSetConn},
  AppSync in 'AppSync.pas',
  CustomSync in 'CustomSync.pas',
  SyncPur in 'SyncPur.pas',
  SyncCusSup in 'SyncCusSup.pas',
  SyncTranReq in 'SyncTranReq.pas',
  SyncSendTran in 'SyncSendTran.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
