unit CellCtrls;

interface

uses
  Classes, DBGrids, ZjhCtrls, SysUtils, DB, uBaseIntf;

Type
  TDataTableFieldDict = class
    Key: String;
    Name: String;
  end;
  TDataTable = class(TComponent, IDataTable)
  private
    mRec: Integer;
    cdsView: TDataSet;
    List: TList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Reset;
    function MoveNext: Boolean;
    function ColumnCount: Integer;
    procedure AddField(const ACode, AName: String);
    function GetColumnValue(AColumn: Integer): Variant;
    function GetColumnTitle(AColumn: Integer): Variant;
    property DataSet: TDataSet read cdsView write cdsView;
  end;
  THRViewShell = class(TComponent,IHRObject)
  private
    DBGrid1: TDBGrid;
    cdsView: TZjhDataSet;
    FMAX_ROW, FMAX_COL: Integer;
    FFieldSize, FColumnWidthDef: Integer;
    FTitles: array of String;
    function GetCells(ln, cl, rw: Integer): String;
    procedure SetCells(ln, cl, rw: Integer; const Value: String);
    function GetTitles(Index: Integer): String;
    procedure SetTitles(Index: Integer; const Value: String);
    procedure SetFieldSize(const Value: Integer);
    procedure SetColumnWidthDef(const Value: Integer);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateView(DataSet: TZjhDataSet; DBGrid: TDBGrid; Rows, Cols: Integer);
    procedure SetColumnTitles(const Values: array of String);
    function Sum(StartLine, EndLine, cl, rw: Integer): Double;
  public
    property MAX_ROW: Integer read FMAX_ROW;
    property MAX_COL: Integer read FMAX_COL;
    property FieldSize: Integer read FFieldSize write SetFieldSize;
    property ColumnWidthDef: Integer read FColumnWidthDef write SetColumnWidthDef;
    property Titles[Index: Integer]: String read GetTitles write SetTitles;
    property Cells[ln, cl, rw: Integer]: String read GetCells write SetCells;
    function PostMessage(MsgType: Integer; Msg: Variant): Variant;  //·¢ËÍÏûÏ¢
  published
    property ViewData: TZjhDataSet read cdsView write cdsView;
    property ViewGrid: TDBGrid read DBGrid1 write DBGrid1;
  end;

implementation

uses ApConst;

{ TViewShell }

constructor THRViewShell.Create(AOwner: TComponent);
begin
  inherited;
  FMAX_ROW :=  2;
  FMAX_COL := 10;
  FColumnWidthDef := 110;
  FFieldSize := 30;
end;

destructor THRViewShell.Destroy;
begin
  FTitles := nil;
  inherited;
end;

procedure THRViewShell.SetCells(ln, cl, rw: Integer; const Value: String);
var
  i: Integer;
begin
  if not Assigned(cdsView) then Exit;
  if not cdsView.Active then Exit;
  with cdsView do
  begin
    if (ln * MAX_ROW) > RecordCount then
    for i := 1 to (ln * MAX_ROW) - RecordCount do
    begin
      Append;
      Post;
    end;
    RecNo := ((ln-1) * MAX_ROW) + rw;
    Edit;
    FieldByName(Format('F_%d',[cl])).AsString := Value;
    Post;
  end;
end;

function THRViewShell.GetCells(ln, cl, rw: Integer): String;
var
  i, m_RecNo: Integer;
begin
  Result := '';
  if not Assigned(cdsView) then Exit;
  if not cdsView.Active then Exit;
  with cdsView do
  begin
    m_RecNo := RecNo;
    DisableControls;
    try
      if (ln * MAX_ROW) > RecordCount then
      for i := 1 to (ln * MAX_ROW) - RecordCount do
      begin
        Append;
        Post;
      end;
      RecNo := ((ln-1) * MAX_ROW) + rw;
      Result := FieldByName(Format('F_%d',[cl])).AsString;
      RecNo := m_RecNo;
    finally
      EnableControls;
    end;
  end;
end;

procedure THRViewShell.CreateView(DataSet: TZjhDataSet; DBGrid: TDBGrid;
  Rows, Cols: Integer);
var
  cl: Integer;
  col: TColumn;
