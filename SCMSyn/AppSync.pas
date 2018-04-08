unit AppSync;

interface

uses
  SysUtils, AppUtils2, ZjhCtrls, Dialogs, ADODB, AppDB2, DB,Classes;

type
  TAppSync = class
  private
    { Private declarations }
    procedure CopyFields(Target, Source: TAppDataSet;const Args: array of String); overload;
    procedure CopyFields(Target: TAppDataSet;Source:TADOQuery;const Args: array of String); overload;
    procedure CopyFields(Target: TAppRecord;Source:TADOQuery;const Args: array of String); overload;

    procedure CopyRecord(Target: TAppDataSet;Source:TADOQuery);overload ;
    procedure CopyRecord(Target: TAppRecord;Source:TADOQuery);overload ;

    function GetFields(const strTable: String): String;
  public

    procedure SynExec(AConn: TADOConnection);
  end;




implementation

uses MainFrm;

{ TAppSync }
procedure TAppSync.CopyFields(Target, Source: TAppDataSet;
  const Args: array of String);
var
  i: Integer;
begin
  for i := Low(Args) to High(Args) do
    Target.FieldByName(Args[i]).Value := Source.FieldByName(Args[i]).Value;
end;

procedure TAppSync.CopyFields(Target: TAppDataSet; Source: TADOQuery;
  const Args: array of String);
var
  i: Integer;
begin
  for i := Low(Args) to High(Args) do
    Target.FieldByName(Args[i]).Value := Source.FieldByName(Args[i]).Value;
end;

procedure TAppSync.CopyFields(Target: TAppRecord; Source: TADOQuery;
  const Args: array of String);
var
  i: Integer;
begin
  for i := Low(Args) to High(Args) do
    Target.FieldByName(Args[i]).Value := Source.FieldByName(Args[i]).Value;
end;


procedure TAppSync.CopyRecord(Target: TAppDataSet; Source: TADOQuery);
var
  i: Integer;
begin
  for i:=0 to Source.Fields.Count - 1 do
  begin
    Target.FieldByName(Source.Fields[i].FieldName).Value := Source.FieldByName(Source.Fields[i].FieldName).Value;
  end;
end;

procedure TAppSync.CopyRecord(Target: TAppRecord; Source: TADOQuery);
var
  i: Integer;
begin
  for i:=0 to Source.Fields.Count - 1 do
  begin
    Target.FieldByName(Source.Fields[i].FieldName).Value := Source.FieldByName(Source.Fields[i].FieldName).Value;
  end;
end;

function TAppSync.GetFields(const strTable: String): String;
var
  i: Integer;
  oRs: _Recordset;
begin
  Result := '';
  oRs := FrmMain.oCn.Execute(Format('Select top 0 * from %s',[strTable]));
  for i:=0 to oRs.Fields.Count - 1 do
  begin
    Result := Result + '''' +oRs.Fields[i].Name +''''+ ',';
  end;
  oRs.Close;
end;

procedure TAppSync.SynExec(AConn: TADOConnection);
var
  cdsCRMSyn,cdsTranH,cdsTranB: TADOQuery;
  app: IAppService;
  cdsH,cdsB:TAppDataSet;
  PID: String;
