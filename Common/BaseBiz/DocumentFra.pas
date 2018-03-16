unit DocumentFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Buttons, StdCtrls, ExtCtrls, DB, DBClient, ZjhCtrls, DBForms,
  uBaseIntf, ErpTools;

type
  TFraDocument = class(TFrame, IFraDocument)
    cdsFileCode: TZjhDataSet;
    dsFileCode: TDataSource;
    Panel2: TPanel;
    lblDirTitle: TLabel;
    sbView: TSpeedButton;
    sbAppend: TSpeedButton;
    sbDelete: TSpeedButton;
    DBGrid3: TDBGrid;
    OpenDialog1: TOpenDialog;
    procedure sbViewClick(Sender: TObject);
    procedure sbAppendClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure cdsFileCodeAfterOpen(DataSet: TDataSet);
    procedure cdsFileCodeAfterClose(DataSet: TDataSet);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure cdsFileCodeLock_GetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    FPathID: String;
    FRootID: String;
    FRootName: String;
    FDefRootName: String;
    FPathName: String;
    FReadOnly: Boolean;
    FActive: Boolean;
    FPathExists: Boolean;
    function CurPathID: String;
    function Pass(const AType: String; bShowError: Boolean): Boolean;
  public
    { Public declarations }
    function GetActive: Boolean;
    function GetDefRootName: String;
    function GetPathName: String;
    function GetReadOnly: Boolean;
    function GetRootID: String;
    function GetRootName: String;
    //
    procedure SetActive(const Value: Boolean);
    procedure SetDefRootName(const Value: String);
    procedure SetPathName(const Value: String);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetRootID(const Value: String);
    procedure SetRootName(const Value: String);
    //
    property DefRootName: String read GetDefRootName write SetDefRootName;
    property RootID: String read GetRootID write SetRootID;
    property RootName: String read GetRootName write SetRootName;
    property PathName: String read GetPathName write SetPathName;
    property Active: Boolean read GetActive write SetActive;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  public
    { Public declarations }
    function AddItem(const strFile, NewFileName: String): Boolean;
    function GetItem(const strFile: String): Boolean;
    function DeleteItem(const strFile: String): Boolean;
    constructor Create(AOwner: TComponent); override;
    procedure RefreshView(const Flag: Boolean);
    function own: TFrame;
  end;

implementation

uses MainData, DocCtrls, ApConst;

{$R *.dfm}

constructor TFraDocument.Create(AOwner: TComponent);
begin
  inherited;
  FDefRootName := 'Temp';
  FRootID := DOC_TEMP_GUID;
  lblDirTitle.Caption := Format(Chinese.AsString('附件存放地址：%s'),['Temp']);
end;

function TFraDocument.CurPathID: String;
begin
  if (PathName <> '') and (PathName <> '..') then
    Result := FPathID
  else
    Result := RootID;
end;

procedure TFraDocument.sbDeleteClick(Sender: TObject);
var
  FID: String;
