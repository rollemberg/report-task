unit SyncTranReq;

interface
uses
  Classes, CustomSync, ADODB,SysUtils;

type
  TSyncTranReq = class(TCustomSync)
  private
    TBNo,CorpCode: String;
    ConfirmDate:TDateTime;
    It,Confirm: Integer;
    function ConfirmTranReq(): Boolean;
  public
    function execSync: Boolean; override;
  end;

implementation

uses MainFrm;

{ TSyncPur }

function TSyncTranReq.ConfirmTranReq(): Boolean;
var
  SQLCmd: String;
  cdsTranReq: TADOQuery;
begin
  //处理回写ERP状态
  cdsTranReq := TADOQuery.Create(nil);
  try
    cdsTranReq.Connection := FrmMain.oCn;
    cdsTranReq.SQL.Text := Format('SELECT * FROM TranReqB WHERE TBNo_=''%s'' and It_=%d and CorpCode_=''%s'' and Final_=1 ',[TBNo,It,CorpCode]);
    cdsTranReq.Open;
    if not cdsTranReq.Eof then
    begin
      cdsTranReq.Edit;
      cdsTranReq.FieldByName('Name_').AsString := Name;
      cdsTranReq.FieldByName('ConfirmDate_').AsDateTime := ConfirmDate;
      cdsTranReq.FieldByName('Confirm_').AsInteger := Confirm;
      cdsTranReq.Post;
    end;
  finally
    cdsTranReq.Free;
  end;
  FrmMain.memBody.Lines.Add('回写厂商资料成功');
end;

function TSyncTranReq.execSync: Boolean;
begin
  //获取dataIn栏位，使用dataOut;s
  TBNo := dataOut.Head.FieldByName('TBNo_').AsString;
  It := dataOut.Head.FieldByName('It_').AsInteger;
  ConfirmDate:= dataOut.Head.FieldByName('ConfirmDate_').AsDateTime;
  Confirm := dataOut.Head.FieldByName('Confirm_').AsInteger;
  CorpCode := dataOut.Head.FieldByName('CorpCode_').AsString;
  //
  ConfirmTranReq();
end;

end.
