unit DocCtrls;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Forms, Controls, DBClient,
  DB, DBGrids, DBCtrls, StdCtrls, Dialogs, ApConst, QuickRpt, ZjhCtrls,
  ComCtrls, ShellAPI, TypInfo, Graphics, Zlib, ExtCtrls, uBaseIntf,
  ShDocVw, Menus, Jpeg, MainData, InfoBox, XmlIntf, XmlDoc;

type
  //Ŀ¼�ڵ��¼
  TFolderRecord = Record
    ID: String;        //Ŀ¼ID
    Name: String;      //Ŀ¼����
    Remark: String;    //��ע����
    WebShare: Boolean; //�Ƿ񷢲���WebShare
  end;

  TKMRecord = Record
    ID: String;
    Index: Integer;
    Size: Integer;
    Data: array of Char;
  end;

  TKMFile = class(TComponent)
  private
    FSource: Integer;
    FSize: Int64;
    FFileID, FFileName: String;
    FPackageCount: Integer;
    FActive: Boolean;
    FDatabase: String;
    function GetPackages(Index: Integer): TKMRecord;
    procedure SetFileID(const Value: String);
    procedure SetFileName(const Value: String);
    procedure SetSource(const Value: Integer);
    procedure SetActive(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
  public
    RemoteServer: TCustomRemoteServer;
    property Active: Boolean read FActive write SetActive;
    property Source: Integer read FSource write SetSource;
    property FileID: String read FFileID write SetFileID;
    property FileName: String read FFileName write SetFileName;
    property PackageCount: Integer read FPackageCount;
    property Packages[Index: Integer]: TKMRecord read GetPackages;
    property Size: Int64 read FSize;
    property Database: String read FDatabase write FDatabase;
    procedure SaveToFile(const strFile: String);
    procedure LoadFromFile(const strFile: String);
  end;
  //�ĵ��Ķ����ӿ�
  IMagicView = interface
    ['{04BDB43D-832E-4286-8365-0D459B56C9B4}']
    procedure SetDatebase(const Value: String);
    procedure Execute(const AID, AName: String; vfValue: TViewFileOptions);
  end;
  TViewDocument = class(TComponent)
  private
    FDatabase: String;
    function GetDatabase: String;
    procedure SetDatebase(const Value: String);
  protected
  public
    property Database: String read GetDatabase write SetDatebase;
    procedure Browser(Sender: TComponent; const AID, AName: String;
      vfValue: TViewFileOptions);
  end;

  TImportCancel = Class(Exception)
  public
    FileID: String;
    constructor Create(const Msg, AFileID: string);
  end;

  //���ļ����뵽 FileImage ��
  TImportFiles = Class
  private
    FDeleteSource, FCanCancel: Boolean;
    FFiles: TStringList;
    FAllowTypes: String;
    CurrentIndex: Integer;
    FOnAfterImport: TNotifyEvent;
    FDatabase: String;
  protected
    function AppendFile(cdsFileCode: TZjhDataSet;
      const strFile: String): Boolean;
  public
    ImportPath, FileGroup, Remark: String;
    DirectoryID,HistoryID: String;
    AutoVersion, OverloadMessage: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function AddFile(const FileName: String): Boolean;
    function ImportFile(const strFile, FileID: String; Source: Integer): Double; virtual;
    function ImportFileEx(const AFolderID, strFile,
      NewName: String): String;
    procedure ImportFiles;
    class procedure EnrollChange(const FileID: String; Operate: Integer);
    class function CreateHistory(const FileID: String): String;
  published
    property AllowTypes: String read FAllowTypes write FAllowTypes;
    property OnAfterImport: TNotifyEvent read FOnAfterImport write FOnAfterImport;
    property DeleteSource: Boolean read FDeleteSource write FDeleteSource default False;
    property CanCancel: Boolean read FCanCancel write FCanCancel default False;
    property Files: TStringList read FFiles write FFiles;
    property Database: String read FDatabase write FDatabase;
  end;

  //�� FileImage �е����ļ�����
  TExportFiles = Class
  private
    FCanCancel: Boolean;
    FOutputFile: String;
    FOutputPath: String;
    FFiles: TStringList;
    FDatabase: String;
    procedure SetOutputPath(const Value: String);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExportFile(const FileID, strFile: String);
    procedure ExportFiles;
  published
    property CanCancel: Boolean read FCanCancel write FCanCancel default False;
    //�ر�ע�⣬�� Files �д���ľ�Ϊ�ļ� ID
    property Files: TStringList read FFiles write FFiles;
    property OutputFile: String read FOutputFile write FOutputFile;
    property OutputPath: String read FOutputPath write SetOutputPath;
    property Database: String read FDatabase write FDatabase;
  end;

  procedure GetFileIcon(SmallIcon: TClientBlobStream;
    const stFileName: String; ICONTYPE: UINT);

implementation

uses ErpTools;

procedure GetFileIcon(SmallIcon: TClientBlobStream;
  const stFileName: String; ICONTYPE: UINT);
var
  LargeIcon: TIcon;
  SHFileInfo: TSHFileInfo;
begin
  LargeIcon := TIcon.Create;
  try
    SHGetFileInfo(PChar(stFileName), 0, SHFileInfo, SizeOf(SHFileInfo),
      SHGFI_ICON or ICONTYPE);
    LargeIcon.Handle := SHFileInfo.hIcon;
    LargeIcon.SaveToStream(SmallIcon);
  finally
    LargeIcon.Free;
  end;
end;

{ TImportCancel }

constructor TImportCancel.Create(const Msg, AFileID: string);
begin
  FileID := AFileID;
  inherited Create(Msg);
end;

{ TImportFiles }

function TImportFiles.AddFile(const FileName: String): Boolean;
var
  strExtName: String;
begin
  Result := False;
  strExtName := UpperCase(ExtractFileExt(FileName));
  if (AllowTypes <> '') then
  begin
    if (strExtName = '') or (Pos(strExtName,AllowTypes) = 0) then
    begin
      //MsgBox('�ļ���' + ExtractFileName(FileName) + ' ��������ķ�Χ[' + AllowTypes + ']֮�ڣ�');
      MsgBox(Chinese.AsString('�ļ���������ķ�Χ֮�ڣ�') + '[' + ExtractFileName(FileName) + ',' + AllowTypes + ']');
      Exit;
    end;
  end;
  if FileExists(FileName) then
  begin
    Files.Add(FileName);
    Result := True;
  end;
end;

constructor TImportFiles.Create;
begin
  CurrentIndex := 0;
  HistoryID := GuidNull;
  AutoVersion := True;
  FFiles := TStringList.Create;
  AllowTypes := UpperCase(CM.DBRead('Select IsNull(AllowFile_,'''') as AllowFile from OA_UserConfig Where '
    + 'UserID_=''' + DM.UserID + '''','',FDatabase));
end;

procedure TImportFiles.Clear;
begin
  CurrentIndex := 0;
  HistoryID := GuidNull;
  FFiles.Clear;
end;

destructor TImportFiles.Destroy;
begin
  FFiles.Free;
  inherited;
end;

procedure TExportFiles.SetOutputPath(const Value: String);
begin
  if (Value <> '') and (Copy(Value,Length(Value),1) <> '\') then
    FOutputPath := Value + '\'
  else
    FOutputPath := Value;
end;

function TImportFiles.ImportFile(const strFile, FileID: String; Source: Integer): Double;//Int64;
var
  DataFile: TFileStream;
  iIndex, iSize: Integer;
  FileImage: TZjhDataSet;
  FData: TClientBlobStream;
  DiskSpace, UsedSpace: Double;
  R: OleVariant;
  Buffer: array[0..MAX_DOCPACKAGE] of Char;
  strMsg: String;
const
  ZipPackage: Char = #1;
begin
  strMsg := Chinese.AsString('���ڵ���� %d ����%s');
  //Result := -1; //Modify by TCS
  DiskSpace := 0; UsedSpace := 0;
  with Buff.GetItem('Common') do
  begin
    Active := False;
    CommandText := Format('Select DiskSpace_,UsedSpace_ '
      + 'From OA_UserConfig Where UserID_=''%s''', [DM.UserID]);
    Open;
    if not Eof then
    begin
      DiskSpace := FieldByName('DiskSpace_').AsFloat;
      UsedSpace := FieldByName('UsedSpace_').AsFloat;
    end;
  end;
  R := NULL;
  if DiskSpace = 0 then
    raise Exception.Create(Chinese.AsString('ϵͳ����Աû��Ϊ��������̿ռ䣬�޷����룡'));  //'ϵͳ����Աû��Ϊ��������̿ռ䣬�޷����룡'
  DataFile := TFileStream.Create(strFile,fmOpenRead);
  if (UsedSpace + DataFile.Size) > DiskSpace then
  begin
    DataFile.Free;
    raise Exception.CreateFmt(Chinese.AsString('����ϵͳ����ԱΪ������Ĵ����޶�[%n]���޷����룡'),[UsedSpace]);  //'����ϵͳ����ԱΪ������Ĵ����޶�[%n]���޷����룡'
  end;
  ibox.Text(Chinese.AsString('���ڵ��룺') + strFile);
  ibox.Max := DataFile.Size;
  //=-1: ��������ֹ��0=������ֹ��1=�ѱ���ֹ
  ibox.JobStop := iif(CanCancel, 0, -1);
  FileImage := TZjhDataSet.Create(Application);
  try
    CM.ExecSQL(Format('Update FileImage Set PID_=''%s'' Where PID_=''%s''',
      [HistoryID,FileID]),FDatabase);
    with FileImage do
    begin
      RemoteServer := DM.DCOM;
      Database := FDatabase;
      TableName := 'FileImage';
      CommandText := ' Select * from FileImage Where ID_ is NULL';
      Open;
      iIndex := 0;
      while DataFile.Position < DataFile.Size do
      begin
        if iIndex mod 100 = 0 then begin Close; Open; end; //ÿһ100�������һ�»���
        iSize := DataFile.Read(Buffer,MAX_DOCPACKAGE);
        ibox.Position := ibox.Position + iSize;
        if ibox.JobStop = 1 then
          raise TImportCancel.Create(Format(Chinese.AsString('�����ļ� %s ����ֹ��'),[strFile]),FileID);
        //if not wat.RefreshW('',0,iSize,True) then
        //  Raise TImportCancel.Create(Format(Chinese.AsString('�����ļ� %s ����ֹ��'),[strFile]),FileID);
        Append;
        FieldByName('PID_').AsString := FileID;
        FieldByName('ID_').AsString := NewGuid();
        FieldByName('Index_').AsInteger := iIndex;
        FieldByName('Source_').AsInteger := SOURCE_KMMAGIC;
        FData := TClientBlobStream.Create(FieldByName('Data_') as TBlobField, bmWrite);
        try
          with TCompressionStream.Create(clDefault,FData) do
          try
            WriteBuffer(ZipPackage,1);
            WriteBuffer(Buffer,iSize);
          finally
            Free;
          end;
          //FData.Write(Buffer, iSize); //��ѹ�����
          FieldByName('Size_').AsInteger := - FData.Size;
        finally
          FData.Free;
        end;
        PostPro(0);
        Inc(iIndex);
      end;
    end;
  finally
    //�ڵ���ϵͳ���Ƴ�Դ�ļ���
    if DeleteSource then DeleteFile(strFile);
    FileImage.Free;
    ibox.Max := 0;
    Result := DataFile.Size;
    DataFile.Free;
  end;
  CM.ExecSQL(Format('Update OA_UserConfig Set UsedSpace_ = UsedSpace_ + %s '
    + 'Where UserID_=''%s''',[FloatToStr(Result),DM.UserID]),FDatabase);
end;

function TImportFiles.ImportFileEx(const AFolderID, strFile, NewName: String): String;
var
  FName, FID: String;
  MYear, MMonth, MDay: Word;
begin
  FName := ExtractFileName(strFile);
  DecodeDate(Date(), MYear, MMonth, MDay);
  try
    FID := NewGuid();
    with TZjhDataSet.Create(DM.DCOM) do
    try
      RemoteServer := DM.DCOM;
      Database := FDatabase;
      TableName := 'FileCode';
      CommandText := 'Select top 0 * from FileCode';
      Open;
      Append();
      FieldByName('Class_').AsInteger := FILE_CLASS_NORAMAL;
      FieldByName('PID_').AsString := AFolderID;
      FieldByName('ID_').AsString := FID;
      if NewName <> '' then
        FieldByName('FileName_').AsString := NewName
      else
        FieldByName('FileName_').AsString := FName;
      FieldByName('FileTime_').AsDateTime := FileDateToDateTime(FileAge(StrFile));
      FieldByName('Size_').AsFloat := ImportFile(strFile, FID, SOURCE_KMMAGIC);
      FieldByName('Ver_').AsInteger := -1;
      FieldByName('AppDate_').AsDateTime := Now();
      FieldByName('AppUser_').AsString := DM.Account;
      PostPro(0);
      Result := FieldByName('ID_').AsString;
    finally
      Free;
    end;
  except
    on E: Exception do MsgBox(E.Message);
  end;
end;

procedure TImportFiles.ImportFiles;
var
  i: Integer;
  strMsg: String;
  cdsFileCode: TZjhDataSet;
const
  SQLCmd: String = 'Select FileName_ from FileCode Where ID_=''%s''';
begin
  if DirectoryID = '' then
    Raise Exception.Create(Chinese.AsString('û�ж����ļ�����Ŀ¼��ִ����ֹ��'));  //'û�ж����ļ�����Ŀ¼��ִ����ֹ��'
  if ImportPath <> '' then
    strMsg := Format(Chinese.AsString('���� %d ����Ŀ�� %s'),[Files.Count,ImportPath])
  else
    strMsg := Format(Chinese.AsString('���� %d ����Ŀ'),[Files.Count]);
  CurrentIndex := 0;
  ibox.Text(strMsg);
  ibox.Text(Chinese.AsString('���ڵ����ļ������Ժ�...'));
  cdsFileCode := TZjhDataSet.Create(Application);
  try
    with cdsFileCode do
    begin
      RemoteServer := DM.DCOM;
      Database := FDatabase;
      TableName := 'FileCode';
      CommandText := 'Select * from FileCode Where PID_=''' + DirectoryID + '''';
      Open;
    end;
    for i := 0 to Files.Count - 1 do
    begin
      CurrentIndex := i + 1;
      if FileExists(Files.Strings[i]) then
      begin
        if not AppendFile(cdsFileCode,Files.Strings[i]) then Exit;
        if Assigned(FOnAfterImport) then FOnAfterImport(Self);
      end;
    end;
  finally
    cdsFileCode.Free;
    CurrentIndex := 0;
  end;
end;

function TImportFiles.AppendFile(cdsFileCode: TZjhDataSet;
  const strFile: String): Boolean;
var
  FSize: Double;
  m_Group, m_Remark: String;
  strFileID, strShortName: String;
  SmallIcon: TClientBlobStream;
begin
  Result := False;
  strShortName := ExtractFileName(strFile);
  try
    with cdsFileCode do
    begin
      if Locate('FileName_',strShortName,[loCaseInsensitive]) then
        begin
          if FieldByName('Lock_').AsBoolean then
            raise Exception.Create(Chinese.AsString('���ĵ��ѱ���������ܸ���!'));
          if OverloadMessage and (MessageDlg(Format(Chinese.AsString('�ļ� %s �Ѿ����ڣ�Ҫ������'),[strShortName]),
            mtConfirmation,[mbYes,mbNo],0) = mrNo) then Exit;
          strFileID := FieldByName('ID_').AsString;
          m_Group := FieldByName('Group_').AsString;
          m_Remark := FieldByName('Remark_').AsString;
          EnrollChange(strFileID,ohOverload);  //������ʷ
          if (not Self.AutoVersion) then
            begin
              HistoryID := GuidNull;
              CM.ExecSQL(Format('Update FileImage Set PID_=''%s'' Where ID_=''%s''',
                [GuidNull,strFileID]));
              Edit;
              FieldByName('AppDate_').AsDatetime := Now();
              FieldByName('AppUser_').AsString := DM.Account;
            end
          else
            begin
              HistoryID := CreateHistory(strFileID); //������ʷ
              Edit;
              FieldByName('Ver_').AsInteger := FieldByName('Ver_').AsInteger - 1;
            end;
        end
      else
        begin
          strFileID := NewGuid();
          HistoryID := GuidNull;
          Append;
          FieldByName('Class_').AsInteger := 0;
          FieldByName('PID_').AsString := DirectoryID;
          FieldByName('ID_').AsString := strFileID;
          FieldByName('AppDate_').AsDatetime := Now();
          FieldByName('AppUser_').AsString := DM.Account;
          FieldByName('Ver_').AsInteger := -1;
        end;
      Edit;
      if Self.FileGroup <> '' then
        FieldByName('Group_').AsString := Self.FileGroup
      else
        FieldByName('Group_').AsString := m_Group;
      if Self.Remark <> '' then
        FieldByName('Remark_').AsString := Self.Remark
      else
        FieldByName('Remark_').AsString := m_Remark;
      FieldByName('FileName_').AsString := strShortName;
      SmallIcon := TClientBlobStream.Create(FieldByName('SmallIcon_') as TBlobField,bmWrite);
      try
        GetFileIcon(SmallIcon, strFile, SHGFI_SMALLICON);
      finally
        SmallIcon.Free;
      end;
      FieldByName('FileTime_').AsDatetime := FileDateToDateTime(FileAge(strFile));
      FieldByName('UpdateKey_').AsString := NewGuid();
      FieldByName('Size_').AsFloat := 0;
      FSize := ImportFile(strFile,strFileID,SOURCE_KMMAGIC);
      if FSize = -1 then
        Raise Exception.Create(Chinese.AsString('�ļ����ڶ��У����ܴ�!'));
      FieldByName('Size_').AsFloat := FSize;
      PostPro(0);
      EnrollChange(strFileID,ohAppend);  //������ʷ
      Result := True;
    end;
  except
    on E: TImportCancel do
      begin
        CM.ExecSQL(Format('Update FileImage Set PID_=''%s'' '
          + 'Where PID_=''%s''',[GuidNull,E.FileID]));
        if not cdsFileCode.Locate('ID_',E.FileID,[]) then MsgBox(Chinese.AsString('�����ش���'));
        cdsFileCode.Delete;
        cdsFileCode.PostPro(0);
        Raise;
      end
    else
      Raise;
  end;
