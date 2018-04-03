unit VirForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZjhCtrls, ImgList, ComCtrls, DBForms, ApConst, uBaseIntf,
  IniFiles, EdtTrans, XMLDoc, XMLIntf;

type
  TVirForm = class(TDBForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ImageList1: TImageList;
    TabSheet3: TTabSheet;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_TT: String;
    FObjList: TList;
    procedure SearchPlugins(Sender: TForm);
    procedure InstallPlugins(item: IXmlNode; Sender: TForm);
  protected

  public
    { Public declarations }
    EdtForm, SchForm, SchFormMX: IBaseForm;
    function Sec: TZjhTool; override;
    property TT: String read m_TT write m_TT;
    function PostMessage(MsgType: Integer; Msg: Variant): Variant; override;
    function InitForms: Boolean; virtual;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses InfoBox, MainData;

{$R *.dfm}

{ TVirTran }

procedure TVirForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Child: TForm;
begin
  Action := caFree;
  if Assigned(EdtForm) then
  begin
    Child := (EdtForm.GetControl('') as TForm);
    if Child.CloseQuery then
      begin
        Child.OnCloseQuery := nil;
        Action := caFree;
      end
    else
      Action := caNone;
  end;
end;

function TVirForm.Sec: TZjhTool;
begin
  Result := nil;
  case PageControl1.ActivePageIndex of
  0:
    if Assigned(EdtForm) then Result := EdtForm.ISec as TZjhTool;
  1:
    if Assigned(SchForm) then Result := SchForm.ISec as TZjhTool;
  2:
    if Assigned(SchFormMX) then Result := SchFormMX.ISec as TZjhTool;
  end;
  {
  if not Assigned(Result) then
    Result := Self.ZjhTool1;
  }
end;

function TVirForm.PostMessage(MsgType: Integer; Msg: Variant): Variant;
begin
  case MsgType of
  CONST_CREATEPARAM:
    begin
      m_TT := Msg;
      if not InitForms then
        raise Exception.Create(Chinese.AsString('�Ƿ��ĵ���') + m_TT);
      if not Assigned(SchFormMX) then TabSheet3.TabVisible := False;
      PageControl1.ActivePageIndex := 1;
    end;
  CONST_GOTORECORD:
    begin
      if Assigned(EdtForm) then
      begin
        Result := EdtForm.PostMessage(CONST_GOTORECORD, Msg);
        PageControl1.ActivePageIndex := 0;
      end;
    end;
  CONST_BARCODE:
    begin
      if Assigned(EdtForm) then
      begin
        Result := EdtForm.PostMessage(CONST_BARCODE, Msg);
        PageControl1.ActivePageIndex := 0;
      end;
    end;
  else
    begin
      case PageControl1.ActivePageIndex of
      0: //
        begin
          if Assigned(EdtForm) then
            Result := EdtForm.PostMessage(MsgType, Msg);
        end;
      1: //
        begin
          if Assigned(SchForm) then
            Result := SchForm.PostMessage(MsgType, Msg);
        end;
      2: //
        begin
          if Assigned(SchFormMX) then
            Result := SchFormMX.PostMessage(MsgType, Msg);
        end;
      end;
    end;
  end;
end;

function TVirForm.InitForms: Boolean;
var
  sl: TStringList;
  Ini: TMemIniFile;
  FormID, FormParam: String;
  cdsTmp: TZjhDataSet;
  function GetChild(PageNo: Integer): IBaseForm;
  var
    //P: TReportOutputEvent;
    AIntf: IBaseForm;
    MenuCode: String;
    AObj: TComponent;
  begin
    AIntf := nil;
    MenuCode := Ini.ReadString('VirForms','Child' + IntToStr(PageNo),'');
    if MenuCode <> '' then
    begin
      AObj := CreateClass(MenuCode, Application);
      if Assigned(AObj) then
        FObjList.Add(AObj);
      AIntf := AObj as IBaseForm;
      if Assigned(AIntf) then
      try
        {
        if AObj is TForm then
          CM.InitForm(AObj as TForm);
        //�ȱ���ԭ���¼������¼�
        P := nil;
        if AObj is TEdtTran then
          P := TEdtTran(AObj).Sec.OnReportOutput;
        }
        if Assigned(AIntf.ISec) then
          (AIntf.ISec as TZjhTool).Passport := VarToStr(Self.AliaName);
        MainIntf.PostMessage(CONST_MAINFORM_SetQuickToolID,
          VarArrayOf([Integer(AIntf.ISec), FormID]));
        //��TEdtTran���帳ֵ
        {
        if (AObj is TEdtTran) then
          if (not Assigned(P)) then
            TEdtTran(AObj).Sec.OnReportOutput := TEdtTran(AObj).qhReportOutput;
        }
        AIntf.AliaName := IBaseForm(Self).AliaName;
        //Modify by MYY @2006-03-17:�Ѿ��ƶ���DBForms.pas��DoCreate�����С�
        //Chinese.AsObject(AIntf.GetControl(''));
        (AIntf.GetControl('') as TForm).Caption := Self.Caption;
        if PageNo = 0 then
          AIntf.PostMessage(CONST_CREATEPARAM,
            VarArrayOf([Integer(TFormCoat.Create(PageControl1.Pages[PageNo])),TT,False]))
        else
          AIntf.PostMessage(CONST_CREATEPARAM,
            VarArrayOf([Integer(TFormCoat.Create(PageControl1.Pages[PageNo])),TT]));
        //��������װ���в��
        SearchPlugins(AObj as TForm);
      except
        on E: Exception do
          MsgBox(Chinese.AsString('%s ���ܺܺõ�֧��VirForms������ϵͳ����Ա��ϵ������֮����ԭ��%s%s'),
            [MenuCode, vbCrLf, E.Message]);
      end;
    end;
    Result := AIntf;
  end;
begin
  Result := False;
  cdsTmp := TZjhDataSet.Create(Self);
  try
    with cdsTmp do
    begin
      RemoteServer := DM.DCOM;
      Database := 'Common';
      CommandText := Format('Select ID_,Param_ From SysFormDef '
        + 'Where Code_=''%s''', [(Self as IBaseForm).AliaName]);
      Open;
      if not Eof then
        begin
          FormID := FieldByName('ID_').AsString;
          FormParam := FieldByName('Param_').AsString;
          sl := TStringList.Create;
          Ini := TMemIniFile.Create('');
          try
            sl.Text := FormParam;
            Ini.SetStrings(sl);
            if Ini.SectionExists('VirForms') then
            begin
              EdtForm   := GetChild(0);
              SchForm   := GetChild(1);
              SchFormMX := GetChild(2);
              Result := True;
            end;
          finally
            FreeAndNil(Ini);
            FreeAndNil(sl);
          end;
        end
      else
        MsgBox(Chinese.AsString('���ܿ����Ҳ��� %s, ��ʼ�����ɹ���'),
          [(Self as IBaseForm).AliaName]);
    end;
  finally
    cdsTmp.Free;
  end;
end;

procedure TVirForm.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  inherited;
  for i := 0 to FObjList.Count - 1 do begin
    TForm(FObjList.Items[i]).Close;
  end;
  FObjList.Free;
end;

constructor TVirForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjList := TList.Create;
end;

procedure TVirForm.SearchPlugins(Sender: TForm);
var
  xmlFile: String;
  xml: IXmlDocument;
  body, item, node: IXmlNode;
  CustomerName: String;
  function Group_ReadString(const KeyNo: String; const Default: String): String;
  var
    cdsTmp: TZjhDataSet;
  begin
    Result := Default;
    //Modify by Jason 2006/11/14
    cdsTmp := TZjhDataSet.Create(Self);
    try
      with cdsTmp do
      begin
        RemoteServer := DM.DCOM;
        Database := 'Common';
        CommandText := Format('Select Value_ From SysValues Where Code_=''%s''', [KeyNo]);
        Open;
        if not Eof then
          Result := FieldByName('Value_').AsString;
      end;
    finally
      cdsTmp.Free;
    end;
  end;
begin
  CustomerName := Trim(Group_ReadString('SYS08007', 'customer'));
  xmlFile := ExtractFilePath(Application.ExeName) + '2052\' + CustomerName + '.xml';
  if not FileExists(xmlFile) then
    Exit;
  xml := LoadXmlDocument(xmlFile);
  try
    body := xml.DocumentElement.ChildNodes.FindNode('body');
    //��װͨ�ò��
    item := body.ChildNodes.FindNode('common');
    if Assigned(item) then
    begin
      node := item.ChildNodes.FindNode('plugins');
      while Assigned(node) do
      begin
        if node.Attributes['enabled'] = 'true' then
          InstallPlugins(node, Sender);
        node := node.NextSibling;
      end;
    end;
    //��װר�ò��
    item := body.ChildNodes.FindNode(Sender.ClassName);
    if Assigned(item) then
    begin
      node := item.ChildNodes.FindNode('plugins');
      while Assigned(node) do
      begin
        if node.Attributes['enabled'] = 'true' then
          InstallPlugins(node, Sender);
        node := node.NextSibling;
      end;
    end;
  finally
    xml := nil;
  end;
end;

procedure TVirForm.InstallPlugins(item: IXmlNode; Sender: TForm);
var
  obj: TComponent;
  AIntf: IPlugins;
begin
  obj := CreateClass(item.Attributes['class'], Sender);
  if Assigned(obj) then
    begin
      if item.HasAttribute('id') then
        obj.Name := item.Attributes['id'];
      if Supports(obj, IPlugins) then
        begin
          AIntf := obj as IPlugins;
          try
            AIntf.Init(item);
            if AIntf.CheckEnvironment then
              begin
                AIntf.Install(Sender);
                ibox.Text(Chinese.AsString('��Ϊ %s ��װ�˱�׼�����%s'), [Sender.ClassName, obj.ClassName]);
              end
            else
              MsgBox(Chinese.AsString('��׼��%s�иı䣬ԭ���%s�Ѳ������ʹ�ã���������������δ֪���գ�'
                + '%s����������ֹͣ��ҵ������µ�ǰ�����Ĳ˵����ƣ�Ȼ��������Բ��Ż������Ӧ�����硣'),
                [Sender.ClassName, obj.ClassName, vbCrLf]);
          finally
            AIntf := nil;
          end;
        end
      else
        ibox.Text(Chinese.AsString('��Ϊ %s ��װ�˷Ǳ�׼��� %s��'), [Sender.ClassName, obj.ClassName]);
    end
  else
    MsgBox(Chinese.AsString('Ϊ %s ��װ��� %s ʧ�ܣ���������������δ֪���գ�') + vbCrLf
      + Chinese.AsString('����������ֹͣ��ҵ�������µ�ǰ�����Ĳ˵����ƣ�Ȼ��������Բ��Ż������Ӧ�����硣'),
      [Sender.ClassName, item.Attributes['class'], vbCrLf])
end;

initialization
  RegClass(TVirForm);

finalization
  UnRegClass(TVirForm);

end.
