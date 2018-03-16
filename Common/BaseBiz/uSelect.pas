unit uSelect;

interface

uses
  Forms, Variants, DBClient, SysUtils, DB, Controls, ComCtrls, Classes,
  StdCtrls, ZjhCtrls, uBaseIntf, MainData, InfoBox, ApConst,
  DBGrids, DocCtrls, XmlIntf, XmlDoc;

type
  THRChoiceItem = record
    Index: Integer;
    Data: Variant;
    Comment: String;
    Checked: Boolean;
  end;
  PHRChoiceItem = ^THRChoiceItem;
  THRChoice = class(TComponent)
  private
    sl: TStringList;
    Values: array of THRChoiceItem;
    function GetSelected: String;
    function GetItems(Index: Integer): PHRChoiceItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    function AddItem: PHRChoiceItem;
    function Add(const Value: Variant): Integer;
    function ItemCount: Integer;
    function Execute: Boolean;
    procedure Clear;
  public
    property Items[Index: Integer]: PHRChoiceItem read GetItems; default;
    property Selected: String read GetSelected;
  end;
  function SelectDisplay(const ClassName: String;
    const Sender: TObject; const Param: Variant): IBaseForm;
  function SelectExecute(const ClassName: String;
    const Targets: array of TObject; const Param: Variant): Variant;
  function SelectDialog(const Args: array of string;
    Default: Integer = 0): Integer;
  function SelDeptCode(const Args: array of TObject; ALevel: Integer = -1): Boolean; overload;
  function SelDeptCode(const Args: array of TObject; const AType: String): Boolean; overload;
  function SelLineCode(const Args: array of TObject; const DeptCode: String = ''): Boolean;
  function SelReasonCode(const Args: array of TObject; const TT: String = ''): Boolean;
  //取系统单别下的所有异动原因
  function SelReasonCode1(const Args: array of TObject; const TT: String = ''): Boolean;
  function SelCorp(const Args: array of TObject; AType: Integer): Boolean;
  function SelWHCode(const Args: array of TObject): Boolean;
  function SelModelCode(const Args: array of TObject): Boolean;
  function SelAccount(const Args: array of TObject): Boolean;
  function SelBuffCode(const Index: String; const Args: array of TObject): Boolean;
  function SelGroupBuff(const Index: String; const Args: array of TObject): Boolean;
  //公用选择函数
  function SelCode(const Args: array of TObject; const strSQLText: String;
    Code_Size: Integer; const Code_Caption: String;
    Name_Size: Integer; const Name_Caption: String;
    RetColumnNo: Integer = 0): Boolean; overload;
  function SelCode(const strSQLText: String;
    Code_Size: Integer; const Code_Caption: String;
    Name_Size: Integer; const Name_Caption: String): String; overload;
  function SelCode(const strSQLText: String;
    Captions: Variant; Sizes: Variant; var RetValue: Variant): Boolean; overload;
  function SelSysList(const Args: array of TObject; TID: Integer;
    const Code_Caption: String = ''; const Name_Caption: String = '';
    RetColumnNo: Integer = 0): Boolean;
  function SelTBDate(Sender: TObject): Boolean;
  function GetSelectDate(): TDateTime;
  function GetNewAccount: String;
  function GetAccountID(Sender: TComponent; SaveBox: TStringList): Boolean;
  function GetActiveGrid(Sender: TForm): TDBGrid;
  function SelAccSubject(const Args: array of TObject;
    const AShowRoot: Boolean = True): Boolean;
  function SelAccSubjectB(var AccCode, AccName: String;
   const AShowRoot: Boolean = True): Boolean;
  function GetCustomerClass(const AClass: String): String;
  {
  //function RptExecute(Sender: TForm; ASec: TZjhTool;
  //  const Args: array of TDataSource; rfAction: TReportFormatOption): Boolean;
  //procedure RptPutOffice(DBGrid: TDBGrid; rfAction: TReportFormatOption);
const
  //TSelectDialog
  CONST_SELECTDIALOG = 102000;
  CONST_SELECTDIALOG_SELACCOUNT = CONST_SELECTDIALOG + 1; //SelAccount函数
  CONST_SELECTDIALOG_OPENCOMMAND = CONST_SELECTDIALOG + 2; //OpenCommand函数
  CONST_SELECTDIALOG_ADDTITLE = CONST_SELECTDIALOG + 3; //AddTitle函数
  CONST_SELECTDIALOG_OPENBUFFER = CONST_SELECTDIALOG + 4; //OpenBuffer函数
  //CONST_SELECTDIALOG_EXECUTE = CONST_SELECTDIALOG + 5; //Execute函数
  CONST_SELECTDIALOG_SETRESULTCOLUMNNO = CONST_SELECTDIALOG + 6; //SetResultColumnNo函数
  CONST_SELECTDIALOG_MULTISELECT = CONST_SELECTDIALOG + 7; //MultiSelect函数

  //TDlgSelCorpCode
  CONST_DLGSELCORPCODE = 106000;
  CONST_DLGSELCORPCODE_SETCORPTYPE = CONST_DLGSELCORPCODE + 1; //SetCorpType函数
  //CONST_DLGSELCORPCODE_EXECUTE = CONST_DLGSELCORPCODE + 2; //Execute函数

  //TFrmSelDeptCode
  CONST_FRMSELDEPTCODE = 107000;
  CONST_FRMSELDEPTCODE_OPENCOMMAND     = CONST_FRMSELDEPTCODE + 1; //OpenCommand函数
  CONST_FRMSELDEPTCODE_SETCURRENTLEVEL = CONST_FRMSELDEPTCODE + 2; //SetCurrentLevel函数
  CONST_FRMSELDEPTCODE_EXECUTE         = CONST_FRMSELDEPTCODE + 3; //SetCorpType函数
  }

