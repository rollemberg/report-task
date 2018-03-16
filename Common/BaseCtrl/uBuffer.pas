unit uBuffer;

interface

uses
  Classes, SysUtils, DB, Variants, DBClient, ApConst, InfoBox, ZjhCtrls,
  uBaseIntf, DBGrids, XmlIntf;

type
  IInitBuffer = interface
    ['{10B99C27-96D6-4494-8F30-3805BA0BAA57}']
    procedure InitBuffer(Sender: TObject; const BuffCode: array of String;
      var AllowCreate: Boolean);
  end;
  TNewBufferEventEvent = procedure(Sender: TObject; const BuffCode: array of String;
    var AllowCreate: Boolean) of object;
  TCustomBuffer = class
  private
    FItems: TStringList;
    FParams: Variant;
    procedure SetOnNewBuffer(const Value: TNewBufferEventEvent);
    function UpdateParams(BuffCode: array of String): String;
  protected
    FOnNewBuffer: TNewBufferEventEvent;
  public
    procedure Clear;
    function Count: Integer;
    function Items: TStrings;
    procedure AddItem(BuffCode: array of String; Item: TObject);
    property Params: Variant read FParams;
    property OnNewBuffer: TNewBufferEventEvent read FOnNewBuffer write SetOnNewBuffer;
  end;
  TObjectBuffer = class(TCustomBuffer)
  private
    FObjectClass: TClass;
  public
    constructor Create(AObjectClass: TClass); virtual;
    destructor Destroy; override;
    function Get(Index: Integer): TObject; overload;
    function Get(BuffCode: String): TObject; overload;
    function Get(BuffCode: array of String): TObject; overload;
  end;
  //
  TComponentBuffer = class(TCustomBuffer)
  private
    FComponentOwner: TComponent;
    FComponentClass: TComponentClass;
  public
    constructor Create(AComponentOwner: TComponent; AComponentClass: TComponentClass); virtual;
    destructor Destroy; override;
    function Get(Index: Integer): TComponent; overload;
    function Get(BuffCode: String): TComponent; overload;
    function Get(BuffCode: array of String): TComponent; overload;
  end;
  //系统缓存管理器
  //
  TErpBuffer = class(TComponent)
  private
    FItems: TStringList;
    FIsGroupData: Boolean;
    FDatabase: String;
    procedure SetIsGroupData(const Value: Boolean);
    function GetItem2(const Index: String): TZjhDataSet;
    procedure SetDatabase(const Value: String);
  public
    procedure ClearAll;
    function Count: Integer;
    function Init(Item: IXmlNode; const Index, KeyName, SQLCmd: String;
      const Args: array of String): Boolean;
    //function Write(const Index: String; Source: TZjhDataSet): Integer;
    function Read(const Index, KeyValue: String; const Args: array of String): Variant;
    function ReadValue(const Index, KeyValue: String; const RetField: String = 'Name_'): Variant;
    function SetLists(const Index: String; sl: TStrings): Integer;
    procedure Clear(const Index: String);
    procedure ReadSections(Strings: TStrings);
    procedure OpenDataSet(const Index: String);
    function GetItem(const Index: String): TZjhDataSet;
    function ValueExists(const Index, Value: String): Boolean;
    procedure SetTitles(const Index: String; Args: array of Variant);
    function GetBuffer(const Index: String): IDataBuffer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Items[const Index: String]: TZjhDataSet read GetItem2; default;
    property IsGroupData: Boolean read FIsGroupData write SetIsGroupData;
    property Database: String read FDatabase write SetDatabase;
  end;
  //缓存管理器
  TBuffManger = class(TComponent)
  private
    FItems: TStringList;
    FProtectObjects: TStringList;
    function GetItems(Index: String): IDataBuffer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    procedure Clear;
    function Count: Integer;
    function Add(const AClass: TComponentClass): TComponent;
    function AddClass(const AClassName: String): TComponent;
    procedure AddProtect(const AClassName: String);
    property Items[Index: String]: IDataBuffer read GetItems; default;
    property Buffers: TStringList read FItems;
    property ProtectObjects: TStringList read FProtectObjects;
  end;

