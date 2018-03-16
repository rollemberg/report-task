unit MailBox_class;
{$I ERPVersion.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, DB, ADODB, Grids, DBGrids, ComCtrls, ApConst,
  StdCtrls, Buttons, DateUtils, Math, AppBean, uBaseIntf;

type
  //处理电子签核流程发送
  TMailBox = class(TAppBean)
  private
    FTID: String;
    FMailID: String;
    FSubject: String;
    FBody: String;
    FMailAmount: Currency;
    {$IFDEF ERP2008}
    FAppUser: String;
    FirstOrder: Integer;
    {$ENDIF}
    FDeptCode: string;
    FTableID: String;
    FFlowClass: Integer;
    FFlowCode: String;
    cdsIncept: TAppQuery;
    procedure SendMailTo(const FromUser, ToUser: String; FlowType: Integer);
    function GetTimeout(AStartTime: TDateTime; AStopTime: Integer): Integer;
    procedure SetTID(const Value: String);
    procedure SetMailID(const Value: String);
    procedure SetBody(const Value: String);
    procedure SetSubject(const Value: String);
    procedure SetMailAmount(const Value: Currency);
    procedure SetDeptCode(const Value: string);
    function GetTID: String;
    {$IFDEF ERP2008}
    function GetDefaultDBName: string;
    {$ENDIF}
    function GetCurDatabase: String;
    procedure SetTableID(const Value: String);
    procedure SetFlowClass(const Value: Integer);
    procedure SetFlowCode(const Value: String);
  private
    {$IFDEF ERP2008}
    procedure AddDept(Source, Target: TDataSet);
    procedure AddDeptLeader(Source, Target: TDataSet);
    procedure AddDeptManager(Source, Target: TDataSet);
    procedure AddUser(Source, Target: TDataSet; const UserCode: String);
    {$ENDIF}
    function GetCofferID(const UserID: String; AType: Integer): String;
    procedure AppendHead(const AppUser: String);
    function GetUserName(UserCode: String): String;
  public
    function Send(ToList: TComponent = nil): Boolean;
    {$IFDEF ERP2008}
    function SendForm(const AppUser, SQLCmd: String): Integer;
    {$ENDIF}
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
  public
    property TID: String read GetTID write SetTID;
    property MailID: String read FMailID write SetMailID;
    property Subject: String read FSubject write SetSubject;
    property Body: String read FBody write SetBody;
    property MailAmount: Currency read FMailAmount write SetMailAmount;
    property DeptCode: string read FDeptCode write SetDeptCode;
    //
    property TableID: String read FTableID write SetTableID;
    property FlowCode: String read FFlowCode write SetFlowCode;
    property FlowClass: Integer read FFlowClass write SetFlowClass;
  end;

implementation

uses SQLServer, AppWorkflowUser;

{ TMailBox }

//返回停止时间(专用于FileIncept)
function TMailBox.GetTimeout(AStartTime: TDateTime;
  AStopTime: Integer): Integer;
var
  oRs: TAppQuery;
begin
  Result := AStopTime;
  oRs := TAppQuery.Create(Application);
  try
    oRs.Connection := Self.Session.Connection;
    oRs.SQL.Text := Format('execute GetTimeout ''%s'',%d',
      [FormatDateTime('YYYY/MM/DD HH:MM:SS',AStartTime),AStopTime]);
    oRs.Open;
    if not oRs.EOF then
      Result := oRs.FieldByName('TimeOut_').AsInteger;
    oRs.Close;
  finally
    oRs.Free;
  end;
end;

function TMailBox.GetUserName(UserCode: String): String;
var
  cdsTmp: TAppQuery;
begin
  Result := '';
  cdsTmp := TAppQuery.Create(Application);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      CommandText := Format('select Name_ from Account where Code_=''%s''',
        [UserCode]);
      Open;
      if not EOF then
        Result := FieldByName('Name_').AsString;
    end;
  finally
    cdsTmp.Free;
  end;
end;

//发送一条讯息
procedure TMailBox.SendMailTo(const FromUser, ToUser: String; FlowType: Integer);
var
  cds: TAppQuery;
  UserID: String;
  StrTmp: String;
  ss: TSQLServer;
begin
  if FlowType > 0 then
    StrTmp := ChineseAsString('RS001', '以上内容等待您的签核，按此调出<a href="hrip:TFrmFlowList0">待签核单据！</a>')
  else
    StrTmp := VarToStr(GetUserName(FromUser)) + ChineseAsString('RS002', ' 意见如下：') + vbCrLf
      + StringOfChar('=', 40) + vbCrLf + ChineseAsString('RS003', '核准！');
  //
  ss := TSQLServer.Create;
  cds := TAppQuery.Create(nil);
  try
    UserID := GetUserInfo(ToUser, 'ID_');
    if ss.Open('Common') then
    with cds do
    begin
      Connection := ss.Connection;
      SQL.Text := 'Select top 0 * from SysRecord';
      Open;
      Append;
      FieldByName('MsgID_').AsString := NewGuid();
      FieldByName('MailBox_').AsString := ToUser;
      FieldByName('PID_').AsString := GetCofferID(UserID, DOC_PRIVATE_ACCEPT);
      FieldByName('CorpCode_').AsString := GetCurDatabase();
      FieldByName('ReceiveUser_').AsString := ToUser;
      FieldByName('AppUser_').AsString := FromUser;
      FieldByName('AppDate_').AsDateTime := Now();
      FieldByName('Subject_').AsString := Subject;
      FieldByName('Body_').AsString := Body + vbCrLf + StrTmp;
      FieldByName('Status_').AsInteger := 0;
      FieldByName('Email_').AsInteger := 0;
      FieldByName('SMS_').AsInteger := 0;
      FieldByName('TID_').AsInteger := 1002;
      FieldByName('UpdateKey_').AsString := NewGuid();
      Post;
      Close;
    end;
  finally
    FreeAndNil(cds);
    ss.Free;
  end;
end;

//取得邮箱子目录
function TMailBox.GetCofferID(const UserID: String; AType: Integer): String;
var
  cdsTmp: TAppQuery;
begin
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Connection;
      SQL.Text := Format('Select DirID_ From DirCoffer '
        + 'Where Owner_=''%s'' and Type_=%d', [UserID, AType]);
      Open;
      if not Eof then
        Result := FieldByName('DirID_').AsString
      else
        Result := UserID;
    end;
  finally
    FreeAndNil(cdsTmp);
  end;
end;

function TMailBox.GetCurDatabase: String;
var
  str: String;
const
  Flag = 'Initial Catalog=';
begin
  Result := '';
  str := Self.Session.Connection.ConnectionString;
  if Pos(Flag, str) > 0 then
  begin
    str := Copy(str, Pos(Flag, str) + Length(Flag), Length(str));
    if Pos(';', str) > 0 then
      str := Copy(str, 1, Pos(';', str) - 1);
  end;
  Result := str;
end;

function TMailBox.Send(ToList: TComponent): Boolean;
var
  i, It: Integer;
  bSendMail: Boolean;
  Item: TAppWorkflowUserRecord;
  List: TAppWorkflowUserList;
begin
  Result := False;
  bSendMail := False;
  if TID = '' then
    raise Exception.Create('Error: TableID is null.');
  //不需要签核
  if TID = GuidNull then Exit;
  //建立公文单身/收件者清单
  cdsIncept := TAppQuery.Create(nil);
  if not Assigned(ToList) then
    List := TAppWorkflowUserList.Create(Self)
  else
    List := ToList as TAppWorkflowUserList;
  try
    with cdsIncept do
    begin
      Connection := Self.Connection;
      {$IFDEF ERP2011}
      SQL.Text := 'Select PID_,ID_,Order_,Type_,Account_,StartTime_,Status_,'
        + 'StopTime_,TimeOut_ From FileIncept Where PID_=''' + MailID + '''';
      {$ELSE}
      SQL.Text := 'Select PID_,Order_,Type_,Account_,StartTime_,Status_,'
        + 'StopTime_,TimeOut_ From FileIncept Where PID_=''' + MailID + '''';
      {$ENDIF}
      Open;
      if Eof then
        begin
          It := 0;
          List.LoadAllUser(TID, DeptCode);
          for i := 0 to List.ItemCount - 1 do
          begin
            Item := List.GetItem(i);
            if not Locate('Account_', Item.UserCode, [loCaseInsensitive]) then
            begin
              if (Item.MaxMoney <= 0) or
                ((MailAmount >= Item.MinMoney) and (MailAmount <  Item.MaxMoney)) then
              begin
                It := It + 1;
                Append;
                FieldByName('Order_').AsInteger    := It;
                FieldByName('PID_').AsString       := Self.MailID;
                {$IFDEF ERP2011}
                FieldByName('ID_').AsString        := NewGuid();
                {$ENDIF}
                FieldByName('Account_').AsString   := Item.UserCode;
                FieldByName('Type_').AsInteger     := Item.FlowType;
                FieldByname('StopTime_').AsInteger := Item.StopTime;;
                FieldByName('Status_').AsInteger   := -1;
                if It = 1 then
                begin
                  //建立公文单头
                  AppendHead(Session.UserCode);
                end;
                //先找到第一位需签核人员，发送签核消息。
                if (Item.FlowType > 0) and (not bSendMail) then
                begin
                  FieldByName('Status_').AsInteger     := 0;
                  FieldByName('StartTime_').AsDateTime := Now();
                  FieldByName('TimeOut_').AsInteger    := GetTimeOut(Now(),
                    FieldByName('StopTime_').AsInteger);
                  SendMailTo(Session.UserCode, FieldByName('Account_').AsString,
                    FieldByName('Type_').AsInteger);
                  bSendMail := True;
                end;
                Post;
              end;
            end;
          end;
          //处理仅有通知型人员
          if not bSendMail then
          begin
            First;
            while not Eof do
            begin
              SendMailTo(Session.UserCode, FieldByName('Account_').AsString,
                FieldByName('Type_').AsInteger);
              Next;
            end;
          end;
        end
      else
        AppendHead(Session.UserCode);
    end;
    Result := bSendMail;//无签核人员单据应直接过帐
  finally
    FreeAndNil(cdsIncept);
    if not Assigned(ToList) then
      List.Free;
  end;
end;

procedure TMailBox.AppendHead(const AppUser: String);
var
  cdsTemp: TAppQuery;
begin
  cdsTemp := TAppQuery.Create(nil);
  try
    with cdsTemp do
    begin
      Connection := Self.Connection;
      SQL.Text := 'Select * from FileData Where ID_=''' + Self.MailID + '''';
      Open();
      //先删
      Self.Connection.Execute('delete FileIncept where PID_=''' + Self.MailID + '''');
      while not Eof do Delete;
      //后增
      Append();
      FieldByName('TID_').AsString := FTableID;
      FieldByName('ID_').AsString := Self.MailID;
      FieldByName('Subject_').AsString := Self.Subject;
      FieldByName('Body_').AsString := Self.Body;
      FieldByName('Class_').Value := FlowClass;
      FieldByName('FlowCode_').AsString := FlowCode;
      FieldByName('AppClass_').AsString := Self.Owner.ClassName;
      FieldByName('Status_').AsInteger := 0;
      FieldByName('SendUser_').AsString := AppUser;
      FieldByName('SendTime_').Value := Now();
      FieldByName('StartTime_').Value := Now();
      Post;
      Close;
    end;
  finally
    FreeAndNil(cdsTemp);
  end;
end;

{$IFDEF ERP2008}
function TMailBox.GetDefaultDBName: string;
begin
  Result := sreg.ReadString('AppSvr','Database',SOFTWARE_NAME)
end;

function TMailBox.SendForm(const AppUser, SQLCmd: String): Integer;
var
  cdsData, cdsSource,cdsTemp: TAppQuery;
  //取得指定用户之ID_
  function GetUserDept(const UserCode: String): String;
  var
    cdsTmp: TAppQuery;
  begin
    cdsTmp := TAppQuery.Create(nil);
    try
      with cdsTmp do
      begin
        Connection := Self.Connection;
        SQL.Text := Format('Select DeptCode_ From %s.dbo.Account Where Code_=''%s''',
          [GetDefaultDBName(), UserCode]);
        Open;
        if not Eof then
          Result := FieldByName('DeptCode_').AsString
        else
          Result := '';
      end;
    finally
      FreeAndNil(cdsTmp);
    end;
  end;
