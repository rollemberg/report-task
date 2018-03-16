unit ServerLang;

interface

uses
  SysUtils, Classes, Windows, AppResource, ApConst;

  function ChineseAsString(Value: string): string;
  function InitLibrary: Boolean;

var
  HTemp: THandle;
  CASProc: function(Value: OleVariant): OleVariant; stdcall;

implementation

{function ChineseAsString(Value: string): string;
var
  HTemp: THandle;
  retStr: OleVariant;
  CASProc: function(Value: OleVariant): OleVariant; stdcall;
begin
  Result := Value;
  HTemp := LoadLibrary('MLang.dll');
  try
    if HTemp <> 0 then
    begin
      CASProc := GetProcAddress(HTemp, 'ChineseAsString');
      if Assigned(CASProc) then
      begin
        try
          retStr := CASProc(Value);
          Result := retStr;
        except
          ureg.WriteString('CASErr', FormatDateTime('YYYY/MM/DD_HH:MM:SS', Now), Value);
          Result := Value;
        end;
      end;
    end;
  finally
    FreeLibrary(HTemp);
  end;
end;
}
function ChineseAsString(Value: string): string;
begin
  Result := Value;
  {
  if Assigned(CASProc) then
  begin
    try
      retStr := CASProc(Value);
      Result := retStr;
    except
      ureg.WriteString('CASErr', FormatDateTime('YYYY/MM/DD_HH:MM:SS', Now), Value);
      Result := Value;
    end;
  end;
  }
end;

function InitLibrary: Boolean;
begin
  if not Assigned(CASProc) then begin
    HTemp := LoadLibrary('MLang.dll');
    if HTemp <> 0 then
      CASProc := GetProcAddress(HTemp, 'ChineseAsString');
    __InitResourceS1;
  end;
  Result := Assigned(CASProc);
end;

initialization
  InitLibrary;

finalization
  FreeLibrary(HTemp);

end.
