unit InfoBox;

interface

uses
  SysUtils, Windows, Dialogs, Classes, Variants, uBaseIntf, ApConst;

type
  TInfoBox = class
  private
    FDebug: Boolean;
    FViewLine: Integer;
    FData: TStringList;
    FMax: Integer;
    FPosition: Integer;
    FLastText: String;
    FJobStop: Integer;
    procedure SetViewLine(const Value: Integer);
    function GetViewLine: Integer;
    procedure SetMax(const Value: Integer);
    procedure SetPosition(const Value: Integer);
    procedure SetDebug(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  public
    property Debug: Boolean read FDebug write SetDebug;
    property ViewLine: Integer read GetViewLine write SetViewLine;
  public
    property Data: TStringList read FData;
    property Max: Integer read FMax write SetMax;
    property Position: Integer read FPosition write SetPosition;
    property JobStop: Integer read FJobStop write FJobStop;
    function GetLine(Index: Integer): String;
    procedure Text(const AText: String); overload;
    procedure DebugText(const AText: String); overload;
    procedure Text(const AFmt: String; const Args: array of const); overload;
    procedure DebugText(const AFmt: String; const Args: array of const); overload;
  end;
  function ibox: TInfoBox;

var
  pub_ibox: TInfoBox;

implementation

uses
  Forms;

const
  CONST_MAINFORM_SETMAX = 100001;
  CONST_MAINFORM_SETPOSITION = 100002;

{ TInfoBox }

procedure TInfoBox.Text(const AFmt: String;
  const Args: array of const);
begin
  Text(Format(AFmt, Args));
end;

procedure TInfoBox.DebugText(const AFmt: String;
  const Args: array of const);
begin
  if FDebug then
    DebugText(Format(AFmt, Args));
end;

procedure TInfoBox.DebugText(const AText: String);
var
  i: Integer;
  Child: TForm;
  AIntf: IMainForm;
begin
  if FDebug then
  begin
    if Assigned(Application.MainForm) and Supports(Application.MainForm, IOutputMessage2) then
    begin
      (Application.MainForm as IOutputMessage2).OutputMessage(Self, AText, MSG_DEBUG);
      Exit;
    end;
    AIntf := MainIntf;
    if Assigned(AIntf) then
    begin
      for i := 0 to Screen.FormCount - 1 do
      begin
        Child := Screen.Forms[i];
        if Child.ClassNameIs('TFrmRunDialog') then
        begin
          if Supports(Child, IBaseForm) then
          begin
            (Child as IBaseForm).PostMessage(CONST_MSG, AText);
            Break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TInfoBox.Text(const AText: String);
begin
  if Trim(AText) = '' then
  begin
    //忽略空消息，Jason 2006/5/28
    Exit;
  end;
  FData.Add(FormatDateTime('HH:MM:SS  ',Now()) + AText);
  FLastText := AText;
  if Assigned(Application.MainForm) then
  begin
    if Supports(Application.MainForm, IOutputMessage2)  then
      (Application.MainForm as IOutputMessage2).OutputMessage(Self, AText, MSG_HINT)
    else if Supports(Application.MainForm, IOutputMessage) then
      (Application.MainForm as IOutputMessage).OutputMessage(AText);
  end;
end;

procedure TInfoBox.SetViewLine(const Value: Integer);
begin
  FViewLine := Value;
end;

constructor TInfoBox.Create;
begin
  FViewLine := 5;
  FJobStop := -1;
  FDebug := False;
  FData := TStringList.Create;
end;

destructor TInfoBox.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

function TInfoBox.GetViewLine: Integer;
begin
  if FData.Count < FViewLine then
    Result := FData.Count else Result := FViewLine;
end;

function TInfoBox.GetLine(Index: Integer): String;
begin
  if Index in [1..FData.Count] then
    begin
      Result := FData.Strings[FData.Count - (ViewLine-Index) - 1];
    end
  else
    Result := '';
end;

procedure TInfoBox.SetMax(const Value: Integer);
var
  AIntf: IMainForm;
begin
  if FMax <> Value then
  begin
    if Value = 0 then
      JobStop := -1;
    FMax := Value;
    AIntf := MainIntf;
    if Assigned(AIntf) then
      AIntf.PostMessage(CONST_MAINFORM_SETMAX, Value);
  end;
{
  if FMax <> Value then
  begin
    FMax := Value;
    if Value > 0 then
      begin
        Position := 0;
        FrmMain.ProgressBar1.Parent := FrmMain.StatusBar1;
        //FrmMain.StatusBar1.Panels[1].Style := psOwnerDraw;
        FrmMain.ProgressBar1.Visible := True;
      end
    else
      begin
        Position := 0;
        FrmMain.ProgressBar1.Parent := nil;
        //FrmMain.StatusBar1.Panels[1].Style := psText;
        FrmMain.ProgressBar1.Visible := False;
      end;
    FrmMain.Update;
  end;
}
end;

procedure TInfoBox.SetPosition(const Value: Integer);
var
  AIntf: IMainForm;
begin
  if FPosition <> Value then
  begin
    FPosition := Value;
    AIntf := MainIntf;
    if Assigned(AIntf) then
      AIntf.PostMessage(CONST_MAINFORM_SETPOSITION, Value);
  end;
  //FrmMain.ProgressBar1.Position := Value;
end;

{
procedure SelectExecute(const ClassName: String;
  const Targets: array of TObject; const Param: Variant);
var
  AIntf: ISelectDialog;
begin
  AIntf := CreateClassEx(ClassName, Application) as ISelectDialog;
  if Assigned(AIntf) then AIntf.Execute(Targets, Param);
end;

procedure SelectDisplay(const ClassName: String;
  const Sender: TObject; const Param: Variant);
var
  AIntf: ISelectDialog;
begin
  AIntf := CreateClassEx(ClassName, Application) as ISelectDialog;
  if Assigned(AIntf) then AIntf.Display(Sender, Param);
end;
}

function ibox: TInfoBox;
begin
  if not Assigned(pub_ibox) then
    pub_ibox := TInfoBox.Create;
  Result := pub_ibox;
end;

procedure TInfoBox.SetDebug(const Value: Boolean);
var
  AIntf: IMainForm;
  Child: IBaseForm;
begin
  if FDebug = Value then
  begin
    Exit;
  end;
  //
  FDebug := Value;
  if not Assigned(Application.MainForm) then
    Exit;
  //
  if Assigned(Application.MainForm) and Supports(Application.MainForm, IOutputMessage2) then
  begin
    if Value then
      (Application.MainForm as IOutputMessage2).OutputMessage(Self,
        Chinese.AsString('系统已进入调试状态。'), MSG_HINT)
    else
      (Application.MainForm as IOutputMessage2).OutputMessage(Self,
        Chinese.AsString('系统已结束调试状态。'), MSG_HINT);
    Exit;
  end;
  //
  if Value then
    begin
      AIntf := MainIntf;
      if Assigned(AIntf) then
        begin
          //启动我的系统助理
          Child := AIntf.GetForm('TFrmRunDialog');
          if Assigned(Child) then
            Child.PostMessage(CONST_MSG, Chinese.AsString('系统已成功进入调试状态，请继续操作！'));
        end
      else
        Text(Chinese.AsString('提示：要查看内部调试信息需启动"我的系统助理"。'));
    end
  else
    begin
      AIntf := MainIntf;
      if Assigned(AIntf) then
        begin
          //启动我的系统助理
          Child := AIntf.FindChild('TFrmRunDialog');
          if Assigned(Child) then
            Child.PostMessage(CONST_MSG, Chinese.AsString('系统已结束调试状态。'));
        end
      else
        Text(Chinese.AsString('系统已结束调试状态。'));
    end;
end;

end.
