unit SearchFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, StdCtrls, Buttons, DBClient, Grids, DBGrids, ExtCtrls, Variants,
  ZjhCtrls, xmldom, XMLIntf, msxmldom, XMLDoc, Menus, uBaseIntf,
  InfoBox, DBForms, uSelect, ErpTools;

type
  {$message '此Class于2008/4/1不再使用，已有引用的亦需移除！'} //Jason 2008/4/1
  TFraSearch = class(TFrame, ISearchFrame)
    cdsSearch: TClientDataSet;
    dsSearch: TDataSource;
    cdsSearchType_: TIntegerField;
    cdsSearchValue_: TWideStringField;
    cdsSearchCode_: TWideStringField;
    cdsSearchName_: TWideStringField;
    DBGrid1: TDBGrid;
    SelectCode1: TSelectCode;
    Label1: TLabel;
    cdsSearchCheck_: TIntegerField;
    SpeedButton1: TSpeedButton;
    cdsSearchWindow_: TWideStringField;
    Bevel1: TBevel;
    cdsSearchOptior: TWideStringField;
    xml: TXMLDocument;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Panel1: TPanel;
    chkSearchClose: TCheckBox;
    chkSearchWindowMax: TCheckBox;
    chkSearchSaveOption: TCheckBox;
    btnFind: TBitBtn;
    procedure cdsSearchBeforeInsert(DataSet: TDataSet);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SelectCode1Selected(K: Integer; V: TErpPack);
    procedure btnFindClick(Sender: TObject);
    procedure cdsSearchCheck_GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cdsSearchAfterScroll(DataSet: TDataSet);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure chkSearchWindowMaxClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    FOnSearchClick: TNotifyEvent;
    FSQLTemplate: String;
    FSQLOrder: String;
    FDataSet: TZjhDataSet;
    FDefaultText: String;
    FViewGrid: TDBGrid;
    function OpenXMLFile: IXMLNode;
    procedure LoadFilterGrid(Root: IXMLNode);
    procedure LoadViewGrid(Root: IXMLNode);
    procedure DeleteNode(Root: IXMLNode; Index: String);
    //function GetNode(Root: IXMLNode; Index: String): IXMLNode;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(const MaxRecord: Integer = 0);
    function AddParam(const ACode, AName: String;
      const Default: String = ''): TField; overload;
    function AddParam(const ACode, AName, Default: String;
      AType: Integer; const AWindow: String = ''): TField; overload;
  public
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetDataSet: TZjhDataSet;
    procedure SetDataSet(const Value: TZjhDataSet);
    function GetViewGrid: TDBGrid;
    procedure SetViewGrid(const Value: TDBGrid);
    function GetDefaultText: String;
    procedure SetDefaultText(const Value: String);
    function GetSQLTemplate: String;
    procedure SetSQLTemplate(const Value: String);
    function GetSQLOrder: String;
    procedure SetSQLOrder(const Value: String);
    function GetOnSearchClick: TNotifyEvent;
    procedure SetOnSearchClick(const Value: TNotifyEvent);
  public
    property DataSet: TZjhDataSet read GetDataSet write SetDataSet;
    property ViewGrid: TDBGrid read GetViewGrid write SetViewGrid;
    property DefaultText: String read GetDefaultText write SetDefaultText;
    property SQLTemplate: String read GetSQLTemplate write SetSQLTemplate;
    property SQLOrder: String read GetSQLOrder write SetSQLOrder;
    property OnSearchClick: TNotifyEvent read GetOnSearchClick write SetOnSearchClick;
  end;

implementation

uses ApConst;

{$R *.dfm}

function TFraSearch.AddParam(const ACode, AName, Default: String): TField;
begin
  Result := AddParam(ACode, AName, '', 0, '');
end;

function TFraSearch.AddParam(const ACode, AName, Default: String;
  AType: Integer; const AWindow: String): TField;
begin
  with cdsSearch do
  begin
    if not Active then CreateDataSet;
    Tag := 1;
    try
      if not cdsSearch.Locate('Code_;Name_',VarArrayOf([ACode,AName]),[]) then
      begin
        Append;
        FieldByName('Check_').AsInteger := AType;
        FieldByName('Code_').AsString := ACode;
        FieldByName('Name_').AsString := AName;
        FieldByName('Value_').AsString := Default;
        FieldByName('Window_').AsString := AWindow;
        Post;
      end;
      Result := FieldByName('Optior');
    finally
      Tag := 0;
    end;
  end;
  //390