end;

class function TImportFiles.CreateHistory(const FileID: String): String;
var
  HistoryID, SQLCmd: String;
begin
  HistoryID := NewGuid();
  SQLCmd := Format('Insert into FileCode (Class_,PID_,ID_,FileName_,Remark_,FileTime_,'
    + 'HID_,Size_,Ver_,Lock_,SmallIcon_,AppDate_,AppUser_,UpdateKey_) '
    + 'Select Class_,''%s'',''%s'',FileName_,Remark_,FileTime_,'
    + '''%s'',Size_, - Ver_,0,SmallIcon_,AppDate_,AppUser_,NewID() '
    + 'From FileCode Where ID_=''%s''',[FileID,HistoryID,FileID,FileID]);
  CM.ExecSQL(SQLCmd);
  Result := HistoryID;
end;

class procedure TImportFiles.EnrollChange(const FileID: String;
  Operate: Integer);
var
  SQLCmd: String;
begin
  SQLCmd := Format('Insert into FileHistory (DirID_, FileID_, FileName_, '
    + 'FileTime_, Size_, Ver_, AppDate_, AppUser_, Operate_, UpdateKey_ )'
    + 'SELECT PID_, ID_, FileName_, FileTime_, Size_, Ver_, getdate(), '
    + '''%s'', %d, newid() FROM FileCode Where Ver_<=0 and ID_=''%s''',
    [DM.Account,Operate,FileID]);
  CM.ExecSQL(SQLCmd);
