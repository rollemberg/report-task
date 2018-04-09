unit AppIMGetRecords;

interface

uses
  AppBean, uBaseIntf, Variants, SysUtils, ApConst;

type
  TAppIMGetRecords = class(TAppBean)
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

{ TAppIMGetRecords }

function TAppIMGetRecords.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  cdsTmp: TAppQuery;
begin
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      //登记消息
      CommandText := Format('select top 100 RecordID_ from IM_History '
        + 'where UserCode_=''%s'' and Read_=0',
        [Session.UserCode]);
      Open;
      Data := VarArrayCreate([0, RecordCount], varVariant);
      Data[0] := RecordCount;
      while not Eof do
      begin
        Data[RecNo] := FieldByName('RecordID_').AsString;
        Next;
      end;
      Result := True;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TAppIMGetRecords.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '取得所有未读讯息清单';
end;

initialization
  RegClass(TAppIMGetRecords);

finalization
  UnRegClass(TAppIMGetRecords);

end.
