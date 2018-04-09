unit AppIMGroupInfo_Data;

interface

uses
  uBaseIntf, AppData, AppBean, Classes, Variants;

type
  TAppIMGroupInfo_Data = class(TAppData)
  private
    FItems: TStringList;
    FGroupID: String;
    FGroupName: String;
    FManageUser: String;
    procedure SetGroupID(const Value: String);
    procedure SetGroupName(const Value: String);
    function GetUsers(Index: Integer): String;
    procedure SetManageUser(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetVariant(const Value: Variant); override;
    function GetVariant: Variant; override;
    function UserCount: Integer;
    procedure AddUser(const Value: String);
    property Users[Index: Integer]: String read GetUsers;
  published
    property GroupID: String read FGroupID write SetGroupID;
    property GroupName: String read FGroupName write SetGroupName;
    property ManageUser: String read FManageUser write SetManageUser;
  end;

implementation

{ TAppIMGroupInfo_Data }

procedure TAppIMGroupInfo_Data.AddUser(const Value: String);
begin
  FItems.Add(Value);
end;

constructor TAppIMGroupInfo_Data.Create;
begin
  FItems := TStringList.Create;
end;

destructor TAppIMGroupInfo_Data.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TAppIMGroupInfo_Data.SetGroupID(const Value: String);
begin
  FGroupID := Value;
end;

procedure TAppIMGroupInfo_Data.SetGroupName(const Value: String);
begin
  FGroupName := Value;
end;

procedure TAppIMGroupInfo_Data.SetManageUser(const Value: String);
begin
  FManageUser := Value;
end;

function TAppIMGroupInfo_Data.GetUsers(Index: Integer): String;
begin
  Result := FItems.Strings[Index];
end;

function TAppIMGroupInfo_Data.GetVariant: Variant;
var
  i: Integer;
begin
  Result := VarArrayCreate([0, FItems.Count + 3], varVariant);
  Result[0] := FGroupID;
  Result[1] := FGroupName;
  Result[2] := FItems.Count;
  Result[3] := FManageUser;
  for i := 1 to FItems.Count do
    Result[i+3] := FItems.Strings[i-1];
end;

procedure TAppIMGroupInfo_Data.SetVariant(const Value: Variant);
var
  i, UserCount: Integer;
begin
  GroupID := Value[0];
  GroupName := Value[1];
  UserCount := Value[2];
  FManageUser := Value[3];
  for i := 1 to UserCount  do
    FItems.Add(VarToStr(Value[i + 3]));
end;

function TAppIMGroupInfo_Data.UserCount: Integer;
begin
  Result := FItems.Count;
end;

end.