implementation

function GetCustomerClass(const AClass: String): String;
var
  strFile: String;
  xml: IXmlDocument;
  body, root, node: IXmlNode;
begin
  Result := AClass;
  strFile := nreg.ReadData('SYS08007');
  if strFile <> '' then
    strFile := ExtractFilePath(Application.ExeName) + '2052\' + strFile + '.xml'
  else
    raise Exception.Create(Chinese.AsString('您没有定义好系统参数(Code=SYS08007)，请检查！'));
  //strFile := ExtractFilePath(Application.ExeName) + PKGManger.LangPath + '\standard.xml';
  if FileExists(strFile) then
  begin
    xml := LoadXmlDocument(strFile);
    try
      body := xml.DocumentElement.ChildNodes.FindNode('body');
      if Assigned(body) then
      begin
        root := body.ChildNodes.FindNode('classes');
        if Assigned(root) then
        begin
          node := root.ChildNodes.First;
          while Assigned(node) do
          begin
            if node.Attributes['class'] = AClass then
            begin
              Result := node.Attributes['customer'];
              Break;
            end;
            node := node.NextSibling;
          end;
        end;
      end;
    finally
      body := nil; root := nil; node := nil;
      xml := nil;
    end;
  end;
end;

function SelectExecute(const ClassName: String;
  const Targets: array of TObject; const Param: Variant): Variant;
var
  newClass: String;
  AIntf: ISelectDialog;
begin
  if High(Targets) = -1 then Result := NULL else Result := False;
  //Modify by MYY@2006/10/25:允许定制选择窗口
  //AIntf := MainIntf.GetForm(ClassName, False) as ISelectDialog;
  //
  newClass := GetCustomerClass(ClassName);
  AIntf := CreateClassEx(newClass, Application) as ISelectDialog;
  if Assigned(AIntf) then
    Result := AIntf.Execute(Targets, Param)
  else
    raise Exception.CreateFmt(Chinese.AsString('没有找到或无法创建对象： %s'), [newClass]);
end;

function SelectDisplay(const ClassName: String;
  const Sender: TObject; const Param: Variant): IBaseForm;
var
  Child: IBaseForm;
  AIntf: ISelectDialog;
begin
  Result := nil;
  AIntf := nil;
  Child := MainIntf.GetForm(GetCustomerClass(ClassName), True);
  if Assigned(Child) then
  begin
    AIntf := (Child.GetControl('') as TForm) as ISelectDialog;
    if Assigned(AIntf) then
      AIntf.Display(Sender, Param);
    Result := (Child.GetControl('') as TForm) as IBaseForm;
  end;
end;

