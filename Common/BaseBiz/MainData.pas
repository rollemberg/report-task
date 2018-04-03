unit MainData;
{$I ERPVersion.inc}

interface

uses
  SysUtils, Windows, Dialogs, Classes, DB, DBClient, MConnect, ObjBrkr,
  Variants, SConnect, ZjhCtrls, Controls, StdCtrls, IniFiles,
  DBGrids, Forms, Messages, DBCtrls, ImgList, Buttons, Graphics, DateUtils,
  ComCtrls, ApConst, uBaseIntf, XMLIntf, xmlDoc, uBuffer, Math;

type
  TSysValues = class
  private
    FBuffName: String;
    procedure RepairValue(const KeyNo, strValue: String; intInit: Integer);
  public
    constructor Create(const ABuffName: String);
    destructor Destroy; override;
  public
    function ValueExists(const Section, Ident: String): Boolean;
    function ReadString(const Section, Ident: String; const Default: String = ''): String;
    function ReadData(const KeyNo: String; const Default: String = ''): String;
    function ReadInit(const Section, Ident: String; const Default: Integer = 0): Integer; overload;
    function ReadInit(const KeyNo: String; const Default: Integer = 0): Integer; overload;
    function WriteString(const Section, Ident, Value: String;
      DataSet: TZjhDataSet = nil): Boolean;
    function WriteInit(const Section, Ident: String; Value: Integer;
      DataSet: TZjhDataSet = nil): Boolean;
    procedure Refresh;
  end;
  //
  TSecIniFile = Class
  private
    FFormCode: String;
    FParam: TMemIniFile;
  public
    constructor Create(const FormCode: String);
    destructor Destroy; override;
  public
    procedure Save;
    function Data: String;
    property Param: TMemIniFile read FParam;
  end;
  //数据库函数集
  CM = class
  public
    //函数功能:取得签核时的超时时间,单位为天
    class function GetTimeout(AStartTime: TDateTime; AStopTime: Integer): Integer;
    //函数功能:更新自定义栏位的标题,显示宽度,居中属性, CM.UpdateFieldDef(cdsTranB, 'OrdB', DBGrid1)
    class procedure UpdateFieldDef(TargetDataSet: TZjhDataSet;
      const ATableName: String; TargetGrid: TDBGrid);
    //class function GetBewrite(const APartCode: String): String;
    //class procedure InitForm(const Sender: TForm);
    class function Validate_Combo(Sender: TDBComboBox; ErrorInfo: String): Boolean;
    //class procedure SetTranBodyGrid(DBGrid: TDBGrid);
    class function CreateTBNo(const TB: TTBRecord; TBDate: TDateTime): String;
    class function SendMail(const UserTo, Subject, Body,
      AppUser: String): Boolean;
    //函数功能:根据作业单别获取单据信息,如单据名称、系统日期范围等
    class function GetTBInfo(var TB: TTBRecord; Sys: Integer): Boolean;
    //函数功能：根据系统单别获取默认作业单别信息
    class function GetDefTBInfo(var TB: TTBRecord; Sys: Integer): Boolean;
    //函数功能：根据系统单别获取默认作业单别代码
    class function GetDefTBCode(const SysTB: String): String;
    //class procedure UpdateTranField(DataSet: TDataSet;
    //  const lstField: OleVariant);
    class function ExecSQL(const SQLCmd: String; const ADBName: String = ''): Boolean;
    //根据指定 SQLCommand 指令，返回第一条记录的第一个字段
    class function DBRead(const SQLCommand: String;
      const Default: OleVariant; const ADBName: String = ''): OleVariant;
    class function DBExists(const SQLCmd: String; const ADBName: String = ''): Boolean;
    class function GetStockNum(const WHCode, PartCode: String; Rate1: Double = 1): Double;
  end;
  function Buff: TErpBuffer;
  function GroupBuff: TErpBuffer;
  function UnitDigit(Value: Double; const AUnit: String): Double;
  function GetUnitByType(const UnitType: Integer): String;
  procedure GetDefFields(sl: TStrings; const ATableName: String);
  procedure GetValuesOfMenuParam(const FormCode, Session: String;
    Address: TStringList);

