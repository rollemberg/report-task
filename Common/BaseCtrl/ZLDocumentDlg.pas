unit ZLDocumentDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ZLDocument, ApConst;

type
  TDlgZLDocument = class(TForm)
    btnUP: TButton;
    btnDown: TButton;
    btnHide: TButton;
    btnSave: TButton;
    btnClose: TButton;
    rbColumn: TRadioButton;
    ListBox1: TListBox;
    rbRow: TRadioButton;
    Label1: TLabel;
    btnReset: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure btnUPClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure rbColumnClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
  private
    { Private declarations }
    box: TZLDocument;
    procedure UpdateDocument;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TDlgZLDocument.FormCreate(Sender: TObject);
var
  str: String;
begin
  box := Self.Owner as TZLDocument;
  box.Reset;
  while box.MoveNext do
  begin
    if box.Current.Visible then
      str := ''
    else
      str := '-----';
    ListBox1.AddItem(Format('%s%s: %s', [str, box.Current.Name, box.Current.Remark]),
      box.Current);
  end;
  rbColumn.OnClick := nil;
  rbRow.OnClick := nil;
  rbColumn.Checked := box.Style = 0;
  rbRow.Checked := box.Style = 1;
  rbColumn.OnClick := rbColumnClick;
  rbRow.OnClick := rbColumnClick;
end;

procedure TDlgZLDocument.FormDestroy(Sender: TObject);
begin
  box.Reset;
  while box.MoveNext do
  begin
    if box.Current.Keystone then
      box.Current.Color := box.KeystoneColor
    else
      box.Current.Color := clBtnFace;
  end;
end;

procedure TDlgZLDocument.ListBox1Click(Sender: TObject);
var
  i: Integer;
  obj: TZLSpan;
begin
  if ListBox1.ItemIndex > -1 then
  begin
    for i := 0 to ListBox1.Items.Count - 1 do
    begin
      obj := ListBox1.Items.Objects[i] as TZLSpan;
      if ListBox1.ItemIndex = i then
        obj.Color := clRed
      else if obj.Keystone then
        obj.Color := box.KeystoneColor
      else
        obj.Color := clBtnFace;
    end;
    //
    i := ListBox1.ItemIndex;
    obj := ListBox1.Items.Objects[i] as TZLSpan;
    btnHide.Caption := iif(obj.Visible, '&Hide', '&Show');
  end;
end;

procedure TDlgZLDocument.btnUPClick(Sender: TObject);
var
  obj: TObject;
  str: String;
  i: Integer;
begin
  i := ListBox1.ItemIndex;
  if i < 1 then Exit;
  obj := ListBox1.Items.Objects[i];
  str := ListBox1.Items.Strings[i];
  ListBox1.Items.Delete(i);
  ListBox1.Items.InsertObject(i - 1, str, obj);
  ListBox1.ItemIndex := i - 1;
  UpdateDocument;
end;

procedure TDlgZLDocument.btnDownClick(Sender: TObject);
var
  obj: TObject;
  str: String;
  i: Integer;
begin
  i := ListBox1.ItemIndex;
  if i = -1 then Exit;
  if i = ListBox1.Items.Count - 1 then Exit;
  obj := ListBox1.Items.Objects[i];
  str := ListBox1.Items.Strings[i];
  ListBox1.Items.Delete(i);
  ListBox1.Items.InsertObject(i + 1, str, obj);
  ListBox1.ItemIndex := i + 1;
  UpdateDocument;
end;

procedure TDlgZLDocument.UpdateDocument;
var
  i: Integer;
begin
  box.Active := True;
  for i :=  0 to ListBox1.Items.Count - 1 do
    (ListBox1.Items.Objects[i] as TZLSpan).Parent := nil;
  for i :=  0 to ListBox1.Items.Count - 1 do
    (ListBox1.Items.Objects[i] as TZLSpan).Parent := box;
  box.UpdatePanel;
end;

procedure TDlgZLDocument.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDlgZLDocument.btnHideClick(Sender: TObject);
var
  obj: TZLSpan;
  i: Integer;
  str: String;
begin
  i := ListBox1.ItemIndex;
  if i = -1 then Exit;
  obj := ListBox1.Items.Objects[i] as TZLSpan;
  if obj.Visible then
    begin
      obj.Visible := False;
      str := ListBox1.Items.Strings[i];
      str := '-----' + str;
      ListBox1.Items.Strings[i] := str;
    end
  else
    begin
      obj.Visible := True;
      str := ListBox1.Items.Strings[i];
      str := Copy(str, 6, Length(str));
      ListBox1.Items.Strings[i] := str;
    end;
  box.Active := True;
  btnHide.Caption := iif(obj.Visible, '&Hide', '&Show');
  box.UpdatePanel;
end;

procedure TDlgZLDocument.ListBox1DblClick(Sender: TObject);
begin
  btnHide.Click;
end;

procedure TDlgZLDocument.ListBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if (Source = ListBox1) then Accept := True;
end;

procedure TDlgZLDocument.ListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  i: Integer;
  APoint: TPoint;
begin
  if Sender = ListBox1 then
  with ListBox1 do
  begin
    APoint.x := X;
    APoint.y := Y;
    i := ItemAtPos(APoint, true);
    if (i >= 0) and (i <= Items.Count - 1) and (i <> ItemIndex ) then
    begin
      Items.Move(ItemIndex, i);
      ItemIndex := i;
      UpdateDocument;
    end;
  end;
end;

procedure TDlgZLDocument.btnSaveClick(Sender: TObject);
begin
  box.SaveOptions;
end;

procedure TDlgZLDocument.rbColumnClick(Sender: TObject);
begin
  if Sender = rbColumn then
    box.Style := 0
  else
    box.Style := 1;
end;

procedure TDlgZLDocument.btnResetClick(Sender: TObject);
begin
  box.ResetOptions;
end;

end.
