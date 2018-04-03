program CheckIndexs;

uses
  Forms,
  RebuildIndexsFrm in 'RebuildIndexsFrm.pas' {FrmRebuildIndexs},
  MainFrm in 'MainFrm.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