const
  IDA_Execute:      String = 'F1';
  IDA_Query:        String = 'F2';
  IDA_Append:       String = 'F3';
  IDA_Modify:       String = 'F4';
  IDA_Delete:       String = 'F5';
  IDA_Print:        String = 'F6';
  IDA_PrintSet:     String = 'F7';
  IDA_Final:        String = 'F8';
  IDA_MoneyDisplay: String = 'F9';
  IDA_MoneyPrint:   String = 'F10';
  IDA_Output:       String = 'F11';
  IDA_FreeFlow:     String = 'F12';

  IDA_AppendFile:   String = 'F1';
  IDA_DeleteFile:   String = 'F2';
  IDA_ChanageFile:  String = 'F3';
  IDA_AppendDir:    String = 'F4';
  IDA_DeleteDir:    String = 'F5';
  IDA_ChanageDir:   String = 'F6';

var
  nreg: TSysValues;
  pub_Buffer: TErpBuffer;
  pub_GroupBuffer: TErpBuffer;
  Buffs: TBuffManger;
  //ReportParam: Variant;//报表参数
  cdsSQL: TZjhDataSet;

implementation

uses InfoBox, ErpTools, AppService, uHRIP;

class function CM.ExecSQL(const SQLCmd, ADBName: String): Boolean;
var
  App: TAppService;
begin
  Result := False;
  App := TAppService.Create(nil);
  try
    ibox.DebugText('ExecSQL:' + SQLCmd);
    App.Database := ADBName;
    App.Service := 'TAppExecSQL';
    App.Param := SQLCmd;
    if App.Execute then
      Result := True
    else
      raise Exception.Create(App.Messages);
  finally
    App.Free;
  end;
end;

class function CM.GetDefTBCode(const SysTB: String): String;
begin
  Result := '';
  with Buff['TranT'] do
  begin
    //此处无法使用Locate查询Boolean类型值，应是Delphi一个Bug。Locate('TB_;IsDefault_', VarArrayOf([SysTB, 1]), [loCaseInsensitive])
    if Locate('TB_', SysTB, [loCaseInSensitive]) then
    begin
      while not Eof do
      begin
        if CompareText(FieldByName('TB_').AsString, SysTB) = 0 then
          begin
            if FieldByName('IsDefault_').AsBoolean then
            begin
              Result := FieldByName('Code_').AsString;
              Exit;
            end;
          end
        else
          Exit;
        Next;
      end;//end while
    end;
  end;
end;

class function CM.GetDefTBInfo(var TB: TTBRecord; Sys: Integer): Boolean;
begin
  Result := False;
  TB.Name := Self.GetDefTBCode(TB.SysTB);
  if TB.Name <> '' then
    Result := Self.GetTBInfo(TB, Sys)
  else
    MsgBox(Chinese.AsString('无法取得%s系统单别的默认工作单别！'), [TB.SysTB]);
end;

class function CM.GetTBInfo(var TB: TTBRecord; Sys: Integer): Boolean;
var
  cdsTmp: TZjhDataSet;
begin
  with Buff['TranT'] do
  begin
    Result := False;
    {$IFDEF ERP2011}
    if Locate('Code_;Sys_',VarArrayOf([TB.Name,Sys]),
      [loCaseInsensitive]) then
    begin
      if Sys = 2 then
        TB.Table := 'Ord'
      else if Sys = 5 then
        TB.Table := 'TranReq'  //add by caojianping 2008/11/27
      else if Copy(TB.Name,1,1) = 'D' then
        TB.Table := 'Pur'
      else if (TB.Name = 'MK') or (TB.Name = 'MR') or (TB.Name = 'ME') then
        TB.Table := 'Make'
      else if ((TB.Name = 'ML') or (TB.Name = 'MN') or (TB.Name = 'MQ')) then  //Modify by caojianping 2008/08/25
        TB.Table := 'MakeList'
      else
        TB.Table := 'Tran';
      TB.MinDate := FieldByName('DateFM_').AsDateTime;
      TB.MaxDate := FieldByName('DateTO_').AsDateTime;
      TB.ID := FieldByName('ID_').AsString;
      //TB.Caption := FieldByName('Name_').AsString;
      TB.Mode := Trim(FieldByName('Mode_').AsString);
      TB.Sys := FieldByName('Sys_').AsInteger;
      TB.InitNo := FieldByName('InitNo_').AsBoolean;
      if TB.Mode = '' then
        TB.AutoNo := FieldByName('AutoNo_').AsBoolean
      else
        TB.AutoNo := True;
      Result := True;
    end;
    {$ELSE}
    if Locate('Code_', TB.Name, [loCaseInsensitive]) then
    begin
      TB.SysTB := FieldByName('TB_').AsString;
      TB.Table := FieldByName('Table_').AsString;
      TB.MinDate := FieldByName('DateFM_').AsDateTime;
      TB.MaxDate := FieldByName('DateTO_').AsDateTime;
      TB.ID := FieldByName('ID_').AsString;
      //TB.Caption := FieldByName('Name_').AsString;
      TB.Mode := Trim(FieldByName('Mode_').AsString);
      TB.Sys := FieldByName('Sys_').AsInteger;
      TB.InitNo := True;
      TB.AutoNo := TB.Mode <> '';
      Result := True;
    end;
    {$ENDIF}
  end;
  if Sys = -1 then
  begin
    cdsTmp := TZjhDataset.Create(DM.DCOM);
    try
      with cdsTmp do
      begin
        CommandText := Format('select DateFM_,DateTO_ from AccBookH where Code_=''%s''',
          [TB.Name]);
        Open;
        TB.MinDate := FieldByName('DateFM_').AsDateTime;
        TB.MaxDate := FieldByName('DateTO_').AsDateTime;
        Close;
      end;
    finally
      cdsTmp.Free;
    end;
  end;