end;

procedure TFraSearch.cdsSearchBeforeInsert(DataSet: TDataSet);
begin
  if DataSet.Tag = 0 then Abort;
end;

procedure TFraSearch.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if cdsSearch.FieldByName('Check_').AsInteger = 0 then
  begin
    DBGrid1.Canvas.Brush.Color := clBtnFace;
    DBGrid1.Canvas.Font.Color := clGray;
  end;
  if (Column.FieldName = 'Name_') and
    (cdsSearch.FieldByName('Window_').AsString <> '') then
  begin
    DBGrid1.Canvas.Font.Color := clBlue;
  end;
  with DBGrid1 do
  begin
    if gdFocused in State then
    begin
      Canvas.Font.Color := clWhite;
      Canvas.Brush.Color := clHighlight;
    end;
    DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;


procedure TFraSearch.DBGrid1CellClick(Column: TColumn);
var
  RetDate: TDateTime;
begin
  if not cdsSearch.Active then Exit;
  with cdsSearch do
  begin
    if (Column.Field = FieldByName('Check_')) then
      begin
        Edit;
        case FieldByName('Check_').AsInteger of
        0: FieldByName('Check_').AsInteger := 1;
        1: FieldByName('Check_').AsInteger := 0;
        end;
        Post;
      end
    else if (Column.Field = FieldByName('Name_'))
      and (FieldByName('Window_').AsString <> '') then
      begin
        if FieldByName('Window_').AsString = 'PartCode' then
          begin
            SelectCode1.Kind := 1;
            SelectDisplay('TSelPart', SelectCode1, EMPTY_VARIANT);
          end
        else if FieldByName('Window_').AsString = 'MakeNo' then
          begin
            SelectCode1.Kind := 2;
            SelectDisplay('TSelMakeMX', SelectCode1, EMPTY_VARIANT);
          end
        else if FieldByName('Window_').AsString = 'CorpCode' then
          begin
            if SelCorp([cdsSearch.FieldByName('Value_')],0) then
            begin
              Edit;
              if FieldByName('Check_').AsInteger = 0 then
                FieldByName('Check_').AsInteger := 1;
              Post;
            end;
          end
        else if FieldByName('Window_').AsString = 'CusCode' then
          begin
            if SelCorp([cdsSearch.FieldByName('Value_')],1) then
            begin
              Edit;
              if FieldByName('Check_').AsInteger = 0 then
                FieldByName('Check_').AsInteger := 1;
              Post;
            end;
          end
        else if FieldByName('Window_').AsString = 'SupCode' then
          begin
            if SelCorp([cdsSearch.FieldByName('Value_')],2) then
            begin
              Edit;
              if FieldByName('Check_').AsInteger = 0 then
                FieldByName('Check_').AsInteger := 1;
              Post;
            end;
          end
        else if FieldByName('Window_').AsString = 'WHCode' then
          begin
            if SelWHCode([cdsSearch.FieldByName('Value_')]) then
            begin
              Edit;
              if FieldByName('Check_').AsInteger = 0 then
                FieldByName('Check_').AsInteger := 1;
              Post;
            end;
          end
        else if FieldByName('Window_').AsString = 'YYYYMM' then
          begin
            RetDate := GetSelectDate;
            Edit;
            FieldByName('Value_').AsString := FormatDatetime('YYYYMM', RetDate);
            if FieldByName('Check_').AsInteger = 0 then
              FieldByName('Check_').AsInteger := 1;
            Post;
          end
        else if FieldByName('Window_').AsString = 'Date' then
          SelTBDate(cdsSearch.FieldByName('Value_'))
        else if FieldByName('Window_').AsString = 'DeptCode' then
          begin
            if SelDeptCode([cdsSearch.FieldByName('Value_')]) then
            begin
              Edit;
              if FieldByName('Check_').AsInteger = 0 then
                FieldByName('Check_').AsInteger := 1;
              Post;
            end;
          end;
      end;
  end;
end;

procedure TFraSearch.SelectCode1Selected(K: Integer; V: TErpPack);
begin
  with cdsSearch do
  begin
    Edit;
    case K of
    1:  FieldByName('Value_').AsString := VarToStr(V[1]);
    2:  FieldByName('Value_').AsString := VarToStr(V[0]);
    end;
    if FieldByName('Check_').AsInteger = 0 then
      FieldByName('Check_').AsInteger := 1;
    Post;
  end;
