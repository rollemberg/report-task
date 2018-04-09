unit WFSend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, DB, ADODB, Grids, DBGrids, ComCtrls, ApConst,
  StdCtrls, Buttons, DateUtils, Math, AppBean, AppWorkflowUser;

type
  //处理电子签核流程发送
  TWFObject = class(TComponent)
  private
    FTTID: String;
    FObjID: String;
    FSubject: String;
    FBody: String;
    FAmount: Currency;
    FDeptCode: string;
    FAppClass: String;
    FViewClass: String;
    FHID: String;
    FTTCode: String;
    procedure SetObjID(const Value: String);
    procedure SetBody(const Value: String);
    procedure SetSubject(const Value: String);
    procedure SetAmount(const Value: Currency);
    procedure SetDeptCode(const Value: string);
    procedure SetAppClass(const Value: String);
    procedure SetViewClass(const Value: String);
    procedure SetHID(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
    procedure SetTTCode(AConnection: TADOConnection; const Value: String);
    //必选属性
    property TTID: String read FTTID;                              //TranT.ID_
    property TTCode: String read FTTCode;                          //TranT.Code_                             //TranT.Code_;
    property ObjID: String read FObjID write SetObjID;             //TranH.ID_ or TranB.ID_
    property Subject: String read FSubject write SetSubject;       //Subject
    property Body: String read FBody write SetBody;                //Body
    property AppClass: String read FAppClass write SetAppClass;    //后台记账Class
    property ViewClass: String read FViewClass write SetViewClass; //前台显示Class
    //可选属性
    property HID: String read FHID write SetHID;                   //TranH.ID_，默认为GuidNull
    property DeptCode: string read FDeptCode write SetDeptCode;
    property Amount: Currency read FAmount write SetAmount;
  end;
  //处理电子签核流程发送
  TWFSend = class(TAppBean)
  private
    WFObj: TWFObject;
    procedure SendMailTo(const FromUser, ToUser: String);
    function GetTimeout(AStartTime: TDateTime; AStopTime: Integer): Integer;
    function GetCurDatabase: String;
    function GetCofferID(const UserID: String; AType: Integer): String;
    procedure AddItem(DataSet: TDataSet; Item: TAppWorkflowUserRecord);
    procedure AddHead(DataSet: TDataSet);
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    function Send(AWFObj: TWFObject; WFList: TComponent): Boolean; Virtual;
    function SendDefaultList(AWFObj: TWFObject): Boolean;
  end;
  //单表签核基类
  TWFSingleTable = class(TAppBean)
  protected
    RecordID: String;
    ViewClass: String;
    cdsView: TAppQuery;
    function OpenDataSet: Boolean; virtual; abstract;
    procedure BuildTarget(WFObj: TWFObject); virtual; abstract;
  public
    function Execute(const Param: OleVariant;
      var Data: OleVariant): Boolean; override;
  end;

implementation

uses SQLServer;

{ TWFSend }

//返回停止时间(专用于FileIncept)
function TWFSend.GetTimeout(AStartTime: TDateTime;
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

//发送一条讯息
procedure TWFSend.SendMailTo(const FromUser, ToUser: String);
var
  cds: TAppQuery;
  UserID: String;
  ss: TSQLServer;
begin
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
      FieldByName('Subject_').AsString := WFObj.Subject;
      FieldByName('Body_').AsString := WFObj.Body + vbCrLf
        + ChineseAsString('RS001', '以上内容等待您的签核，按此调出<a href="hrip:TFrmFlowList0">待签核单据！</a>');
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
function TWFSend.GetCofferID(const UserID: String; AType: Integer): String;
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

function TWFSend.GetCurDatabase: String;
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

function TWFSend.Send(AWFObj: TWFObject; WFList: TComponent): Boolean;
var
  i: Integer;
  Item: TAppWorkflowUserRecord;
  List: IAppWorkflowUserList;
  Obj: TAppWorkflowUserList;
  cdsHead: TAppQuery;
  cdsIncept: TAppQuery;
begin
  WFObj := AWFObj;
  Result := False;
  if WFObj.TTID = '' then
    raise Exception.Create('Error: TTID is null.');
  //不需要签核
  if WFObj.TTID = GuidNull then
    Exit;
  //建立公文单身/收件者清单
  if Assigned(WFList) then
    begin
      Obj := nil;
      List := WFList as IAppWorkflowUserList;
    end
  else
    begin
      Obj := TAppWorkflowUserList.Create(Self);
      Obj.LoadAllUser(WFObj.TTID, WFObj.DeptCode);
      List := Obj as IAppWorkflowUserList;
    end;
  cdsHead := TAppQuery.Create(nil);
  cdsIncept := TAppQuery.Create(nil);
  try
    with cdsIncept do
    begin
      Connection := Self.Connection;
      SQL.Text := 'Select PID_,Order_,Type_,Account_,StartTime_,Status_,'
        + 'StopTime_,TimeOut_ From FileIncept Where PID_=''' + WFObj.ObjID + '''';
      Open;
      if Eof then //如果不存在自定义签核项目，则从列表中取得
      begin
        for i := 0 to List.ItemCount - 1 do
        begin
          Item := List.GetItem(i);
          if not Locate('Account_', Item.UserCode, [loCaseInsensitive]) then
          begin
            if (Item.MaxMoney <= 0) or
              ((WFObj.Amount >= Item.MinMoney) and (WFObj.Amount < Item.MaxMoney)) then
            begin
              AddItem(cdsIncept, Item);
            end;
          end;
        end;
      end;
    end;
    if cdsIncept.RecordCount > 0 then
    begin
      //建立公文单头
      with cdsHead do
      begin
        Connection := Self.Connection;
        SQL.Text := Format('Select * from FileData Where ID_=''%s''', [WFObj.ObjID]);
        Open();
        //先删
        Self.Connection.Execute('delete FileIncept where PID_=''' + WFObj.ObjID + '''');
        while not Eof do Delete;
        //增加
        AddHead(cdsHead);
        Close;
      end;
      Result := True;
    end;
  finally
    FreeAndNil(cdsIncept);
    FreeAndNil(cdsHead);
    if Assigned(Obj) then
      Obj.Free;
  end;
end;

function TWFSend.SendDefaultList(AWFObj: TWFObject): Boolean;
begin
  Result := Send(AWFObj, nil);
end;

procedure TWFSend.AddHead(DataSet: TDataSet);
begin
  with DataSet do
  begin
    //后增
    Append();
    FieldByName('TID_').AsString      := WFObj.TTID;
    FieldByName('ID_').AsString       := WFObj.ObjID;
    FieldByName('Subject_').AsString  := WFObj.Subject;
    FieldByName('Body_').AsString     := WFObj.Body;
    //FieldByName('Class_').Value     := FlowClass;
    FieldByName('FlowCode_').AsString := WFObj.ViewClass;
    FieldByName('AppClass_').AsString := WFObj.AppClass;
    FieldByName('Status_').AsInteger  := 0;
    FieldByName('SendUser_').AsString := Session.UserCode;
    FieldByName('SendTime_').Value    := Now();
    FieldByName('StartTime_').Value   := Now();
    Post;
  end;
end;

procedure TWFSend.AddItem(DataSet: TDataSet; Item: TAppWorkflowUserRecord);
var
  It: Integer;
begin
  with DataSet do
  begin
    if (Item.MaxMoney <= 0) or ((WFObj.Amount >= Item.MinMoney) and (WFObj.Amount < Item.MaxMoney)) then
    begin
      if not Locate('Account_', Item.UserCode, [loCaseInsensitive]) then
      begin
        It := RecordCount + 1;
        Append;
        FieldByName('Order_').AsInteger    := It;
        FieldByName('PID_').AsString       := WFObj.ObjID;
        FieldByName('Account_').AsString   := Item.UserCode;
        FieldByName('Type_').AsInteger     := Item.FlowType;
        FieldByname('StopTime_').AsInteger := Item.StopTime;;
        FieldByName('Status_').AsInteger   := -1;
        //从第一个开始签核
        if It = 1 then
        begin
          FieldByName('Status_').AsInteger     := 0;
          FieldByName('StartTime_').AsDateTime := Now();
          FieldByName('TimeOut_').AsInteger    := GetTimeOut(Now(),
            FieldByName('StopTime_').AsInteger);
          SendMailTo(Session.UserCode, Item.UserCode);
        end;
        Post;
      end;
    end;
  end;
end;

function TWFSend.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
begin
  Result := False;
end;

{ TWFObject }

procedure TWFObject.SetTTCode(AConnection: TADOConnection; const Value: String);
var
  cdsTmp: TAppQuery;
begin
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := AConnection;
      SQL.Text := Format('select ID_ from TranT where Code_=''%s''', [Value]);
      Open;
      if Eof then
        raise Exception.CreateFmt('not find TranT.Code_=%s', [Value]);
      FTTCode := Value;
      FTTID := FieldByName('ID_').AsString;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TWFObject.SetViewClass(const Value: String);
begin
  FViewClass := Value;
end;

procedure TWFObject.SetObjID(const Value: String);
begin
  FObjID := Value;
end;

procedure TWFObject.SetBody(const Value: String);
begin
  FBody := Value;
end;

procedure TWFObject.SetSubject(const Value: String);
begin
  FSubject := Value;
end;

constructor TWFObject.Create(AOwner: TComponent);
begin
  inherited;
  FHID := GuidNull;
  FDeptCode := '';
  FAmount := 0;
end;

procedure TWFObject.SetAmount(const Value: Currency);
begin
  FAmount := Value;
end;

procedure TWFObject.SetDeptCode(const Value: string);
begin
  FDeptCode := Value;
end;

procedure TWFObject.SetHID(const Value: String);
begin
  FHID := Value;
end;

procedure TWFObject.SetAppClass(const Value: String);
begin
  FAppClass := Value;
end;

{ TWFSingleTable }

function TWFSingleTable.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  CurStatus, NewStatus: Integer;
  WFObj: TWFObject;
  WFSend: TWFSend;
  cmd: String;
begin
  Result := False;
  RecordID := Param[0];
  CurStatus := Param[1];
  NewStatus := Param[2];
  ViewClass := Param[3];
  cdsView := TAppQuery.Create(Self);
  try
    if not OpenDataSet() then
    begin
      raise Exception.CreateFmt(ChineseAsString('SR001', '唯一标识%s找不到，请检查！'),
        [RecordID]);
      Exit;
    end;
    if (CurStatus = 0) and (NewStatus = 1) then
      begin
        //送签
        if cdsView.FieldByName('FlowStatus_').AsInteger <> 1 then
          raise Exception.CreateFmt(ChineseAsString('SR002', '操作有误：(%d -> %d)，请与软件供应商联系！'),
            [CurStatus, NewStatus]);
        //删除所有历史的送签记录，不支持自定义签核
        cmd := Format('delete FileIncept where PID_=''%s''', [RecordID]);
        Self.Connection.Execute(cmd);
        cmd := Format('delete FileData where ID_=''%s''', [RecordID]);
        Self.Connection.Execute(cmd);
        //发送邮件
        WFObj := TWFObject.Create(Self);
        WFSend := TWFSend.Create(Self);
        try
          BuildTarget(WFObj);
          if not WFSend.SendDefaultList(WFObj) then
            raise Exception.Create(ChineseAsString('SR003', '送签失败，请检查您的设置或操作！'));
        finally
          WFSend.Free;
          WFObj.Free;
        end;
      end
    else if (CurStatus = 1) and (NewStatus = 0) then
      begin
        with cdsView do
        begin
          if FieldByName('FlowStatus_').AsInteger = 0 then
            begin
              //主动撤消送签，则删除所有的送签记录
              cmd := Format('delete FileIncept where PID_=''%s''', [RecordID]);
              Self.Connection.Execute(cmd);
              cmd := Format('delete FileData where ID_=''%s''', [RecordID]);
              Self.Connection.Execute(cmd);
            end
          else
            begin
              //签核不同意
              Edit;
              FieldByName('FlowStatus_').AsInteger := 0;
              FieldByName('Final_').AsBoolean := False;
              Post;
            end;
        end;
      end
    else if (CurStatus = 1) and (NewStatus = 2) then
      begin
        with cdsView do
        begin
          //审核同意
          Edit;
          FieldByName('FlowStatus_').AsInteger := 2;
          FieldByName('Final_').AsBoolean := True;
          Post;
        end;
      end
    else
      raise Exception.CreateFmt(ChineseAsString('SR004', '错误的指令：(%d -> %d)，请检查您的操作！'),
        [CurStatus, NewStatus]);
    Result := True;
  finally
    cdsView.Free;
    cdsView := nil;
  end;
end;

end.
