unit BuilderTBNo_class;
{$I ERPVersion.inc}

interface

uses
  Classes, SysUtils, DateUtils, ADODB, AppBean;

type
  THRBuilderTBNo = class(TAppBean)
  private
    FTB: String;
    FTBDate: TDatetime;
    FMode: String;
    FMaxLength: Integer;
    FShortYear: Boolean;
    FExtCode: String;
    TableID: String;
    FCostDept: String;
    FCostCorp: String;
    procedure SetTB(const Value: String);
    procedure SetTBDate(const Value: TDatetime);
    procedure SetMode(const Value: String);
    procedure SetMaxLength(const Value: Integer);
    procedure SetShortYear(const Value: Boolean);
    procedure SetExtCode(const Value: String);
    procedure EnrollLastNo(const UKID, LastCode, SerNumber: String);
    procedure LoadParams(const SQLCmd: String);
    function BuilderOfYear (var LastCode: String): String;
    function BuilderOfMonth(var LastCode: String): String;
    function BuilderOfDay  (var LastCode: String): String;
    function BuilderOfDiy  (var LastCode: String): String;
    function BuilderResult(const Head, No: String): String;
    procedure SetCostCorp(const Value: String);
    function GetCostDept: String;
  public
    function CreateOfID(const TID: String): String;
    function CreateOfTB(const ATB: String; ASys: Integer): String;
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    //constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
  public
    property Mode: String read FMode write SetMode;
    property MaxLength: Integer read FMaxLength write SetMaxLength;
    property ShortYear: Boolean read FShortYear write SetShortYear;
    property ExtCode: String read FExtCode write SetExtCode;
    property CostCorp: String read FCostCorp write SetCostCorp;
  published
    property TB: String read FTB write SetTB;
    property TBDate: TDatetime read FTBDate write SetTBDate;
  end;

implementation

uses ApConst, NetRegistry;

{ THRBuilderTBNo }

function THRBuilderTBNo.BuilderOfYear(var LastCode: String): String;
var
  oRs: _Recordset;
  UKID, SQLCmd, sYear: String;
begin
  SQLCmd := 'Select UpdateKey_, Year_,''LastNo'' = LastNo_ + 1 '
    + 'from TranNoDate where TID_=''%s'' and CostDept_=''%s'' and Year_=%d and Mode_=''Y''';
  oRs := Session.Connection.Execute(Format(SQLCmd, [TableID,FCostDept,YearOf(TBDate)]));
  try
    if oRs.EOF then
      begin
        UKID := NewGuid();
        sYear := FormatDatetime('YYYY',TBDate);
        LastCode := '1';
        SQLCmd := 'Insert Into TranNoDate (TID_,CostDept_,UpdateKey_,Year_,Month_,Day_,Mode_) Values '
          + '(''%s'',''%s'',''%s'',%d,1,1,''%s'')';
        Session.Connection.Execute(Format(SQLCmd, [TableID,FCostDept,UKID,YearOf(TBDate),Mode]));
      end
    else
      begin
        UKID := oRs.Fields['UpdateKey_'].Value;
        sYear := IntToStr(oRs.Fields['Year_'].Value);
        LastCode := IntToStr(oRs.Fields['LastNo'].Value);
      end;
    if ShortYear then
      sYear := Copy(sYear,3,2);
  finally
    oRs.Close; oRs := nil;
  end;
  Result := BuilderResult(sYear, LastCode);
  //更新到最新的单号
  if Length(Trim(LastCode)) > 0 then
    EnrollLastNo(UKID, LastCode, Result);
end;

function THRBuilderTBNo.BuilderOfMonth(var LastCode: String): String;
var
  oRs: _Recordset;
  UKID, SQLCmd, sYear, sMonth: String;
