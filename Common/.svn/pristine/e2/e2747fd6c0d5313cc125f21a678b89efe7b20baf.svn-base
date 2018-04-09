unit DBForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZjhCtrls, ApConst, DBClient, uBaseIntf, uSelect;

type
  TDBForm = class(TForm, IBaseForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FAliaName: Variant;
    FOutputParam: Variant;
    FInputParam: Variant;
    FAddress: string;
  protected
    procedure SetAddress(const Value: String); virtual;
    function GetAddress: String; virtual;
    function PostMessage(MsgType: Integer; Msg: Variant): Variant; virtual;
    function GetControl(ControlName: string): TObject;  virtual;   //取窗口上的控件
    function ShowForm(ModalType: Integer; var Param: Variant): Integer; virtual; //显示窗口
    //特有
    function ISec: TObject; virtual; //返回TZjhtool
    function GetAliaName: Variant; virtual;
    procedure SetAliaName(const Value: Variant); virtual;
    //初始化
    procedure DoCreate; override;
    procedure Activate; override;
  public
    { Public declarations }
    Intro: TIntroInfo;
    function Sec: TZjhTool; virtual;
    //输入输出参数
    property InputParam: Variant read FInputParam write FInputParam;
    property OutputParam: Variant read FOutputParam write FOutputParam;
    property AliaName: Variant read GetAliaName write SetAliaName;
//    //IOutputMessage2
//    procedure OutputMessage(Sender: TObject; const Value: String;
//      MsgLevel: TMsgLevelOption); virtual;
  end;

  TTBForm = class(TDBForm)
  public
    function GotoRecord(const Key: Variant): Boolean; virtual;
    function PostMessage(MsgType: Integer; Msg: Variant): Variant; override;
  end;

  TShellForm = class(TDBForm)
  public
  end;

implementation

uses
  StdCtrls, ComCtrls, MainData, InfoBox;

{$R *.dfm}

{ TDBForm }

procedure TDBForm.DoCreate;
begin
  FAliaName := Self.ClassName;
  inherited;
end;

function TDBForm.GetControl(ControlName: string): TObject;
var
  i: integer;
begin
  Result := nil;
  if Trim(ControlName) <> '' then
    for i := 0 to ComponentCount - 1 do begin
      if AnsiCompareText(Components[i].Name, ControlName) = 0 then begin
        Result := Components[i];
        Break;
      end;
    end
  else
    Result := Self;
end;

function TDBForm.ISec: TObject;
var
  i: Integer;
begin
  Result := Sec;
  if not Assigned(Result) then
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TZjhTool) then
        if TZjhTool(Components[i]).MainTool then
        begin
          Result := Components[i];
          Exit;
        end;
    end;
  end;
end;
//
//procedure TDBForm.OutputMessage(Sender: TObject; const Value: String;
//  MsgLevel: TMsgLevelOption);
//begin
//  if Assigned(Application.MainForm) then
//  begin
//    if Supports(Application.MainForm, IOutputMessage2) then
//      (Application.MainForm as IOutputMessage2).OutputMessage(Sender, Value, MsgLevel)
//    else if Supports(Application.MainForm, IOutputMessage) then
//      (Application.MainForm as IOutputMessage).OutputMessage(Value);
//  end;
//end;

{ TDB2Form }

function TTBForm.GotoRecord(const Key: Variant): Boolean;
begin
  Result := False;
end;

function TDBForm.PostMessage(MsgType: Integer; Msg: Variant): Variant;
begin
  Result := NULL;
end;

function TDBForm.GetAliaName: Variant;
begin
  Result := FAliaName;
end;

procedure TDBForm.SetAliaName(const Value: Variant);
begin
  if FAliaName <> Value then
    FAliaName := Value;
end;

function TDBForm.ShowForm(ModalType: Integer; var Param: Variant): Integer;
begin
  InputParam := Param;
  case ModalType of
    CONST_FORM_SHOW: begin
      Show;
      Result := mrOk;
    end;
    CONST_FORM_SHOWMODAL: begin
      Result := ShowModal;
      Param := OutputParam;
    end;
  else
    Result := 0;
  end;
end;

procedure TDBForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TDBForm.Sec: TZjhTool;
var
  i: Integer;
begin
  Result := nil;
  //Modify by Jason, 2006/10/28
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[i] is TZjhTool then
    if TZjhTool(Self.Components[i]).MainTool then
    begin
      Result := Self.Components[i] as TZjhTool;
      Break;
    end;
  end;
end;

procedure TDBForm.Activate;
begin
  inherited Activate;
  if MainIntf <> nil then
  begin
    if Self.GetAddress <> '' then
      MainIntf.Address := Self.GetAddress
    else
      MainIntf.Address := 'service:' + Self.ClassName;
  end;
end;

function TDBForm.GetAddress: String;
begin
  Result := FAddress;
end;

procedure TDBForm.SetAddress(const Value: String);
begin
  FAddress := Value;
end;

function TTBForm.PostMessage(MsgType: Integer; Msg: Variant): Variant;
begin
  case MsgType of
  CONST_GOTORECORD:
    Result := GotoRecord(Msg);
  end;
end;

end.