function SelectDialog(const Args: array of string; Default: Integer = 0): Integer;
var
  i: Integer;
  sl: TStringList;
  AIntf: IHRObject;
begin
  AIntf := CreateClass(GetCustomerClass('TFrmSelectButton'), Application) as IHRObject;
  if Assigned(AIntf) then
    begin
      sl := TStringList.Create;
      try
        for i := Low(Args) to High(Args) do
          sl.Add(Args[i]);
        Result := AIntf.PostMessage(CONST_DEFAULT, Integer(sl));
      finally
        FreeAndNil(sl);
      end;
    end
  else
    Result := -2;
end;

function SelDeptCode(const Args: array of TObject; ALevel: Integer): Boolean;
begin
  Result := SelectExecute('TSelectDept', Args, ALevel);
end;

function SelDeptCode(const Args: array of TObject; const AType: String): Boolean;
begin
  Result := SelectExecute('TSelectDept', Args, AType);
end;

function SelLineCode(const Args: array of TObject; const DeptCode: String): Boolean;
begin
  Result := SelectExecute('TSelectDept', Args, VarArrayOf([DeptCode]));
end;

function SelCorp(const Args: array of TObject; AType: Integer): Boolean;
begin
  Result := SelectExecute('TSelectCorp', Args, AType);
end;

function SelWHCode(const Args: array of TObject): Boolean;
begin
  Result := SelBuffCode('PartWH',Args);
end;

function SelModelCode(const Args: array of TObject): Boolean;
begin
  Result := SelBuffCode('PartModel',Args);
end;

function SelTBDate(Sender: TObject): Boolean;
begin
  Result := SelectExecute('TSelectDatetime', [Sender], EMPTY_VARIANT);
end;

function GetSelectDate(): TDateTime;
var
  vTemp: Variant;
begin
  Result := Now();
  vTemp := SelectExecute('TSelectDatetime',[],EMPTY_VARIANT);
  if not (VarIsNull(vTemp) or VarIsClear(vTemp)) then
    Result := vTemp;
end;

function SelReasonCode1(const Args: array of TObject; const TT: String): Boolean;
var
  AIntf1: IBaseForm;
  AIntf2: ISelectDialog;
  Obj: TComponent;
  SQLCmd: String;
begin
  Obj := CreateClass(GetCustomerClass('TSelectReason'), nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf2 := Obj as ISelectDialog;
    SQLCmd := Format('select R.Code_,R.Name_,R.DefTB_ from TranReason R '
      + 'inner join TranT T on T.Code_=R.DefTB_ and T.UserDef_=1 and T.TB_=''%s''',
      [TT]);
    Aintf1.PostMessage(CONST_SELECTDIALOG_OPENCOMMAND, SQLCmd);
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0,  90, Chinese.AsString('异动代码')]));
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([1, 140, Chinese.AsString('异动原因')]));
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([2,  90, Chinese.AsString('默认单别')]));
    Result := AIntf2.Execute(Args, EMPTY_VARIANT);
  finally
    AIntf1 := nil;
    AIntf2 := nil;
    Obj.Free;
  end;
end;

function SelReasonCode(const Args: array of TObject; const TT: String): Boolean;
var
  AIntf1: IBaseForm;
  AIntf2: ISelectDialog;
  Obj: TComponent;
  Source: TZjhDataSet;
  ACDS: TClientDataSet;
begin
  Obj := CreateClass(GetCustomerClass('TSelectReason'), nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf2 := Obj as ISelectDialog;
    Source := TZjhDataSet.Create(Application);
    try
      Source.Data := Buff['Reason'].Data;
      if TT <> '' then
      begin
        with Source do
        begin
          First;
          while not Eof do
          begin
            if UpperCase(FieldByName('DefTB_').AsString) <> UpperCase(TT) then
              Delete else Next;
          end;
        end;
      end;
      ACDS := TClientDataSet(AIntf1.GetControl('cdsSource'));
      if Assigned(ACDS) then
        ACDS.Data := Source.Data;
    finally
      Source.Free;
    end;
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0,  90, Chinese.AsString('异动代码')]));
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([1, 140, Chinese.AsString('异动原因')]));
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([2,  90, Chinese.AsString('默认单别')]));
    Result := AIntf2.Execute(Args, EMPTY_VARIANT);
  finally
    AIntf1 := nil;
    AIntf2 := nil;
    Obj.Free;
  end;
