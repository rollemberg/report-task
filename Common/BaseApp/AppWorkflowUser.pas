unit AppWorkflowUser;
{$I ERPVersion.inc}

interface

uses
  Classes, SysUtils, AppBean;

type
  TAppWorkflowUserRecord = class
  public
    UserCode: String;
    FlowType: Integer;
    StopTime: Integer;
    MinMoney, MaxMoney: Double;
    constructor Create;
  end;
  IAppWorkflowUserList = interface
    ['{7B3640F2-4273-437D-B656-9A50595E33B2}']
    function ItemCount: Integer;
    function GetItem(Index: Integer): TAppWorkflowUserRecord;
  end;
  TAppWorkflowUserList = class(TAppBean, IAppWorkflowUserList)
  private
    FList: TList;
    function GetDeptLeader(const ADept: String; ALevel: Integer): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadAllUser(const ATID, ADeptCode: String);
    //IAppWorkflowUserList
    function ItemCount: Integer;
    function GetItem(Index: Integer): TAppWorkflowUserRecord;
    //TAppBean
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
  end;

implementation

{ TAppWorkflowUserList }

constructor TAppWorkflowUserList.Create(AOwner: TComponent);
begin
  inherited;
  FList := TList.Create;
end;

destructor TAppWorkflowUserList.Destroy;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    TObject(FList.Items[i]).Free;
  FList.Free;
  inherited;
end;

function TAppWorkflowUserList.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
begin
  Result := False;
end;

procedure TAppWorkflowUserList.LoadAllUser(const ATID, ADeptCode: String);
var
  FirstOrder: Integer;
  cdsTmp: TAppQuery;
  Item: TAppWorkflowUserRecord;
  sUser: String;
  sl: TStringList;
  i: Integer;
begin
  sl := TStringList.Create;
  cdsTmp := TAppQuery.Create(Self);
  try
    FirstOrder := -1000;
    with cdsTmp do
    begin
      Connection := Self.Connection;
      SQL.Text := Format('Select ObjType_,Account_,Order_,MinMoney_,'
        + 'MaxMoney_,Type_,StopTime_ From TableFlow Where PID_=''%s'' '
        + 'Order by Order_',
        [ATID]);
      Open;
      while not Eof do
      begin
        //取第一个等级
        if FirstOrder = -1000 then
          FirstOrder := FieldByName('Order_').AsInteger;
        //开始登记记录
        case FieldByName('ObjType_').AsInteger of
        0: sUser := FieldByName('Account_').AsString; //使用者
        1: sUser := GetDeptLeader(ADeptCode, 1);  //部门主管
        2: sUser := GetDeptLeader(ADeptCode, 2);  //部门经理
        3: sUser := GetDeptLeader(GetUserInfo(Session.UserCode, 'DeptCode_'), 1); //制单员主管
        4: sUser := GetDeptLeader(GetUserInfo(Session.UserCode, 'DeptCode_'), 2); //制单员经理
        {$IFDEF OKUMA}
        5: sUser := GetDeptLeader(ADeptCode, 5);// 部门主管1
        6: sUser := GetDeptLeader(ADeptCode, 6);// 部门主管2
        7: sUser := GetDeptLeader(ADeptCode, 7);// 部门主管3
        8: sUser := GetDeptLeader(ADeptCode, 8);// 部门主管4
        9: sUser := GetDeptLeader(ADeptCode, 9);// 部门主管5
        10: sUser := GetDeptLeader(ADeptCode, 10);// 部门主管6
        11: sUser := GetDeptLeader(GetUserInfo(Session.UserCode, 'DeptCode_'), 1); //制单员主管1
        12: sUser := GetDeptLeader(GetUserInfo(Session.UserCode, 'DeptCode_'), 6); //制单员主管2
        13: sUser := GetDeptLeader(GetUserInfo(Session.UserCode, 'DeptCode_'), 7); //制单员主管3
        14: sUser := GetDeptLeader(GetUserInfo(Session.UserCode, 'DeptCode_'), 8); //制单员主管4
        15: sUser := GetDeptLeader(GetUserInfo(Session.UserCode, 'DeptCode_'), 9); //制单员主管5
        16: sUser := GetDeptLeader(GetUserInfo(Session.UserCode, 'DeptCode_'), 10); //制单员主管6
        {$ENDIF}
        else sUser := '';
        end;
        //保存记录
        if sUser <> '' then
        begin
          if sl.IndexOf(sUser) = -1 then
          begin
            Item := TAppWorkflowUserRecord.Create;
            Item.UserCode := sUser;
            Item.FlowType := FieldByName('Type_').AsInteger;
            Item.StopTime := FieldByName('StopTime_').AsInteger;
            Item.MinMoney := FieldByName('MinMoney_').AsFloat;
            Item.MaxMoney := FieldByName('MaxMoney_').AsFloat;
            FList.Add(Item);
            sl.Add(sUser);
          end;
          //如果是核审人员自己做单则无需前一级人员再审
          if (sUser = Session.UserCode) and (FieldByName('Type_').AsInteger > 0) then
          begin
            for i := FList.Count - 1 downto 0 do
            begin
              Item := FList[i];
              if Item.FlowType > 0 then
              begin
                Item.Free;
                FList.Delete(i);
              end;
            end
          end;
        end;
        Next;
      end;
    end;
  finally
    cdsTmp.Free;
    sl.Free;
  end;
end;

function TAppWorkflowUserList.GetDeptLeader(const ADept: String; ALevel: Integer): String;
var
  cdsTmp: TAppQuery;
  sField: String;
begin
  if ADept = '' then
    Exit;
  cdsTmp := TAppQuery.Create(nil);
  try
    sField := 'LeaderCode_';
    case ALevel of
    1: sField := 'LeaderCode_';
    2: sField := 'ManagerCode_';
	{$IFDEF OKUMA}
    5: sField := 'LeaderCode_';
    6: sField := 'LeaderCode2_';
    7: sField := 'LeaderCode3_';
    8: sField := 'LeaderCode4_';
    9: sField := 'LeaderCode5_';
    10: sField := 'LeaderCode6_';
    {$ENDIF}
    else
       sField := 'LeaderCode_';
    end;
    with cdsTmp do
    begin
      Connection := Self.Connection;
      SQL.Text := Format('Select %s From Dept Where Code_=''%s''', [sField, ADept]);
      Open;
      if not Eof then
        Result := Trim(FieldByName(sField).AsString);
    end;
  finally
    FreeAndNil(cdsTmp);
  end;
end;

function TAppWorkflowUserList.GetItem(Index: Integer): TAppWorkflowUserRecord;
begin
  Result := FList.Items[Index];
end;

function TAppWorkflowUserList.ItemCount: Integer;
begin
  Result := FList.Count;
end;

{ TAppWorkflowUserRecord }

constructor TAppWorkflowUserRecord.Create;
begin
  UserCode := '';
  FlowType := 0;
  StopTime := 24; //停滞3 * 8H = 24H
  MinMoney := -1;
  MaxMoney := -1;
end;

end.
