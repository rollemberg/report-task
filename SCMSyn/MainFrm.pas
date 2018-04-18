unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AppUtils2, Grids, DBGrids, DB, DBClient, ZjhCtrls,
  Buttons, ComCtrls, ADODB, AppDB2, AppSync,IniFiles, Menus,ShellAPI,Tlhelp32,
  jpeg, CustomSync;

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
    oCn: TADOConnection;
    Timer2: TTimer;
    cdsDBListSyncType_: TIntegerField;
    cdsDBListERPCode_: TWideStringField;
    procedure FormCreate(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure popHideFormClick(Sender: TObject);
    procedure popShowFormClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    TrayIconData: TNotifyIconData;
    Ini: TIniFile;
    procedure OnTrayMessage(var Msg: TMessage); message WM_USER + 100;
    procedure CheckSync(const CorpNo: String);
    procedure updateSyncStatus(syncID, newStatus: Integer; value,
      corpno: String);
    function call(intf: ISyncItem; dataOut: TAppDataSet;
      const corpno: String): Boolean;
  public
    { Public declarations }
    function KillTask(ExeFileName:string):boolean;
    procedure ReadDBList;
  end;

var
  FrmMain: TFrmMain;
  __Account: string;
  __Password: string;
  __CorpCode: string;
implementation

uses SyncPur, SyncCusSup, SyncTranReq, SyncSendTran;

{$R *.dfm}

procedure TFrmMain.BtnOpenClick(Sender: TObject);
var
  dReadOnly: Boolean;
  sAccount,sPassword,sHost,DBName : string;
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
  if not loginToVine(edtRemoteUser.Text, edtRemotePwd.Text) then
    begin
      ShowMessage('登录失败');
      Exit;
    end
  else
  begin
    __Account := edtRemoteUser.Text;
    __Password := edtRemotePwd.Text;
    memBody.Lines.Add('登录成功');
  end;
  ReadDBList;
  if cdsDBList.Eof then
  begin
    ShowMessage('无可连接数据库');
    Exit;
  end;
  sAccount := cdsDBList.FieldByName('Account_').AsString;
  sPassword := cdsDBList.FieldByName('Password_').AsString;
  DBName := cdsDBList.FieldByName('Database_').AsString;
  sHost :=  cdsDBList.FieldByName('Host_').AsString;
  __CorpCode :=  cdsDBList.FieldByName('ERPCode_').AsString;
  try
    oCn.Close;
    oCn.ConnectionString := Format('Provider=SQLOLEDB.1;Password=%s;Persist '
      + 'Security Info=True;User ID=%s;Initial Catalog=%s;Data Source=%s',
      [sPassword,sAccount,DBName,sHost]);
    oCn.LoginPrompt := False;
    oCn.Open;
    dReadOnly := oCn.Connected;
    BtnOpen.Enabled := not dReadOnly;
    cboRemoteHost.Enabled := not dReadOnly;
    edtRemoteUser.ReadOnly := dReadOnly;
    edtRemotePwd.ReadOnly := dReadOnly;
  except
    on E: Exception do
    begin
      FrmMain.memBody.Lines.Add('error: ' + DBName + '-' +  E.Message);
    end;
  end;

  timer1.Enabled := True;
  timer2.Enabled := True;


end;

procedure TFrmMain.C1Click(Sender: TObject);
begin
  Close;
end;

function TFrmMain.call(intf: ISyncItem; dataOut: TAppDataSet; const corpno: String): Boolean;
begin
  intf.setDataOut(dataOut);
  Result := intf.execSync;
  //回写到服务器
  if Result then
    begin
      updateSyncStatus(dataOut.Head.FieldByName('_SyncUID_').AsInteger, 1, '执行成功！', corpno);
    end
  else
    updateSyncStatus(dataOut.Head.FieldByName('_SyncUID_').AsInteger, 2, '执行失败！', corpno);
end;

procedure TFrmMain.CheckSync(const corpno: String);
var
  app: IAppService;
  syncpur: TSyncPur;
  synccuSup: TSyncCusSup;
  syncTranReq: TSyncTranReq;
  syncSendTran:TSyncSendTran;
begin
  app := Service('TAppSyncERP.download');
  app.DataIn.Head.FieldByName('CorpNo_').AsString := corpno;
  if app.Exec then
  begin
    if not app.DataOut.Head.FieldDefs.Exists('_SyncUID_') then
      Exit;
    if app.DataOut.Head.FieldByName('_SyncProject_').AsString = 'e_PurB' then
    begin
      syncpur := TSyncPur.Create(Self);
      if call(syncpur as ISyncItem, app.DataOut, corpno) then
        FrmMain.memBody.Lines.Add('执行e_PurB成功!')
      else
        FrmMain.memBody.Lines.Add('执行e_PurB失败!')
    end;
    if app.DataOut.Head.FieldByName('_SyncProject_').AsString = 'e_CusSup' then
    begin
      synccuSup := TSyncCusSup.Create(Self);
      if call(synccuSup as ISyncItem, app.DataOut, corpno) then
        FrmMain.memBody.Lines.Add('执行e_CusSup成功!')
      else
        FrmMain.memBody.Lines.Add('执行e_CusSupB失败!')
    end;
    if app.DataOut.Head.FieldByName('_SyncProject_').AsString = 'e_TranReq' then
    begin
      syncTranReq := TSyncTranReq.Create(Self);
      if call(syncTranReq as ISyncItem, app.DataOut, corpno) then
        FrmMain.memBody.Lines.Add('执行e_TranReq成功!')
      else
        FrmMain.memBody.Lines.Add('执行e_TranReq失败!')
    end;
    if app.DataOut.Head.FieldByName('_SyncProject_').AsString = 'e_SendTran' then
    begin
      SyncSendTran := TSyncSendTran.Create(Self);
      if call(SyncSendTran as ISyncItem, app.DataOut, corpno) then
        FrmMain.memBody.Lines.Add('执行e_TranReq成功!')
      else
        FrmMain.memBody.Lines.Add('执行e_TranReq失败!')
    end;
  end;
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

procedure TFrmMain.ReadDBList;
var
  app: IAppService;
begin
  app := Service('SvrERPSyncReport.getDBList');
  if app.Exec then
    begin
      cdsDBList.EmptyDataSet;
      with app.DataOut do
      begin
        First;
        while not Eof do
        begin
          if FieldByName('SyncType_').AsInteger = 1 then
          begin
            cdsDBList.Append;
            cdsDBList.FieldByName('DBUID_').AsString := FieldByName('UID_').AsString;
            cdsDBList.FieldByName('Database_').AsString := FieldByName('Database_').AsString;
            cdsDBList.FieldByName('Host_').AsString := FieldByName('Host_').AsString;
            cdsDBList.FieldByName('Account_').AsString := FieldByName('Account_').AsString;
            cdsDBList.FieldByName('Password_').AsString := FieldByName('Password_').AsString;
            cdsDBList.FieldByName('PortNo_').AsString := FieldByName('PortNo_').AsString;
            cdsDBList.FieldByName('ExecuteTime_').AsDateTime := FieldByName('ExecuteTime_').AsDateTime;
            cdsDBList.FieldByName('SyncType_').AsInteger := FieldByName('SyncType_').AsInteger;
            cdsDBList.FieldByName('ERPCode_').AsString := FieldByName('ERPCode_').AsString;
            cdsDBList.Post();
          end;
          Next;
        end;
      end;
    end
  else
    ShowMessage(app.Messages);
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  TSync: TAppSync;
begin
  Timer1.Enabled := False;
  TSync := TAppSync.Create;
  try
    TSync.SynExec(oCn);
  finally
    TSync.Free;
    Timer1.Enabled := True;
  end;
end;

procedure TFrmMain.Timer2Timer(Sender: TObject);
var
  cdsSup: TADOQuery;
begin
  Timer2.Enabled := False;
  if not loginToVine(__Account, __Password) then Exit;
  cdsSup := TADOQuery.Create(nil);
  try
    cdsSup.Connection := FrmMain.oCn;
    cdsSup.SQL.Text := 'select distinct CorpNo_ from cussup where isnull(CorpNo_,'''')<>''''';
    cdsSup.Open;
    if not cdsSup.Eof then
    begin
      while not cdsSup.Eof do
      begin
        CheckSync(cdsSup.FieldByName('CorpNo_').AsString);
        cdsSup.Next;
      end;
    end;
  finally
    Timer2.Enabled := True;
  end;
end;

procedure TFrmMain.updateSyncStatus(syncID, newStatus: Integer; value, corpno: String);
var
  app: IAppService;
  tb: String;
begin
  //增加一个同步状态的java后台，参考TAppSyncERP.updateStatus
  app := Service('SvrERPSyncReport.updateStatus');
  app.DataIn.Head.FieldByName('UID_').AsInteger := syncID;
  app.DataIn.Head.FieldByName('Status_').AsInteger := newStatus;
  app.DataIn.Head.FieldByName('Remark_').AsString := value;
  app.DataIn.Head.FieldByName('CorpNo_').AsString := corpno;
  if app.exec then
    FrmMain.memBody.Lines.Add('同步成功')
  else
    FrmMain.memBody.Lines.Add('回写失败');
end;

end.
