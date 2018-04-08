unit SetConnFrm;

interface

uses Forms, SysUtils, StdCtrls, Controls, ExtCtrls, Buttons, Classes, Dialogs,
  IniFiles, ADODB, Graphics;

type
  TFrmSetConn = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel2: TBevel;
    edtServer: TEdit;
    edtDatabase: TEdit;
    edtAccount: TEdit;
    edtPassword: TEdit;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Image1: TImage;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Bevel1: TBevel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FConn: TADOConnection;
    class function Execute2(AConn: TADOConnection;Et1, Et2: TEdit): Boolean;
    class function Execute(AConn: TADOConnection): Boolean;
  end;
  //Set AConn connection to SQL Server.

implementation

uses ApConst;

{$R *.dfm}

class function TFrmSetConn.Execute(AConn: TADOConnection): Boolean;
var
  Child: TFrmSetConn;
begin
  Result := AConn.Connected;
  if AConn.Connected then Exit;
  Child := TFrmSetConn.Create(Application);
  try
    Child.FConn := AConn;
    Result := Child.ShowModal() = mrOk;
  finally
    Child.Free;
  end;
end;

class function TFrmSetConn.Execute2(AConn: TADOConnection; Et1,
  Et2: TEdit): Boolean;
var
  Child: TFrmSetConn;
begin
  Result := AConn.Connected;
  if AConn.Connected then Exit;
  Child := TFrmSetConn.Create(Application);
  try
    Child.FConn := AConn;
    Result := Child.ShowModal() = mrOk;
    Et1.Text := Child.edtServer.Text;
    Et2.Text := Child.edtDatabase.Text ;
  finally
    Child.Free;
  end;
end;

procedure TFrmSetConn.BitBtn1Click(Sender: TObject);
begin
  try
    if RadioButton1.Checked then
      FConn.ConnectionString := Format('Provider=SQLOLEDB.1;Integrated Security=SSPI;'
        +'Persist Security Info=False;Initial Catalog=%s;Data Source=%s'
        ,[edtDatabase.Text,edtServer.Text])
    else
      FConn.ConnectionString := Format('Provider=SQLOLEDB.1;Password=%s;Persist '
        + 'Security Info=True;User ID=%s;Initial Catalog=%s;Data Source=%s',
        [edtPassword.Text,edtAccount.Text,edtDatabase.Text,edtServer.Text]);
    FConn.Open;
    ModalResult := mrOk;
  except
    on E: Exception do ShowMessage(E.Message);
  end;
end;

procedure TFrmSetConn.FormCreate(Sender: TObject);
begin
  edtServer.Text := ureg.ReadString('ErpTools','Server','(local)');
  edtDatabase.Text := ureg.ReadString('ErpTools','Database','BSII');
  edtAccount.Text := ureg.ReadString('ErpTools','Account','sa');
  edtPassword.Text := Encrypt(ureg.ReadString('ErpTools','Password',''),'WinERP',False);
end;

procedure TFrmSetConn.FormDestroy(Sender: TObject);
begin
  ureg.WriteString('ErpTools','Server',edtServer.Text);
  ureg.WriteString('ErpTools','Database',edtDatabase.Text);
  ureg.WriteString('ErpTools','Account',edtAccount.Text);
  ureg.WriteString('ErpTools','Password',Encrypt(edtPassword.Text,'WinERP',True));
end;

procedure TFrmSetConn.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked then
  begin
    EdtAccount.Color := clWindow;
    EdtPassword.Color := clWindow;
    edtAccount.Enabled := True;
    edtPassword.Enabled := True;
    edtAccount.SetFocus;
  end;
end;

procedure TFrmSetConn.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked then
  begin
    EdtAccount.Color := clBtnFace;
    EdtPassword.Color := clBtnFace;
    edtAccount.Enabled := False;
    edtPassword.Enabled := False;
  end;
end;

end.




