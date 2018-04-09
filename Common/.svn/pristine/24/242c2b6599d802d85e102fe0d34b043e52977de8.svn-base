unit AppUtils;

interface

uses
  SysUtils, DateUtils, Controls;

type
  JYearMonth = class
  private
    FValue: String;
    procedure SetValue(const Value: String);
  public
    function FirstDay: TDateTime;
    function LastDay: TDateTime;
    property Value: String read FValue write SetValue;
  end;
  //本月第一天
  function MonthBof(Value: TDate): TDateTime;
  //本月最后天
  function MonthEof(Value: TDate): TDateTime;
  //日期型转时间型
  function CDate(Value: TDateTime): String;

implementation

function MonthBof(Value: TDate): TDateTime;
begin
  Result := Value - DayOf(Value) + 1;
end;

function MonthEof(Value: Tdate): TDateTime;
begin
  Result := IncMonth((Value - DayOf(Value) + 1),1) - 1;
end;

function CDate(Value: TDateTime): String;
begin
  Result := FormatDateTime('YYYY/MM/DD', Value);
end;

{ JYearMonth }

function JYearMonth.FirstDay: TDateTime;
begin
  Result := StrToDateTime(Copy(FValue,1,4) + '/' + Copy(FValue,5,2)+'/'+'01');
end;

function JYearMonth.LastDay: TDateTime;
begin
  Result := MonthEof(FirstDay());
end;

procedure JYearMonth.SetValue(const Value: String);
begin
  FValue := Value;
end;

end.
