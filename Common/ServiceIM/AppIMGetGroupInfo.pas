unit AppIMGetGroupInfo;

interface

uses
  AppBean, uBaseIntf, Variants, SysUtils, ApConst;

type
  TAppIMGetGroupInfo = class(TAppBean)
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

uses AppIMGroupInfo_Data;

{ TAppIMGetGroupInfo }

function TAppIMGetGroupInfo.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  DataOut: TAppIMGroupInfo_Data;
  cdsTmp: TAppQuery;
begin
  DataOut := TAppIMGroupInfo_Data.Create;
  try
    DataOut.GroupID := Param;
    cdsTmp := TAppQuery.Create(Self);
    try
      with cdsTmp do
      begin
        Connection := Self.Session.Connection;
        CommandText := Format('select Name_,AppUser_ from IM_GroupInfo '
          + 'where ID_=''%s''',
          [DataOut.GroupID]);
        Open;
        if Eof then
        begin
          Data := '调用错误，指定的GroupID不存在或已被删除！';
          Result := False;
          Exit;
        end;
        DataOut.GroupName := FieldByName('Name_').AsString;
        DataOut.ManageUser := FieldByName('AppUser_').AsString;
        //
        Active := False;
        CommandText := Format('select UserCode_ from IM_GroupUser '
          + 'where GroupID_=''%s''',
          [DataOut.GroupID]);
        Open;
        while not Eof do
        begin
          DataOut.AddUser(FieldByName('UserCode_').AsString);
          Next;
        end;
        Data := DataOut.GetVariant;
        Result := True;
      end;
    finally
      cdsTmp.Free;
    end;
  finally
    DataOut.Free;
  end;
end;

procedure TAppIMGetGroupInfo.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '取得群的基本资料';
end;

initialization
  RegClass(TAppIMGetGroupInfo);

finalization
  UnRegClass(TAppIMGetGroupInfo);

end.
