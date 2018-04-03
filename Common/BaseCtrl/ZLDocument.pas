unit ZLDocument;

interface

uses
  Forms, Classes, Controls, SysUtils, Types, StdCtrls, ExtCtrls, Graphics, Menus,
  Buttons, DBCtrls, XmlIntf, XmlDoc, ZjhCtrls, ApConst, Variants;

type
  TZLSpan = class(TPanel)
  private
    FKeystone: Boolean;
    FFirstLeft: Integer;
    FFirstTop: Integer;
    FDisplayIndex: Integer;
    FRemark: String;
    procedure SetKeystone(const Value: Boolean);
    procedure SetFirstLeft(const Value: Integer);
    procedure SetFirstTop(const Value: Integer);
    procedure SetDisplayIndex(const Value: Integer);
    procedure SetRemark(const Value: String);
    function GetRemark: String;
  public
    constructor Create(AOwner: TComponent); override;
    property FirstLeft: Integer read FFirstLeft write SetFirstLeft;
    property FirstTop: Integer read FFirstTop write SetFirstTop;
    property DisplayIndex: Integer read FDisplayIndex write SetDisplayIndex;
    property Remark: String read GetRemark write SetRemark;
    property Keystone: Boolean read FKeystone write SetKeystone;
    property Canvas;
    property Color;
  end;
  TZLDocument = class(TPanel)
  private
    _Width: Integer;
    _Height: Integer;
    FStyle: Integer;
    _Menu: TPopupMenu;
    _RecNo: Integer;
    _NameIndex: Integer;
    _LoadOptions: Boolean;
    FSpanHeight: Integer;
    FSpanWidth: Integer;
    FKeystoneColor: TColor;
    ScrollBar1: TScrollBar;
    FMinWidth: Integer;
    FActive: Boolean;
    procedure SetStyle(const Value: Integer);
    procedure OptionsClick(Sender: TObject);
    procedure SetSpanHeight(const Value: Integer);
    procedure SetSpanWidth(const Value: Integer);
    procedure SetKeystoneColor(const Value: TColor);
    function GetXMLNode(Root: IXMLNode; const Key: String): IXMLNode;
    procedure ScrollBar1Change(Sender: TObject);
    procedure SetMinWidth(const Value: Integer);
    procedure ResetByColumn;
    procedure ResetByRow;
    procedure SetActive(const Value: Boolean);
  public
    procedure UpdatePanel;
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function addItem(const args: array of TControl): TZLSpan;
    procedure LoadOptions;
    procedure SetOptions;
    procedure SaveOptions;
    procedure ResetOptions;
    //
    procedure Reset;
    function Current: TZLSpan;
    function MoveNext: Boolean;
  published
    property Style: Integer read FStyle write SetStyle;
    property SpanWidth: Integer read FSpanWidth write SetSpanWidth;
    property SpanHeight: Integer read FSpanHeight write SetSpanHeight;
    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property KeystoneColor: TColor read FKeystoneColor write SetKeystoneColor;
    property Active: Boolean read FActive write SetActive;
  end;

procedure Register;

implementation

uses ZLDocumentDlg;

procedure Register;
begin
  RegisterComponents(SOFTWARE_NAME, [TZLDocument]);
  RegisterComponents(SOFTWARE_NAME, [TZLSpan]);
end;

{ TZLDocument }

function TZLDocument.addItem(const args: array of TControl): TZLSpan;
var
  i: Integer;
  Span: TZLSpan;
  obj: TControl;
  minLeft, maxRight, minTop, maxBottom: Integer;
begin
  Inc(_NameIndex);
  Span := TZLSpan.Create(Self);
  Span.Name := 'Span' + IntToStr(_NameIndex);
  Span.Caption := '';
  Span.Parent := Self;
  Span.Visible := True;
  //
  minLeft := 0;
  maxRight := 0;
  minTop := 0;
  maxBottom := 0;
  for i := Low(args) to High(args) do
  begin
    obj := args[i];
    if i = 0 then
    begin
      minLeft := obj.Left;
      minTop := obj.Top;
    end;
    if obj.Left < minLeft then
      minLeft := obj.Left;
    if obj.Top < minTop then
      minTop := obj.Top;
    if obj.Left + obj.Width > maxRight then
      maxRight := obj.Left + obj.Width;
    if obj.Top + obj.Height > maxBottom then
      maxBottom := obj.Top + obj.Height;
    obj.Parent := Span;
  end;
  for i := Low(args) to High(args) do
  begin
    obj := args[i];
    obj.Left := obj.Left - minLeft + 4;
    obj.Top := obj.Top - minTop + 2;
  end;
  Span.Top    := minTop;
  Span.Left   := minLeft;
  Span.Width  := maxRight - minLeft + 8;
  Span.Height := maxBottom - minTop + 4;
  if Span.Width < MinWidth then
    Span.Width := MinWidth;
  _LoadOptions := False;
  Result := Span;
