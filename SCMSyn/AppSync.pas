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
  begin
    Target.FieldByName(Args[i]).Value := Source.FieldByName(Args[i]).Value;
  end;
end;

procedure TAppSync.CopyFields(Target: TAppDataSet; Source: TADOQuery;
  const Args: array of String);
var
  i: Integer;
begin
  for i := Low(Args) to High(Args) do
  begin
    Target.FieldByName(Args[i]).Value := Source.FieldByName(Args[i]).Value;
  end;
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
  sFieldName: String;
begin
  for i:=0 to Source.Fields.Count - 1 do
  begin
    sFieldName := Source.Fields[i].FieldName;
    if Source.FieldByName(sFieldName).DataType = ftInteger  then
      Target.FieldByName(sFieldName).AsInteger :=Source.FieldByName(sFieldName).AsInteger
    else if Source.FieldByName(sFieldName).DataType = ftDateTime  then
      Target.FieldByName(sFieldName).AsDateTime :=Source.FieldByName(sFieldName).AsDateTime
    else if Source.FieldByName(sFieldName).DataType = ftBoolean  then
      Target.FieldByName(sFieldName).AsBoolean :=Source.FieldByName(sFieldName).AsBoolean
    else if Source.FieldByName(sFieldName).DataType = ftFloat  then
      Target.FieldByName(sFieldName).AsFloat :=Source.FieldByName(sFieldName).AsFloat
    else if Source.FieldByName(sFieldName).DataType = ftBCD  then
      Target.FieldByName(sFieldName).AsFloat :=Source.FieldByName(sFieldName).AsFloat
    else if Source.FieldByName(sFieldName).DataType = ftCurrency  then
      Target.FieldByName(sFieldName).AsFloat :=Source.FieldByName(sFieldName).AsFloat
    else
      Target.FieldByName(sFieldName).Value := Source.FieldByName(sFieldName).Value;
  end;
end;

procedure TAppSync.CopyRecord(Target: TAppRecord; Source: TADOQuery);
var
  i: Integer;
  sFieldName: String;
begin
  for i:=0 to Source.Fields.Count - 1 do
  begin
    sFieldName := Source.Fields[i].FieldName;
    if Source.FieldByName(sFieldName).DataType = ftInteger  then
      Target.FieldByName(sFieldName).AsInteger :=Source.FieldByName(sFieldName).AsInteger
    else if Source.FieldByName(sFieldName).DataType = ftDateTime  then
      Target.FieldByName(sFieldName).AsDateTime :=Source.FieldByName(sFieldName).AsDateTime
    else if Source.FieldByName(sFieldName).DataType = ftBoolean  then
      Target.FieldByName(sFieldName).AsBoolean :=Source.FieldByName(sFieldName).AsBoolean
    else if Source.FieldByName(sFieldName).DataType = ftFloat  then
      Target.FieldByName(sFieldName).AsFloat :=Source.FieldByName(sFieldName).AsFloat
    else if Source.FieldByName(sFieldName).DataType = ftBCD  then
      Target.FieldByName(sFieldName).AsFloat :=Source.FieldByName(sFieldName).AsFloat
    else if Source.FieldByName(sFieldName).DataType = ftCurrency  then
      Target.FieldByName(sFieldName).AsFloat :=Source.FieldByName(sFieldName).AsFloat
    else
      Target.FieldByName(sFieldName).Value := Source.FieldByName(sFieldName).Value;
  end;
end;

