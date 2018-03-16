unit NullLanguage;

interface

uses
  Classes, uBaseIntf, Variants;

type
  TNullLanguage = class(TComponent, IMutiLanguage)
  public
    function GetProgramLangID: Integer;
    function GetDataLangID: Integer;
    procedure SetDataLangID(Value: Integer);
    function GetWindowLangID: Integer;
    procedure SetWindowLangID(Value: Integer);
    function AsObject(Sender: TObject): Boolean;
    function AsString(const Value: String): String;
    function AsData(const Key, DefValue: String): String;
    function PostMessage(MsgType: Integer; Msg: Variant): Variant;  //·¢ËÍÏûÏ¢
  end;

implementation

{ TNullLanguage }

function TNullLanguage.AsObject(Sender: TObject): Boolean;
begin
  Result := False;
end;

function TNullLanguage.AsString(const Value: String): String;
begin
  Result := Value;
end;

function TNullLanguage.AsData(const Key, DefValue: String): String;
begin
  Result := DefValue;
end;

function TNullLanguage.GetWindowLangID: Integer;
begin
  Result := 0;
end;

function TNullLanguage.GetDataLangID: Integer;
begin
  Result := 0;
end;

function TNullLanguage.GetProgramLangID: Integer;
begin
  Result := 0;
end;

procedure TNullLanguage.SetWindowLangID(Value: Integer);
begin
  ;
end;

procedure TNullLanguage.SetDataLangID(Value: Integer);
begin
  ;
end;

function TNullLanguage.PostMessage(MsgType: Integer;
  Msg: Variant): Variant;
begin
  Result := NULL;
end;

end.