begin
  if Assigned(DataSet) then cdsView := DataSet;
  if Assigned(DBGrid) then DBGrid1 := DBGrid;
  FMAX_ROW := Rows;
  FMAX_COL := Cols;
  with cdsView do
  begin
    for cl := 0 to Cols do
    begin
      col := DBGrid1.Columns.Add;
      FieldDefs.Add(Format('F_%d',[cl]),ftString,FFieldSize);
      col.FieldName := Format('F_%d',[cl]);
      col.Width := FColumnWidthDef;
      col.Title.Alignment := taCenter;
      if cl > High(FTitles) then
        col.Title.Caption := Format('C%d',[cl])
      else
        col.Title.Caption := FTitles[cl];
      col.Alignment := taCenter;
    end;
    CreateDataSet;
  end;
end;

function THRViewShell.GetTitles(Index: Integer): String;
begin
  Result := DBGrid1.Columns[Index].Title.Caption;
end;

procedure THRViewShell.SetTitles(Index: Integer; const Value: String);
begin
  DBGrid1.Columns[Index].Title.Caption := Value;
end;

procedure THRViewShell.SetFieldSize(const Value: Integer);
begin
  if not Assigned(cdsView) then
    FFieldSize := Value
  else if cdsView.FieldDefs.Count = 0 then
    FFieldSize := Value;
end;

procedure THRViewShell.SetColumnWidthDef(const Value: Integer);
var
  i: Integer;
begin
  FColumnWidthDef := Value;
  if Assigned(DBGrid1) then
  with DBGrid1 do
    for i := 0 to Columns.Count - 1 do
      Columns[i].Width := Value;
end;

procedure THRViewShell.SetColumnTitles(const Values: array of String);
var
  i: Integer;
begin
  SetLength(FTitles,High(Values)+1);
  for i := Low(Values) to High(Values) do
    FTitles[i] := Values[i];
  if Assigned(DBGrid1) then
  begin
    with DBGrid1 do
    for i := 0 to Columns.Count - 1 do
      if i <= High(Values) then Columns[i].Title.Caption := Values[i];
  end;
end;

function THRViewShell.Sum(StartLine, EndLine, cl, rw: Integer): Double;
var
  ln: Integer;
begin
  Result := 0;
  if not Assigned(cdsView) then Exit;
  for ln := StartLine to EndLine do
    Result := Result + StrToFloatDef(Cells[ln,cl,rw],0);
end;

function THRViewShell.PostMessage(MsgType: Integer; Msg: Variant): Variant;
begin
  //if not Assigned(p_Cell) then
    {if not Init then
      Application.Terminate;}
  ;//Result := NULL;
  {case MsgType of
  CONST_GETVALUE:
    begin
      if Msg = 'Currencys' then
        Result := Integer(p_AccBook.Currencys)
      else if Msg = 'AccSubject' then
        Result := Integer(Buff.GetItem('AccCodes'));
    end;
  end;
   }
end;

{ TDataTable }

constructor TDataTable.Create(AOwner: TComponent);
begin
  inherited;
  List := TList.Create;
  Reset;
end;

destructor TDataTable.Destroy;
var
  Item: Pointer;
begin
  for Item in List do
    TDataTableFieldDict(Item).Free;
  List.Free;
  inherited;
end;

procedure TDataTable.Reset;
begin
  mRec := 0;
end;

function TDataTable.MoveNext: Boolean;
begin
  if mRec < cdsView.RecordCount then
    begin
      Inc(mRec);
      cdsView.RecNo := mRec;
      Result := True;
    end
  else
    Result := False;
end;

procedure TDataTable.AddField(const ACode, AName: String);
var
  Item: TDataTableFieldDict;
begin
  Item := TDataTableFieldDict.Create;
  Item.Key := ACode;
  Item.Name := AName;
  List.Add(Item);
end;

function TDataTable.ColumnCount: Integer;
begin
  Result := List.Count;
end;

function TDataTable.GetColumnTitle(AColumn: Integer): Variant;
var
  Item: TDataTableFieldDict;
begin
  Item := List.Items[AColumn];
  Result := Item.Name
end;

function TDataTable.GetColumnValue(AColumn: Integer): Variant;
var
  Item: TDataTableFieldDict;
  Text: String;
  fd: TField;
begin
  Item := List.Items[AColumn];
  if Supports(Self.Owner, IGetDisplayText) then
    begin
      fd := cdsView.FieldByName(Item.Key);
      Text := fd.DisplayText;
      (Self.Owner as IGetDisplayText).GetDisplayText(fd, Text);
      Result := Text;
    end
  else
    Result := cdsView.FieldByName(Item.Key).AsString;
end;

end.
