unit ZLFileDateTime;

interface

uses
  Windows, Classes, SysUtils, DateUtils;

type
  TZLFileDateTime = class
  private
    FFileName: String;
    FCreationTime: TFileTime;
    FLastWriteTime: TFileTime;
    FLastAccessTime: TFileTime;
    FFileSize: Int64;
    procedure SetCreationTime(const Value: TFileTime);
    procedure SetLastAccessTime(const Value: TFileTime);
    procedure SetLastWriteTime(const Value: TFileTime);
    function HexToDWord(const Hex: String): DWord;
    procedure SetFileName(const Value: String);
  public
    function GetFileInfo: Boolean;
    function UpdateFileTime: Boolean;
    function CompareFileTime(Src, Tar: TFileTime): Boolean;
    function CompareFile(Target: TZLFileDateTime): Boolean;
    function FileTimeToString(const Value: TFileTime): String;
    function StringToFileTime(const Value: String): TFileTime;
    function FileTimeToDateTime(Fd: _FileTime): TDateTime;
    function DateTimeToFileTime(SrcTime: TDateTime; var TarTime: TFileTime): Boolean;
  public
    property FileName: String read FFileName write SetFileName;
    property FileSize: Int64 read FFileSize;
    property CreationTime: TFileTime read FCreationTime write SetCreationTime;
    property LastWriteTime: TFileTime read FLastWriteTime write SetLastWriteTime;
    property LastAccessTime: TFileTime read FLastAccessTime write SetLastAccessTime;
  end;

implementation

{ TZLFileDateTime }

procedure TZLFileDateTime.SetCreationTime(const Value: TFileTime);
begin
  FCreationTime := Value;
end;

procedure TZLFileDateTime.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TZLFileDateTime.SetLastAccessTime(const Value: TFileTime);
begin
  FLastAccessTime := Value;
end;

procedure TZLFileDateTime.SetLastWriteTime(const Value: TFileTime);
begin
  FLastWriteTime := Value;
end;

function TZLFileDateTime.CompareFile(Target: TZLFileDateTime): Boolean;
begin
  if    (Self.FileSize = Target.FileSize)
    and (Self.LastWriteTime.dwLowDateTime  = Target.LastWriteTime.dwLowDateTime)
    and (Self.LastWriteTime.dwHighDateTime = Target.LastWriteTime.dwHighDateTime) then
    Result := True
  else
    Result := False;
end;

function TZLFileDateTime.CompareFileTime(Src, Tar: TFileTime): Boolean;
var
  d1, d2: TDatetime;
begin
  d1 := Self.FileTimeToDateTime(Src);
  d2 := Self.FileTimeToDateTime(Tar);
  if SecondsBetween(d1, d2) < 10 then //小于10秒的差距忽略
    Result := True
  else
    Result := False;
end;

function TZLFileDateTime.DateTimeToFileTime(SrcTime: TDateTime;
  var TarTime: TFileTime): Boolean;
var
  dt: Integer;
begin
  Result := False;
  dt := DateTimeToFileDate(SrcTime);
  if DosDateTimeToFileTime(LongRec(dt).Hi, LongRec(dt).Lo, TarTime) then
    if LocalFileTimeToFileTime(TarTime, TarTime) then
      Result := True;
end;

function TZLFileDateTime.FileTimeToDateTime(Fd: _FileTime): TDateTime;
var
  Tct: _SYSTEMTIME;
  Temp: _FileTime;
begin
  FileTimeToLocalFileTime(Fd, Temp);
  FileTimeToSystemTime(Temp, Tct);
  Result := SystemTimeToDateTime(Tct);
end;

function TZLFileDateTime.GetFileInfo: Boolean;
{ 获取文件时间，Tf表示目标文件路径和名称 }
var
  Tp: TSearchRec; { 申明Tp为一个查找记录 }
begin
  if FileExists(FFileName) then
  begin
    FindFirst(FFileName, faAnyFile, Tp);
    { 查找目标文件 }
    FFileSize := tp.Size;
    { 返回文件的大小 }
    FCreationTime := Tp.FindData.ftCreationTime;
    { 返回文件的创建时间 }
    FLastWriteTime := Tp.FindData.ftLastWriteTime;
    { 返回文件的修改时间 }
    FLastAccessTime := Tp.FindData.ftLastAccessTime;
    { 返回文件的当前访问时间 }
    FindClose(Tp);
    Result := True;
  end
  else
    Result := False;
end;

function TZLFileDateTime.UpdateFileTime: Boolean;
var
  Fs: TFileStream;
begin
  Result := False;
  if FileExists(FFileName) then
  begin
    Fs := TFileStream.Create(FFileName, fmOpenReadWrite);
    try
      SetFileTime(Fs.Handle, @FCreationTime, @FLastAccessTime, @FLastWriteTime);
      Result := True;
      { 设置文件时间属性 }
    finally
      Fs.Free;
    end;
  end;
end;

function TZLFileDateTime.FileTimeToString(const Value: TFileTime): String;
begin
  Result := IntToHex(Value.dwLowDateTime, 8) + IntToHex(Value.dwHighDateTime,
    8);
end;

function TZLFileDateTime.StringToFileTime(const Value: String): TFileTime;
begin
  Result.dwLowDateTime := HexToDWord(Copy(Value, 1, 8));
  Result.dwHighDateTime := HexToDWord(Copy(Value, 9, 8));
end;

function TZLFileDateTime.HexToDWord(const Hex: String): DWord;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Hex) do
  begin
    Result := Result shl 4;
    Result := Result + StrToInt('$' + Copy(Hex, i, 1));
  end;
end;

end.