end;

procedure TFraSearch.cdsSearchCheck_GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  case Sender.AsInteger of
  -1: Text := 'H';
  0 : Text := '';
  1 : Text := 'X';
  2 : Text := 'Y';
  end;
end;

procedure TFraSearch.SpeedButton1Click(Sender: TObject);
begin
  Self.Visible := False;
end;

procedure TFraSearch.cdsSearchAfterScroll(DataSet: TDataSet);
var
  s1: String;
begin
  FindColumn(DBGrid1, 'Value_').PickList.Clear;
  s1 := DataSet.FieldByName('Window_').AsString;
  if Pos('SET=',UpperCase(s1)) > 0 then
    FindColumn(DBGrid1, 'Value_').PickList.Text := Copy(s1, 5, Length(s1));
end;

procedure TFraSearch.btnFindClick(Sender: TObject);
var
  F: TCreateSQLWhere;
begin
  if not Assigned(FOnSearchClick) then
    begin
      F := TCreateSQLWhere.Create;
      try
        F.DataSet := Self.DataSet;
        F.DefaultText := FDefaultText;
        if F.Execute(cdsSearch, FSQLTemplate, FSQLOrder) then
        begin
          if chkSearchWindowMax.Checked then
          begin
            if Self.Owner is TForm then
              TForm(Self.Owner).WindowState := wsMaximized;
            SendMessage(Application.MainForm.Handle, WM_USER + 3, 1, 0);
          end;
          if chkSearchClose.Checked then
          begin
            Self.Visible := False;
          end;
        end;
      finally
        FreeAndNil(F);
      end;
    end
  else
    FOnSearchClick(Self);
end;

procedure TFraSearch.chkSearchWindowMaxClick(Sender: TObject);
begin
  if chkSearchWindowMax.Checked then
    begin
      if Self.Owner is TForm then
        TForm(Self.Owner).WindowState := wsMaximized;
      SendMessage(Application.MainForm.Handle, WM_USER + 3, 1, 0);
    end
  else
    begin
      SendMessage(Application.MainForm.Handle, WM_USER + 3, 0, 0);
      if Self.Owner is TForm then
        TForm(Self.Owner).WindowState := wsNormal;
    end;
end;

constructor TFraSearch.Create(AOwner: TComponent);
var
  xmlPath: String;
  i: Integer;
  Root, Attr, Child: IXMLNode;
begin
  inherited;
  xmlPath := ExtractFilePath(Application.ExeName) + 'Options';
  if not DirectoryExists(xmlPath) then Exit;
  if not FileExists(Format('%s\%s.xml',[xmlPath,Self.Owner.Name])) then Exit;
  xml.LoadFromFile(Format('%s\%s.xml',[xmlPath,Self.Owner.Name]));
  if xml.IsEmptyDoc then Exit;
  Root := xml.DocumentElement;
  for i := 0 to Root.AttributeNodes.Count - 1 do
  begin
    Attr := Root.AttributeNodes.Get(i);
    if Attr.NodeName = 'AutoClose' then
      chkSearchClose.Checked := Attr.Text = 'True'
    else if Attr.NodeName = 'WindowState' then
      begin
        chkSearchWindowMax.OnClick := nil;
        chkSearchWindowMax.Checked := Attr.Text = 'True';
        chkSearchWindowMax.OnClick := chkSearchWindowMaxClick;
      end;
  end;
  Child := Root.ChildNodes.First;
  while Child <> nil do
  begin
    if Child.NodeName = 'Filter' then
      LoadFilterGrid(Child);
    Child := Child.NextSibling;
  end;
end;

procedure TFraSearch.Init(const MaxRecord: Integer);
var
  sl: TList;
  i: Integer;
  box: TPanel;
  MainBox: TForm;
  Root, Child: IXMLNode;