begin
  FAppUser := AppUser;
  Result := 0;
  if TID = '' then
    raise Exception.Create('Error: TableID is null.');
  //不需要签核
  if TID = GuidNull then Exit;

  //建立公文单身/收件者清单
  cdsData := TAppQuery.Create(nil);
  cdsSource := TAppQuery.Create(nil);
  try
    with cdsData do
    begin
      Connection := Self.Connection;
      SQL.Text := 'Select PID_,ID_,Order_,Type_,Account_,StartTime_,Status_,'
        + 'StopTime_,TimeOut_ From FileIncept Where PID_=''' + MailID + '''';
      Open;
      if not Eof then
      begin
        //当存在自定义签核时, 则退出
        Result := cdsData.RecordCount;
        Exit;
      end;
    end;
    cdsSource.Connection := Self.Connection;
    cdsSource.SQL.Text := Format('Select ObjType_,Account_,Order_,MinMoney_,'
      + 'MaxMoney_,Type_,StopTime_ From TableFlow Where PID_=''%s'' '
      + 'Order by Order_', [TID]);
    if SQLCmd <> '' then
      cdsSource.SQL.Text := SQLCmd;
    FirstOrder := -1000;
    with cdsSource do
    begin
      Open;
      while not Eof do
      begin
        if (FieldByName('MaxMoney_').AsFloat = 0) or
          (
                (MailAmount >= FieldByName('MinMoney_').AsFloat)
            and (MailAmount <  FieldByName('MaxMoney_').AsFloat)
          ) then
        begin
          //取第一个等级
          if FirstOrder = -1000 then
            FirstOrder := FieldByName('Order_').AsInteger;
          //开始登记记录
          case FieldByName('ObjType_').AsInteger of
          0: //使用者
            AddUser(cdsSource, cdsData, FieldByName('Account_').AsString);
          1: //部门主管
            AddDept(cdsSource, cdsData);
          2: //部门经理
            AddDeptManager(cdsSource, cdsData);
          3: //制单员主管
            begin
              FDeptCode := GetUserDept(AppUser);
              AddDeptLeader(cdsSource, cdsData);
            end;
          4: //制单员经理
            begin
              FDeptCode := GetUserDept(AppUser);
              AddDeptManager(cdsSource, cdsData);
            end;
          end;
        end;
        Next;
      end;
    end;
    Result := cdsData.RecordCount;
  finally
    FreeAndNil(cdsSource);
    FreeAndNil(cdsData);
  end;
  if Result = 0 then Exit;
  //建立公文单头
  cdsTemp := TAppQuery.Create(nil);
  try
    with cdsTemp do
    begin
    Connection := Self.Connection;
    SQL.Text := 'Select * from FileData Where ID_=''' + Self.MailID + '''';
    Open();
    //先删
    Self.Connection.Execute('delete FileIncept where PID_=''' + Self.MailID + '''');
    while not Eof do Delete;
    //后增
    Append();
    FieldByName('TID_').AsString := FTableID;
    FieldByName('ID_').AsString := Self.MailID;
    FieldByName('Subject_').AsString := Self.Subject;
    FieldByName('Body_').AsString := Self.Body;
    FieldByName('Class_').Value := FlowClass;
    FieldByName('FlowCode_').AsString := FlowCode;
    FieldByName('Status_').AsInteger := 0;
    FieldByName('SendUser_').AsString := AppUser;
    FieldByName('SendTime_').Value := Now();
    FieldByName('StartTime_').Value := Now();
    Post;
    Close;
    end;
  finally
    FreeAndNil(cdsTemp);
  end;
end;
{$ENDIF}

procedure TMailBox.SetTID(const Value: String);
begin
  FTID := Value;
end;

procedure TMailBox.SetMailID(const Value: String);
begin
  FMailID := Value;
end;

procedure TMailBox.SetBody(const Value: String);
begin
  FBody := Value;
end;

procedure TMailBox.SetSubject(const Value: String);
begin
  FSubject := Value;
end;

procedure TMailBox.SetMailAmount(const Value: Currency);
begin
  FMailAmount := Value;
end;

{$IFDEF ERP2008}
procedure TMailBox.AddUser(Source, Target: TDataSet; const UserCode: String);
begin
  with Target do
  begin
    if not Locate('Account_', UserCode, [loCaseInsensitive]) then
    begin
      Append;
      FieldByName('PID_').AsString       := Self.MailID;
      FieldByName('ID_').AsString        := NewGuid();
      FieldByName('Order_').AsInteger    := Source.FieldByName('Order_').AsInteger;
      FieldByName('Type_').AsInteger     := Source.FieldByName('Type_').AsInteger;
      FieldByName('Account_').AsString   := UserCode;
      FieldByname('StopTime_').AsInteger := Source.FieldByName('StopTime_').AsInteger;
      FieldByName('Status_').AsInteger   := -1;
      //
      if Source.FieldByName('Order_').AsInteger = FirstOrder then
      begin
        FieldByName('Status_').AsInteger     := 0;
        FieldByName('StartTime_').AsDateTime := Now();
        FieldByName('TimeOut_').AsInteger    := GetTimeOut(Now(), FieldByName('StopTime_').AsInteger);
        SendMailTo(FAppUser, UserCode);
      end;
      Post;
    end;
  end;
end;

procedure TMailBox.AddDept(Source, Target: TDataSet);
var
  cdsTmp: TAppQuery;
begin
  if FDeptCode = '' then Exit;
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Connection;
      SQL.Text := Format('Select LeaderCode_ From Dept Where Code_=''%s''',
        [DeptCode]);
      Open;
      if not Eof then
      if Trim(FieldByName('LeaderCode_').AsString) <> '' then
        AddUser(Source, Target, FieldByName('LeaderCode_').AsString);
    end;
  finally
    FreeAndNil(cdsTmp);
  end;
