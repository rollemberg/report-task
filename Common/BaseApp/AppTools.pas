unit AppTools;

interface

uses
  Windows, Messages, SysUtils, Classes, DateUtils, IniFiles;

type
  //注册记录包
  T46Register = class(TObject)
  private
    FProdit:     String;   //包装序号
    FAccount:  String;   //服务帐号
    FRegisterNo: String;   //注册号码
    //
    FLanguage: Integer;    //语言 0: 国际； 1: 英文； 2: 简体； 3: 繁体； 4: 日文； 5:韩文；
    FMaxUser: Integer;     //最大用户数
    FTrialDay: Integer;
    //
    FMachNo: String;       //认码号码
    FRegisterFile: String;
    FCurrentKey: String;   //当前注册键
    FRegisterData: String;      //注册文件码
    procedure ReadSecurityFile;
    function CreateKey: String;
    procedure SetRegisterFile(const Value: String);
    function GetMaxUser: Integer;
    function GetTrialDay: Integer;
    procedure InitParam;
  public
    constructor Create; virtual;
    property RegisterFile: String read FRegisterFile write SetRegisterFile;
    property Language: Integer read FLanguage;
    function LanguageText: String;
    property TrialDay: Integer read GetTrialDay;
    property MaxUser: Integer read GetMaxUser;
    //
    property ProdIt: String read FProdIt;
    property Account: String read FAccount;
    property MachNo: String read FMachNo;
    property CurrentKey: String read FCurrentKey;
    property RegisterData: String read FRegisterData;
    //
    function FormatCode24(const Text: String): String;
    function ValidRegister(const ARegKey: String): Boolean;
    procedure WriteKey(const ARegisterFile, AProdIt, AServiceNo, SecCode: String;
      ALanguage, AMaxUser, ATrialDay: Integer);
    function IsTrial: Boolean;
  end;

const
  RegFlag: String = 'CERC46 200412';

implementation

uses ApConst, ServerLang;

{ TRegisterCode }

constructor T46Register.Create;
begin
  FProdit       := FormatDateTime('YYMMDD',Now());
  FAccount      := 'STUDY_USER';
  FRegisterNo   := StringOfChar('0',24);   //注册号码
  SetLength(FMachNo,24); GetMachNo(PChar(FMachNo)); //认码号码
  FLanguage     :=  0; //语言 0: 国际;1: 英文;2: 简体;3: 繁体;4: 日文;5:韩文;
  FRegisterFile := GetWinSys() + '\Service.lic';
  FCurrentKey := StringOfChar('0',24);
end;

function T46Register.CreateKey: String;
var
  i: Integer;
  pwd1,pwd2: String;
  Data, Tmp: String;
begin
  pwd1 := Trim(FAccount) + IntToHex(TrialDay,1) + IntToHex(Language,1);
  pwd1 := Copy(pwd1 + pwd1 + pwd1 + pwd1 + pwd1 + pwd1,1,12);
  pwd2 := Trim(FProdIt) + IntToHex(MaxUser,2);
  pwd2 := Copy(pwd2 + pwd2 + pwd2 + pwd2 + pwd2 + pwd2,1,12);
  tmp := MachNo;
  for i := 1 to Length(tmp) div 2 do
    Data := Data + Char(StrToInt('0x' + Copy(tmp,i*2-1,2)));
  if Length(Data) <> 12 then
    raise Exception.Create(ChineseAsString('非法的认证码：') + MachNo);
  Encrypt(PChar(Data),Length(Data),pwd2);
  Encrypt(PChar(Data),Length(Data),pwd1);
  if Length(Data) <> 12 then
    raise Exception.Create(ChineseAsString('非法的认证码：') + MachNo);
  tmp := '';
  for i := 1 to Length(Data) do
    tmp := tmp + IntToHex(Byte(Data[i]),2);
  Result := tmp;
end;

function T46Register.FormatCode24(const Text: String): String;
begin
  Result := Format('%s-%s-%s-%s',[Copy(Text,1,6),Copy(Text,7,6),
    Copy(Text,13,6),Copy(Text,19,6)]);
end;

function T46Register.LanguageText: String;
begin
  case FLanguage of
  0: Result := ChineseAsString('国际版');
  1: Result := ChineseAsString('英文版');
  2: Result := ChineseAsString('简体中文版');
  3: Result := ChineseAsString('繁体中文版');
  4: Result := ChineseAsString('日文版');
  5: Result := ChineseAsString('韩文版');
  else
     Result := '';
  end;
end;