begin
  SQLCmd := 'Select UpdateKey_, Year_,Month_,''LastNo'' = LastNo_ + 1 '
    + 'from TranNoDate Where TID_=''%s'' and CostDept_=''%s'' and Year_=%d and Month_=%d and Mode_=''M''';
  oRs := Session.Connection.Execute(Format(SQLCmd,[TableID,FCostDept,YearOf(TBDate),MonthOf(TBDate)]));
  try
    if oRs.EOF then
      begin
        UKID := NewGuid();
        sYear := FormatDatetime('YYYY',TBDate);
        sMonth := FormatDateTime('MM',TBDate);
        LastCode := '1';
        SQLCmd := 'Insert Into TranNoDate (TID_,CostDept_,UpdateKey_,Year_,Month_,Day_,Mode_) values '
          + '(''%s'',''%s'',''%s'',''%d'',%d,1,''%s'')';
        Session.Connection.Execute(Format(SQLCmd,[TableID,FCostDept,UKID,YearOf(TBDate),MonthOf(TBDate),Mode]));
      end
    else
      begin
        UKID := oRs.Fields['UpdateKey_'].Value;
        sYear := IntToStr(oRs.Fields['Year_'].Value);
        sMonth := '00' + Trim(IntToStr(oRs.Fields['Month_'].Value));
        sMonth := Copy(sMonth,Length(sMonth)-1,2);
        LastCode := IntToStr(oRs.Fields['LastNo'].Value);
      end;
    if ShortYear then
      sYear := Copy(sYear,3,2);
  finally
    oRs.Close; oRs := nil;
  end;
  Result := BuilderResult(sYear + sMonth, LastCode);
  //更新到最新的单号
  if Length(Trim(LastCode)) > 0 then
    EnrollLastNo(UKID, LastCode, Result);
end;

function THRBuilderTBNo.BuilderOfDay(var LastCode: String): String;
var
  oRs: _Recordset;
  UKID, SQLCmd, sYear, sMonth, sDay: String;
begin
  SQLCmd := 'Select UpdateKey_, Year_,Month_,Day_,''LastNo'' = LastNo_ + 1 '
    + 'from TranNoDate where TID_=''%s'' and CostDept_=''%s'' and Year_=%d and Month_=%d and Day_=%d and Mode_=''D''';
  oRs := Session.Connection.Execute(Format(SQLCmd,[TableID,FCostDept,YearOf(TBDate),MonthOf(TBDate),DayOf(TBDate)]));
  try
    if oRs.EOF then
      begin
        UKID := NewGuid();
        sYear := FormatDatetime('YYYY',TBDate);
        sMonth := FormatDatetime('MM',TBDate);
        sDay := FormatDatetime('DD',TBDate);
        LastCode := '1';
        SQLCmd := 'Insert Into TranNoDate (TID_,CostDept_,UpdateKey_,Year_,Month_,Day_,Mode_) values '
          + '(''%s'',''%s'',''%s'',%d,%d,%d,''%s'')';
        Session.Connection.Execute(Format(SQLCmd,[TableID,FCostDept,UKID,YearOf(TBDate),MonthOf(TBDate),DayOf(TBDate),Mode]));
      end
    else
      begin
        UKID := oRs.Fields['UpdateKey_'].Value;
        sYear := IntToStr(oRs.Fields['Year_'].Value);
        sMonth := '00' + Trim(IntToStr(oRs.Fields['Month_'].Value));
        sMonth := Copy(sMonth,Length(sMonth)-1,2);
        sDay := '00' + Trim(IntToStr(oRs.Fields['Day_'].Value));
        sDay := Copy(sDay,Length(sDay)-1,2);
        LastCode := IntToStr(oRs.Fields['LastNo'].Value);
      end;
    if ShortYear then
      sYear := Copy(sYear,3,2);
  finally
    oRs.Close; oRs := nil;
  end;
  Result := BuilderResult(sYear + sMonth + sDay, LastCode);
  //更新到最新的单号
  if Length(Trim(LastCode)) > 0 then
    EnrollLastNo(UKID, LastCode, Result);
end;

function THRBuilderTBNo.BuilderOfDiy(var LastCode: String): String;
var
  oRs: _Recordset;
  UKID, SQLCmd, sYear: String;
begin
  SQLCmd := 'Select UpdateKey_, Year_,''LastNo'' = LastNo_ + 1 '
    + 'from TranNoDate where TID_=''%s'' and CostDept_=''%s'' and Mode_=''%s''';
  oRs := Session.Connection.Execute(Format(SQLCmd,[TableID,FCostDept,Mode]));
  try
    if oRs.EOF then
      begin
        UKID := NewGuid();
        sYear := IntToStr(YearOf(TBDate));
        LastCode := '1';
        SQLCmd := 'Insert Into TranNoDate (TID_,CostDept_,UpdateKey_,Year_,Month_,Day_,Mode_) values '
          + '(''%s'',''%s'',''%s'',%s,1,1,''%s'')';
        Session.Connection.Execute(Format(SQLCmd,[TableID,FCostDept,UKID,sYear,Mode]));
      end
    else
      begin
        UKID := oRs.Fields['UpdateKey_'].Value;
        sYear := IntToStr(oRs.Fields['Year_'].Value);
        LastCode := IntToStr(oRs.Fields['LastNo'].Value);
      end;
    if ShortYear then
      sYear := Copy(sYear,3,2);
  finally
    oRs.Close; oRs := nil;
  end;
  Result := BuilderResult(sYear, LastCode);
  //更新到最新的单号
  if Length(Trim(LastCode)) > 0 then
    EnrollLastNo(UKID, LastCode, Result);
