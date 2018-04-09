unit NetRegistry;

interface

uses
  Classes, SysUtils, AppBean;

type
  TNetRegistry = class
  private
    FSession: TServiceSession;
  public
    function ReadString(const Section, Key, Default: String): String;
    function ReadInit(const Section, Key: String;
      Default: Integer = 0): Integer;
    function ReadSelected(const ARoot, AKey: String; AParam: TStrings;
      Default: Integer): Integer;
    property Session: TServiceSession read FSession write FSession;
    constructor Create(AOwner: TAppBean);
  end;
  
implementation

{ TNetRegistry }

function TNetRegistry.ReadInit(const Section, Key: String;
  Default: Integer): Integer;
var
  cdsTmp: TAppQuery;
begin
  Result := Default;
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      SQL.Text := Format('Select Init_ From SysValues '
        + 'where Root_=''%s'' and Code_=''%s''',[Section, Key]);
      Open;
      if not Eof then
        Result := FieldByName('Init_').AsInteger;
    end;
  finally
    cdsTmp.Free;
  end;
end;

function TNetRegistry.ReadString(const Section, Key,
  Default: String): String;
var
  cdsTmp: TAppQuery;
begin
  Result := Default;
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      SQL.Text := Format('Select Value_ From SysValues '
        + 'where Root_=''%s'' and Code_=''%s''',[Section, Key]);
      Open;
      if not Eof then
        Result := FieldByName('Value_').AsString;
    end;
  finally
    cdsTmp.Free;
  end;
end;

function TNetRegistry.ReadSelected(const ARoot, AKey: String; AParam: TStrings;
  Default: Integer): Integer;
var
  cdsTmp: TAppQuery;
begin
  {$message '此函数未来要取消！Jason 2008/9/12'}
  Result := Default;
  cdsTmp := TAppQuery.Create(nil);
  try
    with cdsTmp do
    begin
      Connection := Self.Session.Connection;
      SQL.Text := Format('Select Init_ From SysValues '
        + 'where Root_=''%s'' and Key_=''%s''',[ARoot, AKey]);
      Open;
      //F.固定字符组
      if not Eof then
        Result := FieldByName('Init_').AsInteger;
    end;
  finally
    cdsTmp.Free;
  end;
end;

constructor TNetRegistry.Create(AOwner: TAppBean);
begin
  FSession := AOwner.Session;
end;

end.
