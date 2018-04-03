unit BuildConnectionString;

interface

uses
  SysUtils;

type
  TBuildConnectionString = class
  private
    FDatabase: String;
    FPassword: String;
    FWindowsSecurity: Boolean;
    FAccount: String;
    FServer: String;
    FSQLServer: String;
    procedure SetAccount(const Value: String);
    procedure SetDatabase(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetWindowsSecurity(const Value: Boolean);
    procedure SetServer(const Value: String);
    procedure SetSQLServer(const Value: String);
  public
    function GetConnectionString: String;
  public
    property Server: String read FServer write SetServer;
    property Database: String read FDatabase write SetDatabase;
    property Account: String read FAccount write SetAccount;
    property Password: String read FPassword write SetPassword;
    property WindowsSecurity: Boolean read FWindowsSecurity write SetWindowsSecurity;
    property SQLServer: String read FSQLServer write SetSQLServer;
  end;

implementation

{ TBuildConnectionString }

function TBuildConnectionString.GetConnectionString: String;
begin
  if FSQLServer = '2012' then
    begin
      //Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security Info=False;User ID="";Initial Catalog="";Data Source=ZHANGGONG-PC\SQLEXPRESS;
      if FWindowsSecurity then
        Result := Format('Provider=SQLNCLI11.1;Integrated Security=SSPI;'
          + 'Persist Security Info=False;Initial Catalog=%s;Data Source=%s',
          [FDatabase, FServer])
      else
        Result := Format('Provider=SQLNCLI11.1;Password=%s;Persist Security Info=True;'
          + 'User ID=%s;Initial Catalog=%s;Data Source=%s;Use Procedure for Prepare=1;'
          + 'Auto Translate=True;Packet Size=4096;Workstation ID=AppServer',
          [FPassword, FAccount, FDatabase, FServer]);
    end
  else if FSQLServer = '2005' then
    begin
      if FWindowsSecurity then
        Result := Format('Provider=SQL Native Client;Integrated Security=SSPI;'
          + 'Persist Security Info=False;Initial Catalog=%s;Data Source=%s',
          [FDatabase, FServer])
      else
        Result := Format('Provider=SQL Native Client;Password=%s;Persist Security Info=True;'
          + 'User ID=%s;Initial Catalog=%s;Data Source=%s;Use Procedure for Prepare=1;'
          + 'Auto Translate=True;Packet Size=4096;Workstation ID=AppServer',
          [FPassword, FAccount, FDatabase, FServer]);
    end
  else
    begin
      if FWindowsSecurity then
        Result := Format('Provider=SQLOLEDB.1;Integrated Security=SSPI;'
          + 'Persist Security Info=False;Initial Catalog=%s;Data Source=%s',
          [FDatabase, FServer])
      else
        Result := Format('Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;'
          + 'User ID=%s;Initial Catalog=%s;Data Source=%s;Use Procedure for Prepare=1;'
          + 'Auto Translate=True;Packet Size=4096;Workstation ID=AppServer',
          [FPassword, FAccount, FDatabase, FServer]);
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

procedure TBuildConnectionString.SetSQLServer(const Value: String);
begin
  FSQLServer := Value;
end;

procedure TBuildConnectionString.SetWindowsSecurity(const Value: Boolean);
begin
  FWindowsSecurity := Value;
end;

end.