end;

function SelBuffCode(const Index: String; const Args: array of TObject): Boolean;
var
  AIntf1: IBaseForm;
  AIntf2: ISelectDialog;
  Obj: TComponent;
begin
  Obj := CreateClass('TSelectDialog', nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf2 := Obj as ISelectDialog;
    AIntf1.PostMessage(CONST_SELECTDIALOG_OPENBUFFER, VarArrayOf([Index, False]));
    Result := AIntf2.Execute(Args, EMPTY_VARIANT);
  finally
    AIntf1 := nil;
    AIntf2 := nil;
    Obj.Free;
  end;
end;

function SelGroupBuff(const Index: String; const Args: array of TObject): Boolean;
var
  AIntf1: IBaseForm;
  AIntf2: ISelectDialog;
  Obj: TComponent;
begin
  Obj := CreateClass('TSelectDialog', nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf2 := Obj as ISelectDialog;
    AIntf1.PostMessage(CONST_SELECTDIALOG_OPENBUFFER, VarArrayOf([Index, True]));
    Result := AIntf2.Execute(Args, EMPTY_VARIANT);
  finally
    AIntf1 := nil;
    AIntf2 := nil;
    Obj.Free;
  end;
end;

function SelAccount(const Args: array of TObject): Boolean;
var
  AIntf1: IBaseForm;
  AIntf2: ISelectDialog;
  Obj: TComponent;
begin
  Obj := CreateClass('TSelectDialog', nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf2 := Obj as ISelectDialog;
    AIntf1.PostMessage(CONST_SELECTDIALOG_OPENCOMMAND,
      'Select Code_,Name_ From Account Order by Code_');
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0, 65,Chinese.AsString('用户帐号')]));
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([1,125,Chinese.AsString('用户姓名')]));
    Result := AIntf2.Execute(Args, EMPTY_VARIANT);
  finally
    AIntf1 := nil;
    AIntf2 := nil;
    Obj.Free;
  end;
end;

function SelCode(const Args: array of TObject;  const strSQLText: String;
  Code_Size: Integer; const Code_Caption: String;
  Name_Size: Integer; const Name_Caption: String;
  RetColumnNo: Integer): Boolean; overload;
var
  AIntf1: IBaseForm;
  AIntf2: ISelectDialog;
  Obj: TComponent;
begin
  Obj := CreateClass('TSelectDialog', nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf2 := Obj as ISelectDialog;
    AIntf1.PostMessage(CONST_SELECTDIALOG_OPENCOMMAND, strSQLText);
    AIntf1.PostMessage(CONST_SELECTDIALOG_SETRESULTCOLUMNNO, RetColumnNo);
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0, Code_Size, Code_Caption]));
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([1, Name_Size, Name_Caption]));
    Result := AIntf2.Execute(Args, EMPTY_VARIANT);
  finally
    AIntf1 := nil;
    AIntf2 := nil;
    Obj.Free;
  end;
end;

function SelCode(const strSQLText: String;
  Code_Size: Integer; const Code_Caption: String;
  Name_Size: Integer; const Name_Caption: String): String; overload;
var
  AIntf1: IBaseForm;
  AIntf2: ISelectDialog;
  Obj: TComponent;
begin
  Obj := CreateClass('TSelectDialog', nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf2 := Obj as ISelectDialog;
    AIntf1.PostMessage(CONST_SELECTDIALOG_OPENCOMMAND, strSQLText);
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0, Code_Size, Code_Caption]));
    AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([1, Name_Size, Name_Caption]));
    Result := AIntf2.Execute([], EMPTY_VARIANT);
  finally
    AIntf1 := nil;
    AIntf2 := nil;
    Obj.Free;
  end;
end;

function SelCode(const strSQLText: String;
  Captions: Variant; Sizes: Variant; var RetValue: Variant): Boolean; overload;
var
  i, iCount: integer;
  vTemp: Variant;
  AIntf1: IBaseForm;
  Obj: TComponent;