end;

procedure TMailBox.AddDeptLeader(Source, Target: TDataSet);
var
  cdsTmp: TAppQuery;
begin
  if FDeptCode = '' then Exit;
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Connection;
      SQL.Text := Format('Select LeaderCode_ From Dept Where Code_=''%s''', [DeptCode]);
      Open;
      if not Eof then
      if Trim(FieldByName('LeaderCode_').AsString) <> '' then
        AddUser(Source, Target, FieldByName('LeaderCode_').AsString);
    end;
  finally
    FreeAndNil(cdsTmp);
  end;
end;

procedure TMailBox.AddDeptManager(Source, Target: TDataSet);
var
  cdsTmp: TAppQuery;
begin
  if FDeptCode = '' then Exit;
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Connection;
      SQL.Text := Format('Select ManagerCode_ From Dept Where Code_=''%s''', [DeptCode]);
      Open;
      if not Eof then
      if Trim(FieldByName('ManagerCode_').AsString) <> '' then
        AddUser(Source, Target, FieldByName('ManagerCode_').AsString);
    end;
  finally
    FreeAndNil(cdsTmp);
  end;
end;
{$ENDIF}

procedure TMailBox.SetDeptCode(const Value: string);
begin
  FDeptCode := Value;
end;

function TMailBox.GetTID: String;
begin
  if FTID <> '' then
    Result := FTID
  else
    Result := FTableID;
end;

procedure TMailBox.SetTableID(const Value: String);
begin
  FTableID := Value;
end;

procedure TMailBox.SetFlowClass(const Value: Integer);
begin
  FFlowClass := Value;
end;

procedure TMailBox.SetFlowCode(const Value: String);
begin
  FFlowCode := Value;
end;

function TMailBox.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
begin
  Result := False;
end;

end.
