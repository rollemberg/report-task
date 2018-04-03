unit AppRegister_DataOut;

interface

uses
  AppData, IniFiles;

type
  TAppRegister_DataOut = class(TAppData)
  private
    FMachNo: String;
    FLanguage: Integer;
    FProdIt: String;
    FTrialDay: Integer;
    FMaxUser: Integer;
    FCusCode: String;
    FRegisterNo: String;
    procedure SetCusCode(const Value: String);
    procedure SetLanguage(const Value: Integer);
    procedure SetMachNo(const Value: String);
    procedure SetMaxUser(const Value: Integer);
    procedure SetProdIt(const Value: String);
    procedure SetTrialDay(const Value: Integer);
    procedure SetRegisterNo(const Value: String);
  published
    property MachNo: String read FMachNo write SetMachNo;        //�������
    property ProdIt: String read FProdIt write SetProdIt;        //��װ���
    property CusCode: String read FCusCode write SetCusCode;     //�����ʺ�
    property Language: Integer read FLanguage write SetLanguage; //���� 0: ���ʣ� 1: Ӣ�ģ� 2: ���壻 3: ���壻 4: ���ģ� 5:���ģ�
    property MaxUser: Integer read FMaxUser write SetMaxUser;    //����û���
    property TrialDay: Integer read FTrialDay write SetTrialDay; //��������
    property RegisterNo: String read FRegisterNo write SetRegisterNo; //ע����
  end;

implementation

{ TAppRegister_DataOut }

procedure TAppRegister_DataOut.SetCusCode(const Value: String);
begin
  FCusCode := Value;
end;

procedure TAppRegister_DataOut.SetLanguage(const Value: Integer);
begin
  FLanguage := Value;
end;

procedure TAppRegister_DataOut.SetMachNo(const Value: String);
begin
  FMachNo := Value;
end;

procedure TAppRegister_DataOut.SetMaxUser(const Value: Integer);
begin
  FMaxUser := Value;
end;

procedure TAppRegister_DataOut.SetProdIt(const Value: String);
begin
  FProdIt := Value;
end;

procedure TAppRegister_DataOut.SetRegisterNo(const Value: String);
begin
  FRegisterNo := Value;
end;

procedure TAppRegister_DataOut.SetTrialDay(const Value: Integer);
begin
  FTrialDay := Value;
end;

end.