begin
  Obj := CreateClass('TSelectDialog', nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf1.PostMessage(CONST_SELECTDIALOG_OPENCOMMAND, strSQLText);
    if VarIsArray(Captions) then
      begin
        iCount := VarArrayHighBound(Captions, 1);
        for i := 0 to iCount do
        begin
          AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([i, Sizes[i], Captions[i]]));
        end;
      end
    else
      AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0, Sizes, Captions]));
    Result := AIntf1.ShowForm(CONST_FORM_SHOWMODAL, vTemp) = mrOK;
    if Result then
      RetValue := vTemp;
  finally
    AIntf1 := nil;
    Obj.Free;
  end;
end;

function SelSysList(const Args: array of TObject; TID: Integer;
  const Code_Caption: String; const Name_Caption: String;
  RetColumnNo: Integer): Boolean;
var
  AIntf1: IBaseForm;
  AIntf2: ISelectDialog;
  Obj: TComponent;
begin
  Obj := CreateClass('TSelectDialog', nil);
  try
    AIntf1 := Obj as IBaseForm;
    AIntf2 := Obj as ISelectDialog;
    AIntf1.PostMessage(CONST_SELECTDIALOG_OPENBUFFER, 'SYSLIST.'+IntToStr(TID));
    if Code_Caption <> '' then
      begin
        AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0,  85, Code_Caption]));
        AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([1, 125, Name_Caption]));
        AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([2, 155, Chinese.AsString('备注说明')]));
      end
    else
      begin
        AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([0,  85, Chinese.AsString('人员编号')]));
        AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([1, 125, Chinese.AsString('人员名称')]));
        AIntf1.PostMessage(CONST_SELECTDIALOG_ADDTITLE, VarArrayOf([2, 155, Chinese.AsString('备注说明')]));
      end;
    AIntf1.PostMessage(CONST_SELECTDIALOG_SETRESULTCOLUMNNO, RetColumnNo);
    Result := AIntf2.Execute(Args, EMPTY_VARIANT);
  finally
    AIntf1 := nil;
    AIntf2 := nil;
    Obj.Free;
  end;
end;

{ THRChoice }

function THRChoice.Add(const Value: Variant): Integer;
begin
  AddItem.Data := Value;
  Result := ItemCount - 1;
end;

function THRChoice.AddItem: PHRChoiceItem;
var
  i: Integer;
begin
  i :=  High(Values) + 1;
  SetLength(Values, i + 1);
  Result := @Values[i];
  //
  Result.Index := i;
  Result.Data := NULL;
  Result.Comment := '';
  Result.Checked := False;
end;

procedure THRChoice.Clear;
begin
  sl.Text := '';
  Values := nil;
end;

constructor THRChoice.Create(AOwner: TComponent);
begin
  inherited;
  sl := TStringList.Create;
end;

destructor THRChoice.Destroy;
begin
  Values := nil;
  FreeAndNil(sl);
  inherited;
end;

function THRChoice.Execute: Boolean;
var
  i: Integer;
  R: Variant;
  AIntf: IBaseForm;
  Child: TComponent;
begin
  R := VarArrayCreate([Low(Values), High(Values)], VarVariant);
  for i := Low(Values) to High(Values) do
    R[i] := Values[i].Data;
  //Modif by Jason at 2007/6/29
  //sl.Text := SelectChoice(R);
  sl.Text := '';
  Child := CreateClass('TFrmChoice', Application);
  if Assigned(Child) then
    try
      if Supports(Child, IBaseForm) then
      begin
        AIntf := Child as IBaseForm;
        if Assigned(AIntf) then
          sl.Text := VarToStr(AIntf.PostMessage(CONST_DEFAULT, R));
      end;
    finally
      AIntf := nil;
      FreeAndNil(Child);
    end
  else
    MsgBox(Chinese.AsString('无法创建 TFrmChoice, 请检查系统安装是否正常！'));
  for i := Low(Values) to High(Values) do
    Items[i].Checked := sl.IndexOf(IntToStr(i)) > -1;
  Result := sl.Count > 0;
end;

function THRChoice.GetItems(Index: Integer): PHRChoiceItem;
begin
  Result := @Values[Index];
end;

function THRChoice.GetSelected: String;
begin
  Result := sl.Text;
end;

