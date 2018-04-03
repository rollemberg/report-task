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
  //��ת����
  TProgress = procedure(Max: Integer; var Value: Integer; FormHandle: Integer; Msg: PChar);
  TQRMTask = function(oCn: TADOConnection; const TaskID: String;
    Progress: TProgress; FormHandle: Integer): Boolean; stdcall;

implementation

const
  MAX_SLEEP = 1000 * 60 * 5; //5���Ӽ��һ��

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
  Timer1.Interval := MAX_SLEEP; //60��
  Timer1.OnTimer := Timer1Timer;
  Timer1.Enabled := True;
  OutputMessage(ChineseAsString('���ݷ���������������5���Ӻ�ʼ��һ�μ��'));
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
    //ִ�а�ť
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
      OutputMessage('�������������޷�ִ���Զ����ݣ�');
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
    //��δ���ݣ��Ϳ�ʼִ��
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
    if FindFirst(BackFile, faAnyFile, fp) = 0 then //�ҵ��ļ�
    begin
      //ȡ��ԭ�����ļ�����ʱ��
      FileTime := fp.FindData.ftCreationTime;
      FileTimeToLocalFileTime(FileTime, fTemp);
      FileTimeToSystemTime(fTemp, SysTime);
      OldTime := SystemTimeToDateTime(SysTime);
      if DaysBetween(OldTime, Now) = Days then   //ԭ�����ļ�ʱ�����Daysɾ��
      begin
        DeleteFile(PWideChar(BackFile));
        OutputMessage(Format('Delete OldFile: %s, OK.', [BackFile]));
      end;
    end;
  end;
begin
  try
    //Ĭ��ֵΪ30�룬��Ϊ4Сʱ
    Server.Connection.CommandTimeout := 3600 * 4;
    BackPath := ExtractFilePath(Application.ExeName) + 'Backup\';
    //һ��֮�ڣ�ÿ��һ��
    BackName := Format('%s-%sDayOfWeek', [ADatabase, IntToStr(DayOfTheWeek(Date()))]);
    DeleteOldFile(3);
    ExecuteBackup;
    //һ��֮�ڣ�ÿ��һ��
    BackName := Format('%s-%sWeekOfYear', [ADatabase, IntToStr(WeekOfTheYear(Date()))]);
    DeleteOldFile(30);
    ExecuteBackup;
    //һ��֮�ڣ�ÿ��һ��
    BackName := Format('%s-%s01', [ADatabase, FormatDatetime('YYYYMM', Date())]);
    ExecuteBackup;
  except
    on E: Exception do
      OutputMessage(E.Message);
  end;
end;

{
  --�˴�����ɾ�������Ӻ�̨���ö�ʱ�Զ����ݣ�����ֱ��copy���·�������
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