end;

constructor TZLDocument.Create(AOwner: TComponent);
var
  item: TMenuItem;
begin
  inherited;
  _Width := 0;
  _Height := 0;
  _NameIndex := 0;
  _Menu := TPopupMenu.Create(Self);
  if not (csDesigning in ComponentState) then
    Self.PopupMenu := _Menu;
  //
  item := TMenuItem.Create(Self);
  item.Caption := '&Options...';
  item.OnClick := Self.OptionsClick;
  _Menu.Items.Add(item);

  ScrollBar1 := TScrollBar.Create(Self);
  ScrollBar1.OnChange := ScrollBar1Change;
  ScrollBar1.LargeChange := 8;
  FActive := False;
  //
  FKeystoneColor := clMedGray;
  FSpanHeight := 0;
  FSpanWidth := 0;
  FStyle := 0;
  Caption := '';
end;

destructor TZLDocument.Destroy;
begin
  _Menu.Free;
  ScrollBar1.Free;
  inherited;
end;

procedure TZLDocument.OptionsClick(Sender: TObject);
begin
  SetOptions;
end;

procedure TZLDocument.SetOptions;
var
  savParent: TWinControl;
  Child: TDlgZLDocument;
begin
  savParent := Self.Parent;
  Child := TDlgZLDocument.Create(Self);
  try
    Child.ShowModal();
    Self.UpdatePanel;
  finally
    Self.Parent := savParent;
    Child.Free;
  end;
end;

procedure TZLDocument.Paint;
begin
  inherited;
  if (_Width <> Self.Width) or (_Height <> Self.Height) then
  begin
    _Width := Self.Width;
    _Height := Self.Height;
    UpdatePanel;
  end;
end;

procedure TZLDocument.UpdatePanel;
var
  i: Integer;
  Span: TZLSpan;
begin
  if csDesigning in ComponentState then
    Exit;
  for i := Self.ControlCount - 1 downto 0 do
  begin
    if not (Self.Controls[i] is TScrollBar) then
    begin
      if Self.Controls[i] is TZLSpan then
        begin
          Span := TZLSpan(Controls[i]);
          Span.BevelOuter := bvNone;
          Span.BevelInner := bvNone;
          if Span.Keystone then
            Span.Color := FKeystoneColor;
        end
      else
        addItem([Self.Controls[i]]);
    end;
  end;
  //
  if Self.ControlCount > 1 then
  if not _LoadOptions then
  begin
    _LoadOptions := True;
    LoadOptions;
  end;
  if not Active then
    Exit;
  //
  if FStyle = 0 then
    ResetByColumn
  else
    ResetByRow;
end;

procedure TZLDocument.ResetByColumn;
var
  w, h: Integer;
  maxW: Integer;
  iTop, maxWidth, iLeft: Integer;
begin
  iTop := 4;
  iLeft := 8;
  maxWidth := 0;
  maxW := 0;
  //
  Reset;
  while MoveNext() do
  begin
    if Current.Visible then
    begin
      w := Current.Width;
      h := Current.Height;
      if (iTop + h + SpanHeight + 18) > Self.Height then
      begin
        iLeft := iLeft + maxWidth + SpanWidth;
        maxWidth := 0;
        iTop := 4;
      end;
      iTop := iTop + SpanHeight;
      Current.FirstTop := iTop;
      Current.FirstLeft := iLeft + SpanWidth;
      if w > maxWidth then
        maxWidth := w;
      iTop := iTop + h;
      if (Current.Left + Current.Width) > maxW then
        maxW := Current.Left + Current.Width;
    end;
  end;
  //
  if maxW > Width then
    begin
      Self.ScrollBar1.Parent := Self;
      Self.ScrollBar1.Kind := sbHorizontal;
      Self.ScrollBar1.Visible := True;
      Self.ScrollBar1.Align := alBottom;
      Self.ScrollBar1.Height := 17;
      Self.ScrollBar1.Max := maxW - Width + 4;
      Self.ScrollBar1.Position := 0;
    end
  else
    begin
      Self.ScrollBar1.Visible := False;
      Self.ScrollBar1.Parent := nil;
    end;