function THRChoice.ItemCount: Integer;
begin
  Result := High(Values) + 1;
end;

function GetNewAccount: String;
var
  Child: TForm;
  cdsAccount: TDataSet;
begin
  Result := '';
  {$message '此函数后续可以删除，已没有程式再调用它！Jason at 2009/8/28'}
  Child := CreateClass(GetCustomerClass('TSelAccount'), Application) as TForm;
  try
    (Child as IBaseForm).PostMessage(CONST_CREATEPARAM, NULL);
    if Child.ShowModal = mrOK then
    begin
      cdsAccount := (Child as IBaseForm).GetControl('cdsAccount') as TDataSet;
      Result := cdsAccount.FieldByName('Code_').AsString;
    end;
  finally
    FreeAndNil(Child);
  end;
end;

function GetAccountID(Sender: TComponent;
  SaveBox: TStringList): Boolean;
var
  Child: TForm;
  cdsAccount: TDataSet;
begin
  Result := False;
  Child := CreateClass(GetCustomerClass('TSelAccount'), Application) as TForm;
  try
    Child.FormStyle := fsNormal;
    (Child as IBaseForm).PostMessage(CONST_CREATEPARAM, NULL);
    if Child.ShowModal = mrOK then
    begin
      cdsAccount := (Child as IBaseForm).GetControl('cdsAccount') as TDataSet;
      if not cdsAccount.Eof then
      begin
        SaveBox.Add(cdsAccount.FieldByName('ID_').AsString);
        SaveBox.Add(Trim(cdsAccount.FieldByName('Name_').AsString));
        SaveBox.Add(Trim(cdsAccount.FieldByName('Code_').AsString));
        SaveBox.Insert(0,'0');
        Result := True;
      end;
    end;
  finally
    FreeAndNil(Child);
  end;
end;

function GetActiveGrid(Sender: TForm): TDBGrid;
var
  i, j: Integer;
begin
  Result := nil;
  if (Assigned(Screen.ActiveControl)
    and (Screen.ActiveControl is TDBGrid)) then
  begin
    Result := TDBGrid(Screen.ActiveControl);
    Exit;
  end;
  if (Assigned(Sender.ActiveControl)
    and (Sender.ActiveControl is TDBGrid)) then
  begin
    Result := TDBGrid(Sender.ActiveControl);
    Exit;
  end;
  //搜索Sender窗体, 如只有一个DBGrid，则返回它
  j := 0;
  for i := 0 to Sender.ComponentCount - 1 do
  begin
    if Sender.Components[1] is TDBGrid then
    begin
      Inc(j);
      Result := TDBGrid(Sender.Components[1]);
    end;
  end;
   //如果有超过两个表格的，则不执行
  if j <> 1 then
  begin
    Result := nil;
    Exit;
  end;
end;

{
procedure RptOutput(Sender: TForm; rfAction: TReportFormatOption;
  ASec: TZjhTool);
var
  RptGrid: TDBGrid;
begin
  RptGrid := GetActiveGrid(Sender);
  if not Assigned(RptGrid) then
  begin
    MsgBox(Chinese.AsString('请先选择您要输出的数据表格！'));
    Exit;
  end;
  RptExecute(Sender, ASec, [RptGrid.DataSource], rfAction);
end;

function RptExecute(Sender: TForm; ASec: TZjhTool;
  const Args: array of TDataSource; rfAction: TReportFormatOption): Boolean; overload;
var
  Child: TForm;
  sParam: Variant;
begin
  Child := CreateClass('TSelReport', Sender) as TForm;
  if Assigned(Child) then
    begin
      (Child as IBaseForm).PostMessage(CONST_CREATEPARAM, NULL);
      Child.Show;
      case High(Args) of
      0: sParam := VarArrayOf([Integer(Args[0])]);
      1: sParam := VarArrayOf([Integer(Args[0]), Integer(Args[1])]);
      2: sParam := VarArrayOf([Integer(Args[0]), Integer(Args[1]), Integer(Args[2])]);
      3: sParam := VarArrayOf([Integer(Args[0]), Integer(Args[1]), Integer(Args[2]), Integer(Args[3])]);
      end;
      Result := (Child as IBaseForm).PostMessage(CONST_SELREPORT_EXECUTE,
        VarArrayOf([Integer(ASec), sParam, rfAction]));
    end
  else
    Result := False;
end;

procedure RptPutOffice(DBGrid: TDBGrid; rfAction: TReportFormatOption);
var
  Child: TForm;
begin
  if not Assigned(DBGrid.DataSource) then
    Raise Exception.Create(Chinese.AsString('找不到数据，或数据源没有打开！'));
  if not Assigned(DBGrid.DataSource.DataSet) then
    Raise Exception.Create(Chinese.AsString('找不到数据，或数据源没有打开！'));
  if not DBGrid.DataSource.DataSet.Active then
    Raise Exception.Create(Chinese.AsString('数据源没有打开，无法继续！'));
  case rfAction of
  rfExcel, rfWord:
    begin
      Child := CreateClass('TFrmPutOffice', Application) as TForm;
      if Assigned(Child) then
      try
        (Child as IBaseForm).PostMessage(CONST_DATA, VarArrayOf([Integer(DBGrid),rfAction]));
        Child.ShowModal();
      finally
        FreeAndNil(Child);
      end;
    end;
  rfTxt:
    DBGridToText(DBGrid);
  end;
end;
}