end;

{ TExportFiles }

constructor TExportFiles.Create;
begin
  FFiles := TStringList.Create;
end;

destructor TExportFiles.Destroy;
begin
  FFiles.Free;
  inherited;
end;

procedure TExportFiles.ExportFiles;
var
  i: Integer;
  strMsg, strFile: String;
const
  SQLCmd: String = 'Select FileName_ from FileCode Where ID_=''%s''';
begin
  strMsg := Format(Chinese.AsString('���� %d ����Ŀ'),[Files.Count]);
  ibox.Text(strMsg);
  ibox.Text(Chinese.AsString('���������ļ������Ժ�...'));
  for i := 0 to Files.Count - 1 do
  begin
    strFile := CM.DBRead(Format(SQLCmd,[Files.Strings[i]]),'',FDatabase);
    if strFile <> '' then
    begin
      OutputFile := OutputPath + strFile;
      TImportFiles.EnrollChange(Files.Strings[i],ohDownLoad);
      ExportFile(Files.Strings[i],strFile);
    end;
  end;
end;

procedure TExportFiles.ExportFile(const FileID, strFile: String);
var
  DataFile: TFileStream;
  iCount, iSize, i: Integer;
  FData: TClientBlobStream;
  cdsImage: TZjhDataset;
  ZipVersion: Char;
  Buffer: array[0..MAX_DOCPACKAGE] of Char;
