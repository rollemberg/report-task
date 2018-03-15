unit AppSync;

interface

uses
  SysUtils, AppUtils2, ZjhCtrls, Dialogs, ADODB, AppDB2, DB,Classes;

type
  TAppSync = class
  private
    { Private declarations }
    procedure CreateDBListTable;
    procedure CreateReportListTable;
    function setReportDate(cdsTmp: TAppDataSet; const difTime,Status: Integer;const ErrorMsg: String = ''): Boolean;
  public
    cdsDBList: TZjhDataSet;
    cdsReportList: TZjhDataSet;
    procedure ReadDBList;
    procedure ReadReportList;
    procedure Init();
    procedure Destroy();
    procedure Exec();
  end;

  {
  TThreadAppSync = class(TThread)
  private
    difTime: Integer;
    cdsDBList: TZjhDataSet;
    cdsReportList: TZjhDataSet;
    procedure Init();
    procedure ReadDBList;
    procedure ReadReportList;
    procedure CreateDBListTable;
    procedure CreateReportListTable;
    function setReportDate(cdsTmp: TAppDataSet; const difTime,Status: Integer;const ErrorMsg: String = ''): Boolean;
  protected
  public
    constructor Create(CreateSuspended: Boolean); overload;
    destructor Destroy; override;
  public
    procedure SetParams(difTime: Integer);
    procedure Execute; override;
  end;
  }

implementation

{ TAppSync }

procedure TAppSync.CreateDBListTable;
begin
  with cdsDBList do
  begin
    FieldDefs.Clear;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 19;
      Name := 'DBUID_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 20;
      Name := 'Database_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 100;
      Name := 'Host_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 50;
      Name := 'Account_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 50;
      Name := 'Password_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 5;
      Name := 'PortNo_';
    end;
    CreateDataSet;
  end;
end;

procedure TAppSync.CreateReportListTable;
begin
  with cdsReportList do
  begin
    FieldDefs.Clear;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 19;
      Name := 'DBUID_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 20;
      Name := 'CorpNo_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 100;
      Name := 'Group_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 30;
      Name := 'RetNo_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 30;
      Name := 'RetName_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideMemo;
      Name := 'Param_';
    end;
    with FieldDefs.AddFieldDef do
    begin
      DataType := ftWideString;
      Size := 10;
      Name := 'Ver_';
    end;
    CreateDataSet;
  end;

end;
procedure TAppSync.Destroy;
begin
  cdsDBList.Free;
  cdsReportList.Free;
end;

procedure TAppSync.Exec;
var
  sAccount,sPassword,sHost,DBName : String;
  SQLCmd: String;
  cdsTmp: TADOQuery;
  cdsTmp1: TAppDataSet;
  d1: TDateTime;
  difTime: Integer;
  oCn: TADOConnection;
begin
  if not cdsDBList.Active then Exit;
  if cdsDBList.RecordCount =0 then Exit;
  if not cdsReportList.Active then Exit;
  if cdsReportList.RecordCount =0 then Exit;
  oCn := TADOConnection.Create(nil);
  cdsTmp := TADOQuery.Create(nil);
  try
    cdsTmp.Connection := oCn;
    cdsDBList.First;
    while not cdsDBList.eof do
    begin
      sAccount:= cdsDBList.FieldByName('Account_').AsString;
      sPassword:= cdsDBList.FieldByName('Password_').AsString;
      DBName:= cdsDBList.FieldByName('Database_').AsString;
      sHost :=  cdsDBList.FieldByName('Host_').AsString;
      try
        oCn.Close;
        oCn.ConnectionString := Format('Provider=SQLOLEDB.1;Password=%s;Persist '
          + 'Security Info=True;User ID=%s;Initial Catalog=%s;Data Source=%s',
          [sPassword,sAccount,DBName,sHost]);
        oCn.LoginPrompt := False;
        oCn.Open;
      except
        begin
          cdsDBList.Next;
          Continue;
        end;
      end;
      cdsReportList.Filtered:= False;
      cdsReportList.Filter:=Format('DBUID_=%s',[cdsDBList.FieldByName('DBUID_').AsString]);
      cdsReportList.Filtered:=True;
      cdsReportList.First;
      while not cdsReportList.eof do
      begin
        SQLCmd := cdsReportList.FieldByName('Param_').AsString ;
        try
          difTime := 0;
          cdsTmp.Close;
          cdsTmp.SQL.Text := SQLCmd;
          d1 := now();
          cdsTmp.Open;
          difTime := Trunc(now()) - Trunc(d1);
          if not cdsTmp.Eof then
          begin
            cdsTmp1 := TAppDataSet.Create;
            try
              cdsTmp1.LoadFrom(cdsTmp);
              setReportDate(cdsTmp1, difTime,1);
            finally
              cdsTmp1.Free;
            end;
          end;
        except
          on E: Exception do
          begin
            //ShowMessage(E.Message);
            setReportDate(cdsTmp1, difTime,0,E.Message);
          end;
        end;
        cdsReportList.Next;
      end;
      cdsDBList.Next;
    end;
    ShowMessage('执行完成');
  finally
    oCn.Free;
    cdsTmp.Free;
  end;