begin
  cdsCRMSyn := TADOQuery.Create(nil);
  cdsTranH := TADOQuery.Create(nil);
  cdsTranB := TADOQuery.Create(nil);
  try
    cdsCRMSyn.Connection := FrmMain.oCn;
    cdsCRMSyn.SQL.Text := Format('SELECT top 1 * FROM CRMSyn WHERE CorpCode_=''%s'' ',[FrmMain.EdtCorp.Text]);
    cdsCRMSyn.Open;
    if not cdsCRMSyn.Eof  then
    begin
      if cdsCRMSyn.FieldByName('Type_').AsInteger in [0,2] then   //0-待同步 1-已同步 2-重新同步 3-不需要同步 4-同步失败
      try
        cdsTranH.Connection := FrmMain.oCn;
        cdsTranH.SQL.Text := Format('SELECT top 1 * FROM %sH WHERE CorpCode_=''%s'' and TBNo_=''%s'' and Ver_<=0 and Final_=1',[cdsCRMSyn.FieldByName('Table_').AsString,FrmMain.EdtCorp.Text,cdsCRMSyn.FieldByName('TBNo_').AsString]);
        cdsTranH.Open;
        if not cdsTranH.Eof then
        begin
          PID:= cdsTranH.FieldByName('ID_').AsString;
          cdsTranB.Connection := FrmMain.oCn;
          cdsTranB.SQL.Text := Format('SELECT * FROM %sB WHERE PID_=''%s'' ',[cdsCRMSyn.FieldByName('Table_').AsString,PID]);
          cdsTranB.Open;
          //app := Service('SvrERPSyncDate.ERPPurDate');
          app := Service('SvrERPSyncReport.ERPPurDate');
          CopyRecord(app.DataIn.Head,cdsTranH);
          cdsTranB.First;
          while not cdsTranB.Eof do
          begin
            app.DataIn.Append();
            CopyFields(app.DataIn,cdsTranB,['TBNo_','TBDate_','SupCode_','It_','PartCode_','Desc_','Spec_']);
            app.DataIn.FieldByName('ID_').AsString := cdsTranB.FieldByName('ID_').AsString;
            app.DataIn.FieldByName('PID_').AsString := cdsTranB.FieldByName('PID_').AsString;
            app.DataIn.FieldByName('UpdateKey_').AsString := cdsTranB.FieldByName('UpdateKey_').AsString;
            app.DataIn.FieldByName('Num_').AsFloat := cdsTranB.FieldByName('Num_').AsFloat;
            app.DataIn.FieldByName('SpareNum_').AsFloat := cdsTranB.FieldByName('SpareNum_').AsFloat;
            app.DataIn.FieldByName('InAccNum_').AsFloat := cdsTranB.FieldByName('InAccNum_').AsFloat;
            app.DataIn.FieldByName('Unit_').AsString := cdsTranB.FieldByName('Unit_').AsString;
            app.DataIn.FieldByName('UP_').AsFloat := cdsTranB.FieldByName('UP_').AsFloat;
            app.DataIn.FieldByName('OriUP_').AsFloat := cdsTranB.FieldByName('OriUP_').AsFloat;
            app.DataIn.FieldByName('TaxRate_').AsFloat := cdsTranB.FieldByName('TaxRate_').AsFloat;
            app.DataIn.FieldByName('TaxUP_').AsFloat := cdsTranB.FieldByName('TaxUP_').AsFloat;
            app.DataIn.FieldByName('Freight_').AsFloat := cdsTranB.FieldByName('Freight_').AsFloat;
            app.DataIn.FieldByName('Currency_').AsString := cdsTranB.FieldByName('Currency_').AsString;
            app.DataIn.FieldByName('WHCode_').AsString := cdsTranB.FieldByName('WHCode_').AsString;
            app.DataIn.FieldByName('ReceiveDate_').AsDateTime := cdsTranB.FieldByName('ReceiveDate_').AsDateTime;
            app.DataIn.FieldByName('ReturnNum_').AsFloat := cdsTranB.FieldByName('ReturnNum_').AsFloat;
            app.DataIn.FieldByName('ReceiveNum_').AsFloat := cdsTranB.FieldByName('ReceiveNum_').AsFloat;
            app.DataIn.FieldByName('ReceiveSpare_').AsFloat := cdsTranB.FieldByName('ReceiveSpare_').AsFloat;
            app.DataIn.FieldByName('QcPassNum_').AsFloat := cdsTranB.FieldByName('QcPassNum_').AsFloat;
            app.DataIn.FieldByName('QcPassSpare_').AsFloat := cdsTranB.FieldByName('QcPassSpare_').AsFloat;
            app.DataIn.FieldByName('SupOrdNo_').AsString := cdsTranB.FieldByName('SupOrdNo_').AsString;
            app.DataIn.FieldByName('TranXBID_').AsString := cdsTranB.FieldByName('TranXBID_').AsString;
            app.DataIn.FieldByName('MakeIt_').AsInteger := cdsTranB.FieldByName('MakeIt_').AsInteger;
            app.DataIn.FieldByName('WP_').AsBoolean := cdsTranB.FieldByName('WP_').AsBoolean;
            app.DataIn.FieldByName('Finish_').AsInteger := cdsTranB.FieldByName('Finish_').AsInteger;
            app.DataIn.FieldByName('FinishDate_').AsDateTime := cdsTranB.FieldByName('FinishDate_').AsDateTime;
            app.DataIn.FieldByName('ExRate_').AsFloat := cdsTranB.FieldByName('ExRate_').AsFloat;
            app.DataIn.FieldByName('Final_').AsBoolean := cdsTranB.FieldByName('Final_').AsBoolean;
            app.DataIn.FieldByName('ReqNo_').AsString := cdsTranB.FieldByName('ReqNo_').AsString;
            app.DataIn.FieldByName('ReqIt_').AsInteger := cdsTranB.FieldByName('ReqIt_').AsInteger;
            app.DataIn.FieldByName('StNum_').AsFloat := cdsTranB.FieldByName('StNum_').AsFloat;
            app.DataIn.FieldByName('CorpCode_').AsString := cdsTranB.FieldByName('CorpCode_').AsString;
            app.DataIn.FieldByName('Type_').AsInteger := cdsTranB.FieldByName('Type_').AsInteger;
            app.DataIn.FieldByName('Type1_').AsInteger := cdsTranB.FieldByName('Type1_').AsInteger;
            app.DataIn.FieldByName('NetW_').AsFloat := cdsTranB.FieldByName('NetW_').AsFloat;
            app.DataIn.FieldByName('PlanUP_').AsFloat := cdsTranB.FieldByName('PlanUP_').AsFloat;
            app.DataIn.FieldByName('AppDate_').AsDateTime := cdsTranB.FieldByName('AppDate_').AsDateTime;
            app.DataIn.FieldByName('AppUP_').AsFloat := cdsTranB.FieldByName('AppUP_').AsFloat;
            app.DataIn.FieldByName('Remark1_').AsString := cdsTranB.FieldByName('Remark1_').AsString;
            app.DataIn.FieldByName('SupRecDate_').AsDateTime := cdsTranB.FieldByName('SupRecDate_').AsDateTime;
            app.DataIn.FieldByName('Pay_').AsBoolean := cdsTranB.FieldByName('Pay_').AsBoolean;
            app.DataIn.FieldByName('IsTran_').AsBoolean := cdsTranB.FieldByName('IsTran_').AsBoolean;
            app.DataIn.FieldByName('ManuCode_').AsString := cdsTranB.FieldByName('ManuCode_').AsString;
            app.DataIn.FieldByName('ManuDrawing_').AsString := cdsTranB.FieldByName('ManuDrawing_').AsString;
            app.DataIn.FieldByName('Scale_').AsString := cdsTranB.FieldByName('Scale_').AsString;
            app.DataIn.FieldByName('WorkCode_').AsString := cdsTranB.FieldByName('WorkCode_').AsString;
            app.DataIn.FieldByName('IsStock_').AsBoolean := cdsTranB.FieldByName('IsStock_').AsBoolean;
            app.DataIn.FieldByName('Confirm_').AsInteger := cdsTranB.FieldByName('Confirm_').AsInteger;
            app.DataIn.FieldByName('InvSupCode_').AsString := cdsTranB.FieldByName('InvSupCode_').AsString;
            app.DataIn.FieldByName('SupSendPurNum_').AsFloat := cdsTranB.FieldByName('SupSendPurNum_').AsFloat;
            app.DataIn.FieldByName('Num1_').AsFloat := cdsTranB.FieldByName('Num1_').AsFloat;
            app.DataIn.FieldByName('Unit1_').AsString := cdsTranB.FieldByName('Unit1_').AsString;
            app.DataIn.FieldByName('CusCode_').AsString := cdsTranB.FieldByName('CusCode_').AsString;
            app.DataIn.FieldByName('WebPublish_').AsBoolean := cdsTranB.FieldByName('WebPublish_').AsBoolean;
            app.DataIn.FieldByName('PublishDate_').AsDateTime := cdsTranB.FieldByName('PublishDate_').AsDateTime;
            app.DataIn.FieldByName('ConfirmDate_').AsDateTime := cdsTranB.FieldByName('ConfirmDate_').AsDateTime;
            app.DataIn.FieldByName('LineDate_').AsDateTime := cdsTranB.FieldByName('LineDate_').AsDateTime;
            app.DataIn.FieldByName('Convert_').AsBoolean := cdsTranB.FieldByName('Convert_').AsBoolean;
            app.DataIn.Post;
            cdsTranB.Next;
          end;
          if app.Exec then
            begin
              FrmMain.memBody.Lines.Add('同步成功');
            end
          else
            ShowMessage(app.Messages);
        end;
      except
        on E: Exception do
        begin
          FrmMain.memBody.Lines.Add('error: '+ E.Message);
        end;
      end;
    end;
  finally
    cdsCRMSyn.Free;
    cdsTranH.Free;
    cdsTranB.Free;
  end;
end;

end.
