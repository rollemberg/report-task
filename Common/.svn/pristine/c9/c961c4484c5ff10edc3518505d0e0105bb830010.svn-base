unit AppIMCreateRecord;

interface

uses
  AppBean, uBaseIntf, Variants, SysUtils, ApConst;

type
  TAppIMCreateRecord = class(TAppBean)
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

{ TAppIMCreateRecord }

function TAppIMCreateRecord.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  UserCode: String;
  GroupID, IMData, IMID, SQLCmd: String;
  cdsTmp: TAppQuery;
begin
  GroupID := Param[0];
  IMData := Param[1];
  IMID := NewGuid();
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      //登记消息
      CommandText := 'select top 0 ID_,GroupID_,Text_,AppUser_,AppDate_ '
        + 'from IM_Records';
      Open;
      Append;
      FieldByName('ID_').AsString := IMID;
      FieldByName('GroupID_').AsString := GroupID;
      FieldByName('Text_').AsString := IMData;
      FieldByName('AppUser_').AsString := Session.UserCode;
      FieldByName('AppDate_').AsDateTime := Now();
      Post;
      //通报对方
      Active := False;
      CommandText := Format('select UserCode_ from IM_GroupUser '
        + 'where GroupID_=''%s'' and UserCode_<>''%s''',
        [GroupID, Session.UserCode]);
      //MsgBox(CommandText);
      Open;
      while not Eof do
      begin
        UserCode := FieldByName('UserCode_').AsString;
        SQLCmd := Format('insert into IM_History (RecordID_,UserCode_,Read_) '
          + 'values (''%s'', ''%s'', 0)',
          [IMID, UserCode]);
        //MsgBox(SQLCmd);
        Session.Connection.Execute(SQLCmd);
        Next;
      end;
      Result := True;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TAppIMCreateRecord.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '新的消息记录存档';
end;

initialization
  RegClass(TAppIMCreateRecord);

finalization
  UnRegClass(TAppIMCreateRecord);

end.