begin
  iCount := CM.DBRead('Select Count(*) from FileImage Where PID_=''' + FileID + '''',0,FDatabase);
  if iCount = 0 then
  begin
    MsgBox(Chinese.AsString('���ļ�����Ϊ�գ�'));
    Exit;
  end;
  if OutputFile = '' then
    OutputFile := GetTempFile(ExtractFileExt(strFile));
  ibox.Text(Chinese.AsString('�������أ�') + ExtractFileName(strFile));
  ibox.Max := iCount;
  try
    ibox.JobStop := iif(CanCancel, 0, -1);
    DataFile := TFileStream.Create(OutputFile, fmCreate);
    cdsImage := TZjhDataSet.Create(Application);
    try
      cdsImage.RemoteServer := DM.DCOM;
      cdsImage.Database := FDatabase;
      cdsImage.ProviderName := 'dspSQL';
      for i := 0 to iCount - 1 do
      begin
        ibox.Position := i + 1;
        if ibox.JobStop = 1 then
          raise Exception.Create(Chinese.AsString('�ĵ����ر��û���ֹ��'));
        //if not wat.RefreshW('',iCount,i,False) then
        //  raise Exception.Create(Chinese.AsString('�ĵ����ر��û���ֹ��'));
        cdsImage.Close;
        cdsImage.CommandText := Format('Select Data_,Size_,Index_ from FileImage '
          + 'Where PID_ =''%s'' and Index_=%d',[FileID,i]) ;
        cdsImage.Open;
        FData := TClientBlobStream.Create(cdsImage.FieldByName('Data_') as TBlobField,bmRead);
        try
          if cdsImage.FieldByName('Size_').AsInteger < 0 then //��ѹ����
            begin
              with TDecompressionStream.Create(FData) do
              try
                Read(ZipVersion,1); //��ȡ�汾��
                iSize := Read(Buffer, MAX_DOCPACKAGE);
                while iSize > 0 do
                begin
                  DataFile.Write(Buffer, iSize);
                  iSize := Read(Buffer, MAX_DOCPACKAGE);
                end;
              finally
                Free;
              end
            end
          else
            DataFile.CopyFrom(FData,FData.Size);
          //DataFile.Write(Buffer,FData.Read(Buffer,FData.Size));
        finally
          FData.Free;
        end;
      end;
    finally
      DataFile.Free;
      cdsImage.Free;
    end;
  finally
    ibox.Max := 0;
  end;
end;

{ TKMFile }

constructor TKMFile.Create(AOwner: TComponent);
begin
  inherited;
  //FActive := False;
  FSource := FILE_CLASS_NORAMAL;
end;

function TKMFile.GetPackages(Index: Integer): TKMRecord;
var
  KMR: TKMRecord;
begin
  if not Active then Raise Exception.Create(Chinese.AsString('����Դû�п�����'));
  Result := KMR;
end;

procedure TKMFile.LoadFromFile(const strFile: String);
begin
  if Active then Raise Exception.Create(Chinese.AsString('������Կ���������ִ�д����'));
  Active := False;
  ;
end;

procedure TKMFile.SaveToFile(const strFile: String);
begin
  if not Active then Raise Exception.Create(Chinese.AsString('����Դû�п�����'));
  ;
end;

procedure TKMFile.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

procedure TKMFile.SetFileID(const Value: String);
begin
  if FFileID <> Value then
  begin
    Active := False;
    FFileID := Value;
  end;
end;

procedure TKMFile.SetFileName(const Value: String);
begin
  if FFileName <> Value then
  begin
    Active := False;
    FFileName := Value;
  end;
end;

procedure TKMFile.SetSource(const Value: Integer);
begin
  if FSource <> Value then
  begin
    Active := False;
    FSource := Value;
  end;
end;

{ TViewDocument }

procedure TViewDocument.Browser(Sender: TComponent; const AID, AName: String;
  vfValue: TViewFileOptions);
var
  vd: IMagicView;
  DefaultClass: String;
  xml: IXmlDocument;
  Root, Item: IXmlNode;
  //ef: TExportFiles;
begin
  if AID = '' then Exit;
  vd := nil;
  xml := LoadXmlDocument(GetSystemConfigFile());
  try
    DefaultClass := '';
    root := xml.DocumentElement.ChildNodes.FindNode('ViewDocument');
    if Assigned(root) then
      begin
        Item := Root.ChildNodes.First;
        while Assigned(Item) do
        begin
          if UpperCase(item.Attributes['extname']) = UpperCase(ExtractFileExt(AName)) then
          begin
            vd := CreateClass(Item.Attributes['class'], Application) as IMagicView;
            Break;
          end;
          if UpperCase(item.Attributes['extname']) = '.*' then
            DefaultClass := Item.Attributes['class'];
          Item := Item.NextSibling;
        end;
        if not Assigned(vd) then
        begin
          if DefaultClass <> '' then
            vd := CreateClass(DefaultClass, Application) as IMagicView
        end;
      end
    else
      MsgBox(Chinese.AsString('�����ļ�%s�����Ҳ���ViewDocument�Σ�'),
        [GetSystemConfigFile()]);
  finally
    xml := nil;
  end;
  //���Ķ���
  try
    if Assigned(vd) then
    begin
      vd.SetDatebase(Self.FDatabase);
      vd.Execute(AID,AName,vfValue);
      TImportFiles.EnrollChange(AID,ohBrowser);
    end;
  finally
    vd := nil;
  end;
  {
  strExtName := UpperCase(ExtractFileExt(AName));
  if Pos(strExtName,'.JPG;.BMP') > 0 then
    vd := TViewPicture.Create(Sender)
  else if Pos(strExtName,'.TXT,.SQL,.SN,.INI') > 0 then
    vd := TViewText.Create(Sender)
  else if Pos(strExtName,'.EML') > 0 then
    begin
      ef := TExportFiles.Create;
      try
        ef.ExportFile(AID,AName);
        if ShellExecute(Application.handle, 'open', PChar(ef.OutputFile),
          nil, nil, SW_SHOWNORMAL) = SE_ERR_NOASSOC then
          raise Exception.Create(Chinese.AsString('�޷���ָ���ļ���') + vbCrLf + AName); //'�޷��򿪰����ļ���'
      finally
        ef.Free;
      end;
    end
  else
    vd := TViewWebBrowser.Create(Sender);
  try
    if Assigned(vd) then
    begin
      vd.Execute(AID,AName,vfValue);
      TImportFiles.EnrollChange(AID,ohBrowser);
    end;
  finally
    if Assigned(vd) then FreeAndNil(vd);
  end;
  }
end;

function TViewDocument.GetDatabase: String;
begin
  Result := FDatabase;
end;

procedure TViewDocument.SetDatebase(const Value: String);
begin
  FDatabase := Value;
end;

end.
