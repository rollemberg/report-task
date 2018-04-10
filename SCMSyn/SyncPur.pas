unit SyncPur;

interface
uses
  Classes, CustomSync, ADODB,SysUtils;

type
  TSyncPur = class(TCustomSync)
  private
    TBNo, Remark1,CorpCode: String;
    ConfirmDate:TDateTime;
    It,Confirm: Integer;
    cdsTranH, cdsTranB: TADOQuery;
    function ConfirmPur(): Boolean;
  public
    function execSync: Boolean; override;
  end;

implementation

uses MainFrm;

{ TSyncPur }

function TSyncPur.ConfirmPur(): Boolean;
var
  SQLCmd: String;
  cdsPurB: TADOQuery;
begin
  //处理回写ERP状态
  cdsPurB := TADOQuery.Create(nil);
  try
    cdsPurB.Connection := FrmMain.oCn;
    cdsPurB.SQL.Text := Format('SELECT * FROM PurB WHERE TBNo_=''%s'' and It_=%d and Final_=1',[TBNo,It]);
    cdsPurB.Open;
    if not cdsPurB.Eof then
    begin
      cdsPurB.Edit;
      cdsPurB.FieldByName('ConfirmDate_').AsDateTime := ConfirmDate;
      cdsPurB.FieldByName('Confirm_').AsInteger := Confirm;
      cdsPurB.FieldByName('Remark1_').AsString := Remark1;
      cdsPurB.Post;
    end;
  finally
    cdsPurB.Free;
  end;
  //SQLCmd:=Format('UPDATE PurB SET ConfirmDate_=''%s'',Confirm_=%d,Remark1_=''%s'' WHERE TBNo_=''%s'' and It_=%d',[DateToStr(ConfirmDate),Confirm,Remark1,TBNo,It]);
  //FrmMain.oCn.Execute(SQLCmd);
  FrmMain.memBody.Lines.Add('回写采购单成功');
end;

function TSyncPur.execSync: Boolean;
begin
  //获取dataIn栏位，使用dataOut;s
  TBNo := dataOut.Head.FieldByName('TBNo_').AsString;
  It := dataOut.Head.FieldByName('It_').AsInteger;
  ConfirmDate:= dataOut.Head.FieldByName('ConfirmDate_').AsDateTime;
  Confirm := dataOut.Head.FieldByName('Confirm_').AsInteger;
  Remark1 := dataOut.Head.FieldByName('Remark1_').AsString;
  //CorpCode := dataOut.Head.FieldByName('CorpCode_').AsString;
  //
  ConfirmPur();
end;

end.