end;

class function CM.DBRead(const SQLCommand: String;
  const Default: OleVariant; const ADBName: String): OleVariant;
var
  Rec: OleVariant;
  oRs: TZjhDataSet;
  i: Integer;
begin
  Result := Default;
  oRs := TZjhDataSet.Create(nil);
  try
    oRs.RemoteServer := DM.DCOM;
    oRs.Database := Trim(ADBName);
    oRs.CommandText := SQLCommand;
    oRs.Open;
    with oRs do
    begin
      if not Eof then
      begin
        if Fields.Count > 1 then
          begin
            Rec := VarArrayCreate([0,Fields.Count],varVariant);
            Rec[0] := Fields.Count;
            for i := 0 to Fields.Count - 1 do
              Rec[i+1] := VarToStr(Fields[i].Value);
            Result := Rec;
          end
        else
          Result := Fields[0].Value;
      end;
      Close();
    end;
  finally
    FreeAndNil(oRs);
  end;
end;

class function CM.DBExists(const SQLCmd: String; const ADBName: String): Boolean;
var
  cdsTmp: TZjhDataSet;
begin
  cdsTmp := TZjhDataSet.Create(nil);
  try
    with cdsTmp do
    begin
      RemoteServer := DM.DCOM;
      Database := ADBName;
      CommandText := SQLCmd;
      Open;
      Result := not Eof;
    end;
  finally
    FreeAndNil(cdsTmp);
  end;
  {
  if ADBName = '' then
    Result := VarToStr(DBRead(SQLCmd, '<None>')) <> '<None>'
  else
    Result := VarToStr(DBRead(SQLCmd, '<None>', ADBName)) <> '<None>';
  }
end;

class function CM.GetStockNum(const WHCode, PartCode: String; Rate1: Double): Double;
var
  cdsTmp: TZjhDataSet;
begin
  Result := 0;
  if (Trim(WHCode) = '') or (Trim(PartCode) = '') then Exit;
  cdsTmp := TZjhDataSet.Create(nil);
  try
    with cdsTmp do
    begin
      RemoteServer := DM.DCOM;
      CommandText := Format('Select Stock_ from StockNum '
        + 'Where WHCode_=''%s'' and PartCode_=''%s''', [WHCode, PartCode]);
      Open;
      if not Eof then
        Result := RoundTo(FieldByName('Stock_').AsFloat / Rate1, -4);
    end;
  finally
    FreeAndNil(cdsTmp);
  end;
end;

