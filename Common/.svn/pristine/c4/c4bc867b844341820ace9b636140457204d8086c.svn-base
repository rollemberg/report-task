unit RebuildIndexsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB, StdCtrls, Grids, DBGrids, DBClient, ComCtrls, ExtCtrls;

type
  TFrmRebuildIndexs = class(TForm)
    qSQL: TADOQuery;
    oCn: TADOConnection;
    cdsView: TClientDataSet;
    dsView: TDataSource;
    cdsViewTable_: TStringField;
    cdsViewCount_: TIntegerField;
    cdsViewDatabase_: TStringField;
    cdsViewIndexName_: TStringField;
    cdsViewIndexFile_: TStringField;
    cdsViewSelect: TBooleanField;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    edtServer: TEdit;
    edtAccount: TEdit;
    edtPassword: TEdit;
    Button2: TButton;
    cboDatabase: TComboBox;
    edtIndexPath: TEdit;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    chkSelectAll: TCheckBox;
    Panel3: TPanel;
    btnRebuild: TButton;
    chkOverwrite: TCheckBox;
    TabSheet4: TTabSheet;
    DBGrid2: TDBGrid;
    cdsIndexs: TADOQuery;
    dsIndexs: TDataSource;
    chkDemo: TCheckBox;
    btnCreate: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure cdsViewSelectGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure cdsViewSelectSetText(Sender: TField; const Text: string);
    procedure chkSelectAllClick(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure btnRebuildClick(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTableIndexs(DataSet: TADOQuery; const strTable: String);
    function GetTableCount(const strTable: String): Integer;
    procedure CreateIndexs(Items: TStrings; const strTable, IndexFile: String);
  public
    { Public declarations }
  end;

const
  DROP_EXISTING_OFF = 'DROP_EXISTING = OFF';
  DROP_EXISTING_ON = 'DROP_EXISTING = ON';
  PRIMARY_KEY = 'PRIMARY KEY';

implementation

{$R *.dfm}

procedure TFrmRebuildIndexs.btnCreateClick(Sender: TObject);
var
  strTable, strFile: String;
begin
  try
    Memo2.Lines.Clear;
    Memo2.Lines.Add('USE ' + cboDatabase.Text);
    Memo2.Lines.Add('GO');
    Screen.Cursor := crHourGlass;
    with cdsView do
    begin
      First;
      while not Eof do
      begin
        if FieldByName('Select').AsBoolean then
        begin
          strTable := Trim(FieldByName('Table_').AsString);
          strFile := Trim(cdsView.FieldByName('IndexFile_').AsString);
          if (Trim(strTable) <> '') and (strFile <> '') and FileExists(strFile)
            then
          begin
            CreateIndexs(Memo2.Lines, strTable, strFile);
            Memo2.Lines.Add('GO');
          end;
        end;
        Application.ProcessMessages;
        Next;
      end;
    end;
    strFile := ExtractFilePath(Application.ExeName) + cboDatabase.Text + '.sql';
    if FileExists(strFile) then
      DeleteFile(strFile);
    Memo2.Lines.SaveToFile(strFile);
    PageControl1.ActivePageIndex := 3;
    ShowMessage('已生成文件：' + strFile);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmRebuildIndexs.btnRebuildClick(Sender: TObject);
var
  strTable, strFile: String;
begin
  Memo2.Lines.Clear;
  strTable := Trim(cdsView.FieldByName('Table_').AsString);
  strFile := Trim(cdsView.FieldByName('IndexFile_').AsString);
  if (Trim(strTable) <> '') and (strFile <> '') and FileExists(strFile) then
    Self.CreateIndexs(Memo2.Lines, strTable, strFile);
  PageControl1.ActivePageIndex := 3;
end;

procedure TFrmRebuildIndexs.Button1Click(Sender: TObject);
var
  i: Integer;
  ct: Integer;
  sl: TStringList;
  IndexFile: String;
begin
  sl := TStringList.Create;
  try
    oCn.Connected := False;
    oCn.ConnectionString := Format('Provider=SQLOLEDB.1;Password=%s;' +
        'Persist Security Info=True;User ID=%s;Initial Catalog=%s;' +
        'Data Source=%s', [edtPassword.Text, edtAccount.Text, cboDatabase.Text,
      edtServer.Text]);
    oCn.Connected := True;
    oCn.GetTableNames(sl);
    cdsView.EmptyDataSet;
    with cdsView do
      for i := 0 to sl.Count - 1 do
      begin
        IndexFile := edtIndexPath.Text + '\' + sl.Strings[i] + '.sql';
        if CheckBox1.Checked then // 必须要有索引文件
        begin
          if FileExists(IndexFile) then
          begin
            Append;
            FieldByName('Database_').AsString := cboDatabase.Text;
            FieldByName('Table_').AsString := sl.Strings[i];
            FieldByName('Count_').AsInteger := -1;
            FieldByName('IndexFile_').AsString := IndexFile;
            FieldByName('Select').AsBoolean := True;
          end;
        end
        else
        begin
          ct := GetTableCount(sl.Strings[i]);
          Append;
          FieldByName('Database_').AsString := cboDatabase.Text;
          FieldByName('Table_').AsString := sl.Strings[i];
          FieldByName('Count_').AsInteger := ct;
          if FileExists(IndexFile) then
          begin
            FieldByName('IndexFile_').AsString := IndexFile;
            FieldByName('Select').AsBoolean := True;
          end;
          Post;
        end;
        Application.ProcessMessages;
      end;
  finally
    sl.Free;
  end;
end;

procedure TFrmRebuildIndexs.Button2Click(Sender: TObject);
var
  cdsTmp: TADOQuery;
begin
  oCn.Connected := False;
  oCn.ConnectionString := Format('Provider=SQLOLEDB.1;Password=%s;' +
      'Persist Security Info=True;User ID=%s;Initial Catalog=%s;' +
      'Data Source=%s', [edtPassword.Text, edtAccount.Text, 'master',
    edtServer.Text]);
  oCn.Connected := True;
  //
  cboDatabase.Items.Clear;
  cdsTmp := TADOQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.oCn;
      SQL.Text := 'select name from master..sysdatabases';
      Open;
      while not Eof do
      begin
        cboDatabase.Items.Add(FieldByName('Name').AsString);
        Next;
      end;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TFrmRebuildIndexs.cdsViewSelectGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsBoolean then
    Text := 'Yes'
  else
    Text := '';
end;

procedure TFrmRebuildIndexs.cdsViewSelectSetText(Sender: TField;
  const Text: string);
begin
  Sender.AsBoolean := UpperCase(Copy(Text, 1, 1)) = 'Y';
end;

procedure TFrmRebuildIndexs.chkSelectAllClick(Sender: TObject);
begin
  with cdsView do
  begin
    DisableControls;
    First;
    while not Eof do
    begin
      Edit;
      FieldByName('Select').AsBoolean := chkSelectAll.Checked;
      Post;
      Next;
    end;
    First;
    EnableControls;
  end;
end;

procedure TFrmRebuildIndexs.DBGrid1DblClick(Sender: TObject);
begin
  with cdsView do
  begin
    if DBGrid1.SelectedField = FieldByName('Select') then
    begin
      Edit;
      DBGrid1.SelectedField.AsBoolean := not DBGrid1.SelectedField.AsBoolean;
      Post;
    end;
  end;
end;

function TFrmRebuildIndexs.GetTableCount(const strTable: String): Integer;
var
  cdsTmp: TADOQuery;
begin
  cdsTmp := TADOQuery.Create(nil);
  try
    cdsTmp.Connection := Self.oCn;
    cdsTmp.SQL.Text := Format('select count(*) as Count_ from %s', [strTable]);
    cdsTmp.Open;
    Result := cdsTmp.FieldByName('Count_').AsInteger;
  finally
    cdsTmp.Free;
  end;
end;

procedure TFrmRebuildIndexs.LoadTableIndexs(DataSet: TADOQuery;
  const strTable: String);
begin
  with DataSet do
  begin
    Active := False;
    Connection := Self.oCn;
    SQL.Add('SELECT ');
    SQL.Add('c.name AS TableName_, a.name AS IndexName_, d.name AS Column_,');
    SQL.Add(
      'b.keyno AS IndexOrder_, CASE indexkey_property(c.id, b.indid, b.keyno, ''isdescending'')');
    SQL.Add(
      'WHEN 1 THEN ''降序'' WHEN 0 THEN ''升序'' END AS 排序, CASE WHEN p.id IS NULL '
      );
    SQL.Add(
      'THEN '''' ELSE ''Yes'' END AS IsPK_, CASE INDEXPROPERTY(c.id, a.name, ''IsClustered'')');
    SQL.Add(
      'WHEN 1 THEN ''√'' WHEN 0 THEN '''' END AS 聚集, CASE INDEXPROPERTY(c.id,');
    SQL.Add(
      'a.name, ''IsUnique'') WHEN 1 THEN ''√'' WHEN 0 THEN '''' END AS 唯一,');
    SQL.Add('CASE WHEN e.id IS NULL THEN '''' ELSE ''√'' END AS 唯一约束,');
    SQL.Add(
      'a.OrigFillFactor AS 填充因子, c.crdate AS CreateTime_, c.refdate AS UpdateTime_ ');

    SQL.Add('FROM dbo.sysindexes a INNER JOIN ');
    SQL.Add(
      'dbo.sysindexkeys b ON a.id = b.id AND a.indid = b.indid INNER JOIN ');
    SQL.Add
      ('dbo.syscolumns d ON b.id = d.id AND b.colid = d.colid INNER JOIN ');
    SQL.Add(
      'dbo.sysobjects c ON a.id = c.id AND c.xtype = ''U'' LEFT OUTER JOIN ');
    SQL.Add(
      'dbo.sysobjects e ON e.name = a.name AND e.xtype = ''UQ'' LEFT OUTER JOIN ');
    SQL.Add('dbo.sysobjects p ON p.name = a.name AND p.xtype = ''PK'' ');
    SQL.Add(
      'WHERE (OBJECTPROPERTY(a.id, N''IsUserTable'') = 1) AND (OBJECTPROPERTY(a.id, ');
    SQL.Add(
      'N''IsMSShipped'') = 0) AND (INDEXPROPERTY(a.id, a.name, ''IsAutoStatistics'') = 0) ');
    SQL.Add(Format('and c.name=''%s'' ', [strTable]));
    SQL.Add('ORDER BY c.name, a.name, b.keyno ');
    Open;
  end;
end;

procedure TFrmRebuildIndexs.CreateIndexs(Items: TStrings;
  const strTable, IndexFile: String);
var
  i: Integer;
  str, s1: String;
  sl: TStringList;
  cdsTmp: TADOQuery;
  procedure AddCommand(const SQLCmd: String);
  begin
    Items.Add(SQLCmd);
    if not chkDemo.Checked then
    begin
      try
        oCn.Execute(SQLCmd);
        Items.Add('OK');
      except
        on e: Exception do
          Memo2.Lines.Add(e.Message);
      end;
      Items.Add('');
    end;
  end;

begin
  if Self.chkOverwrite.Checked then
  begin
    sl := TStringList.Create;
    cdsTmp := TADOQuery.Create(nil);
    try
      Self.LoadTableIndexs(cdsTmp, strTable);
      with cdsTmp do
      begin
        First;
        while not Eof do
        begin
          if FieldByName('IsPK_').AsString = 'Yes' then
            str := Format('ALTER TABLE %s DROP CONSTRAINT %s',
              [strTable, FieldByName('IndexName_').AsString])
          else
            str := Format('DROP INDEX %s ON %s',
              [FieldByName('IndexName_').AsString, strTable]);
          if sl.IndexOf(str) = -1 then
          begin
            AddCommand(str);
            sl.Add(str);
          end;
          Next;
        end;
      end;
    finally
      cdsTmp.Free;
      sl.Free;
    end;
  end;
  //
  s1 := '';
  sl := TStringList.Create;
  try
    sl.LoadFromFile(IndexFile);
    for i := 0 to sl.Count - 1 do
    begin
      str := Trim(sl.Strings[i]);
      if str <> '' then
      begin
        if str = 'GO' then
        begin
          AddCommand(Trim(s1));
          s1 := '';
        end
        else if Copy(str, 1, 2) <> '/*' then
        begin
          s1 := s1 + str;
        end;
      end;
    end;
    if s1 <> '' then
    begin
      AddCommand(Trim(s1));
    end;
  finally
    sl.Free;
  end;
end;

procedure TFrmRebuildIndexs.TabSheet2Show(Sender: TObject);
var
  strFile: String;
begin
  Memo1.Lines.Clear;
  with cdsView do
  begin
    strFile := FieldByName('IndexFile_').AsString;
    if (strFile <> '') and FileExists(strFile) then
    begin
      Memo1.Lines.Clear;
      Memo1.Lines.LoadFromFile(strFile);
    end;
  end;
end;

procedure TFrmRebuildIndexs.TabSheet4Show(Sender: TObject);
var
  i: Integer;
  strTable: String;
begin
  strTable := cdsView.FieldByName('Table_').AsString;
  if strTable <> '' then
    try
      Screen.Cursor := crHourGlass;
      oCn.Connected := False;
      oCn.ConnectionString := Format('Provider=SQLOLEDB.1;Password=%s;' +
          'Persist Security Info=True;User ID=%s;Initial Catalog=%s;' +
          'Data Source=%s', [edtPassword.Text, edtAccount.Text,
        cboDatabase.Text, edtServer.Text]);
      oCn.Connected := True;
      LoadTableIndexs(cdsIndexs, strTable);
      for i := 0 to DBGrid2.Columns.Count - 1 do
        DBGrid2.Columns.Items[i].Width := 145;
    finally
      Screen.Cursor := crDefault;
    end;
end;

procedure TFrmRebuildIndexs.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  cdsView.CreateDataSet;
  Memo2.Lines.Clear;
  edtIndexPath.Text := ExtractFilePath(Application.ExeName) + 'Indexs';
end;

end.