end;

procedure TZLDocument.ResetByRow;
var
  w, h: Integer;
  maxH: Integer;
  iTop, iLeft, maxHeight: Integer;
begin
  iTop := 4;
  iLeft := 8;
  maxHeight := 0;
  maxH := 0;
  Reset;
  while MoveNext() do
  begin
    if Current.Visible then
    begin
      w := Current.Width;
      h := Current.Height;
      if (iLeft + w + SpanWidth + 18) > Self.Width then
      begin
        iTop := iTop + maxHeight + SpanHeight;
        maxHeight := 0;
        iLeft := 8;
      end;
      iLeft := iLeft + SpanWidth;
      Current.FirstLeft := iLeft;
      Current.FirstTop := iTop + SpanHeight;
      if h > maxHeight then
        maxHeight := h;
      iLeft := iLeft + w;
      if (Current.Top + Current.Height) > maxH then
        maxH := Current.Top + Current.Height;
    end;
  end;
  //
  if maxH > Height then
    begin
      Self.ScrollBar1.Parent := Self;
      Self.ScrollBar1.Kind := sbVertical;
      Self.ScrollBar1.Visible := True;
      Self.ScrollBar1.Align := alRight;
      Self.ScrollBar1.Width := 17;
      Self.ScrollBar1.Max := maxH - Height + 4;
      Self.ScrollBar1.Position := 0;
    end
  else
    begin
      Self.ScrollBar1.Visible := False;
      Self.ScrollBar1.Parent := nil;
    end;
end;

procedure TZLDocument.SetStyle(const Value: Integer);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    FActive := True;
    Self.UpdatePanel;
  end;
end;

function TZLDocument.Current: TZLSpan;
begin
  Result := Controls[_RecNo] as TZLSpan;
end;

function TZLDocument.MoveNext: Boolean;
begin
  Inc(_RecNo);
  while _RecNo < ControlCount do
  begin
     if (Controls[_RecNo] is TZLSpan) then
       Break;
    Inc(_RecNo);
  end;
  Result := _RecNo < ControlCount;
end;

procedure TZLDocument.Reset;
begin
  _RecNo := -1;
end;

procedure TZLDocument.SetSpanHeight(const Value: Integer);
begin
  FSpanHeight := Value;
end;

procedure TZLDocument.SetSpanWidth(const Value: Integer);
begin
  FSpanWidth := Value;
end;

procedure TZLDocument.SetKeystoneColor(const Value: TColor);
begin
  FKeystoneColor := Value;
end;

procedure TZLDocument.SaveOptions;
var
  i: Integer;
  xml: TXMLDocument;
  Root, Child, Node: IXMLNode;
begin
  if csDesigning in ComponentState then
    Exit;
  xml := OpenConfigFile(Self.Owner.Name, Root);
  try
    Child := GetXMLNode(Root, Self.Name);
    Child.Attributes['Style'] := Self.Style;
    i := 0;
    Reset;
    while MoveNext() do
    begin
      Node := GetXMLNode(Child, Current.Name);
      Node.Attributes['Visible'] := Current.Visible;
      Node.Attributes['Index'] := i;
      Inc(i);
    end;
    xml.SaveToFile;
  finally
    FreeAndNil(xml);
  end;
end;

procedure TZLDocument.LoadOptions;
var
  i: Integer;
  Site: String;
  sl: TStringList;
  xml: TXMLDocument;
  Root, Child, Node: IXMLNode;
  Span: TZLSpan;
begin
  if csDesigning in ComponentState then
    Exit;
  xml := OpenConfigFile(Self.Owner.Name, Root);
  sl := TStringList.Create;
  try
    i := 0;
    Reset;
    while MoveNext() do
    begin
      Site := '000000' + IntToStr(i);
      sl.AddObject(Copy(Site, Length(Site) - 5, 6), Current);
      Inc(i);
    end;
    //
    Child := GetXMLNode(Root, Self.Name);
    if Child.HasAttribute('Style') then
      Self.Style := Child.Attributes['Style'];
    Node := Child.ChildNodes.First;
    while Assigned(Node) do
    begin
      Reset;
      for i := 0 to sl.Count - 1 do
      begin
        Span := sl.Objects[i] as TZLSpan;
        if Node.NodeName = Span.Name then
        begin
          Span.Visible := Node.Attributes['Visible'];
          Site := '000000' + VarToStr(Node.Attributes['Index']);
          sl.Strings[i] := Copy(Site, Length(Site) - 5, 6);
          FActive := True;
          Break;
        end;
      end;
      Node := Node.NextSibling;
    end;
    //
    for i := 0 to sl.Count - 1 do
      (sl.Objects[i] as TZLSpan).Parent := nil;
    sl.Sort;
    for i := 0 to sl.Count - 1 do
      (sl.Objects[i] as TZLSpan).Parent := Self;
  finally
    sl.Free;
    FreeAndNil(xml);
  end;