const
  BUFFER_BuffName: String = 'BuffName';
  BUFFER_KeyField: String = 'KeyField';
  BUFFER_Database: String = 'Database';
  BUFFER_BigData: String = 'BigDataMode';

implementation

{ TCustomBuffer }

procedure TCustomBuffer.AddItem(BuffCode: array of String; Item: TObject);
var
  Key: String;
begin
  Key := UpdateParams(BuffCode);
  if FItems.IndexOf(Key) > - 1 then
    raise Exception.CreateFmt('Error! The is %s object has Enroll.', [Key]);
  FItems.AddObject(Key, Item);
end;

procedure TCustomBuffer.Clear;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    FItems.Objects[i].Free;
  FItems.Clear;
end;

function TCustomBuffer.Count: Integer;
begin
  Result := FItems.Count;
end;

function TCustomBuffer.Items: TStrings;
begin
  Result := FItems;
end;

procedure TCustomBuffer.SetOnNewBuffer(const Value: TNewBufferEventEvent);
begin
  FOnNewBuffer := Value;
end;

function TCustomBuffer.UpdateParams(BuffCode: array of String): String;
var
  i: Integer;
  Key: String;
begin
  Key := '';
  FParams := VarArrayCreate([0, High(BuffCode)], varVariant);
  for i := Low(BuffCode) to High(BuffCode) do
  begin
    FParams[i] := BuffCode[i];
    Key := Key + BuffCode[i] + '@';
  end;
  if Key <> '' then
    Key := Copy(Key, 1, Length(Key) - 1);
  Result := Key;
end;

{ TObjectBuffer }

constructor TObjectBuffer.Create(AObjectClass: TClass);
begin
  FObjectClass := AObjectClass;
  FItems := TStringList.Create;
  FParams := NULL;
end;

function TObjectBuffer.Get(Index: Integer): TObject;
begin
  Result := FItems.Objects[Index];
end;

function TObjectBuffer.Get(BuffCode: String): TObject;
begin
  Result := Get([BuffCode]);
end;

destructor TObjectBuffer.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

function TObjectBuffer.Get(BuffCode: array of String): TObject;
var
  i: Integer;
  Obj: TObject;
  Key: String;
  AllowCreate: Boolean;
begin
  Key := UpdateParams(BuffCode);
  i := FItems.IndexOf(Key);
  if i = -1 then
    begin
      Obj := nil;
      if Assigned(FObjectClass) then
      begin
        Obj := FObjectClass.Create;
        if Assigned(FOnNewBuffer) then
        try
          AllowCreate := True;
          FOnNewBuffer(Obj, BuffCode, AllowCreate);
          if not AllowCreate then
            FreeAndNil(Obj);
        except
          FreeAndNil(Obj);
          raise;
        end;
        if Assigned(Obj) then
          FItems.AddObject(Key, Obj);
      end;
      Result := Obj;
    end
  else
    Result := FItems.Objects[i];
end;

{ TComponentBuffer }

constructor TComponentBuffer.Create(AComponentOwner: TComponent;
  AComponentClass: TComponentClass);
begin
  FComponentOwner := AComponentOwner;
  FComponentClass := AComponentClass;
  FItems := TStringList.Create;
  FParams := NULL;
end;

function TComponentBuffer.Get(Index: Integer): TComponent;
begin
  Result := FItems.Objects[Index] as TComponent;
end;

function TComponentBuffer.Get(BuffCode: String): TComponent;
begin
  Result := Get([BuffCode]);
end;

destructor TComponentBuffer.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

function TComponentBuffer.Get(BuffCode: array of String): TComponent;
var
  i: Integer;
  Obj: TComponent;
  AllowCreate: Boolean;
  Key: String;
