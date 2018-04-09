unit ComponentTest_class;

interface

uses
  Classes, SysUtils, Forms, Menus, uBaseIntf, ApConst, ErpTools;

type
  THRComponentTest = class(TMenuItem)
  private
    FParam0: String;
    FParam1: String;
    procedure SetParam0(const Value: String);
    procedure SetParam1(const Value: String);
  public
    procedure Click; override;
  published
    property Caption;
    property MenuIndex;
    property Param0: String read FParam0 write SetParam0;
    property Param1: String read FParam1 write SetParam1;
  end;

implementation

uses
  MainData;

{ THRComponentTest }

procedure THRComponentTest.Click;
var
  TB: TTBRecord;
  str: String;
begin
  TB.Name := Param0;
  TB.Sys := StrToInt(Param1);
  str := CM.CreateTBNo(TB, Date());
  MsgBox(str);
end;

procedure THRComponentTest.SetParam0(const Value: String);
begin
  FParam0 := Value;
end;

procedure THRComponentTest.SetParam1(const Value: String);
begin
  FParam1 := Value;
end;

initialization
  RegClass(THRComponentTest);

finalization
  UnRegClass(THRComponentTest);

end.