function SelAccSubject(const Args: array of TObject;
  const AShowRoot: Boolean = True): Boolean;
var
  AIntf: IBaseForm;
  ACDS: TClientDataSet;
  SelField: TField;
  SelEdit: TEdit;
begin
  if (High(Args) = 0) then
    begin
      if Args[0] is TField then
        begin
          SelField := Args[0] as TField;
          AIntf := CreateClass(GetCustomerClass('TFrmSelAccSub')) as IBaseForm;
          if Assigned(AIntf) then begin
            try
              AIntf.PostMessage(CONST_CREATEPARAM, NULL);
              AIntf.PostMessage(CONST_DEFAULT, AShowRoot);
              Result := AIntf.ShowForm(CONST_FORM_SHOWMODAL, TEMP_VARIANT) = mrOK;
              if Result then begin
                SelField.DataSet.Edit;
                ACDS := TClientDataSet(AIntf.GetControl('cdsAccSubject'));
                if Assigned(ACDS) then
                  SelField.AsString := ACDS.FieldByName('AccCode_').AsString;
              end;
            finally
              AIntf := nil;
            end;
          end;
        end
      else if Args[0] is TEdit then
        begin
          SelEdit := Args[0] as TEdit;
          AIntf := CreateClass(GetCustomerClass('TFrmSelAccSub')) as IBaseForm;
          if Assigned(AIntf) then begin
            try
              AIntf.PostMessage(CONST_CREATEPARAM, NULL);
              AIntf.PostMessage(CONST_DEFAULT, AShowRoot);
              Result := AIntf.ShowForm(CONST_FORM_SHOWMODAL, TEMP_VARIANT) = mrOK;
              if Result then begin
                ACDS := TClientDataSet(AIntf.GetControl('cdsAccSubject'));
                if Assigned(ACDS) then
                  SelEdit.Text := ACDS.FieldByName('AccCode_').AsString;
              end;
            finally
              AIntf := nil;
            end;
          end;
        end;
      Result := False;
    end
  else
    Result := False;
end;

function SelAccSubjectB(var AccCode, AccName: String;
 const AShowRoot: Boolean = True): Boolean;
var
  AIntf: IBaseForm;
  ACDS: TClientDataSet;
begin
  Result := False;
  AIntf := CreateClass(GetCustomerClass('TFrmSelAccSub')) as IBaseForm;
  if Assigned(AIntf) then begin
    try
      AIntf.PostMessage(CONST_CREATEPARAM, NULL);
      AIntf.PostMessage(CONST_DEFAULT, AShowRoot);
      Result := AIntf.ShowForm(CONST_FORM_SHOWMODAL, TEMP_VARIANT) = mrOK;
      if Result then begin
        ACDS := TClientDataSet(AIntf.GetControl('cdsAccSubject'));
        if Assigned(ACDS) then begin
          AccCode := ACDS.FieldByName('AccCode_').AsString;
          AccName := ACDS.FieldByName('Name_').AsString;
        end;
      end;
    finally
      AIntf := nil;
    end;
  end;
end;

end.
