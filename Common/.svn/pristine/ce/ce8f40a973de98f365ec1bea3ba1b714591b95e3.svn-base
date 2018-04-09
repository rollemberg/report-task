unit AppIMGetFirends;

interface

uses
  AppBean, uBaseIntf, Variants, SysUtils, Classes, DB;

type
  TAppIMGetFirends = class(TAppBean)
  private
    procedure GetMyCorp(Items: TStrings);
    procedure GetFirends(Items: TStrings);
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

{ TAppIMGetFirends }

function TAppIMGetFirends.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  DeptCode: String;
  i, UserCount: Integer;
  sl: TStringList;
  cdsTmp: TAppQuery;
begin
  sl := TStringList.Create;
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      CommandText := 'select ID_,Code_,Name_,DeptCode_ '
        + 'from Account where Enabled_=1';
      Open;
      if Session.CostDeptEnabled then
        begin
          GetMyCorp(sl);
        end
      else
        begin
          //取同部门
          if Locate('Code_', Session.UserCode, [loCaseInsensitive]) then
          begin
            DeptCode := Trim(FieldByName('DeptCode_').AsString);
            First;
            while not Eof do
            begin
              if Trim(FieldByName('DeptCode_').AsString) = Trim(DeptCode) then
              begin
                if FieldByName('Code_').AsString <> Session.UserCode then
                  sl.Add(FieldByName('Code_').AsString);
              end;
              Next;
            end;
          end;
        end;
      //取朋友
      GetFirends(sl);
      //传回于前台
      Data := VarArrayCreate([0, sl.Count], varVariant);
      UserCount := 0;
      for i := 0 to sl.Count - 1 do
      begin
        if sl.Strings[i] <> Session.UserCode then
        if Locate('Code_', sl.Strings[i], [loCaseInsensitive]) then
        begin
          Inc(UserCount);
          Data[UserCount] := VarArrayOf([FieldByName('ID_').AsString,
            FieldByName('Code_').AsString, FieldByName('Name_').AsString, 0]);
        end;
      end;
      Data[0] := UserCount;
      Result := True;
    end;
  finally
    cdsTmp.Free;
    sl.Free;
  end;
end;

procedure TAppIMGetFirends.GetFirends(Items: TStrings);
var
  UserCode: String;
  cdsTmp: TAppQuery;
begin
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := Session.Connection;
      CommandText := Format('Select FriendCode_ from SY_UserFriend '
        + 'Where UserCode_=''%s'' Order by Type_,FriendCode_',
        [Session.UserCode]);
      Open;
      while not Eof do
      begin
        UserCode := Trim(FieldByName('FriendCode_').AsString);
        if Items.IndexOf(UserCode) = -1 then
          Items.Add(UserCode);
        Next;
      end;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TAppIMGetFirends.GetMyCorp(Items: TStrings);
var
  UserCode: String;
  cdsTmp: TAppQuery;
begin
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := Session.Connection;
      CommandText := Format('select UserCode_ From SysUserProperty '
        + 'where CostDept_=''%s''',
        [Session.CostDept]);
      Open;
      while not Eof do
      begin
        UserCode := Trim(FieldByName('UserCode_').AsString);
        if Items.IndexOf(UserCode) = -1 then
          Items.Add(UserCode);
        Next;
      end;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TAppIMGetFirends.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '取当前用户所有好友清单！';
end;

initialization
  RegClass(TAppIMGetFirends);

finalization
  UnRegClass(TAppIMGetFirends);

end.
