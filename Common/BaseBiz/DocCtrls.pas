unit DocCtrls;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Forms, Controls, DBClient,
  DB, DBGrids, DBCtrls, StdCtrls, Dialogs, ApConst, QuickRpt, ZjhCtrls,
  ComCtrls, ShellAPI, TypInfo, Graphics, Zlib, ExtCtrls, uBaseIntf,
  ShDocVw, Menus, Jpeg, MainData, InfoBox, XmlIntf, XmlDoc;

type
  //目录节点记录
  TFolderRecord = Record
    ID: String;        //目录ID
    Name: String;      //目录名称
    Remark: String;    //备注描述
    WebShare: Boolean; //是否发布于WebShare
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
  //文档阅读器接口
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

  //将文件导入到 FileImage 中
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

  //从 FileImage 中导出文件并打开
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
    //特别注意，此 Files 中存入的均为文件 ID
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
      //MsgBox('文件：' + ExtractFileName(FileName) + ' 不在允许的范围[' + AllowTypes + ']之内！');
      MsgBox(Chinese.AsString('文件不在允许的范围之内！') + '[' + ExtractFileName(FileName) + ',' + AllowTypes + ']');
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
  strMsg := Chinese.AsString('正在导入第 %d 个：%s');
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
    raise Exception.Create(Chinese.AsString('系统管理员没有为您分配磁盘空间，无法导入！'));  //'系统管理员没有为您分配磁盘空间，无法导入！'
  DataFile := TFileStream.Create(strFile,fmOpenRead);
  if (UsedSpace + DataFile.Size) > DiskSpace then
  begin
    DataFile.Free;
    raise Exception.CreateFmt(Chinese.AsString('超出系统管理员为您分配的磁盘限额[%n]，无法导入！'),[UsedSpace]);  //'超出系统管理员为您分配的磁盘限额[%n]，无法导入！'
  end;
  ibox.Text(Chinese.AsString('正在导入：') + strFile);
  ibox.Max := DataFile.Size;
  //=-1: 不允许中止，0=允许中止，1=已被中止
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
        if iIndex mod 100 = 0 then begin Close; Open; end; //每一100个包清除一下缓存
        iSize := DataFile.Read(Buffer,MAX_DOCPACKAGE);
        ibox.Position := ibox.Position + iSize;
        if ibox.JobStop = 1 then
          raise TImportCancel.Create(Format(Chinese.AsString('导入文件 %s 被中止！'),[strFile]),FileID);
        //if not wat.RefreshW('',0,iSize,True) then
        //  Raise TImportCancel.Create(Format(Chinese.AsString('导入文件 %s 被中止！'),[strFile]),FileID);
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
          //FData.Write(Buffer, iSize); //不压缩存放
          FieldByName('Size_').AsInteger := - FData.Size;
        finally
          FData.Free;
        end;
        PostPro(0);
        Inc(iIndex);
      end;
    end;
  finally
    //在导入系统后，移除源文件。
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
    Raise Exception.Create(Chinese.AsString('没有定义文件导入目录，执行终止。'));  //'没有定义文件导入目录，执行终止。'
  if ImportPath <> '' then
    strMsg := Format(Chinese.AsString('导入 %d 个项目到 %s'),[Files.Count,ImportPath])
  else
    strMsg := Format(Chinese.AsString('导入 %d 个项目'),[Files.Count]);
  CurrentIndex := 0;
  ibox.Text(strMsg);
  ibox.Text(Chinese.AsString('正在导入文件，请稍候...'));
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
            raise Exception.Create(Chinese.AsString('此文档已被借出，不能覆盖!'));
          if OverloadMessage and (MessageDlg(Format(Chinese.AsString('文件 %s 已经存在，要覆盖吗？'),[strShortName]),
            mtConfirmation,[mbYes,mbNo],0) = mrNo) then Exit;
          strFileID := FieldByName('ID_').AsString;
          m_Group := FieldByName('Group_').AsString;
          m_Remark := FieldByName('Remark_').AsString;
          EnrollChange(strFileID,ohOverload);  //产生历史
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
              HistoryID := CreateHistory(strFileID); //产生历史
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
        Raise Exception.Create(Chinese.AsString('文件正在动行，不能打开!'));
      FieldByName('Size_').AsFloat := FSize;
      PostPro(0);
      EnrollChange(strFileID,ohAppend);  //产生历史
      Result := True;
    end;
  except
    on E: TImportCancel do
      begin
        CM.ExecSQL(Format('Update FileImage Set PID_=''%s'' '
          + 'Where PID_=''%s''',[GuidNull,E.FileID]));
        if not cdsFileCode.Locate('ID_',E.FileID,[]) then MsgBox(Chinese.AsString('极严重错误！'));
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
  strMsg := Format(Chinese.AsString('下载 %d 个项目'),[Files.Count]);
  ibox.Text(strMsg);
  ibox.Text(Chinese.AsString('正在下载文件，请稍候...'));
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
    MsgBox(Chinese.AsString('此文件内容为空！'));
    Exit;
  end;
  if OutputFile = '' then
    OutputFile := GetTempFile(ExtractFileExt(strFile));
  ibox.Text(Chinese.AsString('正在下载：') + ExtractFileName(strFile));
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
          raise Exception.Create(Chinese.AsString('文档下载被用户中止！'));
        //if not wat.RefreshW('',iCount,i,False) then
        //  raise Exception.Create(Chinese.AsString('文档下载被用户中止！'));
        cdsImage.Close;
        cdsImage.CommandText := Format('Select Data_,Size_,Index_ from FileImage '
          + 'Where PID_ =''%s'' and Index_=%d',[FileID,i]) ;
        cdsImage.Open;
        FData := TClientBlobStream.Create(cdsImage.FieldByName('Data_') as TBlobField,bmRead);
        try
          if cdsImage.FieldByName('Size_').AsInteger < 0 then //有压缩过
            begin
              with TDecompressionStream.Create(FData) do
              try
                Read(ZipVersion,1); //读取版本号
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
  if not Active then Raise Exception.Create(Chinese.AsString('数据源没有开启。'));
  Result := KMR;
end;

procedure TKMFile.LoadFromFile(const strFile: String);
begin
  if Active then Raise Exception.Create(Chinese.AsString('不允许对开启的数据执行此命令。'));
  Active := False;
  ;
end;

procedure TKMFile.SaveToFile(const strFile: String);
begin
  if not Active then Raise Exception.Create(Chinese.AsString('数据源没有开启。'));
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
      MsgBox(Chinese.AsString('配置文件%s错误，找不到ViewDocument段！'),
        [GetSystemConfigFile()]);
  finally
    xml := nil;
  end;
  //打开阅读器
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
          raise Exception.Create(Chinese.AsString('无法打开指定文件：') + vbCrLf + AName); //'无法打开帮助文件：'
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
