unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AppUtils2, Grids, DBGrids, DB, DBClient, ZjhCtrls,
  Buttons, ComCtrls, ADODB, AppDB2, AppSync;

type
  TFrmMain = class(TForm)
    cdsView: TZjhDataSet;
    dsView: TDataSource;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    cdsViewCorpNo_: TWideStringField;
    cdsViewGroup_: TWideStringField;
    cdsViewRetNo_: TWideStringField;
    cdsViewRetName_: TWideStringField;
    cdsViewParam_: TWideMemoField;
    Panel3: TPanel;
    Label4: TLabel;
    cboRemoteHost: TComboBox;
    Label5: TLabel;
    edtRemoteUser: TEdit;
    Label6: TLabel;
    edtRemotePwd: TEdit;
    BitBtn3: TBitBtn;
    DBGrid2: TDBGrid;
    cdsDBList: TZjhDataSet;
    dsDBList: TDataSource;
    cdsDBListDatabase_: TWideStringField;
    cdsDBListHost_: TWideStringField;
    cdsDBListPassword_: TWideStringField;
    cdsDBListAccount_: TWideStringField;
    cdsDBListPortNo_: TWideStringField;
    cdsDBListDBUID_: TWideStringField;
    cdsViewDBUID_: TWideStringField;
    cdsSQL: TZjhDataSet;
    cdsViewVer_: TWideStringField;
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure cdsViewParam_GetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function setReportDate(cdsTmp: TAppDataSet; difTime: Integer): Boolean;
  public
    { Public declarations }
    procedure ReadDBList;
    procedure ReadReportList;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.BitBtn3Click(Sender: TObject);
var
  dReadOnly: Boolean;
begin
  __ServerIP := cboRemoteHost.Text;
  dReadOnly := loginToVine(edtRemoteUser.Text,edtRemotePwd.Text);
  BitBtn3.Enabled := not dReadOnly;
  cboRemoteHost.Enabled := not dReadOnly;
  edtRemoteUser.ReadOnly := dReadOnly;
  edtRemotePwd.ReadOnly := dReadOnly;
  ReadDBList;
  ReadReportList;
  Button1.Enabled := dReadOnly;
  //if dReadOnly then showmessage('成功連接');
end;

procedure TFrmMain.Button1Click(Sender: TObject);
var
  TSync: TAppSync;
begin
  if __SessionID = '' then
  begin
    ShowMessage('请先登录');
    Exit;
  end;
  TSync := TAppSync.Create;
  try
    TSync.Init;
    TSync.ReadDBList;
    TSync.ReadReportList;
    TSync.Exec;
    TSync.Destroy;
  finally
    TSync.Free;
  end;
end;

procedure TFrmMain.cdsViewParam_GetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Sender.AsWideString;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  cdsView.CreateDataSet;
  cdsDBList.CreateDataSet;
  cboRemoteHost.Text :='127.0.0.1:8080';//'c1.knowall.cn';
  edtRemoteUser.Text := '91100123';
  edtRemotePwd.Text := '123456';
end;

procedure TFrmMain.ReadReportList;
var
  app: IAppService;
begin
  app := Service('SvrERPSyncReport.getReportList');
  if app.Exec then
    begin
      cdsView.EmptyDataSet;
      with app.DataOut do
      begin
        First;
        while not Eof do
        begin
          cdsView.Append;
          cdsView.FieldByName('DBUID_').AsString := FieldByName('DBID_').AsString;
          cdsView.FieldByName('CorpNo_').AsString := FieldByName('CorpNo_').AsString;
          cdsView.FieldByName('Group_').AsString := FieldByName('Group_').AsString;
          cdsView.FieldByName('RetNo_').AsString := FieldByName('RetNo_').AsString;
          cdsView.FieldByName('RetName_').AsString := FieldByName('RetName_').AsString;
          cdsView.FieldByName('Param_').AsString := FieldByName('Param_').AsString;
          cdsView.FieldByName('Ver_').AsString := FieldByName('Ver_').AsString;
          cdsView.Post();
          Next;
        end;
      end;
    end
  else
    ShowMessage(app.Messages);
end;

function TFrmMain.setReportDate(cdsTmp: TAppDataSet; difTime: Integer): Boolean;
var
  app: IAppService;
begin
  Result := False;
  app := Service('SvrERPSyncReport.setReportDate');
  app.DataIn.Append();
  app.DataIn.FieldByName('RetNo_').AsString := cdsView.FieldByName('RetNo_').AsString;
  app.DataIn.FieldByName('TDate_').AsDateTime := Date();
  app.DataIn.FieldByName('Status_').AsInteger := 1;
  app.DataIn.FieldByName('Value_').AsString := cdsTmp.JSON.AsString;
  app.DataIn.FieldByName('ErrorMsg_').AsString := '';
  app.DataIn.FieldByName('Remark_').AsString := '';
  app.DataIn.FieldByName('Times_').AsInteger := difTime;
  app.DataIn.FieldByName('Ver_').AsString := cdsView.FieldByName('Ver_').AsString;
  app.DataIn.FieldByName('Database_').AsString := cdsDBList.FieldByName('Database_').AsString;
  if app.Exec then
    Result := True
  else
    ShowMessage(app.Messages);
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

end.