begin
  inherited;
  if MaxRecord > 0 then
    AddParam('@MaxRecord',Chinese.AsString('载入笔数'),IntToStr(MaxRecord),1,'');
  if not (Self.Owner is TForm) then Exit;
  MainBox := TForm(Self.Owner);
  sl := TList.Create;
  try
    for i := 0 to MainBox.ControlCount - 1 do sl.Add(MainBox.Controls[i]);
    Parent := MainBox;
    Align := alLeft;
    Visible := True;
    if sl.Count > 1 then
    begin
      box := TPanel.Create(MainBox);
      box.BevelOuter := bvNone;
      box.Parent := MainBox;
      box.Align := alClient;
      for i := 0 to sl.Count - 1 do
        TControl(sl.Items[i]).Parent := box;
    end;
  finally
    FreeAndNil(sl);
  end;
  //
  Root := OpenXMLFile;
  Child := Root.ChildNodes.First;
  while Child <> nil do
  begin
    if Child.NodeName = 'ViewGrid' then
      LoadViewGrid(Child)
    else if Child.NodeName = 'Command' then
      SQLTemplate := Child.Text
    else if Child.NodeName = 'Where' then
      DefaultText := Child.Text
    else if Child.NodeName = 'Order' then
      SQLOrder := Child.Text;
    Child := Child.NextSibling;
  end;
  //
  Visible := True;
end;

destructor TFraSearch.Destroy;
var
  i: Integer;
  Root, Grid, Farther, Child: IXMLNode;
begin
  Root := OpenXMLFile();
  try
    Root.Attributes['AutoClose'] := chkSearchClose.Checked;
    Root.Attributes['WindowState'] := chkSearchWindowMax.Checked;
    DeleteNode(Root, 'Filter');
    DeleteNode(Root, 'Command');
    DeleteNode(Root, 'Where');
    DeleteNode(Root, 'Order');
    //
    if chkSearchSaveOption.Checked then
    begin
      //
      with cdsSearch do
      begin
        Grid := Root.AddChild('Filter');
        First;
        while not Eof do
        begin
          Farther := Grid.AddChild(Format('R%d',[RecNo]));
          for i := 0 to Fields.Count - 1 do
          begin
            Child := Farther.AddChild(Fields[i].FullName);
            Child.Text := Fields[i].AsString;
          end;
          Next;
        end;
      end;
      //
      Root.AddChild('Command').Text := SQLTemplate;
      Root.AddChild('Where').Text := DefaultText;
      Root.AddChild('Order').Text := SQLOrder;
    end;
    //
    xml.SaveToFile(xml.FileName);
  finally
    xml.Active := False;
  end;
  inherited;
end;

function TFraSearch.OpenXMLFile: IXMLNode;
var
  Root: IXMLNode;
  xmlPath: String;
begin
  xmlPath := ExtractFilePath(Application.ExeName) + 'Options';
  if not DirectoryExists(xmlPath) then
    if not CreateDir(xmlPath) then
    raise Exception.CreateFmt('Cannot create %s', [xmlPath]);
  xml.Active := True;
  Root := xml.DocumentElement;
  if Root = nil then
    Root := xml.AddChild(Self.Owner.Name);
  if xml.FileName = '' then
  begin
    Root.Attributes['CreateDate'] := Now();
    xml.FileName := Format('%s\%s.xml',[xmlPath,Self.Owner.Name]);
  end;
  Result := Root;
end;

procedure TFraSearch.DeleteNode(Root: IXMLNode; Index: String);
var
  i: Integer;
begin
  for i := Root.ChildNodes.Count - 1 downto 0 do
  begin
    if UpperCase(Root.ChildNodes.Get(i).NodeName) = UpperCase(Index) then
      Root.ChildNodes.Delete(i);
  end;
end;

procedure TFraSearch.PopupMenu1Popup(Sender: TObject);
begin
  N1.Visible := Assigned(ViewGrid);
  if not chkSearchSaveOption.Checked then Abort;
end;

procedure TFraSearch.N1Click(Sender: TObject);
var
  i: Integer;
  Column: TColumn;
  Field: TField;
  Root, Grid, Farther, Child: IXMLNode;
begin
  Root := OpenXMLFile;
  DeleteNode(Root, 'ViewGrid');
  Grid := Root.AddChild('ViewGrid');
  Grid.Attributes['Name'] := ViewGrid.Name;
  with ViewGrid do
  for i := 0 to Columns.Count - 1 do
  begin
    Column := Columns[i];
    Farther := Grid.AddChild(Format('C%d',[i+1]));
    Farther.Attributes['Field'] := Column.FieldName;
    Farther.AddChild('Width').Text := IntToStr(Column.Width);
    Farther.AddChild('Visible').Text := iif(Column.Visible, 'True', 'False');
    Field := Column.Field;
    if Assigned(Field) and (Field is TFloatField) then
      Farther.AddChild('Format').Text := TFloatField(Field).DisplayFormat;
    Child := Farther.AddChild('Title');
    Child.AddChild('Caption').Text := Column.Title.Caption;
  end;