procedure TAppSync.SynExec(AConn: TADOConnection);
var
  cdsCRMSyn,cdsTranH,cdsTranB: TADOQuery;
  app: IAppService;
  cdsH,cdsB:TAppDataSet;
  PID,sTable: String;
  CRMSynID: String;
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
      if cdsCRMSyn.FieldByName('Status_').AsInteger in [0,2] then   //0-待同步 1-已同步 2-重新同步 3-不需要同步 4-同步失败
      try
        CRMSynID := cdsCRMSyn.FieldByName('ID_').AsString;
        if cdsCRMSyn.FieldByName('Type_').AsInteger = 0 then  //0-非单据(单表)  1-单据
        begin
          cdsTranH.Connection := FrmMain.oCn;
          cdsTranH.SQL.Text := Format('SELECT top 1 * FROM %s WHERE CorpCode_=''%s'' and %s=''%s'' '
            ,[cdsCRMSyn.FieldByName('Table_').AsString,FrmMain.EdtCorp.Text,cdsCRMSyn.FieldByName('KeyCode_').AsString,cdsCRMSyn.FieldByName('TBNo_').AsString]);
          cdsTranH.Open;
          if not cdsTranH.Eof then
          begin
            sTable := 'E_'+cdsCRMSyn.FieldByName('Table_').AsString;
            app := Service('SvrERPSyncReport.SyncERPDate');
            app.DataIn.Head.FieldByName('E_Table_').AsString := sTable;
            app.DataIn.Head.FieldByName('KeyCode_').AsString := cdsCRMSyn.FieldByName('KeyCode_').AsString;
            CopyRecord(app.DataIn.Head,cdsTranH);
          end;
          if app.Exec then
            begin
              FrmMain.oCn.Execute(Format('UPDATE CRMSyn SET Status_=1 WHERE ID_=''%s''',[CRMSynID]));
              FrmMain.memBody.Lines.Add('同步成功');
            end
          else
          begin
            FrmMain.oCn.Execute(Format('UPDATE CRMSyn SET Status_=4 WHERE ID_=''%s''',[CRMSynID]));
            ShowMessage('同步失败:'+app.Messages);
          end;
        end
        else
        begin
          cdsTranH.Connection := FrmMain.oCn;
          cdsTranH.SQL.Text := Format('SELECT top 1 * FROM %sH WHERE CorpCode_=''%s'' and %s=''%s'' and Ver_<=0 and Final_=1'
            ,[cdsCRMSyn.FieldByName('Table_').AsString,FrmMain.EdtCorp.Text,cdsCRMSyn.FieldByName('KeyCode_').AsString,cdsCRMSyn.FieldByName('TBNo_').AsString]);
          cdsTranH.Open;
          if not cdsTranH.Eof then
          begin
            PID:= cdsTranH.FieldByName('ID_').AsString;
            cdsTranB.Connection := FrmMain.oCn;
            cdsTranB.SQL.Text := Format('SELECT * FROM %sB WHERE PID_=''%s'' ',[cdsCRMSyn.FieldByName('Table_').AsString,PID]);
            cdsTranB.Open;
            sTable := 'E_'+cdsCRMSyn.FieldByName('Table_').AsString+'H';
            app := Service('SvrERPSyncReport.SyncERPDate');
            app.DataIn.Head.FieldByName('E_Table_').AsString := sTable;
            app.DataIn.Head.FieldByName('KeyCode_').AsString := cdsCRMSyn.FieldByName('KeyCode_').AsString;
            CopyRecord(app.DataIn.Head,cdsTranH);
            cdsTranB.First;
            while not cdsTranB.Eof do
            begin
              app.DataIn.Append();
              sTable := 'E_'+cdsCRMSyn.FieldByName('Table_').AsString+'B';
              app.DataIn.FieldByName('E_Table_').AsString := sTable;
              CopyRecord(app.DataIn,cdsTranB);
              app.DataIn.Post;
              cdsTranB.Next;
            end;
            if app.Exec then
              begin
                FrmMain.oCn.Execute(Format('UPDATE CRMSyn SET Status_=1 WHERE ID_=''%s''',[CRMSynID]));
                FrmMain.memBody.Lines.Add('同步成功');
              end
            else
            begin
              FrmMain.oCn.Execute(Format('UPDATE CRMSyn SET Status_=4 WHERE ID_=''%s''',[CRMSynID]));
              ShowMessage('同步失败:'+app.Messages);
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          FrmMain.oCn.Execute(Format('UPDATE CRMSyn SET Status_=4 WHERE ID_=''%s''',[CRMSynID]));
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
