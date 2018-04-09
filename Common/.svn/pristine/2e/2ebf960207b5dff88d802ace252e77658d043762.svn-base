unit AppIMCreateGroup;

interface

uses
  AppBean, Classes, uBaseIntf, Variants, SysUtils, ApConst;

type
  TAppIMCreateGroup = class(TAppBean)
  private
    function IsThisGroup(Items: TStrings; const GID: String): Boolean;
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

{ TAppIMCreateGroup }

function TAppIMCreateGroup.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  UserCode: String;
  GroupID, GroupName: String;
  UserCount: Integer;
  cdsTmp: TAppQuery;
  sl: TStringList;
  i: Integer;
  SQLCmd: String;
  Flag: Boolean;
begin
  sl := TStringList.Create;
  cdsTmp := TAppQuery.Create(Self);
  try
    GroupName := Param[0];
    UserCount := Param[1];
    //依据多人来建立群
    for i := 2 to 1 + UserCount do
      sl.Add(Param[i]);
    sl.Sort;
    //
    SQLCmd := Format('select GroupID_ from IM_GroupUser '
      + 'where UserCode_=''%s''',
      [Session.UserCode]);
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      CommandText := Format('Select ID_,Type_,Name_,UserCount_,'
        + 'AppDate_,AppUser_ from IM_GroupInfo '
        + 'where UserCount_=%d and Type_=0 and ID_ in (%s)',
        [UserCount, SQLCmd]);
      Open;
      Flag := False;
      while not Eof do
      begin
        GroupID := FieldByName('ID_').AsString;
        if IsThisGroup(sl, GroupID) then
        begin
          Flag := True;
          Break;
        end;
        Next;
      end;
      if not Flag then //增加一个新组
      begin
        GroupID := NewGuid();
        Append;
        FieldByName('ID_').AsString := GroupID;
        FieldByName('Type_').AsInteger := 0;
        FieldByName('Name_').AsString := GroupName;
        FieldByName('UserCount_').AsInteger := UserCount;
        FieldByName('AppDate_').AsDateTime := Now();
        FieldByName('AppUser_').AsString := Session.UserCode;
        Post;
        //
        for i := 0 to sl.Count - 1 do
        begin
          UserCode := sl.Strings[i];
          SQLCmd := Format('insert into IM_GroupUser (GroupID_,UserCode_,Manage_) '
            + 'values (''%s'', ''%s'', 0)', [GroupID, UserCode]);
          Session.Connection.Execute(SQLCmd);
        end;
      end;
      Data := GroupID;
      Result := True;
    end;
  finally
    cdsTmp.Free;
  end;
end;

function TAppIMCreateGroup.IsThisGroup(Items: TStrings;
  const GID: String): Boolean;
var
  cdsUser: TAppQuery;
begin
  Result := True;
  cdsUser := TAppQuery.Create(Self);
  try
    cdsUser.Connection := Self.Session.Connection;
    with cdsUser do
    begin
      CommandText := Format('select UserCode_ from IM_GroupUser '
        + 'where GroupID_=''%s'' Order by UserCode_',
        [GID]);
      Open;
      if RecordCount <> Items.Count then
      begin
        Result := False;
        Exit;
      end;
      while not Eof do
      begin
        if FieldByName('UserCode_').AsString <> Items.Strings[RecNo - 1] then
        begin
          Result := False;
          Break;
        end;
        Next;
      end;
    end;
  finally
    cdsUser.Free;
  end;
end;

procedure TAppIMCreateGroup.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '创建消息组';
end;

initialization
  RegClass(TAppIMCreateGroup);

finalization
  UnRegClass(TAppIMCreateGroup);

end.
