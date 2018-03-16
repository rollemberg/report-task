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
    property MachNo: String read FMachNo write SetMachNo;        //认码号码
    property ProdIt: String read FProdIt write SetProdIt;        //包装序号
    property CusCode: String read FCusCode write SetCusCode;     //服务帐号
    property Language: Integer read FLanguage write SetLanguage; //语言 0: 国际； 1: 英文； 2: 简体； 3: 繁体； 4: 日文； 5:韩文；
    property MaxUser: Integer read FMaxUser write SetMaxUser;    //最大用户数
    property TrialDay: Integer read FTrialDay write SetTrialDay; //试用天数
    property RegisterNo: String read FRegisterNo write SetRegisterNo; //注册码
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
