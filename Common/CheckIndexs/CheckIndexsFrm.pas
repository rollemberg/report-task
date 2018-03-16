unit CheckIndexsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB, StdCtrls, Grids, DBGrids, DBClient, ComCtrls;

type
  TFrmCheckIndexs = class(TForm)
    qSQL: TADOQuery;
    oCn: TADOConnection;
    Button1: TButton;
    cdsView: TClientDataSet;
    dsView: TDataSource;
    cdsViewTable_: TStringField;
    cdsViewCount_: TIntegerField;
    cdsViewUpdateKey_: TBooleanField;
    Label1: TLabel;
    edtServer: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtAccount: TEdit;
    Label4: TLabel;
    edtPassword: TEdit;
    Button2: TButton;
    cboDatabase: TComboBox;
    ListView1: TListView;
    cdsViewDatabase_: TStringField;
    PageControl1: TPageControl;
    当前SQL指令: TTabSheet;
    执行检查结果: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Button3: TButton;
    dsCurJob: TDataSource;
    adoCurJob: TADOQuery;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cboDatabaseChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    function ExistsUpdateKey(const strTable: String): Boolean;
    function GetTableCount(const strTable: String): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmCheckIndexs.Button1Click(Sender: TObject);
var
  i: Integer;
  ct: Integer;
  sl: TStringList;
  uk: Boolean;
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
        uk := ExistsUpdateKey(sl.Strings[i]);
        if not uk then
        begin
          ct := GetTableCount(sl.Strings[i]);
          Append;
          FieldByName('Database_').AsString := cboDatabase.Text;
          FieldByName('Table_').AsString := sl.Strings[i];
          FieldByName('Count_').AsInteger := ct;
          FieldByName('UpdateKey_').AsBoolean := uk;
          Post;
        end;
        Application.ProcessMessages;
      end;
  finally
    sl.Free;
  end;
end;

procedure TFrmCheckIndexs.Button2Click(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
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
  ListView1.Items.Clear;
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
        Item := ListView1.Items.Add;
        Item.Caption := FieldByName('Name').AsString;
        Item.Checked := cboDatabase.Text = Item.Caption;
        Next;
      end;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TFrmCheckIndexs.Button3Click(Sender: TObject);
begin
  with adoCurJob do
  begin
    Active := False;
    SQL.Text := 'exec master..dba_WhatSQLIsExecuting';
    Open;
  end;
end;

procedure TFrmCheckIndexs.cboDatabaseChange(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    Item := ListView1.Items.Item[i];
    Item.Checked := Item.Caption = cboDatabase.Text;
  end;
end;

function TFrmCheckIndexs.ExistsUpdateKey(const strTable: String): Boolean;
var
  cdsTmp: TADOQuery;
begin
  cdsTmp := TADOQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.oCn;
      SQL.Add('SELECT ');
      SQL.Add('CASE WHEN b.keyno = 1 THEN c.name ELSE '''' END AS TableName,');
      SQL.Add(
        'CASE WHEN b.keyno = 1 THEN a.name ELSE '''' END AS IndexName, d.name AS ColumnName ');
      SQL.Add('FROM dbo.sysindexes a INNER JOIN ');
      SQL.Add(
        'dbo.sysindexkeys b ON a.id = b.id AND a.indid = b.indid INNER JOIN ');
      SQL.Add(
        'dbo.syscolumns d ON b.id = d.id AND b.colid = d.colid INNER JOIN ');
      SQL.Add(
        'dbo.sysobjects c ON a.id = c.id AND c.xtype = ''U'' LEFT OUTER JOIN ');
      SQL.Add(
        'dbo.sysobjects e ON e.name = a.name AND e.xtype = ''UQ'' LEFT OUTER JOIN ');
      SQL.Add('dbo.sysobjects p ON p.name = a.name AND p.xtype = ''PK'' ');
      SQL.Add(
        'WHERE (OBJECTPROPERTY(a.id, N''IsUserTable'') = 1) AND (OBJECTPROPERTY(a.id, ');
      SQL.Add(
        'N''IsMSShipped'') = 0) AND (INDEXPROPERTY(a.id, a.name, ''IsAutoStatistics'') = 0) ');
      SQL.Add(Format('and c.name=''%s'' and d.name=''UpdateKey_'' ',
          [strTable]));
      SQL.Add('ORDER BY c.name, a.name, b.keyno ');
      Open;
      Result := not Eof;
    end;
  finally
    cdsTmp.Free;
  end;
end;

function TFrmCheckIndexs.GetTableCount(const strTable: String): Integer;
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

procedure TFrmCheckIndexs.FormCreate(Sender: TObject);
begin
  cdsView.CreateDataSet;
end;

end.