{
class procedure CM.SetTranBodyGrid(DBGrid: TDBGrid);
var
  i: Integer;
begin
  for i := 0 to DBGrid.Columns.Count - 1 do
  begin
    if UpperCase(DBGrid.Columns[i].FieldName) = UpperCase('WHCode_') then
    begin
      Buff.SetLists('PartWH',DBGrid.Columns[i].PickList);
    end;
  end;
end;

class procedure CM.UpdateTranField(DataSet: TDataSet; const lstField: OleVariant);
var
  i: Integer;
  R: Variant;
  strField: String;
  function GetStatusCaption(Status: Integer): String;
  begin
    case Status of
      -1: Result := Chinese.AsString('作废状态');
       0: Result := Chinese.AsString('草稿状态');
       1: Result := Chinese.AsString('确认状态');
       2: Result := Chinese.AsString('签核状态');
    else  Result := Chinese.AsString('状态非法');
    end;
  end;
begin
  if DataSet.ControlsDisabled then Exit;
  with DataSet do
  for i := VarArrayLowBound(lstField,1) to VarArrayHighBound(lstField,1) do
  begin
    strField := UpperCase(lstField[i]);
    if strField = '' then Exit;
    if FindField(strField) <> nil then
      begin
        if strField = UpperCase('SellsName') then
          begin
            R := Buff.Read(SYSLIST_Sells,FieldByName('SellsCode_').AsString,['Name_']);
            if not VarIsNull(R) then FieldByName('SellsName').AsString := VarToStr(R[0]);
          end
        else if strField = UpperCase('CusName') then
          begin
            R := Buff.Read('Corp',FieldByName('CusCode_').AsString,['ShortName_']);
            if not VarIsNull(R) then FieldByName(strField).AsString := VarToSTr(R[0]);
          end
        else if strField = UpperCase('SupName') then
          begin
            R := Buff.Read('Corp',FieldByName('SupCode_').AsString,['ShortName_']);
            if not VarIsNull(R) then FieldByName(strField).Value := R[0];
          end
        else if strField = UpperCase('ReasonName') then
          begin
            R := Buff.Read('Reason',FieldByName('ReasonCode_').AsString,['Name_']);
            if not VarIsNull(R) then FieldByName(strField).AsString := VarToStr(R[0]);
          end
        else if strField = UpperCase('DeptName') then
          begin
            R := Buff.Read('Dept',FieldByName('DeptCode_').AsString,['Name_']);
            if not VarIsNull(R) then FieldByName(strField).AsString := VarToStr(R[0]);
          end
        else if strField = UpperCase('Bewrite') then
          begin
            R := Buff.Read('Part',FieldByName('PartCode_').AsString,['Bewrite_']);
            if not VarIsNull(R) then FieldByName('Bewrite').AsString := VarToStr(R[0]);
          end
        //
        else if strField = UpperCase('StockNum') then
          FieldbyName(strField).Value := CM.GetStockNum(FieldByName('WHCode_').AsString,FieldByName('PartCode_').AsString)
        else if strField = UpperCase('Status') then
          FieldByName(strField).Value := GetStatusCaption(FieldByName('Status_').AsInteger)
        else if strField = UpperCase('WHName') then
          FieldByName('WHName').Value := Buff.ReadValue('PartWH',FieldByName('WHCode_').AsString)
        else if strField = UpperCase('TBCode') then
          FieldByName(strField).Value := FieldByName('TB_').AsString + FieldByName('TBNo_').AsString
        else if strField = UpperCase('Amount') then
          FieldByName('Amount').AsCurrency := FieldByName('Num_').AsFloat * FieldByName('OriUP_').AsCurrency * FieldByName('ExRate_').AsFloat
        else if strField = UpperCase('UserName') then
          FieldByName('UserName').Value := GroupBuff.ReadValue('Account',FieldByName('AppUser_').AsString)
        else
          MsgBox(Chinese.AsString('没有处理的计算字段：') + strField + '!');
      end
    else
      MsgBox(Chinese.AsString('非法的计算字段：') + strField + '!');
  end;
end;
}

class function CM.Validate_Combo(Sender: TDBComboBox; ErrorInfo: String): Boolean;
begin
  Result := True;
  if not (Sender.DataSource.DataSet.State in [dsInsert,dsEdit]) then Exit;
  with Sender do
  begin
    if Trim(Text) = '' then Exit;
    if Items.IndexOf(Trim(Text)) = -1 then
    begin
      Result := False;
      MsgBox(ErrorInfo);
      SetFocus;
    end;
  end;
end;

class function CM.CreateTBNo(const TB: TTBRecord; TBDate: TDateTime): String;
var
  App: TAppService;
begin
  App := TAppService.Create(nil);
  try
    App.Service := 'TAppCreateTBNo';
    App.Param := VarArrayOf([TB.Name, TB.Sys, TBDate]);
    if App.Execute then
      Result := VarToStr(App.Data)
    else
      raise Exception.Create(App.Messages);
  finally
    App.Free;
  end;
end;

class function CM.GetTimeout(AStartTime: TDateTime;
  AStopTime: Integer): Integer;
