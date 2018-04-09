unit MessageDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uBaseIntf, ApConst, ZjhCtrls;

type
  TDialogMessage = class(TForm, IOutputMessage2)
    Memo1: TMemo;
    procedure Memo1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OutputMessage(Sender: TObject; const Value: String; MsgLevel: TMsgLevelOption);
  end;

implementation

{$R *.dfm}

procedure TDialogMessage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDialogMessage.FormCreate(Sender: TObject);
begin
  Self.Left := Screen.Width - Self.Width - 20;
  Self.Top := Screen.Height - Self.Height - 60;
  Memo1.Lines.Clear;
  TZoomWindow.RefreshForm(Self);
end;

procedure TDialogMessage.Memo1DblClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TDialogMessage.OutputMessage(Sender: TObject; const Value: String;
  MsgLevel: TMsgLevelOption);
begin
  Memo1.Lines.Add(FormatDateTime('HH:MM:SS ', Now()) + Value);
end;

initialization
  RegClass(TDialogMessage);

finalization
  UnRegClass(TDialogMessage);

end.
