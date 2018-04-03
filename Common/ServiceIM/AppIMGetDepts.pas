unit AppIMGetDepts;

interface

uses
  AppBean, uBaseIntf, Variants, SysUtils;

type
  TAppIMGetDepts = class(TAppBean)
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    procedure WriteReadme(This: TServiceReadme); override;
  end;

implementation

{ TAppIMGetDepts }

function TAppIMGetDepts.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  cdsTmp: TAppQuery;
begin
  cdsTmp := TAppQuery.Create(Self);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      CommandText := Format('Select ID_,Code_,Name_,Level_ from Dept '
        + 'where (ParentCode_=''%s'') or (ParentCode_ is null)',
        [VarToStr(Param)]);
      Open;
      Data := VarArrayCreate([0, RecordCount], varVariant);
      Data[0] := RecordCount;
      while not Eof do
      begin
        Data[RecNo] := VarArrayOf([FieldByName('ID_').AsString,
          FieldByName('Code_').AsString, FieldByName('Name_').AsString,
          FieldByName('Level_').AsInteger]);
        Next;
      end;
      Result := True;
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TAppIMGetDepts.WriteReadme(This: TServiceReadme);
begin
  inherited;
  This.Remark := '取子部门名单！';
end;

initialization
  RegClass(TAppIMGetDepts);

finalization
  UnRegClass(TAppIMGetDepts);

end.