procedure T46Register.SetRegisterFile(const Value: String);
begin
  if FRegisterFile <> Value then
  begin
    FRegisterFile := Value;
    if FileExists(FRegisterFile) then
    begin
      ReadSecurityFile;
      FRegisterNo := CreateKey;
    end;
  end;
end;

function T46Register.ValidRegister(const ARegKey: String): Boolean;
begin
  Result := FRegisterNo = ARegKey;
end;

function T46Register.IsTrial: Boolean;
begin
  Result := FTrialDay < 99;
end;

procedure T46Register.WriteKey(const ARegisterFile, AProdIt, AServiceNo,
  SecCode: String; ALanguage, AMaxUser, ATrialDay: Integer);
var
  str: String;
  t: TStringStream;
  f: TFileStream;
begin
  if (AMaxUser < 0) or (AMaxUser > 4000) then
    Raise Exception.Create('Value not in [0..4000]');
  if not (ATrialDay in [0..99]) then
    Raise Exception.Create('Value not in [0..99]');
  if not (ALanguage in [0..9]) then
    Raise Exception.Create('Value not in [0..9]');
  FMaxUser  := AMaxUser;
  FTrialDay := ATrialDay;
  FLanguage := ALanguage;
  FProdIt   := Copy(AProdIt + StringOfChar(' ',6),1,6);
  FAccount  := Copy(AServiceNo + StringOfChar(' ',8),1,8);
  FRegisterFile := ARegisterFile;
  if FileExists(FRegisterFile) then DeleteFile(FRegisterFile);
  //
  FCurrentKey := CreateKey;
  FRegisterNo := FCurrentKey;
  //
  str := RegFlag
    + Account + IntToHex(MaxUser,4) + IntToHex(TrialDay,2) + ProdIt
    + IntToHex(Language,1) + StringOfChar(' ',3)
    + FCurrentKey;
  FRegisterData := Encrypt(str,RegFlag,True);
  //
  f := TFileStream.Create(FRegisterFile,fmCreate);
  try
    t := TStringStream.Create(FRegisterData);
    try
      f.CopyFrom(t,t.Size);
    finally
      t.Free;
    end;
  finally
    f.Free;
  end;
end;

procedure T46Register.ReadSecurityFile;
var
  str: String;
  t: TStringStream;
  f: TFileStream;
  Value: String;
begin
  if not FileExists(FRegisterFile) then Exit;
  t := TStringStream.Create('');
  f := TFileStream.Create(FRegisterFile,fmOpenRead);
  try
    t.CopyFrom(f,f.Size);
    FRegisterData := t.DataString;
    str := Encrypt(FRegisterData,RegFlag,False);
  finally
    f.Free; t.Free;
  end;
  //
  if Length(str) <> (Length(RegFlag) + (24*2)) then Exit;
  if Copy(str,1,Length(RegFlag)) <> RegFlag then Exit;

  Value := Copy(str,Length(RegFlag)+1,24);
  FAccount := Copy(Value,1,8);
  FMaxUser := StrToIntDef('0x' + Copy(Value,9,4),2);
  FTrialDay := StrToIntDef('0x' + Copy(Value,13,2),0);
  FProdIt := Copy(Value,15,6);
  FLanguage := StrToIntDef('0x' + Copy(Value,21,1),3);
  //
  FCurrentKey :=  Copy(str,Length(RegFlag)+25,24);
end;

function T46Register.GetMaxUser: Integer;
begin
  if FMaxUser = 0 then InitParam;
  Result := FMaxUser;
end;

function T46Register.GetTrialDay: Integer;
begin
  if FMaxUser = 0 then InitParam;
  Result := FTrialDay;
end;

procedure T46Register.InitParam;
var
  TrialDay: TDateTime;
begin
  inherited;
  FMaxUser      :=  2; //最大用户数
  FTrialDay     := 30; //一个月
  //
  if FileExists(FRegisterFile) then
  begin
    ReadSecurityFile;
    FRegisterNo := CreateKey;
  end;
  if FAccount = 'SCM-USER' then
  begin
    FMaxUser := 10;
    FTrialDay := 99;
    Exit;
  end;
  if FTrialDay in [1..98] then
  begin
    TrialDay := sreg.ReadDateTime('System','LogoutTime',Date()-1);
    if TrialDay <> Date() then
    begin
      sreg.WriteDateTime('System','LogoutTime',Date());
      if TrialDay > Date() then
        FTrialDay := FTrialDay - 1
      else
        FTrialDay := FTrialDay - DaysBetween(Date(), TrialDay);
    end;
    if FTrialDay < 0 then FTrialDay := 0;
    WriteKey(FRegisterFile,FProdIt,FAccount,FMachNo,FLanguage,FMaxUser,FTrialDay);
  end;
end;

end.