end;

procedure TAppSync.Init;
begin
  cdsDBList := TZjhDataSet.Create(nil);
  cdsReportList := TZjhDataSet.Create(nil);
  CreateDBListTable;
  CreateReportListTable;
end;

procedure TAppSync.ReadDBList;
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
          cdsDBList.Append;
          cdsDBList.FieldByName('DBUID_').AsString := FieldByName('UID_').AsString;
          cdsDBList.FieldByName('Database_').AsString := FieldByName('Database_').AsString;
          cdsDBList.FieldByName('Host_').AsString := FieldByName('Host_').AsString;
          cdsDBList.FieldByName('Account_').AsString := FieldByName('Account_').AsString;
          cdsDBList.FieldByName('Password_').AsString := FieldByName('Password_').AsString;
          cdsDBList.FieldByName('PortNo_').AsString := FieldByName('PortNo_').AsString;
          cdsDBList.Post();
          Next;
        end;
      end;
    end
  else
    ShowMessage(app.Messages);
end;

procedure TAppSync.ReadReportList;
var
  app: IAppService;
begin
  app := Service('SvrERPSyncReport.getReportList');
  if app.Exec then
    begin
      cdsReportList.EmptyDataSet;
      with app.DataOut do
      begin
        First;
        while not Eof do
        begin
          cdsReportList.Append;
          cdsReportList.FieldByName('DBUID_').AsString := FieldByName('DBID_').AsString;
          cdsReportList.FieldByName('CorpNo_').AsString := FieldByName('CorpNo_').AsString;
          cdsReportList.FieldByName('Group_').AsString := FieldByName('Group_').AsString;
          cdsReportList.FieldByName('RetNo_').AsString := FieldByName('RetNo_').AsString;
          cdsReportList.FieldByName('RetName_').AsString := FieldByName('RetName_').AsString;
          cdsReportList.FieldByName('Param_').AsString := FieldByName('Param_').AsString;
          cdsReportList.FieldByName('Ver_').AsString := FieldByName('Ver_').AsString;
          cdsReportList.Post();
          Next;
        end;
      end;
    end
  else
    ShowMessage(app.Messages);
end;



function TAppSync.setReportDate(cdsTmp: TAppDataSet; const difTime,
  Status: Integer; const ErrorMsg: String): Boolean;
var
  app: IAppService;
begin
  Result := False;
  app := Service('SvrERPSyncReport.setReportDate');
  app.DataIn.Append();
  app.DataIn.FieldByName('RetNo_').AsString := cdsReportList.FieldByName('RetNo_').AsString;
  app.DataIn.FieldByName('TDate_').AsDateTime := Date();
  app.DataIn.FieldByName('Status_').AsInteger := Status;
  app.DataIn.FieldByName('Value_').AsString := cdsTmp.JSON.AsString;
  app.DataIn.FieldByName('ErrorMsg_').AsString := ErrorMsg;
  app.DataIn.FieldByName('Remark_').AsString := '';
  app.DataIn.FieldByName('Times_').AsInteger := difTime;
  app.DataIn.FieldByName('Ver_').AsString := cdsReportList.FieldByName('Ver_').AsString;
  app.DataIn.FieldByName('Database_').AsString := cdsDBList.FieldByName('Database_').AsString;
  if app.Exec then
    Result := True
  else
    ShowMessage(app.Messages);
end;
end.
