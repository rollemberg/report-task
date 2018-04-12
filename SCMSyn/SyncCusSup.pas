unit SyncCusSup;

interface
uses
  Classes, CustomSync, ADODB,SysUtils;

type
  TSyncCusSup = class(TCustomSync)
  private
    Code,Name, Address,Tel1,Tel2,Fax: String;
    Email,ShortName,CorpCode: String;
    function ConfirmCusSup(): Boolean;
  public
    function execSync: Boolean; override;
  end;

implementation

uses MainFrm;

{ TSyncPur }

function TSyncCusSup.ConfirmCusSup(): Boolean;
var
  SQLCmd: String;
  cdsCusSup: TADOQuery;
begin
  //处理回写ERP状态
  cdsCusSup := TADOQuery.Create(nil);
  try
    cdsCusSup.Connection := FrmMain.oCn;
    cdsCusSup.SQL.Text := Format('SELECT * FROM CusSup WHERE Code_=''%s'' and CorpCode_=''%s'' ',[Code,CorpCode]);
    cdsCusSup.Open;
    if not cdsCusSup.Eof then
    begin
      cdsCusSup.Edit;
      cdsCusSup.FieldByName('Name_').AsString := Name;
      cdsCusSup.FieldByName('Address_').AsString := Tel2;
      cdsCusSup.FieldByName('Tel1_').AsString := Tel1;
      cdsCusSup.FieldByName('Tel2_').AsString := Tel2;
      cdsCusSup.FieldByName('Fax_').AsString := Fax;
      cdsCusSup.FieldByName('Email_').AsString := Email;
      cdsCusSup.FieldByName('ShortName_').AsString := ShortName;
      cdsCusSup.Post;
    end;
  finally
    cdsCusSup.Free;
  end;
  FrmMain.memBody.Lines.Add('回写厂商资料成功');
end;

function TSyncCusSup.execSync: Boolean;
begin
  //获取dataIn栏位，使用dataOut;s
  Code := dataOut.Head.FieldByName('Code_').AsString;
  Name := dataOut.Head.FieldByName('Name_').AsString;
  Address := dataOut.Head.FieldByName('Address_').AsString;
  Tel1:= dataOut.Head.FieldByName('Tel1_').AsString;
  Tel2 := dataOut.Head.FieldByName('Tel2_').AsString;
  Fax := dataOut.Head.FieldByName('Fax_').AsString;
  Email := dataOut.Head.FieldByName('Email_').AsString;
  ShortName := dataOut.Head.FieldByName('ShortName_').AsString;
  CorpCode := dataOut.Head.FieldByName('CorpCode_').AsString;

  //
  ConfirmCusSup();
end;

end.
