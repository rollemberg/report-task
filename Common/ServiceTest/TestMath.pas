unit TestMath;

interface

uses
  AppBean;

type
  TTestMath = class(TAppBean)
  public
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
  end;


implementation

{ TTestMath }

function TTestMath.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
var
  x, y: Integer;
begin
  x := Param[0];
  y := Param[1];
  Data := x * y;
  Result := True;
end;

initialization
  RegClass(TTestMath);

finalization
  UnRegClass(TTestMath);

end.
