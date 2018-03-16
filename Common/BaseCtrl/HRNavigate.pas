unit HRNavigate;

interface

uses
  Classes, uBaseIntf, ZjhCtrls, Buttons, SysUtils, ApConst, Menus;

type
  THRNavigate = class(TComponent)
  private
    FItems: TList;
    FTitle: String;
    FCurrent: Integer;
    FOnRefresh: TNotifyEvent;
    FOnClick: TNotifyEvent;
    procedure SetCurrent(const Value: Integer);
    function GetKind(AKind: Integer): TMenuItem;
    function GetItem(Index: Integer): TMenuItem;
  public
    procedure Refresh;
    procedure Click;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    function Add(const ACaption: String; AKind: Integer = 0): TMenuItem;
    procedure Delete(const AKind: Integer);
    procedure Clear;
    function Count: Integer;
    property Kinds[AKind: Integer]: TMenuItem read GetKind;
    property Items[Index: Integer]: TMenuItem read GetItem; default;
    property Current: Integer read FCurrent write SetCurrent;
  published
    property Title: String read FTitle write FTitle;
    property OnRefresh: TNotifyEvent read FOnRefresh write FOnRefresh;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;
  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents(SOFTWARE_NAME, [THRNavigate]);
end;

{ TMenuItems }

constructor THRNavigate.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TList.Create;
  FCurrent := 0;
end;

destructor THRNavigate.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure THRNavigate.Clear;
var
  i: Integer;
  obj: TObject;
begin
  FCurrent := 0;
  for i := FItems.Count - 1 downto 0 do
  begin
    obj := FItems.Items[i];
    obj.Free;
    FItems.Delete(i);
  end;
end;

procedure THRNavigate.Click;
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

function THRNavigate.Add(const ACaption: String; AKind: Integer): TMenuItem;
begin
  Result := TMenuItem.Create(Self);
  Result.Caption := ACaption;
  Result.Visible := True;
  Result.Enabled := True;
  FItems.Add(Result);
  if FItems.Count < 11 then //F11：导航图，F12：关闭当前窗口
  begin
    Result.Caption := Format('F%d: %s', [FItems.Count, ACaption]);
    Result.ShortCut := 111 + FItems.Count;
  end;
  //
  if AKind <> 0 then
    Result.Tag := AKind
  else
    Result.Tag := FItems.Count;
end;

function THRNavigate.GetKind(AKind: Integer): TMenuItem;
var
  i: Integer;
  Item: TMenuItem;
begin
  Result := nil;
  for i := 0 to FItems.Count - 1 do
  begin
    Item := FItems.Items[i];
    if Item.Tag = AKind then
    begin
      Result := Item;
      Break;
    end;
  end;
end;

function THRNavigate.GetItem(Index: Integer): TMenuItem;
begin
  Result := Self.FItems[Index];
end;

function THRNavigate.Count: Integer;
begin
  Result := FItems.Count;
end;

procedure THRNavigate.Refresh;
begin
  if Assigned(FOnRefresh) then
    FOnRefresh(Self);
end;

procedure THRNavigate.Delete(const AKind: Integer);
var
  i: Integer;
  Item: TMenuItem;
begin
  for i := 0 to FItems.Count - 1 do
  begin
    Item := FItems.Items[i];
    if Item.Tag = AKind then
    begin
      FItems.Delete(i);
      Item.Free;
      Break;
    end;
  end;
end;

procedure THRNavigate.SetCurrent(const Value: Integer);
var
  Item: TMenuItem;
begin
  if FCurrent <> Value then
  begin
    if FCurrent <> 0 then
    begin
      Item := GetKind(FCurrent);
      if Assigned(Item) then
        Item.Checked := False;
    end;
    if Value <> 0 then
    begin
      Item := GetKind(Value);
      if Assigned(Item) then
        Item.Checked := True;
    end;
    FCurrent := Value;
  end;
end;

end.
