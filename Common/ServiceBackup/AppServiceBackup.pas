unit AppServiceBackup;

interface

uses
  Classes, uBaseIntf, SysUtils, ApConst, ExtCtrls, Windows, ADODB, StdCtrls,
  Forms, DateUtils, Controls, SQLServer, IniFiles, Variants, ServerLang;

type
  TAppServiceBackup = class(TComponent, IOutputMessage)
  private
    Timer1: TTimer;
    btnExec: TButton;
    procedure OutputMessage(const Value: String);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure BackupDatabase(Server: TSQLServer; const ADatabase: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;
  //回转函数
  TProgress = procedure(Max: Integer; var Value: Integer; FormHandle: Integer; Msg: PChar);
  TQRMTask = function(oCn: TADOConnection; const TaskID: String;
    Progress: TProgress; FormHandle: Integer): Boolean; stdcall;

implementation

const
  MAX_SLEEP = 1000 * 60 * 5; //5分钟检查一次

{ TAppServiceBackup }

constructor TAppServiceBackup.Create(AOwner: TComponent);
var
  Child: TForm;
begin
  inherited;
  btnExec := TButton.Create(Self.Owner);
  if Self.Owner is TForm then
  begin
    Child := TForm(Self.Owner);
    btnExec.Caption := '&Backup';
    btnExec.Parent := Child;
    btnExec.Visible := True;
    btnExec.Top := 16;
    btnExec.Left := 360; //Child.Left + Child.Width - 125;
    btnExec.Anchors := [akRight,akTop];
    btnExec.OnClick := Self.btnExecClick;;
  end;
  //
  Timer1 := TTimer.Create(Self);
  Timer1.Interval := MAX_SLEEP; //60秒
  Timer1.OnTimer := Timer1Timer;
  Timer1.Enabled := True;
  OutputMessage(ChineseAsString('备份服务已启动，将于5分钟后开始第一次检查'));
end;

destructor TAppServiceBackup.Destroy;
begin
  Timer1.Free;
  inherited;
end;

procedure TAppServiceBackup.OutputMessage(const Value: String);
begin
  if Supports(Self.Owner, IOutputMessage) then
    (Self.Owner as IOutputMessage).OutputMessage(FormatDateTime('YYYY/MM/DD HH:MM:SS',Now()) + ': ' + Value);
end;

procedure TAppServiceBackup.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    //执行按钮
    btnExec.Click;
  finally
    Timer1.Enabled := True;
  end;
end;

procedure TAppServiceBackup.btnExecClick(Sender: TObject);
var
  Server: TSQLServer;
begin
  Server := TSQLServer.Create;
  try
    Screen.Cursor := crHourGlass;
    Timer1.Enabled := False;
    btnExec.Enabled := False;
    if Server.ExistsConfig then
      begin
        if Server.Open() then
        begin
          BackupDatabase(Server, Server.GetDefaultDBName());
        end;
      end
    else
      OutputMessage('您的配置有误，无法执行自动备份！');
  finally
    Timer1.Enabled := True;
    btnExec.Enabled := True;
    Screen.Cursor := crDefault;
    Server.Free;
  end;
end;

procedure TAppServiceBackup.BackupDatabase(Server: TSQLServer;
  const ADatabase: String);
var
  BackPath: String;
  BackName: String;
  procedure ExecuteBackup;
  var
    BackFile, BackCommand: String;
  begin
    if not DirectoryExists(BackPath) then
      CreateDirectory(PWideChar(BackPath), nil);
    BackFile := Format('%s%s.BAK', [BackPath, BackName]);
    //若未备份，就开始执行
    if not FileExists(BackFile) then
    begin
      OutputMessage(Format('Backup %s, please wait...', [ADatabase]));
      BackCommand := Format('BACKUP DATABASE [%s] TO DISK = ''%s'' WITH NOFORMAT, '
        + 'NAME = ''%s''', [ADatabase, BackFile, BackName]);
      Server.Connection.Execute(BackCommand);
      OutputMessage(Format('Save to %s, OK.', [BackFile]));
    end;
  end;
  procedure DeleteOldFile(Days: Integer);
  var
    BackFile: String;
    fp: TSearchRec;
    SysTime: _SystemTime;
    FileTime, fTemp: _FileTime;
    OldTime: TDateTime;
  begin
    BackFile := Format('%s%s.BAK', [BackPath, BackName]);
    if not FileExists(BackFile) then Exit;
    if FindFirst(BackFile, faAnyFile, fp) = 0 then //找到文件
    begin
      //取得原备份文件创建时间
      FileTime := fp.FindData.ftCreationTime;
      FileTimeToLocalFileTime(FileTime, fTemp);
      FileTimeToSystemTime(fTemp, SysTime);
      OldTime := SystemTimeToDateTime(SysTime);
      if DaysBetween(OldTime, Now) = Days then   //原备份文件时间大于Days删除
      begin
        DeleteFile(PWideChar(BackFile));
        OutputMessage(Format('Delete OldFile: %s, OK.', [BackFile]));
      end;
    end;
  end;
begin
  try
    //默认值为30秒，设为4小时
    Server.Connection.CommandTimeout := 3600 * 4;
    BackPath := ExtractFilePath(Application.ExeName) + 'Backup\';
    //一周之内，每天一个
    BackName := Format('%s-%sDayOfWeek', [ADatabase, IntToStr(DayOfTheWeek(Date()))]);
    DeleteOldFile(3);
    ExecuteBackup;
    //一年之内，每周一个
    BackName := Format('%s-%sWeekOfYear', [ADatabase, IntToStr(WeekOfTheYear(Date()))]);
    DeleteOldFile(30);
    ExecuteBackup;
    //一年之内，每月一个
    BackName := Format('%s-%s01', [ADatabase, FormatDatetime('YYYYMM', Date())]);
    ExecuteBackup;
  except
    on E: Exception do
      OutputMessage(E.Message);
  end;
end;

{
  --此代码勿删除，若从后台设置定时自动备份，可以直接copy如下范例代码
  declare @BackName nvarchar(255)
  set @BackName = N'EasyERP-' + convert(nchar(10), getdate(), 112)
  declare @BackFile nvarchar(255)
  set @BackFile = N'D:\' + @BackName + N'.BAK'
  BACKUP DATABASE [EasyERP] TO DISK = @BackFile WITH NOFORMAT, NAME = @BackName
}

initialization
  RegClass(TAppServiceBackup);

finalization
  UnRegClass(TAppServiceBackup);

end.
