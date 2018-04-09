unit AppIMReadRecord;

interface

uses
  AppBean, uBaseIntf, Variants, SysUtils, ApConst;

type
  TAppIMReadRecord = class(TAppBean)
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

{ TAppIMReadRecord }

function TAppIMReadRecord.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  IMID: String;
  SQLCmd: String;
  cdsTmp: TAppQuery;
  ReadFlag: Boolean;
begin
  IMID := Param[0];
  ReadFlag := Param[1];
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      //登记消息
      CommandText := Format('select GroupID_,Text_,AppUser_,AppDate_ '
        + 'from IM_Records where ID_=''%s''', [IMID]);
      Open;
      if not Eof then
        begin
          Data := VarArrayOf([FieldByName('GroupID_').AsString,
            FieldByName('Text_').AsString, FieldByName('AppUser_').AsString,
            FieldByName('AppDate_').AsDateTime]);
          if ReadFlag then
          begin
            SQLCmd := Format('update IM_History set Read_=1, ReadTime_=Getdate() '
              + 'where RecordID_=''%s'' and UserCode_=''%s'' and Read_=0',
              [IMID, Session.UserCode]);
            Session.Connection.Execute(SQLCmd);
          end;
          Result := True;
        end
      else
        begin
          Data := 'not find RecordID=' + IMID;
          Result := False;
        end;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TAppIMReadRecord.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '读取一条消息记录';
end;

initialization
  RegClass(TAppIMReadRecord);

finalization
  UnRegClass(TAppIMReadRecord);

end.