begin
  Key := UpdateParams(BuffCode);
  i := FItems.IndexOf(Key);
  if i = -1 then
    begin
      Obj := nil;
      if Assigned(FComponentClass) then
      begin
        Obj := FComponentClass.Create(FComponentOwner);
        try
          AllowCreate := True;
          if Assigned(FOnNewBuffer) then
            FOnNewBuffer(Obj, BuffCode, AllowCreate)
          else if Supports(obj, IInitBuffer) then
            (Obj as IInitBuffer).InitBuffer(Obj, BuffCode, AllowCreate);
          if not AllowCreate then
            FreeAndNil(Obj);
        except
          FreeAndNil(Obj);
          raise;
        end;
        if Assigned(Obj) then
          FItems.AddObject(Key, Obj);
      end;
      Result := Obj;
    end
  else
    Result := FItems.Objects[i] as TComponent;
end;

{ TBuffManger }

constructor TBuffManger.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TStringList.Create;
  FProtectObjects := TStringList.Create;
end;

destructor TBuffManger.Destroy;
begin
  FProtectObjects.Free;
  FItems.Free;
  inherited;
end;

procedure TBuffManger.AddProtect(const AClassName: String);
begin
  if FProtectObjects.IndexOf(AClassName) = -1 then
    FProtectObjects.Add(AClassName);
end;

function TBuffManger.Add(const AClass: TComponentClass): TComponent;
var
  i: Integer;
  Ret: TComponent;
begin
  i := FItems.IndexOf(AClass.ClassName);
  if i = -1 then
    begin
      Ret := AClass.Create(Self);
      if Assigned(Ret) then
        FItems.AddObject(AClass.ClassName, Ret);
      Result := Ret;
    end
  else
    Result := TComponent(FItems.Objects[i]);
end;

function TBuffManger.AddClass(const AClassName: String): TComponent;
var
  i: Integer;
  Ret: TComponent;
begin
  i := FItems.IndexOf(AClassName);
  if i = -1 then
    begin
      Ret := CreateClass(AClassName, Self);
      if Assigned(Ret) then
        FItems.AddObject(AClassName, Ret);
      Result := Ret;
    end
  else
    Result := TComponent(FItems.Objects[i]);
end;

procedure TBuffManger.Clear;
var
  i: Integer;
  Obj: TComponent;
begin
  for i := FItems.Count - 1 downto 0 do
  begin
    Obj := TComponent(FItems.Objects[i]);
    if FProtectObjects.IndexOf(FItems.Strings[i]) = -1 then
    begin
      if ibox.Debug then
        ibox.Text('Destroy Buffer Object: %s', [Obj.ClassName]);
      Obj.Free;
      FItems.Delete(i);
    end;
  end;
end;

function TBuffManger.Count: Integer;
begin
  Result := FItems.Count;
end;

function TBuffManger.GetItems(Index: String): IDataBuffer;
var
  i: Integer;
begin
  i := FItems.IndexOf(Index);
  if i > - 1 then
    Result := TComponent(FItems.Objects[i]) as IDataBuffer
  else
    Result := CreateClass(Index, Self) as IDataBuffer;
end;

{ TErpBuffer }

procedure TErpBuffer.Clear(const Index: String);
var
  AIntf: IDataBuffer;
begin
  AIntf := GetBuffer(Index);
  if Assigned(AIntf) then
    AIntf.Clear;
end;

procedure TErpBuffer.ClearAll;
var
  i: Integer;
  Obj: TComponent;
  ds: TDataSet;
begin
  for i := 0 to FItems.Count - 1 do
  begin
    Obj := TComponent(FItems.Objects[i]);
    (Obj as IDataBuffer).Clear;
    ds := (Obj as IDataBuffer).GetDataSet();
    if ds is TZjhDataSet then
      TZjhDataSet(ds).Database := FDatabase;
  end;
end;

function TErpBuffer.Count: Integer;
begin
  Result := FItems.Count;
end;

constructor TErpBuffer.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TStringList.Create;
end;

destructor TErpBuffer.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TErpBuffer.GetBuffer(const Index: String): IDataBuffer;
var
  i: Integer;
begin
  i := FItems.IndexOf(Index);
  if i = -1 then
    raise Exception.CreateFmt(Chinese.AsString('缓存失败，系统使用了一个未注册的缓存器[代码=%s]！'),[Index]);
  Result := TComponent(FItems.Objects[i]) as IDataBuffer;
