﻿unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AppUtils2, Grids, DBGrids, DB, DBClient, ZjhCtrls,
  Buttons, ComCtrls, ADODB, AppDB2, AppSync,IniFiles, Menus,ShellAPI,Tlhelp32,
  jpeg;

type
  TFrmMain = class(TForm)
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    popShowForm: TMenuItem;
    popHideForm: TMenuItem;
    N2: TMenuItem;
    C1: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    Timer1: TTimer;
    cdsDBList: TZjhDataSet;
    cdsDBListDBUID_: TWideStringField;
    cdsDBListDatabase_: TWideStringField;
    cdsDBListHost_: TWideStringField;
    cdsDBListAccount_: TWideStringField;
    cdsDBListPassword_: TWideStringField;
    cdsDBListPortNo_: TWideStringField;
    cdsDBListExecuteTime_: TTimeField;
    BtnOpen: TBitBtn;
    cboRemoteHost: TComboBox;
    edtRemotePwd: TEdit;
    edtRemoteUser: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    memBody: TMemo;
    Image1: TImage;
    Panel1: TPanel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    oCn: TADOConnection;
    ChkPur: TCheckBox;
    Label1: TLabel;
    EdtCorp: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure popHideFormClick(Sender: TObject);
    procedure popShowFormClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
    TrayIconData: TNotifyIconData;
    Ini: TIniFile;
    procedure OnTrayMessage(var Msg: TMessage); message WM_USER + 100;
  public
    { Public declarations }
    function KillTask(ExeFileName:string):boolean;
  end;

var
  FrmMain: TFrmMain;

implementation

uses SetConnFrm;

{$R *.dfm}

procedure TFrmMain.BitBtn3Click(Sender: TObject);
begin
  if (EdtCorp.Text = '') then
  begin
    ShowMessage('请输入公司别！');
    Exit;
  end;
  if not TFrmSetConn.Execute(oCn) then Exit;
  BtnOpen.Enabled := oCn.Connected;
end;

procedure TFrmMain.BtnOpenClick(Sender: TObject);
var
  dReadOnly: Boolean;
begin
  if (cboRemoteHost.Text = '') then
  begin
    ShowMessage('请输入服务主机！');
    Exit;
  end;
  if (edtRemoteUser.Text = '') then
  begin
    ShowMessage('请输入帐号！');
    Exit;
  end;
  if (edtRemotePwd.Text = '') then
  begin
    ShowMessage('请输入密码！');
    Exit;
  end;
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'TAppSync.ini');
  try
    Ini.WriteString('TAppSync','Host', cboRemoteHost.Text);
    Ini.WriteString('TAppSync','User', edtRemoteUser.Text);
    //Ini.WriteString('TAppSync','Pwd', edtRemotePwd.Text);
  finally
    Ini.Free;
  end;
  __ServerIP := cboRemoteHost.Text;
  dReadOnly := loginToVine(edtRemoteUser.Text, edtRemotePwd.Text);
  if not dReadOnly then
    begin
      ShowMessage('登录失败');
      Exit;
    end
  else
    memBody.Lines.Add('登录成功');
  timer1.Enabled := True;
  BtnOpen.Enabled := not dReadOnly;
  BitBtn3.Enabled := not dReadOnly;
  cboRemoteHost.Enabled := not dReadOnly;
  edtRemoteUser.ReadOnly := dReadOnly;
  edtRemotePwd.ReadOnly := dReadOnly;
end;

procedure TFrmMain.C1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  cdsDBList.CreateDataSet;
  //cboRemoteHost.Items.Add('127.0.0.1:8080');
  //cboRemoteHost.Items.Add('c1.knowall.cn');
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'TAppSync.ini');
  try
    cboRemoteHost.Text := Ini.ReadString('TAppSync', 'Host', 'c1.knowall.cn');//
    edtRemoteUser.Text := Ini.ReadString('TAppSync', 'User', '91100123');
    //edtRemotePwd.Text := Ini.ReadString('TAppSync','Pwd','123456');
  finally
    Ini.Free;
  end;
  with TrayIconData do
  begin
    Wnd := Handle;
    uID := 100;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_USER + 100;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Application.Title);
  end;
  Shell_NotifyIcon(NIM_ADD, @TrayIconData);
  Application.OnMinimize := popHideFormClick;
end;


function TFrmMain.KillTask(ExeFileName: string): boolean;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOLean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  sFileName: String;
begin
  Result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    sFileName := UpperCase(ExtractFileName(FProcessEntry32.szExeFile));
    if sFileName = UpperCase(ExeFileName)then
      Result := TerminateProcess(OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0);
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TFrmMain.N3Click(Sender: TObject);
begin
  memBody.Visible := not memBody.Visible;
end;

procedure TFrmMain.OnTrayMessage(var Msg: TMessage);
var
  P: TPoint;
begin
  case Msg.LParam of
    WM_RBUTTONDOWN:
      begin
        GetCursorPos(P);
        PopupMenu1.Popup(p.X, p.Y);
      end;
    WM_LBUTTONDBLCLK:
    //WM_LBUTTONDOWN:
      begin
        if not popShowForm.Enabled then
          popHideFormClick(Self)
        else
          popShowFormClick(Self);
      end;
  end;
end;

procedure TFrmMain.popHideFormClick(Sender: TObject);
begin
  popShowForm.Enabled := True;
  popHideForm.Enabled := False;
  Hide;
  ShowWindow(Application.Handle,SW_HIDE);
end;

procedure TFrmMain.popShowFormClick(Sender: TObject);
begin
  popShowForm.Enabled := False;
  popHideForm.Enabled := True;
  Application.Restore;
  Show;
  Application.BringToFront;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  TSync: TAppSync;
begin
  Timer1.Enabled := False;
  TSync := TAppSync.Create;
  try
    if ChkPur.Checked then TSync.SynExec(oCn);
  finally
    TSync.Free;
    Timer1.Enabled := True;
  end;
end;

end.