end;

function THRBuilderTBNo.BuilderResult(const Head, No: String): String;
var
  n1: Integer;
  function Space(const intLength: Integer; const data: char): String;
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to intLength do
      Result := Result + data;
  end;
begin
  {$IFDEF ERP2011}
  n1 := MaxLength - Length(TB + ExtCode) - Length(Head) - Length(No) + 2;
  if n1 > 0 then
    Result := TB + ExtCode + Head + Space(n1, '0') + No
  else
    Result := TB + ExtCode + Head + No;
  if Length(Result) > 14 then
    raise Exception.Create(ChineseAsString('RS001', '自动编码失败：总编码长度已超出最大长度14位！'));
  {$ELSE}
  n1 := MaxLength - Length(TB + ExtCode + '-') - Length(Head) - Length(No);
  if n1 > 0 then
    Result := TB + ExtCode + '-' + Head + Space(n1, '0') + No
  else
    Result := TB + ExtCode + '-' + Head + No;
  if Length(Result) > 20 then
    raise Exception.Create(ChineseAsString('RS001', '自动编码失败：总编码长度已超出最大长度20位！'));
  {$ENDIF}
end;

procedure THRBuilderTBNo.EnrollLastNo(const UKID, LastCode, SerNumber: String);
var
  SQLCmd: String;
  oRs: _Recordset;
  SerNumber1: String;
begin
  //记录最新的单号
  {$IFDEF ERP2011}
  SerNumber1 := Copy(SerNumber,Length(TB+ExtCode)+1,12);
  {$ELSE}
  SerNumber1 := Copy(SerNumber,Length(TB + ExtCode + '-') + 1, 20);
  {$ENDIF}
  SQLCmd := 'Update TranNoDate Set LastNo_=LastNo_+1,SerNumber_=''%s'' '
    + 'Where UpdateKey_=''%s'' and LastNo_=%s';
  Session.Connection.Execute(Format(SQLCmd,[SerNumber1,UKID,IntToStr(StrToInt(LastCode)-1)]));
  oRs := Session.Connection.Execute('Select ''RowCount'' = @@RowCount');
  try
    if oRs.Fields[0].Value = 0 then
      raise Exception.Create(ChineseAsString('RS002', '生成异动单号失败，请再试一次！'));
  finally
    oRs := nil;
  end;
end;

function THRBuilderTBNo.CreateOfID(const TID: String): String;
var
  SQLCmd, LastCode, SerNumber: String;
