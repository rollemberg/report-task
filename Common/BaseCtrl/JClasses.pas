unit JClasses;

interface

uses
  Classes, SysUtils;

type
  JString = class(TObject)
  private
    FValue: String;
    procedure SetValue(const Value: String);
  public
    property Value: String read FValue write SetValue;
    function Length: Integer;
  end;
  JInteger = class(TObject)
  private
    FValue: Integer;
    procedure SetValue(const Value: Integer);
  public
    property Value: Integer read FValue write SetValue;
    function ToString: String; override;
  end;
  JFloat = class(TObject)
  private
    FValue: Double;
    procedure SetValue(const Value: Double);
  public
    property Value: Double read FValue write SetValue;
    function ToString: String; override;
  end;
  JDateTime = class(TObject)
  private
    FValue: TDateTime;
    procedure SetValue(const Value: TDateTime);
  public
    property Value: TDateTime read FValue write SetValue;
    function ToString: String; override;
  end;
  JAttTime = class(TObject)
  private
    FValue: String;
    procedure SetValue(const Value: String);
    property Value: String read FValue write SetValue;
    function TimeToInt(const Times: String): Integer;
    function IntToTime(Value: Integer): String;
  public
    function ToInt: Integer;
    function ToTime: String;
  end;
  JBoolean = class
  public
    Value: Boolean;
  end;
  JDouble = class
  public
    Value: Double;
  end;
  //ÄÚ´æ¹ÜÀíÆ÷
  JMemory = class
  private
    List: TList;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function NewString(const Value: String = ''): JString;
    function NewInteger(const Value: Integer = 0): JInteger;
    function NewFloat(const Value: Double = 0): JFloat;
    function NewDateTime(const Value: TDateTime = 0): JDateTime;
    function AttTime(const Value: String = ''): JAttTime;
  end;

implementation
{ JString }

function JString.Length: Integer;
begin
  Result := System.Length(FValue);
end;

procedure JString.SetValue(const Value: String);
begin
  FValue := Value;
end;

{ JInteger }

procedure JInteger.SetValue(const Value: Integer);
begin
  FValue := Value;
end;

function JInteger.toString: String;
begin
  Result := IntToStr(FValue);
end;

{ JFloat }

procedure JFloat.SetValue(const Value: Double);
begin
  FValue := Value;
end;

function JFloat.toString: String;
begin
  Result := FloatToStr(FValue);
end;

{ JDateTime }

procedure JDateTime.SetValue(const Value: TDateTime);
begin
  FValue := Value;
end;

function JDateTime.toString: String;
begin
  Result := FormatDatetime('YYYY/MM/DD', FValue);
end;

{ JMemory }

function JMemory.AttTime(const Value: String): JAttTime;
begin
  Result := JAttTime.Create;
  Result.Value := Value;
  List.Add(Result);
end;

constructor JMemory.Create;
begin
  List := TList.Create;
end;

destructor JMemory.Destroy;
var
  i: Integer;
  Data: TObject;
begin
  for i := List.Count - 1 downto 0 do
  begin
    Data := List.Items[i];
    Data.Free;
  end;
  List.Free;
  inherited;
end;

function JMemory.NewDateTime(const Value: TDateTime): JDateTime;
begin
  Result := JDateTime.Create;
  Result.Value := Value;
  List.Add(Result);
end;

function JMemory.NewFloat(const Value: Double): JFloat;
begin
  Result := JFloat.Create;
  Result.Value := Value;
  List.Add(Result);
end;

function JMemory.NewInteger(const Value: Integer): JInteger;
begin
  Result := JInteger.Create;
  Result.Value := Value;
  List.Add(Result);
end;

function JMemory.NewString(const Value: String): JString;
begin
  Result := JString.Create;
  Result.Value := Value;
  List.Add(Result);
end;

{ JAttTime }

function JAttTime.toInt: Integer;
begin
  Result := TimeToInt(FValue);
end;

function JAttTime.toTime: String;
begin
  Result := IntToTime(TimeToInt(FValue));
end;

procedure JAttTime.SetValue(const Value: String);
begin
  FValue := Value;
end;

function JAttTime.TimeToInt(const Times: String): Integer;
begin
  if Times <> '00:00' then
    begin
      Result := StrToIntDef(Copy(Times,1,2),0)*60 + StrToIntDef(Copy(Times,4,2),0);
      if Result = 0 then
        Result := -1;
    end
  else
    Result := 0;
end;

function JAttTime.IntToTime(Value: Integer): String;
var
  s1, s2: String;
begin
  s1 := '00' + IntToStr(Value div 60);
  s2 := '00' + IntToStr(Value mod 60);
  Result := Copy(s1,System.Length(s1)-1,2) + ':' + Copy(s2,System.Length(s2)-1,2);
end;

end.
