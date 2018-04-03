unit SQLServer;

interface

uses
  ADODB, IniFiles, Forms, SysUtils, ApConst;

type
  TSQLServer = class
  private
    FConnection: TADOConnection;
    FDBName: String;
    FWorkstationID: String;
    FVersion: Integer;
    FAccount: String;
    FPassword: String;
    procedure SetWorkstationID(const Value: String);
    procedure SetVersion(const Value: Integer);
    procedure SetAccount(const Value: String);
    procedure SetPassword(const Value: String);
  public
    function GetConnectionString(const ADBName: String): String;
    function Open(const ADBName: String = 'Common'): Boolean;
    function GetDefaultDBName: string;
    function ExistsConfig: Boolean;
    constructor Create;
    destructor Destroy; override;
  public
    property Connection: TADOConnection read FConnection;
    property WorkstationID: String read FWorkstationID write SetWorkstationID;
    property DBName: String read FDBName;
    property Account: String read FAccount write SetAccount;
    property Password: String read FPassword write SetPassword;
    property Version: Integer read FVersion write SetVersion;
  end;
  TBuildConnectionString = class
  private
    FDatabase: String;
    FPassword: String;
    FWindowsSecurity: Boolean;
    FAccount: String;
    FServer: String;
    FVersion: Integer;
    FWorkstationID: String;
    procedure SetAccount(const Value: String);
    procedure SetDatabase(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetWindowsSecurity(const Value: Boolean);
    procedure SetServer(const Value: String);
    procedure SetVersion(const Value: Integer);
    procedure SetWorkstationID(const Value: String);
    function GetProvider: String;
  public
    constructor Create;
    function GetConnectionString: String;
  public
    property Server: String read FServer write SetServer;
    property Database: String read FDatabase write SetDatabase;
    property Account: String read FAccount write SetAccount;
    property Password: String read FPassword write SetPassword;
    property WindowsSecurity: Boolean read FWindowsSecurity write SetWindowsSecurity;
    property WorkstationID: String read FWorkstationID write SetWorkstationID;
    property Version: Integer read FVersion write SetVersion;
    property Provider: String read GetProvider;
  end;

const csAppServer = 'AppSvr';

implementation

{ TSQLServer }

constructor TSQLServer.Create;
begin
  FVersion := 2000;
  case sreg.ReadInteger(csAppServer, 'Version', 0) of
  1: FVersion := 2005;
  2: FVersion := 2008;
  3: FVersion := 2012;
  end;
  FWorkstationID := 'App2011';
end;

destructor TSQLServer.Destroy;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Connected := False;
    FreeAndNil(FConnection);
  end;
  inherited;
end;

function TSQLServer.Open(const ADBName: String): Boolean;
begin
  if not Assigned(FConnection) then
    FConnection := TADOConnection.Create(nil);
  if ADBName = 'Common' then
    FDBName := GetDefaultDBName()
  else
    FDBName := ADBName;
  FConnection.Connected := False;
  FConnection.LoginPrompt := False;
  FConnection.ConnectionString := Self.GetConnectionString(ADBName);
  FConnection.Connected := True;
  Result := True;
end;

procedure TSQLServer.SetAccount(const Value: String);
begin
  FAccount := Value;
end;

procedure TSQLServer.SetPassword(const Value: String);
begin
  FPassword := Value;
end;

procedure TSQLServer.SetVersion(const Value: Integer);
begin
  FVersion := Value;
end;

procedure TSQLServer.SetWorkstationID(const Value: String);
begin
  FWorkstationID := Value;
end;

function TSQLServer.GetDefaultDBName: string;
begin
  Result := sreg.ReadString('AppSvr', 'Database', SOFTWARE_NAME)
end;

function TSQLServer.ExistsConfig: Boolean;
begin
  Result := sreg.ValueExists('AppSvr', 'Database');
end;

function TSQLServer.GetConnectionString(const ADBName: String): String;
var
  Ini: TIniFile;
  strFile: String;
  bc: TBuildConnectionString;
begin
  bc := TBuildConnectionString.Create;
  try
    bc.Version := Self.FVersion;
    bc.WorkstationID := FWorkstationID;
    bc.Database := Trim(ADBName);
    if (bc.Database = '') or (bc.Database = 'Common') then
      bc.Database := sreg.ReadString('AppSvr', 'Database', SOFTWARE_NAME);
    strFile := ExtractFilePath(Application.ExeName) + 'Database.ini';
    if FileExists(strFile) then
    begin
      Ini := TIniFile.Create(strFile);
      try
        if not Ini.ValueExists(bc.Database, 'ConnectionString') then
          begin
            bc.Server := Ini.ReadString(bc.Database, 'Server', '(local)');
            bc.Account := Ini.ReadString(bc.Database, 'UserID', 'sa');
            bc.Password := Ini.ReadString(bc.Database, 'Password', '');
            if Ini.ReadInteger(bc.Database, 'Login', 1) = 1 then // Windows 认证
              bc.WindowsSecurity := True
            else
              bc.WindowsSecurity := False;
            Result := bc.GetConnectionString();
          end
        else
          Result := Ini.ReadString(bc.Database, 'ConnectionString', '');
      finally
        Ini.Free;
      end;
    end
    else
    begin
      if not sreg.ValueExists('Connections', bc.Database) then
        begin
          bc.Server := sreg.ReadString('AppSvr', 'SQL Server', '(local)');
          bc.Account := sreg.ReadString('AppSvr', 'User ID', 'sa');
          bc.Password := Encrypt(sreg.ReadString('AppSvr', 'Password', ''), SECURITY_PASSWORD, False);
          if sreg.ReadInteger('AppSvr', 'Login', 1) = 1 then //Windows 认证
            bc.WindowsSecurity := True
          else
            bc.WindowsSecurity := False;
          Result := bc.GetConnectionString();
        end
      else
        Result := sreg.ReadString('Connections', bc.Database, '');
    end;
  finally
    bc.Free;
  end;
end;

{ TBuildConnectionString }

constructor TBuildConnectionString.Create;
begin
  FVersion := 2000;
  FWorkstationID := 'App2011';
end;

function TBuildConnectionString.GetConnectionString: String;
begin
  if FWindowsSecurity then
    begin
      Result := Format('Provider=%s;Integrated Security=SSPI;'
        + 'Persist Security Info=False;Initial Catalog=%s;Data Source=%s',
        [Self.Provider, FDatabase, FServer]);
    end
  else
    begin
      Result := Format('Provider=%s;Password=%s;Persist Security Info=True;'
        + 'User ID=%s;Initial Catalog=%s;Data Source=%s;Use Procedure for Prepare=1;'
        + 'Auto Translate=True;Packet Size=4096;Workstation ID=%s',
        [Self.Provider, FPassword, FAccount, FDatabase, FServer, FWorkstationID]);
    end;
end;

function TBuildConnectionString.GetProvider: String;
begin
  case FVersion of
  2005: Result := 'SQLNCLI.1';
  2008: Result := 'SQLNCLI10.1';
  2012: Result := 'SQLNCLI11.1';
  else
        Result := 'SQLOLEDB.1';
  end;
end;

procedure TBuildConnectionString.SetAccount(const Value: String);
begin
  FAccount := Value;
end;

procedure TBuildConnectionString.SetDatabase(const Value: String);
begin
  FDatabase := Value;
end;

procedure TBuildConnectionString.SetPassword(const Value: String);
begin
  FPassword := Value;
end;

procedure TBuildConnectionString.SetServer(const Value: String);
begin
  FServer := Value;
end;

procedure TBuildConnectionString.SetVersion(const Value: Integer);
begin
  FVersion := Value;
end;

procedure TBuildConnectionString.SetWindowsSecurity(const Value: Boolean);
begin
  FWindowsSecurity := Value;
end;

procedure TBuildConnectionString.SetWorkstationID(const Value: String);
begin
  FWorkstationID := Value;
end;

end.
