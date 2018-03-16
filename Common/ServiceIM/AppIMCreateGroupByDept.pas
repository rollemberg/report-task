unit AppIMCreateGroupByDept;

interface

uses
  AppBean, Classes, uBaseIntf, Variants, SysUtils, ApConst;

type
  TAppIMCreateGroupByDept = class(TAppBean)
  private
    function AppendByDept(const DeptID, DeptCode: String): Integer;
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

{ TAppIMCreateGroupByDept }

function TAppIMCreateGroupByDept.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  cdsTmp: TAppQuery;
  UserCount: Integer;
  DeptID, DeptCode, DeptName: String;
begin
  DeptID := Param[0];
  DeptCode := Param[1];
  DeptName := Param[2];
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      CommandText := Format('Select ID_,Type_,Name_,UserCount_,'
        + 'AppDate_,AppUser_ from IM_GroupInfo '
        + 'where ID_=''%s''',
        [DeptID]);
      Open;
      if Eof then //增加一个新组
        begin
          UserCount := AppendByDept(DeptID, DeptCode);
          if UserCount > 0 then
            begin
              Append;
              FieldByName('ID_').AsString := DeptID;
              FieldByName('Type_').AsInteger := 1;
              FieldByName('Name_').AsString := DeptName;
              FieldByName('UserCount_').AsInteger := UserCount;
              FieldByName('AppDate_').AsDateTime := Now();
              FieldByName('AppUser_').AsString := Session.UserCode;
              Post;
              Result := True;
            end
          else
            begin
              Data := Format('此部门 %s 没有找到有成员存在，无法建立群！', [DeptName]);
              Result := False;
            end;
        end
      else
        Result := True;
    end;
  finally
    cdsTmp.Free;
  end;
end;

function TAppIMCreateGroupByDept.AppendByDept(const DeptID,
  DeptCode: String): Integer;
var
  cdsUser: TAppQuery;
  UserCode, SQLCmd: String;
begin
  cdsUser := TAppQuery.Create(Self);
  try
    with cdsUser do
    begin
      Connection := Self.Session.Connection;
      CommandText := Format('select Code_ from Account '
        + 'where DeptCode_=''%s'' and Enabled_=1', [DeptCode]);
      Open;
      if not Eof then
        begin
          while not Eof do
          begin
            UserCode := FieldByName('Code_').AsString;
            SQLCmd := Format('insert into IM_GroupUser (GroupID_,UserCode_,Manage_) '
              + 'values (''%s'', ''%s'', 0)', [DeptID, UserCode]);
            Session.Connection.Execute(SQLCmd);
            Next;
          end;
          Result := RecordCount;
        end
      else
        Result := 0;
    end;
  finally
    cdsUser.Free;
  end;
end;

procedure TAppIMCreateGroupByDept.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '依部门创建消息组';
end;

initialization
  RegClass(TAppIMCreateGroupByDept);

finalization
  UnRegClass(TAppIMCreateGroupByDept);

end.