end;

procedure TZLDocument.ScrollBar1Change(Sender: TObject);
begin
  Reset;
  while MoveNext() do
  begin
    if Self.ScrollBar1.Kind = sbHorizontal then //¿í¶È²»×ã
      Current.Left := Current.FirstLeft - ScrollBar1.Position
    else
      Current.Top := Current.FirstTop - ScrollBar1.Position
  end;
end;

function TZLDocument.GetXMLNode(Root: IXMLNode;
  const Key: String): IXMLNode;
begin
  Result := Root.ChildNodes.FindNode(Key);
  if not Assigned(Result) then
    Result := Root.AddChild(Key);
end;

procedure TZLDocument.ResetOptions;
var
  i: Integer;
  xml: TXMLDocument;
  Root, Child, Node: IXMLNode;
begin
  if csDesigning in ComponentState then
    Exit;
  //»Ö¸´´ÎÐò
  xml := OpenConfigFile(Self.Owner.Name, Root);
  try
    i := 0;
    Child := GetXMLNode(Root, Self.Name);
    Node := Child.ChildNodes.First;
    while Assigned(Node) do
    begin
      Node.Attributes['Visible'] := 'True';
      Node.Attributes['Index'] := i;
      Inc(i);
      Node := Node.NextSibling;
    end;
    xml.SaveToFile;
  finally
    FreeAndNil(xml);
  end;
  LoadOptions;
  UpdatePanel;
  //É¾³ýÉèÖÃ
  xml := OpenConfigFile(Self.Owner.Name, Root);
  try
    for i := Root.ChildNodes.Count - 1 downto 0 do
    begin
      if Root.ChildNodes.Get(i).NodeName = Self.Name then
        Root.ChildNodes.Delete(i);
    end;
    xml.SaveToFile;
  finally
    FreeAndNil(xml);
  end;
end;

procedure TZLDocument.SetMinWidth(const Value: Integer);
begin
  FMinWidth := Value;
end;

procedure TZLDocument.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

{ TZLSpan }

constructor TZLSpan.Create(AOwner: TComponent);
begin
  inherited;
  if csDesigning in ComponentState then
    begin
      Self.BevelInner := bvLowered;
      Self.BevelOuter := bvNone;
    end
  else
    begin
      Self.BevelInner := bvNone;
      Self.BevelOuter := bvNone;
    end;
end;

function TZLSpan.GetRemark: String;
var
  obj: TControl;
begin
  if FRemark = '' then
    begin
      if Self.ControlCount > 0 then
        begin
          obj := Self.Controls[0];
          if obj is TCustomLabel then
            Result := TCustomLabel(obj).Caption
          else if obj is TButton then
            Result := TButton(obj).Caption
          else if obj is TSpeedButton then
            Result := TSpeedButton(obj).Caption
          else if obj is TCheckBox then
            Result := TCheckBox(obj).Caption
          else if obj is TDBCheckBox then
            Result := TDBCheckBox(obj).Caption
          else if obj is TZjhDateRange then
            Result := TZjhDateRange(obj).Caption
          else
            Result := obj.ClassName;
        end
      else
        Result := '(NULL)'
    end
  else
    Result := FRemark;
end;

procedure TZLSpan.SetDisplayIndex(const Value: Integer);
begin
  FDisplayIndex := Value;
end;

procedure TZLSpan.SetFirstLeft(const Value: Integer);
begin
  FFirstLeft := Value;
  Left := Value;
end;

procedure TZLSpan.SetFirstTop(const Value: Integer);
begin
  FFirstTop := Value;
  Top := Value;
end;

procedure TZLSpan.SetKeystone(const Value: Boolean);
begin
  FKeystone := Value;
end;

procedure TZLSpan.SetRemark(const Value: String);
begin
  FRemark := Value;
end;

end.