begin
  if Self.Pass('Delete', True) then
  begin
    FID := cdsFileCode.FieldByName('ID_').AsString;
    if FID <> '' then
    begin
      CM.ExecSQL('Delete FileImage Where PID_=''' + FID + '''');
      CM.ExecSQL('Delete FileCode Where ID_=''' + FID + '''');
      cdsFileCode.Delete;
      cdsFileCode.MergeChangeLog;
      cdsFileCode.First;
    end;
  end;
end;

procedure TFraDocument.sbViewClick(Sender: TObject);
var
  vd: TViewDocument;
  FID, strFile: String;
begin
  if cdsFileCode.RecordCount > 0 then
  begin
    FID := cdsFileCode.FieldByName('ID_').AsString;
    strFile := cdsFileCode.FieldByName('FileName_').AsString;
    vd := TViewDocument.Create(Self);
    try
      vd.Browser(Self,FID,strFile,[]);
    finally
      vd.Free;
    end;
  end;
end;

procedure TFraDocument.sbAppendClick(Sender: TObject);
var
  strFile, strPath: String;
begin
  if Self.Pass('Append', True) then
  begin
    if OpenDialog1.Execute then
    begin
      strPath := ExtractFilePath(OpenDialog1.FileName);
      strFile := ErpInput(Chinese.AsString('重命名(排序)'),
        Chinese.AsString('请输入新的文件名：'), ExtractFileName(OpenDialog1.FileName), GuidNull);
      if strFile <> GuidNull then
      begin
        if ExtractFileExt(OpenDialog1.FileName) = ExtractFileExt(strFile) then
          begin
            if strFile = '' then
              strFile := ExtractFileName(OpenDialog1.FileName);
            if not cdsFileCode.Locate('FileName_', strFile, [loCaseInsensitive]) then
              AddItem(OpenDialog1.FileName, strFile)
            else
              MsgBox(Format(Chinese.AsString('文件名 %s 已经存在，请重新输入！'), [strFile]));
          end
        else
          MsgBox(Chinese.AsString('对不起，您不能修改此文件的扩展名！'));
      end;
    end;
  end;
end;

procedure TFraDocument.cdsFileCodeAfterOpen(DataSet: TDataSet);
var
  sField: TField;
begin
  sbAppend.Visible := DataSet.Active;
  sbDelete.Visible := DataSet.Active;
  sbView.Visible   := DataSet.Active and (DataSet.RecordCount > 0);
  sField := DataSet.FindField('Lock_');
  if sField is TBooleanField then
    TBooleanField(sField).OnGetText := cdsFileCodeLock_GetText;
end;

procedure TFraDocument.cdsFileCodeLock_GetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := iif(Sender.AsBoolean, 'Yes', '');
end;

procedure TFraDocument.cdsFileCodeAfterClose(DataSet: TDataSet);
begin
  sbView.Visible   := DataSet.Active;
  sbAppend.Visible := DataSet.Active;
  sbDelete.Visible := DataSet.Active;
  lblDirTitle.Caption := Format(Chinese.AsString('附件存放地址：%s'),[PathName]);
end;

procedure TFraDocument.SetReadOnly(const Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    sbAppend.Enabled := not Value;
    sbDelete.Enabled := not Value;
    cdsFileCode.ReadOnly := Value;
    FReadOnly := Value;
  end;
end;

procedure TFraDocument.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraDocument.SetRootID(const Value: String);
var
  str: String;
begin
  if FRootID <> Value then
  begin
    str := CM.DBRead(Format('Select Name_ From DirCode '
      + 'Where ID_=''%s''', [Value]), GuidNull);
    if str = GuidNull then
      begin
        CM.ExecSQL(Format('Insert into DirCode (PID_,ID_,Index_,Name_,Remark_,'
          + 'AppDate_,AppUser_,UpdateKey_,WebShare_) Values '
          + '(''%s'',''%s'',0,''%s'',''%s'',GetDate(),''%s'',NewID(),0)',
          [GuidNull,Value,FDefRootName,Chinese.AsString('此目录由系统自动建立，不得随意删除。'),DM.Account]));
        RootName := FDefRootName;
      end
    else
      RootName := str;
    FRootID := Value;
    if Active then RefreshView(True);
  end;
end;

