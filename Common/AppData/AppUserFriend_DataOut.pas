unit AppUserFriend_DataOut;

interface

uses
  AppData, Classes, Variants, uBaseIntf;

type
  TItemData = record
    Code: String;
    Name: String;
  end;
  TAppUserFriend_DataOut = class(TAppData)
  var
    FItems1, FItems2: TStringList;
  private
    function GetItems(Index: Integer): TItemData;
  published
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetVariant(const Value: Variant); override;
    function GetVariant: Variant; override;
    procedure AddItem(const ACode, AName: String);
    function ItemCount: Integer;
    property Items[Index: Integer]: TItemData read GetItems; default;
  end;

implementation

{ TAppUserFriend_DataOut }

constructor TAppUserFriend_DataOut.Create;
begin
  FItems1 := TStringList.Create;
  FItems2 := TStringList.Create;
end;

destructor TAppUserFriend_DataOut.Destroy;
begin
  FItems2.Free;
  FItems1.Free;
  inherited;
end;

procedure TAppUserFriend_DataOut.AddItem(const ACode, AName: String);
begin
  FItems1.Add(ACode);
  FItems2.Add(AName);
end;

function TAppUserFriend_DataOut.GetItems(Index: Integer): TItemData;
begin
  Result.Code := FItems1.Strings[Index];
  Result.Name := FItems2.Strings[Index];
end;

function TAppUserFriend_DataOut.ItemCount: Integer;
begin
  Result := FItems1.Count;
end;

function TAppUserFriend_DataOut.GetVariant: Variant;
var
  i: Integer;
  Item: TItemData;
begin
  Result := VarArrayCreate([0, ItemCount()], varVariant);
  Result[0] := ItemCount();
  for i := 1 to ItemCount() do
  begin
    Item := GetItems(i-1);
    Result[i] := VarArrayOf([Item.Code, Item.Name]);
  end;
end;

procedure TAppUserFriend_DataOut.SetVariant(const Value: Variant);
var
  i: Integer;
begin
  for i := 1 to Value[0] do
    AddItem(Value[i][0], Value[i][1]);
end;

end.