begin
  Result := '000000000000';
  //载入各类参数
  SQLCmd := Format('Select ID_,Mode_,MaxLength_,'
    + 'ShortYear_,IsNull(ExtCode_,'''') as ExtCode, Sys_ from TranT Where (ID_=''%s'')'
    + ' and (''%s'' BetWeen DateFM_ and DateTo_)',
    [TID, FormatDatetime('YYYY/MM/DD', TBDate)]);
  LoadParams(SQLCmd);
  if UpperCase(Mode) = 'Y' then // year mode
    SerNumber := BuilderOfYear(LastCode)
  else if UpperCase(Mode) = 'M' then // month mode
    SerNumber := BuilderOfMonth(LastCode)
  else if UpperCase(Mode) = 'D' then // Day mode
    SerNumber := BuilderOfDay(LastCode)
  else // DIY mode
    SerNumber := BuilderOfDiy(LastCode);
  if Length(Trim(LastCode)) = 0 then
    raise Exception.Create(ChineseAsString('RS003', '单号长度不够,生成单号失败!'));
  Result := SerNumber;
end;

function THRBuilderTBNo.CreateOfTB(const ATB: String; ASys: Integer): String;
var
  SQLCmd, LastCode, SerNumber: String;
begin
  TB := ATB;
  Result := '000000000000';
  //载入各类参数
  {$IFDEF ERP2011}
  SQLCmd := Format('Select ID_,Mode_,MaxLength_,'
    + 'ShortYear_,IsNull(ExtCode_,'''') as ExtCode, Sys_ from TranT '
    + 'Where (Code_=''%s'' and Sys_=%d) and (''%s'' Between DateFM_ and DateTo_)',
    [ATB, ASys, FormatDatetime('YYYY/MM/DD', TBDate)]);
  {$ELSE}
  SQLCmd := Format('Select ID_,Mode_,MaxLength_,'
    + 'ShortYear_,IsNull(ExtCode_,'''') as ExtCode, Sys_ from TranT '
    + 'Where Code_=''%s'' and (''%s'' Between DateFM_ and DateTo_)',
    [ATB, FormatDatetime('YYYY/MM/DD', TBDate)]);
  {$ENDIF}
  LoadParams(SQLCmd);
  if UpperCase(Mode) = 'Y' then // year mode
    SerNumber := BuilderOfYear(LastCode)
  else if UpperCase(Mode) = 'M' then // month mode
    SerNumber := BuilderOfMonth(LastCode)
  else if UpperCase(Mode) = 'D' then // Day mode
    SerNumber := BuilderOfDay(LastCode)
  else // DIY mode
    SerNumber := BuilderOfDiy(LastCode);
  if Length(Trim(LastCode)) = 0 then
    raise Exception.Create(ChineseAsString('RS004', '单号长度不够,生成单号失败!'));
  Result := SerNumber;
end;

procedure THRBuilderTBNo.LoadParams(const SQLCmd: String);
var
  oRs: _RecordSet;
  nreg: TNetRegistry;
  nSys: Integer;
begin
  //载入各类参数
  oRs := Session.Connection.Execute(SQLCmd);
  try
    if oRs.EOF then
      raise Exception.CreateFmt(ChineseAsString('RS005', '%s单号日期勾稽错误，请联络电脑管理员！'),[TB]);
    TableID   := oRs.Fields['ID_'].Value;
    Mode      := oRs.Fields['Mode_'].Value;
    MaxLength := oRs.Fields['MaxLength_'].Value;
    nSys      := oRs.Fields['Sys_'].Value;
    nreg := TNetRegistry.Create(Self);
    try
      if nreg.ReadInit('system', 'SYS08008') > 0 then //启动成本部门
        begin
          ShortYear := True;
          if nSys in [0,4,7,70] then
            begin
              FCostDept := '';
              ExtCode := '';
            end
          else
            begin
              if FCostCorp <> '' then
                FCostDept := FCostCorp
              else if Session.Version = 2011 then
                FCostDept := Session.CostDept
              else
                FCostDept := GetCostDept();
              ExtCode := FCostDept;
            end;
        end
      else
        begin
          ShortYear := oRs.Fields['ShortYear_'].Value;
          ExtCode   := oRs.Fields['ExtCode'].Value;
        end;
    finally
      nreg.Free;
    end;
  finally
    oRs.Close; oRs := nil;
  end;
end;

function THRBuilderTBNo.GetCostDept: String;
var
  cdsTmp: TAppQuery;
begin
  Result := '';
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Connection;
      SQL.Text := Format('Select CostDept_ From SysUserProperty '
        + 'Where UserCode_=''%s''', [Self.Session.UserCode]);
      Open;
      if not Eof then
        Result := FieldByName('CostDept_').AsString;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure THRBuilderTBNo.SetExtCode(const Value: String);
begin
  FExtCode := Trim(Value);
end;

procedure THRBuilderTBNo.SetMaxLength(const Value: Integer);
begin
  {$IFDEF ERP2011}
  if Value < 1 then
    FMaxLength := 12
  else if Value > 12 then
    FMaxLength := 12
  else
    FMaxLength := Value;
  {$ELSE}
  if Value < 1 then
    FMaxLength := 20
  else if Value > 20 then
    FMaxLength := 20
  else
    FMaxLength := Value;
  {$ENDIF}
end;

procedure THRBuilderTBNo.SetMode(const Value: String);
begin
  FMode := Value;
end;

procedure THRBuilderTBNo.SetShortYear(const Value: Boolean);
begin
  FShortYear := Value;
end;

procedure THRBuilderTBNo.SetTB(const Value: String);
begin
  FTB := Value;
end;

procedure THRBuilderTBNo.SetTBDate(const Value: TDatetime);
begin
  FTBDate := Value;
end;

function THRBuilderTBNo.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
begin
  Result := False;
end;

procedure THRBuilderTBNo.SetCostCorp(const Value: String);
begin
  FCostCorp := Value;
end;

end.