procedure TFraDocument.SetRootName(const Value: String);
begin
  if FRootName <> Value then
  begin
    if (PathName <> '') and (PathName <> '..') then
      lblDirTitle.Caption := Format(Chinese.AsString('附件存放地址：%s'),[Value + '\' + PathName])
    else
      lblDirTitle.Caption := Format(Chinese.AsString('附件存放地址：%s'),[Value]);
    FRootName := Value;
  end;
end;

procedure TFraDocument.SetPathName(const Value: String);
begin
  if FPathName <> Value then
  begin
    FPathName := Value;
    if Value <> '' then
      begin
        FPathID := CM.DBRead(Format('Select ID_ From DirCode '
          + 'Where PID_=''%s'' and Name_=''%s''',[RootID, Value]),GuidNull);
        if FPathID = GuidNull then
          begin
            FPathID := NewGuid();
            FPathExists := False;
          end
        else
          FPathExists := True;
        if (Value <> '') and (Value <> '..') then
          lblDirTitle.Caption := Format(Chinese.AsString('附件存放地址：%s'),[RootName + '\' + Value])
        else
          lblDirTitle.Caption := Format(Chinese.AsString('附件存放地址：%s'),[RootName]);
        if Active then RefreshView(True);
      end
    else
      begin
        if Active then RefreshView(False);
        FPathID := '';
        FPathExists := False;
      end;
  end;
end;

procedure TFraDocument.DBGrid3DblClick(Sender: TObject);
begin
  sbView.Click;
end;

procedure TFraDocument.RefreshView(const Flag: Boolean);
begin
  if Flag then
    with cdsFileCode do
    begin
      Active := False;
      if PathName <> '' then
      begin
        if PathName <> '..' then
          CommandText := 'Select * from FileCode Where PID_=''' + FPathID + ''''
        else
          CommandText := 'Select * from FileCode Where PID_=''' + RootID + '''';
        CommandText := CommandText + ' Order by FileName_';
        Open;
      end;
    end
  else
    with cdsFileCode do
    begin
      if not Active then Exit;
      if State in [dsInsert, dsEdit] then Post;
      if (ChangeCount > 0) and (MessageDlg(Chinese.AsString('当前数据没有保存，您真的要保存并退出吗？'),mtConfirmation,
        [mbYes,mbNo,mbCancel],0) = mrYes) then PostPro(0);
      Active := False;
    end;
end;

function TFraDocument.GetActive: Boolean;
begin
  Result := FActive;
end;

function TFraDocument.GetDefRootName: String;
begin
  Result := FDefRootName;
end;

function TFraDocument.GetPathName: String;
begin
  Result := FPathName;
end;

function TFraDocument.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

function TFraDocument.GetRootID: String;
begin
  Result := FRootID;
end;

function TFraDocument.GetRootName: String;
begin
  Result := FRootName;
end;

procedure TFraDocument.SetDefRootName(const Value: String);
begin
  FDefRootName := Value;
end;

function TFraDocument.own: TFrame;
begin
  Result := Self;
end;

function TFraDocument.Pass(const AType: String; bShowError: Boolean): Boolean;
var
  mSec: TZjhTool;
begin
  if Supports(Self.Owner, IBaseForm) then
    begin
      mSec := (Self.Owner as IBaseForm).ISec as TZjhTool;
      if Assigned(mSec) then
        Result := mSec.Pass(AType, bShowError)
      else
        Result := True;
    end
  else
    Result := True;
end;

function TFraDocument.AddItem(const strFile, NewFileName: String): Boolean;
var
  FSize: Double;
  DocImport: TImportFiles;
  MYear, MMonth, MDay: Word;
  FName, FID: String;
begin
  Result := False;
  if NewFileName <> '' then
    FName := NewFileName
  else
    FName := ExtractFileName(strFile);
  DecodeDate(Date(), MYear, MMonth, MDay);
  try
    if not FPathExists then
    begin
      CM.ExecSQL(Format('Insert into DirCode (PID_,ID_,Index_,Name_,Remark_,'
        + 'AppDate_,AppUser_,UpdateKey_,WebShare_) Values '
        + '(''%s'',''%s'',0,''%s'',''%s'',GetDate(),''%s'',NewID(),0)',
        [RootID,FPathID,PathName,Chinese.AsString('此目录由系统自动建立，不得随意删除。'),DM.Account]));
      FPathExists := True;
    end;
    //
    FID := NewGuid();
    //
    with cdsFileCode do
    begin
      Append();
      FieldByName('Class_').AsInteger := 0;
      FieldByName('PID_').AsString := CurPathID;
      FieldByName('ID_').AsString := FID;
      FieldByName('FileName_').AsString := FName;
      FieldByName('FileTime_').AsDateTime := FileDateToDateTime(FileAge(StrFile));
      FieldByName('Size_').AsFloat := 0;
      FieldByName('Ver_').AsInteger := 0;
      FieldByName('Remark_').AsString := '';
      FieldByName('AppDate_').AsDateTime := Now();
      FieldByName('AppUser_').AsString := DM.Account;
      PostPro(0);
    end;
    DocImport := TImportFiles.Create;
    try
      FSize := DocImport.ImportFile(strFile,FID,SOURCE_KMMAGIC);
      cdsFileCode.Edit;
      cdsFileCode.FieldByName('Size_').AsFloat := FSize;
      cdsFileCode.PostPro(0);
    finally
      DocImport.Free;
    end;
    sbView.Visible := True;
    Result := True;
  except
    on E: Exception do MsgBox(E.Message);
  end;
end;

function TFraDocument.DeleteItem(const strFile: String): Boolean;
begin
  Result := False;
  with cdsFileCode do
  begin
    if Active then
    begin
      if Locate('FileName_', strFile, [loCaseInsensitive]) then
      begin
        sbDelete.Click;
        Result := True;
      end;
    end;
  end;
end;

function TFraDocument.GetItem(const strFile: String): Boolean;
var
  ef: TExportFiles;
begin
  Result := False;
  with cdsFileCode do
  begin
    if Active then
    begin
      if Locate('FileName_', ExtractFileName(strFile), [loCaseInsensitive]) then
      begin
        ef := TExportFiles.Create;
        try
          ef.OutputFile := strFile;
          ef.ExportFile(FieldByName('ID_').AsString, strFile);
          Result := True;
        finally
          FreeAndNil(ef);
        end;
      end;
    end;
  end;
end;

initialization
  RegClass(TFraDocument);

finalization
  UnRegClass(TFraDocument);

end.