end;

function TErpBuffer.Init(Item: IXmlNode; const Index, KeyName, SQLCmd: String;
  const Args: array of String): Boolean;
var
  AIntf: IDataBuffer;
  Obj: TComponent;
  ObjName: String;
begin
  Result := False;
  if FItems.IndexOf(Index) = - 1 then
  begin
    //缓存对象
    ObjName := 'TZLBufferDefault';
    if Assigned(Item) and Item.HasAttribute('class') then
      ObjName := Item.Attributes['class'];
    //建立对象
    Obj := CreateClass(ObjName, Self);
    if Assigned(Obj) then
      begin
        FItems.AddObject(Index, Obj);
        AIntf := Obj as IDataBuffer;
        AIntf.SetProperty(BUFFER_BuffName, Index);
        AIntf.SetProperty(BUFFER_KeyField, KeyName);
        if FIsGroupData then
          AIntf.SetProperty(BUFFER_Database, 'Common');
        Result := AIntf.Init(Item, SQLCmd, Args)
      end
    else
      raise Exception.CreateFmt(Chinese.AsString('无法建立缓存对象 %s[%s] ！'),
        [ObjName, Index]);
  end;
end;

procedure TErpBuffer.OpenDataSet(const Index: String);
begin
  GetBuffer(Index).Ready;
end;

function TErpBuffer.Read(const Index, KeyValue: String;
  const Args: array of String): Variant;
begin
  Result := GetBuffer(Index).Read(KeyValue, Args);
end;

function TErpBuffer.ReadValue(const Index, KeyValue, RetField: String): Variant;
var
  R: Variant;
begin
  R := Read(Index, KeyValue, [RetField]);
  if VarIsArray(R) then
    Result := R[0]
  else
    Result := NULL;
end;

function TErpBuffer.ValueExists(const Index, Value: String): Boolean;
var
  R: Variant;
  AIntf: IDataBuffer;
begin
  Result := Trim(Value) = '';
  if Result then Exit;
  //
  AIntf := GetBuffer(Index);
  AIntf.Ready;
  R := Read(Index, Value, [AIntf.GetProperty(BUFFER_KeyField)]);
  Result := not VarIsNull(R);
end;

procedure TErpBuffer.ReadSections(Strings: TStrings);
begin
  Strings.Assign(Self.FItems);
end;

function TErpBuffer.GetItem(const Index: String): TZjhDataSet;
var
  i: Integer;
begin
  i := FItems.IndexOf(Index);
  if i > -1 then
    Result := GetBuffer(Index).GetDataSet as TZjhDataSet
  else
    Result := nil;
end;

function TErpBuffer.GetItem2(const Index: String): TZjhDataSet;
var
  i: Integer;
begin
  i := FItems.IndexOf(Index);
  if i > -1 then
    begin
      GetBuffer(Index).Ready;
      Result := GetBuffer(Index).GetDataSet as TZjhDataSet;
    end
  else
    Result := nil;
end;

function TErpBuffer.SetLists(const Index: String; sl: TStrings): Integer;
var
  AIntf: IDataBuffer;
begin
  Result := 0;
  if not Assigned(sl) then
    Exit;
  //
  sl.Clear;
  AIntf := GetBuffer(Index);
  AIntf.Ready;
  with AIntf.GetDataSet do
  begin
    First;
    while not Eof do
    begin
      sl.Add(Trim(FieldByName(AIntf.GetProperty(BUFFER_KeyField)).AsString));
      Next;
    end;
  end;
  Result := sl.Count;
end;

procedure TErpBuffer.SetTitles(const Index: String; Args: array of Variant);
begin
  GetBuffer(Index).SetTitles(Args);
end;

procedure TErpBuffer.SetDatabase(const Value: String);
begin
  if FDatabase <> Value then
  begin
    FDatabase := Value;
    Self.ClearAll;
  end;
end;

procedure TErpBuffer.SetIsGroupData(const Value: Boolean);
begin
  FIsGroupData := Value;
end;

end.
