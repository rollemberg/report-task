unit AppIMSetGroupInfo;

interface

uses
  AppBean, uBaseIntf, Variants, SysUtils, ApConst;

type
  TAppIMSetGroupInfo = class(TAppBean)
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

uses AppIMGroupInfo_Data;

{ TAppIMSetGroupInfo }

function TAppIMSetGroupInfo.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  i: Integer;
  cdsTmp: TAppQuery;
  DataIn: TAppIMGroupInfo_Data;
  Flag: Boolean;
begin
  DataIn := TAppIMGroupInfo_Data.Create;
  try
    DataIn.SetVariant(Param);
    if DataIn.UserCount < 2 then
    begin
      Data := '群设置错误，一个群必须最少有二名成员！';
      Result := False;
      Exit;
    end;
    //
    cdsTmp := TAppQuery.Create(Self);
    try
      with cdsTmp do
      begin
        Connection := Self.Session.Connection;
        CommandText := Format('select * from IM_GroupInfo '
          + 'where ID_=''%s''',
          [DataIn.GroupID]);
        Open;
        if Eof then
        begin
          Data := '调用错误，指定的GroupID不存在或已被删除！';
          Result := False;
          Exit;
        end;
        //
        Flag := False;
        for i := 0 to DataIn.UserCount - 1 do
        begin
          if DataIn.Users[i] = FieldByName('AppUser_').AsString then
          begin
            Flag := True;
            Break;
          end;
        end;
        if not Flag then
        begin
          Data := '对不起，不允许删除此群的主管理员！';
          Result := False;
          Exit;
        end;
        //保存群名
        Edit;
        FieldByName('Name_').AsString := DataIn.GroupName;
        Post;
        //
        Active := False;
        CommandText := Format('select * from IM_GroupUser '
          + 'where GroupID_=''%s''',
          [DataIn.GroupID]);
        Open;
        //先全部删除
        while not Eof do
          Delete;
        //再全部添加
        for i := 0 to DataIn.UserCount - 1 do
        begin
          Append;
          FieldByName('GroupID_').AsString := DataIn.GroupID;
          FieldByName('UserCode_').AsString := DataIn.Users[i];
          FieldByName('Manage_').AsBoolean := False;
          Post;
        end;
        Result := True;
      end;
    finally
      cdsTmp.Free;
    end;
  finally
    DataIn.Free;
  end;
end;

procedure TAppIMSetGroupInfo.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '保存群的资料修改';
end;

initialization
  RegClass(TAppIMSetGroupInfo);

finalization
  UnRegClass(TAppIMSetGroupInfo);

end.
