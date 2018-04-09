unit MemoFra;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DB, DBClient, Buttons, Variants, ZjhCtrls, DocCtrls,
  Grids, DBGrids, Mask, ExtCtrls, ErpTools, ComCtrls, ADODB, DBForms,
  uBaseIntf;

type
  TFraMemo = class(TFrame)
    dsRemark: TDataSource;
    cdsRemark: TZjhDataSet;
    cdsRemarkID_: TGuidField;
    cdsRemarkTID_: TSmallintField;
    cdsRemarkAppUser_: TWideStringField;
    cdsRemarkAppDate_: TDateTimeField;
    cdsRemarkTableName_: TWideStringField;
    cdsRemarkRemark_: TWideMemoField;
    cdsRemarkMemo1_: TWideMemoField;
    cdsRemarkMemo2_: TWideMemoField;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    memFraRemark: TDBMemo;
    Panel2: TPanel;
    Label1: TLabel;
    TabSheet2: TTabSheet;
    memFraMemo1: TDBMemo;
    Panel5: TPanel;
    Label2: TLabel;
    TabSheet3: TTabSheet;
    Panel6: TPanel;
    Label3: TLabel;
    memFraMemo2: TDBMemo;
    TabSheet4: TTabSheet;
    Panel7: TPanel;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    DBGrid1: TDBGrid;
    cdsFileCode: TZjhDataSet;
    dsFileCode: TDataSource;
    OpenDialog1: TOpenDialog;
    sbAppend: TSpeedButton;
    sbDelete: TSpeedButton;
    sbSave: TSpeedButton;
    sbSaveFile: TSpeedButton;
    SaveDialog1: TSaveDialog;
    cdsFileCodeClass_: TIntegerField;
    cdsFileCodePID_: TGuidField;
    cdsFileCodeID_: TGuidField;
    cdsFileCodeGroup_: TWideStringField;
    cdsFileCodeFileName_: TWideStringField;
    cdsFileCodeFileTime_: TDateTimeField;
    cdsFileCodeRemark_: TWideMemoField;
    cdsFileCodeSize_: TFloatField;
    cdsFileCodeLink_: TGuidField;
    cdsFileCodeHID_: TGuidField;
    cdsFileCodeVer_: TSmallintField;
    cdsFileCodeLock_: TBooleanField;
    cdsFileCodeSmallIcon_: TBlobField;
    cdsFileCodeAppDate_: TDateTimeField;
    cdsFileCodeAppUser_: TWideStringField;
    cdsFileCodeUpdateKey_: TGuidField;
    cdsRemarkUpdateKey_: TGuidField;
    procedure cdsRemarkBeforePost(DataSet: TDataSet);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbAppendClick(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure cdsFileCodeBeforeInsert(DataSet: TDataSet);
    procedure cdsFileCodeAfterOpen(DataSet: TDataSet);
    procedure sbSaveFileClick(Sender: TObject);
  private
    { Private declarations }
    s: TZjhSkin;
    Flag: Integer;
    m_Table, m_Key: String;
    FReadOnly: Boolean;
    FCorpCode: String;
    procedure SetMasterKey(const Value: String);
    procedure SetStatus(bEnabled: Boolean);
    procedure SetReadOnly(const Value: Boolean);
    procedure cdsFileCodeVer_GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure SetCorpCode(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override; //当第一次显示时被调用
    destructor Destroy; override;
    procedure Init(const ATable: String; const TranMode: Boolean);
    //property MasterKey: String read m_Key write SetMasterKey;
  public
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property CorpCode: String read FCorpCode write SetCorpCode;
    procedure NewRecord(const AKey, AName: String);
    procedure DeleteRecord(const AKey: String);
    procedure SaveRecord;
    function GotoRecord(const AKey: Variant): Boolean; overload;
    function GotoRecord(ADataSet: TZjhDataSet; const AField: Variant): Boolean; overload;
  end;

implementation

uses MainData, ApConst;

{$R *.dfm}

constructor TFraMemo.Create(AOwner: TComponent);
begin
  s := TZjhSkin.Create(AOwner.Owner);
  s.AutoStart := False;
  inherited Create(AOwner.Owner);
  Self.Parent := AOwner as TWinControl;
  Self.Align := alClient;
  Self.Visible := True;
  cdsRemark.RemoteServer := DM.DCOM;
  cdsFileCode.RemoteServer := DM.DCOM;
end;

destructor TFraMemo.Destroy;
begin
  if Assigned(s) then s.Free;
  inherited;
end;

procedure TFraMemo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  s.Refresh(Self);
end;

procedure TFraMemo.Init(const ATable: String; const TranMode: Boolean);
begin
  m_Table := ATable;
  if not TranMode then
  begin
    TabSheet2.Free;
    TabSheet3.Free;
    PageControl1.ActivePageIndex := 0;
  end;
end;

procedure TFraMemo.cdsRemarkBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('AppDate_').AsDateTime := Now();
end;

procedure TFraMemo.SpeedButton2Click(Sender: TObject);
var
  iSize: Double;
  DocImport: TImportFiles;
  strFile, FName, FID: String;
  MYear, MMonth, MDay: Word;
begin
  if m_Key = '' then Exit;
  {$IFDEF DEBUG}
  if m_Table = '' then
    Raise Exception.Create(Chinese.AsString('程式设计失误：没有呼叫FraMemo1.Init(<TableName>)'));
  {$ENDIF}
  if not OpenDialog1.Execute then Exit;
  strFile := OpenDialog1.FileName;
  FName := ExtractFileName(strFile);
  DecodeDate(Date(), MYear, MMonth, MDay);
  try
    FID := NewGuid();
    DocImport := TImportFiles.Create;
    try
      iSize := DocImport.ImportFile(strFile, FID, SOURCE_WORKFLOW);
    finally
      DocImport.Free;
    end;
    with cdsFileCode do
    begin
      Tag := 1;
      Append();
      FieldByName('Class_').AsInteger := FILE_CLASS_REMARK;
      FieldByName('PID_').AsString := m_Key;
      FieldByName('ID_').AsString := FID;
      FieldByName('FileName_').AsString := FName;
      FieldByName('FileTime_').AsDateTime := FileDateToDateTime(FileAge(StrFile));
      FieldByName('Size_').AsFloat := iSize;
      FieldByName('Group_').AsString := 'Source=' + m_Table;
      FieldByName('Ver_').AsInteger := 0;
      FieldByName('AppDate_').AsDateTime := Now();
      FieldByName('AppUser_').AsString := DM.Account;
      Tag := 0;
      PostPro(0);
    end;
  except
    on E: Exception do MsgBox(E.Message);
  end;
end;

procedure TFraMemo.SetCorpCode(const Value: String);
begin
  FCorpCode := Value;
end;

procedure TFraMemo.SetMasterKey(const Value: String);
begin
  if m_Key = Value then
    Exit;
  m_Key := Value;
  if m_Key = '' then
  begin
    if cdsFileCode.Active then cdsFileCode.Close;
    if cdsRemark.Active then cdsRemark.Close;
    Exit;
  end;
  //Refresh FileCode;
  with cdsFileCode do
  begin
    Active := False;
    if FCorpCode <> '' then Database := FCorpCode;
    CommandText := 'Select * from FileCode Where PID_=''' + m_Key + '''';
    if Flag = 1 then CreateDataSet; // New Record
    Open;
  end;
  with cdsRemark do
  begin
    Active := False;
    if FCorpCode <> '' then Database := FCorpCode;
    CommandText := 'Select * from Remark Where ID_=''' + m_Key + '''';
    if Flag = 1 then CreateDataSet; // New Record
    Open;
    SetStatus(not Eof);
  end;
end;

procedure TFraMemo.cdsFileCodeVer_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Format('%d',[-Sender.AsInteger]);
end;

procedure TFraMemo.SpeedButton3Click(Sender: TObject);
var
  FID: String;
begin
  if m_Key = '' then Exit;
  FID := cdsFileCode.FieldByName('ID_').AsString;
  if FID <> '' then
  begin
    CM.ExecSQL(Format('Update FileImage Set PID_=''%s'' Where PID_=''%s''',
      [GuidNull,FID]));
    CM.ExecSQL('Delete FileCode Where ID_=''' + FID + '''');
    cdsFileCode.Delete;
    cdsFileCode.MergeChangeLog;
    cdsFileCode.First;
  end;
end;

procedure TFraMemo.SpeedButton1Click(Sender: TObject);
var
  vd: TViewDocument;
  FID, strFile: String;
begin
  if not cdsFileCode.Active then Exit;
  if cdsFileCode.RecordCount > 0 then
  begin
    FID := cdsFileCode.FieldByName('ID_').AsString;
    strFile := cdsFileCode.FieldByName('FileName_').AsString;
    vd := TViewDocument.Create(Self);
    try
      if FCorpCode <> '' then vd.Database := FCorpCode;
      vd.Browser(Self,FID,strFile,[vfPrint]);
    finally
      vd.Free;
    end;
  end;
end;

procedure TFraMemo.sbAppendClick(Sender: TObject);
begin
  with cdsRemark do
  begin
    if not Active then Exit;
    if ReadOnly then Exit;
    if RecordCount = 0 then
    begin
      Append;
      FieldByName('ID_').AsString := m_Key;
      FieldByName('AppUser_').AsString := DM.Account;
      FieldByName('AppDate_').AsDateTime := Now();
      PostPro(0);
    end;
    SetStatus(True);
  end;
end;

procedure TFraMemo.sbSaveClick(Sender: TObject);
begin
  if cdsRemark.Active then cdsRemark.PostPro(0);
end;

procedure TFraMemo.sbDeleteClick(Sender: TObject);
begin
  if MessageDlg(Chinese.AsString('您确定要删除备注吗?')
    ,mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    with cdsRemark do
    begin
      if RecordCount > 0 then Delete;
      PostPro(0);
    end;
    SetStatus(False);
  end;
end;

procedure TFraMemo.PageControl1Change(Sender: TObject);
var
  oParent: TWinControl;
begin
  oParent := nil;
  case PageControl1.ActivePageIndex of
  0: oParent := Panel2;
  1: oParent := Panel5;
  2: oParent := Panel6;
  end;
  if not Assigned(oParent) then Exit;
  sbAppend.Parent := oParent;
  sbDelete.Parent := oParent;
  sbSave.Parent := oParent;
end;

procedure TFraMemo.SetStatus(bEnabled: Boolean);
begin
  sbAppend.Enabled := not bEnabled;
  sbDelete.Enabled := bEnabled;
  sbSave.Enabled := bEnabled;
  memFraRemark.Enabled := bEnabled;
  if PageControl1.PageCount > 2 then
  begin
    memFraMemo1.Enabled := bEnabled;
    memFraMemo2.Enabled := bEnabled;
  end;
  if bEnabled then
    begin
      memFraRemark.Color := clWhite;
      if PageControl1.PageCount > 2 then
      begin
        memFraMemo1.Color := clWhite;
        memFraMemo2.Color := clWhite;
      end;
    end
  else
    begin
      memFraRemark.Color := clBtnFace;
      if PageControl1.PageCount > 2 then
      begin
        memFraMemo1.Color := clBtnFace;
        memFraMemo2.Color := clBtnFace;
      end;
    end;
end;

procedure TFraMemo.DeleteRecord(const AKey: String);
begin
  sbDeleteClick(Self);
end;

procedure TFraMemo.NewRecord(const AKey, AName: String);
begin
  Flag := 1;
  try
    SetMasterKey(AKey);
    with cdsRemark do
    begin
      if not Active then CreateDataSet;
      if ReadOnly then ReadOnly := False;
      Append;
      FieldByName('ID_').AsString := AKey;
      FieldByName('TID_').AsInteger := 0;
      FieldByName('AppUser_').AsString := DM.Account;
      FieldByName('AppDate_').AsDateTime := Now();
      FieldByName('TableName_').AsString := AName;
      {$message '提示：此处存在错误未解决！ Jason 2003.7.19'}
      {
      if DM.cdsTranT.Active then
      begin
        FieldByName('Remark_').AsString := DM.cdsTranT.FieldByName('Remark_').AsString;
        FieldByName('Memo1_').AsString := DM.cdsTranT.FieldByName('Memo1_').AsString;
        FieldByName('Memo2_').AsString := DM.cdsTranT.FieldByName('Memo2_').AsString;
      end;
      }
      Post;
    end;
  finally
    Flag := 0;
  end;
end;

procedure TFraMemo.SaveRecord;
begin
  sbSaveClick(Self);
end;

procedure TFraMemo.SetReadOnly(const Value: Boolean);
begin
  Self.FReadOnly := Value;
  Self.cdsRemark.ReadOnly := Value;
  Self.sbAppend.Visible := not Value;
  Self.sbDelete.Visible := not Value;
  Self.sbSave.Visible := not Value;
  Self.cdsFileCode.ReadOnly := Value;
  Self.SpeedButton2.Visible := not Value;
  Self.SpeedButton3.Visible := not Value;
end;

procedure TFraMemo.cdsFileCodeBeforeInsert(DataSet: TDataSet);
begin
  if DataSet.Tag = 0 then Abort;
end;

procedure TFraMemo.cdsFileCodeAfterOpen(DataSet: TDataSet);
begin
  TIntegerField(DataSet.FieldByName('Ver_')).OnGetText := cdsFileCodeVer_GetText;
end;

function TFraMemo.GotoRecord(const AKey: Variant): Boolean;
begin
  SetMasterKey(AKey);
  if cdsRemark.Active and cdsFileCode.Active then
    Result := (cdsRemark.RecordCount + cdsFileCode.RecordCount) > 0
  else
    Result := False;
end;

function TFraMemo.GotoRecord(ADataSet: TZjhDataSet; const AField: Variant): Boolean;
begin
  Result := False;
  if ADataSet.Active then
    begin
      SetMasterKey(ADataSet.FieldByName(AField).AsString);
      if cdsRemark.Active and cdsFileCode.Active then
        Result := (cdsRemark.RecordCount + cdsFileCode.RecordCount) > 0;
    end
  else
    begin
      cdsRemark.Active := False;
      Exit;
    end;
  SetReadOnly(ADataSet.ReadOnly);
end;

procedure TFraMemo.sbSaveFileClick(Sender: TObject);
var
  ef: TExportFiles;
  FID, strFile: String;
  Sec: TZjhTool;
begin
  if not cdsFileCode.Active then Exit;
  if cdsFileCode.RecordCount > 0 then
  begin
    Sec := GetSec(Self);
    if not Assigned(Sec) then
      Raise Exception.Create(Chinese.AsString('当前不支持文件下载！'));
    if not Sec.Pass('DownFile',True) then Exit;
    FID := cdsFileCode.FieldByName('ID_').AsString;
    strFile := cdsFileCode.FieldByName('FileName_').AsString;
    SaveDialog1.FileName := strFile;
    SaveDialog1.DefaultExt := ExtractFileExt(strFile);
    if SaveDialog1.Execute then
    begin
      ef := TExportFiles.Create;
      try
        if FCorpCode <> '' then ef.Database := FCorpCode;
        ef.OutputFile := SaveDialog1.FileName;
        ef.ExportFile(FID,strFile);
        MsgBox(Chinese.AsString('文件下载完成！'));
      finally
        ef.Free;
      end;
    end;
  end;
end;

initialization
  RegClass(TFraMemo);

finalization
  UnRegclass(TFraMemo);

end.