var
  cdsTmp: TZjhDataSet;
begin
  Result := AStopTime;
  cdsTmp := TZjhDataSet.Create(DM.DCOM);
  try
    with cdsTmp do
    begin
      RemoteServer := DM.DCOM;
      CommandText := Format('execute GetTimeout ''%s'',%d',
        [FormatDatetime('YYYY/MM/DD HH:MM:SS',AStartTime),AStopTime]);
      Open;
      if not Eof then Result := FieldByName('TimeOut_').AsInteger;
    end;
  finally
    cdsTmp.Free;
  end;
end;

{
class function CM.GetBewrite(const APartCode: String): String;
var
  R: Variant;
begin
  R := Buff.Read('Part',APartCode,['Bewrite_']);
  if not VarIsNull(R) then Result := VarToStr(R[0]) else Result := '';
end;

class procedure CM.InitForm(const Sender: TForm);
var
  i: Integer;
begin
  if Assigned(DM) then
  for i := 0 to Sender.ComponentCount - 1 do
  begin
    if Sender.Components[i] is TZjhDataSet then
    begin
      if not TZjhDataSet(Sender.Components[i]).Active then
        TZjhDataSet(Sender.Components[i]).RemoteServer := DM.DCOM;
    end;
  end;
end;
}

{ TErpBuffer }

function Buff: TErpBuffer;
begin
  if Assigned(HRIP) then Result := HRIP.Buff else Result := nil;
end;

function GroupBuff: TErpBuffer;
begin
  if Assigned(HRIP) then
    begin
      HRIP.GroupBuff.Database := 'Common';
      Result := HRIP.GroupBuff;
    end
  else
    Result := nil;
end;

{ TSysValues }

constructor TSysValues.Create(const ABuffName: String);
begin
  FBuffName := ABuffName;
  //_System.WHAccess := ReadInit(NREG_SY_0005,0) = 1;
end;

destructor TSysValues.Destroy;
begin
  ;
  inherited;
end;

function TSysValues.ValueExists(const Section, Ident: String): Boolean;
begin
  Result := Buff[FBuffName].Locate('Root_;Code_',
    VarArrayOf([Section,Ident]),[loCaseInsensitive]);
end;

function TSysValues.ReadString(const Section, Ident,
  Default: String): String;
var
  sName: String;
begin
  sName := '';
  Result := Default;
  with Buff[FBuffName] do
  begin
    if Locate('Root_;Code_',VarArrayOf([Section,Ident]),[loCaseInsensitive]) then
    begin
      sName := FieldByName('Key_').AsString;
      Result := FieldByName('Value_').AsString;
    end;
  end;
  if ibox.Debug then
  begin
    if sName <> '' then sName := ', Name=' + sName;
    ibox.DebugText('NREG Read: Section=%s, Ident=%s, Default=%s%s', [Section, Ident, Default, sName]);
  end;
end;

function TSysValues.ReadInit(const Section, Ident: String;
  const Default: Integer): Integer;
var
  sName: String;
begin
  sName := '';
  Result := Default;
  with Buff[FBuffName] do
  begin
    if Locate('Root_;Code_',VarArrayOf([Section,Ident]),[loCaseInsensitive]) then
    begin
      sName := FieldByName('Key_').AsString;
      Result := FieldByName('Init_').AsInteger;
    end;
  end;
  if ibox.Debug then
  begin
    if sName <> '' then sName := ', Name=' + sName;
    ibox.DebugText('NREG Read: Section=%s, Ident=%s, Default=%d%s', [Section, Ident, Default, sName]);
  end;
end;

function TSysValues.ReadInit(const KeyNo: String;
  const Default: Integer = 0): Integer;
var
  str: String;
  sName: String;
begin
  sName := '';
  Result := Default;
  str := iif(Pos('.',KeyNo) > 0,Copy(KeyNo,1,Pos('.',KeyNo)-1),KeyNo);
  with Buff[FBuffName] do
  begin
    if Locate('Code_',str,[loCaseInsensitive]) then
      begin
        sName := FieldByName('Key_').AsString;
        Result := FieldByName('Init_').AsInteger;
      end
    else if Pos('.',KeyNo) > 0 then
      RepairValue(KeyNo, '', Default);
  end;
  if ibox.Debug then
  begin
    if sName <> '' then sName := ', Name=' + sName;
    ibox.DebugText('NREG Read: KeyNo=%s, Default=%d%s', [KeyNo, Default, sName]);
  end;