end;

procedure TFraSearch.LoadFilterGrid(Root: IXMLNode);
var
  i: Integer;
  Rec, Node: IXMLNode;
begin
  Rec := Root.ChildNodes.First;
  if Rec = nil then Exit;
  chkSearchSaveOption.Checked := True;
  with cdsSearch do
  try
    if not Active then CreateDataSet;
    Tag := 1;
    while Rec <> nil do
    begin
      try
        Append;
        for i := 0 to Rec.ChildNodes.Count - 1 do
        begin
          Node := Rec.ChildNodes.Get(i);
          if Node.NodeName <> Fields[i].FullName then
          begin
            chkSearchSaveOption.Checked := False;
            Break;
          end;
          Fields[i].AsString := Node.Text;
        end;
        Post;
      except
        on E: Exception do MsgBox(E.Message);
      end;
      Rec := Rec.NextSibling;
    end;
  finally
    Tag := 0;
  end;
end;

procedure TFraSearch.LoadViewGrid(Root: IXMLNode);
var
  Field: TField;
  Column: TColumn;
  Rec, Attr, Node, Title: IXMLNode;
begin
  if not Assigned(ViewGrid) then Exit;
  Rec := Root.ChildNodes.First;
  while Rec <> nil do
  begin
    Attr := Rec.AttributeNodes['Field'];
    if (Attr <> nil) and (Attr.Text <> '') then
    begin
      with ViewGrid do
      begin
        Column := FindColumn(ViewGrid, Attr.Text);
        if Assigned(Column) then
        begin
          Node := Rec.ChildNodes.First;
          while Node <> nil do
          begin
            if UpperCase(Node.NodeName) = UpperCase('Width') then
              Column.Width := StrToIntDef(Node.Text, Column.Width)
            else if UpperCase(Node.NodeName) = UpperCase('Visible') then
              Column.Visible := Node.Text <> 'False'
            else if UpperCase(Node.NodeName) = UpperCase('Format') then
              begin
                Field := Column.Field;
                if Assigned(Field) and (Field is TFloatField) then
                  TFloatField(Field).DisplayFormat := Node.Text;
              end
            else if UpperCase(Node.NodeName) = UpperCase('Title') then
              begin
                Title := Node.ChildNodes.First;
                while Title <> nil do
                begin
                  if UpperCase(Title.NodeName) = UpperCase('Caption') then
                    Column.Title.Caption := Title.Text;
                  Title := Title.NextSibling;
                end;
              end;
            Node := Node.NextSibling;
          end;
        end;
      end;
    end;
    Rec := Rec.NextSibling;
  end;
end;

function TFraSearch.GetDataSet: TZjhDataSet;
begin
  Result := FDataSet;
end;

function TFraSearch.GetDefaultText: String;
begin
  Result := FDefaultText;
end;

function TFraSearch.GetOnSearchClick: TNotifyEvent;
begin
  Result := FOnSearchClick;
end;

function TFraSearch.GetSQLOrder: String;
begin
  Result := FSQLOrder;
end;

function TFraSearch.GetSQLTemplate: String;
begin
  Result := FSQLTemplate;
end;

function TFraSearch.GetViewGrid: TDBGrid;
begin
  Result := FViewGrid;
end;

procedure TFraSearch.SetDataSet(const Value: TZjhDataSet);
begin
  FDataSet := Value;
end;

procedure TFraSearch.SetDefaultText(const Value: String);
begin
  FDefaultText := Value;
end;

procedure TFraSearch.SetOnSearchClick(const Value: TNotifyEvent);
begin
  FOnSearchClick := Value;
end;

procedure TFraSearch.SetSQLOrder(const Value: String);
begin
  FSQLOrder := Value;
end;

procedure TFraSearch.SetSQLTemplate(const Value: String);
begin
  FSQLTemplate := Value;
end;

procedure TFraSearch.SetViewGrid(const Value: TDBGrid);
begin
  FViewGrid := Value;
end;

function TFraSearch.GetActive: Boolean;
begin
  Result := Visible;
end;

procedure TFraSearch.SetActive(const Value: Boolean);
begin
  Visible := Value;
end;

initialization
  RegClass(TFraSearch);

finalization
  UnRegClass(TFraSearch);

end.
