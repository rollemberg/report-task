unit SyncSendTran;

interface
uses
  Classes, CustomSync, ADODB,SysUtils;

type
  TSyncSendTran = class(TCustomSync)
  private
    TBNo,CorpCode,MakeNo,PartCode,PurNo: String;
    QCFile,Remark,SupCode: String;
    FinishDate,TBDate:TDateTime;
    ID,It,Finish,MakeIt,PurIt: Integer;
    Num: Double;
    function ConfirmSendTran(): Boolean;
  public
    function execSync: Boolean; override;
  end;

implementation

uses MainFrm;

{ TSyncPur }

function TSyncSendTran.ConfirmSendTran(): Boolean;
var
  SQLCmd: String;
  cdsSendTran,cdsPurB: TADOQuery;
begin
  //处理回写ERP状态
  cdsSendTran := TADOQuery.Create(nil);
  cdsPurB := TADOQuery.Create(nil);
  try
    cdsSendTran.Connection := FrmMain.oCn;
    cdsSendTran.SQL.Text := 'SELECT top 0 * FROM SupSendTran  ';
    cdsSendTran.Open;
    cdsSendTran.Append;
    cdsSendTran.FieldByName('CorpCode_').AsString := CorpCode;
    cdsSendTran.FieldByName('FinishDate_').AsDateTime := FinishDate;
    cdsSendTran.FieldByName('Finish_').AsInteger := Finish;
    //cdsSendTran.FieldByName('ID_').AsInteger := ID;
    cdsSendTran.FieldByName('It_').AsInteger := It;
    cdsSendTran.FieldByName('MakeIt_').AsInteger := MakeIt;
    cdsSendTran.FieldByName('MakeNo_').AsString := MakeNo;
    cdsSendTran.FieldByName('Num_').AsFloat := Num;
    cdsSendTran.FieldByName('PartCode_').AsString := PartCode;
    cdsSendTran.FieldByName('PurIt_').AsInteger := PurIt;
    cdsSendTran.FieldByName('PurNo_').AsString := PurNo;
    cdsSendTran.FieldByName('QCFile_').AsString := QCFile;
    cdsSendTran.FieldByName('Remark_').AsString := Remark;
    cdsSendTran.FieldByName('SupCode_').AsString := SupCode;
    cdsSendTran.FieldByName('TBNo_').AsString := TBNo;
    cdsSendTran.FieldByName('TBDate_').AsDateTime := TBDate;
    cdsSendTran.Post;
    cdsPurB.Connection := FrmMain.oCn;
    cdsPurB.SQL.Text := Format('SELECT * FROM PurB WHERE TBNo_=''%s'' and It_=%d and Final_=1 and CorpCode_=''%s''',[PurNo,PurIt,CorpCode]);
    cdsPurB.Open;
    if not cdsPurB.Eof then
    begin
      cdsPurB.Edit;
      cdsPurB.FieldByName('SupSendPurNum_').AsFloat := cdsPurB.FieldByName('SupSendPurNum_').AsFloat + Num;
      cdsPurB.Post;
    end;
  finally
    cdsSendTran.Free;
    cdsPurB.Free;
  end;
  FrmMain.memBody.Lines.Add('回写厂商送货单资料成功');
end;

function TSyncSendTran.execSync: Boolean;
begin
  //获取dataIn栏位，使用dataOut;s
  CorpCode := dataOut.Head.FieldByName('CorpCode_').AsString;
  FinishDate:= dataOut.Head.FieldByName('FinishDate_').AsDateTime;
  Finish := dataOut.Head.FieldByName('Finish_').AsInteger;
  ID := dataOut.Head.FieldByName('ID_').AsInteger;
  It := dataOut.Head.FieldByName('It_').AsInteger;
  MakeIt := dataOut.Head.FieldByName('MakeIt_').AsInteger;
  MakeNo := dataOut.Head.FieldByName('MakeNo_').AsString;
  Num := dataOut.Head.FieldByName('Num_').AsFloat;
  PartCode := dataOut.Head.FieldByName('PartCode_').AsString;
  PurIt := dataOut.Head.FieldByName('PurIt_').AsInteger;
  PurNo := dataOut.Head.FieldByName('PurNo_').AsString;
  QCFile := dataOut.Head.FieldByName('QCFile_').AsString;
  Remark := dataOut.Head.FieldByName('Remark_').AsString;
  SupCode := dataOut.Head.FieldByName('SupCode_').AsString;
  TBNo := dataOut.Head.FieldByName('TBNo_').AsString;
  TBDate:= dataOut.Head.FieldByName('TBDate_').AsDateTime;
  //
  ConfirmSendTran();
end;

end.