end;

function TSysValues.ReadData(const KeyNo, Default: String): String;
var
  str: String;
  sName: String;
begin
  sName := '';
  Result := Default;
  str := iif(Pos('.',KeyNo) > 0,Copy(KeyNo,1,Pos('.',KeyNo)-1),KeyNo);
  with Buff[FBuffName] do
  begin
    if Locate('Code_',str,[loCaseInsensitive]) then
      begin
        sName := FieldByName('Key_').AsString;
        Result := FieldByName('Value_').AsString
      end
    else if Pos('.',KeyNo) > 0 then
      RepairValue(KeyNo, Default, 0);
  end;
  if ibox.Debug then
  begin
    if sName <> '' then sName := ', Name=' + sName;
    ibox.DebugText('NREG Read: KeyNo=%s, Default=%s%s', [KeyNo, Default, sName]);
  end;
end;

procedure TSysValues.RepairValue(const KeyNo, strValue: String; intInit: Integer);
var
  s1, s2, s3: String;
  cdsTmp: TZjhDataSet;
begin
  //KeyNo值范例: 01-0006.mrp.启动制造参数管理
  s3 := KeyNo;
  s1 := Copy(s3,1,Pos('.',s3)-1); s3 := Copy(s3,Pos('.',s3)+1,Length(s3));
  s2 := Copy(s3,1,Pos('.',s3)-1); s3 := Copy(s3,Pos('.',s3)+1,Length(s3));
  //
  if MessageDlg(Format('经检查系统参数档中, 发现[%s.%s]项目没有登记, 要自动修复吗?', [s2,s3]),
    mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
  cdsTmp := TZjhDataSet.Create(DM.DCOM);
  with cdsTmp do
  try
    RemoteServer := DM.DCOM;
    TableName := 'SysValues';
    CommandText := Format('Select * From SysValues Where Code_=''%s''',[s1]);
    Open;
    if Eof then
      begin
        Append;
        FieldByName('Code_').AsString := s1;
        FieldByName('Root_').AsString := s2;
        FieldByName('Key_').AsString := s3;
        FieldByName('Init_').AsInteger := intInit;
        //
        FieldByName('Type_').AsString := 'S';
        FieldByName('Value_').AsString := strValue;
        FieldByName('Remark_').AsString := '';
        PostPro(0);
        Close;
        Buff.Clear(FBuffName);
        MsgBox(Chinese.AsString('自动修复成功！'));
      end
    else
      MsgBox(Chinese.AsString('修复失败！'));
  finally
    FreeAndNil(cdsTmp);
  end;
end;

function TSysValues.WriteString(const Section, Ident, Value: String;
  DataSet: TZjhDataSet): Boolean;
var
  cds: TZjhDataSet;
begin
  cds := TZjhDataSet.Create(nil);
  try
    with cds do
    begin
      RemoteServer := DM.DCOM;
      TableName := 'SysValues';
      CommandText := Format('Select * From SysValues Where Root_=''%s'' and Code_=''%s''',
        [Section, Ident]);
      Open;
      if Eof then
        begin
          Append;
          FieldByName('Root_').AsString := Section;
          FieldByName('Code_').AsString := Ident;
          FieldByName('Key_').AsString := Ident;
          FieldByName('Value_').AsString := '';
          FieldByName('Init_').AsInteger := 0;
          FieldByName('Value_').AsString := Value;
          PostPro(0);
          Result := True;
        end
      else if FieldByName('Value_').AsString <> Value then
        begin
          Edit;
          FieldByName('Value_').AsString := Value;
          PostPro(0);
          Result := True;
        end
      else
        Result := False;
      Buff.Clear(FBuffName);
    end;
  finally
    cds.Free;
  end;
  if Result then
    Buff.Clear(FBuffName);
end;

function TSysValues.WriteInit(const Section, Ident: String; Value: Integer;
  DataSet: TZjhDataSet): Boolean;
var
  cds: TZjhDataSet;
begin
  if not Assigned(DataSet) then
    begin
      Buff.Clear(FBuffName);
      cds := Buff[FBuffName];
      cds.TableName := 'SysValues';
    end
  else
    cds := DataSet;
  with cds do
  begin
    if not Locate('Root_;Code_',VarArrayOf([Section,Ident]),[loCaseInsensitive]) then
      begin
        Append;
        FieldByName('Root_').AsString := Section;
        FieldByName('Code_').AsString := Ident;
        FieldByName('Key_').AsString := Ident;
        FieldByName('Value_').AsString := '';
        FieldByName('Init_').AsInteger := 0;
        FieldByName('Init_').AsInteger := Value;
        PostPro(0);
        Result := True;
      end
    else if FieldByName('Init_').AsInteger <> Value then
      begin
        Edit;
        FieldByName('Init_').AsInteger := Value;
        PostPro(0);
        Result := True;
      end
    else
      Result := False;
  end;
  if Result then Buff.Clear(FBuffName);
end;

procedure TSysValues.Refresh;
begin
  Buff.Clear(FBuffName);
end;

class procedure CM.UpdateFieldDef(TargetDataSet: TZjhDataSet; const ATableName: String;
  TargetGrid: TDBGrid);
var
  s1: String;
  fd: TField;
  col: TColumn;
  bUpdate: Boolean;
begin
  bUpdate := False;
  with Buff['FieldDef'] do
  begin
    if not Active then
      Buff.OpenDataSet('FieldDef');
    Filter := Format('Table_=''%s''', [ATableName]);
    Filtered := True;
    while not Eof do
    begin
      FD := nil;
      if FieldByName('Width_').AsInteger > 0 then
      begin
        s1 := FieldByName('Type_').AsString;
        s1 := Copy(s1, Pos('(',s1) + 1, Length(s1));
        if TargetDataSet.Fields.Count > 0 then
        begin
          if Copy(FieldByName('Type_').AsString,1,8) = 'nvarchar' then
            begin
              fd := TWideStringField.Create(TargetDataSet);
              fd.Size := StrToIntDef(Copy(s1, 1, Pos(')',s1) - 1),20);
              //fd.Calculated := true;
            end
          else if FieldByName('Type_').AsString = 'int' then
            fd := TIntegerField.Create(TargetDataSet)
          else if FieldByName('Type_').AsString = 'float' then
            fd := TFloatField.Create(TargetDataSet)
          else if FieldByName('Type_').AsString = 'datetime' then
            fd := TDateTimeField.Create(TargetDataSet)
          else
            fd := nil;
          if Assigned(fd) then
          begin
            fd.FieldName := FieldByName('Code_').AsString;
            fd.Name := TargetDataSet.Name + fd.FieldName;
            fd.DataSet := TargetDataSet;
          end;
        end;
        if Assigned(fd) then
        begin
          col := TargetGrid.Columns.Add;
          col.FieldName := FieldByName('Code_').AsString;
          col.Title.Caption := FieldByName('Name_').AsString;
          col.Width := FieldByName('Width_').AsInteger;
          col.Title.Alignment := taCenter;
          bUpdate := True;
        end;
      end;
      Next;
    end;
    Filtered := False;
  end;
  //Jason 2006/6/26 修改，目的是防止当表格没有自定义栏位时，不执行更新代码(否则会报错)
  if bUpdate then
  begin
    if Assigned(TargetDataSet.DataSetField) or Assigned(TargetDataSet.RemoteServer) then
      TargetDataSet.FieldDefs.Update;
  end;
end;

procedure GetDefFields(sl: TStrings; const ATableName: String);
begin
  with Buff['FieldDef'] do
  try
    if not Active then Buff.OpenDataSet('FieldDef');
    Filter := Format('Table_=''%s''', [ATableName]);
    Filtered := True;
    while not Eof do
    begin
      sl.Add(FieldByName('Code_').AsString);
      Next;
    end;
  finally
    Filtered := False;
  end;
end;

function UnitDigit(Value: Double; const AUnit: String): Double;
var
  R: Variant;
  Digits: Integer;
  {$IFDEF ERP2011}
  cdsDigit: TZjhDataSet;
  {$ENDIF}
begin
  {$IFDEF ERP2011}
  Result := 0;
  {$ENDIF}
  R := Buff.ReadValue('UnitDigit', AUnit, 'Digit_');
  if not VarIsNull(R) then
    Digits := R
  else
    begin
      {$IFDEF ERP2011}
      Digits := 4;
      cdsDigit := TZjhDataSet.Create(DM.DCOM);
      try
        with cdsDigit do
        begin
          RemoteServer := DM.DCOM;
          TableName := 'PartPurRate';
          CommandText := Format('Select * From PartPurRate Where Unit_=N''%s''',[AUnit]);
          Open;
          if Eof then
            begin
              Append;
              FieldByName('ID_').AsString := NewGuid;
              FieldByName('Unit_').AsString := AUnit;
              FieldByName('PurUnit_').AsString := AUnit;
              FieldByName('PurRate_').AsInteger := 1;
              FieldByName('AccDigit_').AsInteger := Digits;
              FieldByName('UpdateKey_').AsString := NewGuid;
              PostPro(0);
            end
          else
            Digits := FieldByName('AccDigit_').AsInteger;
        end;
      finally
        FreeAndNil(cdsDigit);
      end;
      Buff.Clear('UnitDigit');
      {$ELSE}
      raise Exception.CreateFmt(Chinese.AsString('单位名称[%s]不存在，请检查！'), [AUnit]);
      {$ENDIF}
    end;
  Result := StrToFloat(FloatToStrF(Value, ffFixed, 18, Digits));
end;

function GetUnitByType(const UnitType: Integer): String;
var
  sl: TStringList;
begin
  Result := '';
  sl := TStringList.Create;
  try
    with Buff['UnitDigit'] do
    begin
      First;
      while not Eof do
      begin
        if UnitType = FieldByName('Type_').AsInteger then
          sl.Add(FieldByName('Code_').AsString);
        Next();
      end;
    end;
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

procedure GetValuesOfMenuParam(const FormCode, Session: String;
  Address: TStringList);
var
  Ini: TSecIniFile;
  ss, s1: String;
begin
  Ini := TSecIniFile.Create(FormCode);
  try
    ss := Ini.Param.ReadString('Changed Message',Session,'');
    if ss <> '' then
    begin
      while Pos(',',ss) > 0 do
      begin
        s1 := Copy(ss, 1, Pos(',',ss)-1);
        ss := Copy(ss, Pos(',',ss)+1, Length(ss));
        if s1 <> '' then Address.Add(s1);
      end;
      if ss <> '' then Address.Add(ss);
    end;
  finally
    FreeAndNil(Ini);
  end;
end;

class function CM.SendMail(const UserTo, Subject, Body, AppUser: String): Boolean;
begin
  Result := SendErpInfo(UserTo, Subject, Body, AppUser, False, False, False);
end;

{ TSecIniFile }

constructor TSecIniFile.Create(const FormCode: String);
var
  sl: TStringList;
  cdsView: TZjhDataSet;
begin
  FFormCode := FormCode;
  sl := TStringList.Create;
  cdsView := TZjhDataSet.Create(DM.DCOM);
  try
    with cdsView do
    begin
      RemoteServer := DM.DCOM;
      Database := 'Common';
      CommandText := Format('Select Param_ From SysFormDef '
        + 'Where Code_=''%s''',[FormCode]);
      Open;
      if not Eof then
        sl.Text := FieldByName('Param_').AsString;
      Close;
    end;
    FParam := TMemIniFile.Create('');
    FParam.SetStrings(sl);
  finally
    FreeAndNil(cdsView);
    FreeAndNil(sl);
  end;
end;

procedure TSecIniFile.Save;
var
  sl: TStringList;
  cdsView: TZjhDataSet;
begin
  SL := TStringList.Create;
  cdsView := TZjhDataSet.Create(DM.DCOM);
  try
    Param.GetStrings(sl);
    with cdsView do
    begin
      RemoteServer := DM.DCOM;
      Database := 'Common';
      TableName := 'SysFormDef';
      CommandText := Format('Select * From SysFormDef '
        + 'Where Code_=''%s''',[FFormCode]);
      Open;
      if not Eof then
      begin
        Edit;
        FieldByName('Param_').AsString := sl.Text;
        PostPro(0);
      end;
    end;
  finally
    FreeAndNil(cdsView);
    FreeAndNil(sl);
  end;
end;

destructor TSecIniFile.Destroy;
begin
  FreeAndNil(FParam);
  inherited;
end;

function TSecIniFile.Data: String;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    Param.GetStrings(sl);
    Result := sl.Text;
  finally
    FreeAndNil(sl);
  end;
end;

initialization
  Buffs := TBuffManger.Create(nil);
  //ReportParam := NULL;
  cdsSQL := TZjhDataSet.Create(nil);

finalization
  FreeAndNil(Buffs);
  FreeAndNil(cdsSQL);

end.
