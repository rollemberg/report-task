
{*************************************************************************}
{                                                                         }
{                            XML Data Binding                             }
{                                                                         }
{         Generated on: 2011/12/28 9:39:19                                }
{       Generated from: D:\MIMRC\Frame2012\CDROM\Database\RecordSet.xsd   }
{                                                                         }
{*************************************************************************}

unit xsdRecordSet;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLRecordSet = interface;
  IXMLTable = interface;
  IXMLRecord_ = interface;
  IXMLRecordField = interface;
  IXMLRecordFieldList = interface;
  IXMLRecordMemofield = interface;
  IXMLRecordMemofieldList = interface;

{ IXMLRecordSet }

  IXMLRecordSet = interface(IXMLNodeCollection)
    ['{382AEF33-D998-4DC8-90CB-9A06488D6590}']
    { Property Accessors }
    function Get_Table(Index: Integer): IXMLTable;
    { Methods & Properties }
    function Add: IXMLTable;
    function Insert(const Index: Integer): IXMLTable;
    property Table[Index: Integer]: IXMLTable read Get_Table; default;
  end;

{ IXMLTable }

  IXMLTable = interface(IXMLNodeCollection)
    ['{1D1B22F2-DA4A-44B8-904E-2BFF2797DA83}']
    { Property Accessors }
    function Get_Code: String;
    function Get_Record_(Index: Integer): IXMLRecord_;
    procedure Set_Code(Value: String);
    { Methods & Properties }
    function Add: IXMLRecord_;
    function Insert(const Index: Integer): IXMLRecord_;
    property Code: String read Get_Code write Set_Code;
    property Record_[Index: Integer]: IXMLRecord_ read Get_Record_; default;
  end;

{ IXMLRecord_ }

  IXMLRecord_ = interface(IXMLNode)
    ['{EF325470-BE66-40BD-82A5-91CADC81DA6E}']
    { Property Accessors }
    function Get_Need: Boolean;
    function Get_Delete: Boolean;
    function Get_Author: String;
    function Get_Qcdate: UnicodeString;
    function Get_Field: IXMLRecordFieldList;
    function Get_Memofield: IXMLRecordMemofieldList;
    procedure Set_Need(Value: Boolean);
    procedure Set_Delete(Value: Boolean);
    procedure Set_Author(Value: String);
    procedure Set_Qcdate(Value: UnicodeString);
    { Methods & Properties }
    property Need: Boolean read Get_Need write Set_Need;
    property Delete: Boolean read Get_Delete write Set_Delete;
    property Author: String read Get_Author write Set_Author;
    property Qcdate: UnicodeString read Get_Qcdate write Set_Qcdate;
    property Field: IXMLRecordFieldList read Get_Field;
    property Memofield: IXMLRecordMemofieldList read Get_Memofield;
  end;

{ IXMLRecordField }

  IXMLRecordField = interface(IXMLNode)
    ['{FEF66C9A-BB03-4303-9F48-1E7E44FB2208}']
    { Property Accessors }
    function Get_Code: String;
    procedure Set_Code(Value: String);
    { Methods & Properties }
    property Code: String read Get_Code write Set_Code;
  end;

{ IXMLRecordFieldList }

  IXMLRecordFieldList = interface(IXMLNodeCollection)
    ['{E4BCF55C-6A56-48E5-8964-79361399F8D9}']
    { Methods & Properties }
    function Add: IXMLRecordField;
    function Insert(const Index: Integer): IXMLRecordField;

    function Get_Item(Index: Integer): IXMLRecordField;
    property Items[Index: Integer]: IXMLRecordField read Get_Item; default;
  end;

{ IXMLRecordMemofield }

  IXMLRecordMemofield = interface(IXMLNodeCollection)
    ['{06AD6013-6562-4748-9645-88A835630CF3}']
    { Property Accessors }
    function Get_Code: String;
    function Get_Line(Index: Integer): String;
    procedure Set_Code(Value: String);
    { Methods & Properties }
    function Add(const Line: String): IXMLNode;
    function Insert(const Index: Integer; const Line: String): IXMLNode;
    property Code: String read Get_Code write Set_Code;
    property Line[Index: Integer]: String read Get_Line; default;
  end;

{ IXMLRecordMemofieldList }

  IXMLRecordMemofieldList = interface(IXMLNodeCollection)
    ['{39F6DD7C-8ECC-4850-8530-FC07352FFA31}']
    { Methods & Properties }
    function Add: IXMLRecordMemofield;
    function Insert(const Index: Integer): IXMLRecordMemofield;

    function Get_Item(Index: Integer): IXMLRecordMemofield;
    property Items[Index: Integer]: IXMLRecordMemofield read Get_Item; default;
  end;

{ Forward Decls }

  TXMLRecordSet = class;
  TXMLTable = class;
  TXMLRecord_ = class;
  TXMLRecordField = class;
  TXMLRecordFieldList = class;
  TXMLRecordMemofield = class;
  TXMLRecordMemofieldList = class;

{ TXMLRecordSet }

  TXMLRecordSet = class(TXMLNodeCollection, IXMLRecordSet)
  protected
    { IXMLRecordSet }
    function Get_Table(Index: Integer): IXMLTable;
    function Add: IXMLTable;
    function Insert(const Index: Integer): IXMLTable;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTable }

  TXMLTable = class(TXMLNodeCollection, IXMLTable)
  protected
    { IXMLTable }
    function Get_Code: String;
    function Get_Record_(Index: Integer): IXMLRecord_;
    procedure Set_Code(Value: String);
    function Add: IXMLRecord_;
    function Insert(const Index: Integer): IXMLRecord_;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRecord_ }

  TXMLRecord_ = class(TXMLNode, IXMLRecord_)
  private
    FField: IXMLRecordFieldList;
    FMemofield: IXMLRecordMemofieldList;
  protected
    { IXMLRecord_ }
    function Get_Need: Boolean;
    function Get_Delete: Boolean;
    function Get_Author: String;
    function Get_Qcdate: UnicodeString;
    function Get_Field: IXMLRecordFieldList;
    function Get_Memofield: IXMLRecordMemofieldList;
    procedure Set_Need(Value: Boolean);
    procedure Set_Delete(Value: Boolean);
    procedure Set_Author(Value: String);
    procedure Set_Qcdate(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRecordField }

  TXMLRecordField = class(TXMLNode, IXMLRecordField)
  protected
    { IXMLRecordField }
    function Get_Code: String;
    procedure Set_Code(Value: String);
  end;

{ TXMLRecordFieldList }

  TXMLRecordFieldList = class(TXMLNodeCollection, IXMLRecordFieldList)
  protected
    { IXMLRecordFieldList }
    function Add: IXMLRecordField;
    function Insert(const Index: Integer): IXMLRecordField;

    function Get_Item(Index: Integer): IXMLRecordField;
  end;

{ TXMLRecordMemofield }

  TXMLRecordMemofield = class(TXMLNodeCollection, IXMLRecordMemofield)
  protected
    { IXMLRecordMemofield }
    function Get_Code: String;
    function Get_Line(Index: Integer): String;
    procedure Set_Code(Value: String);
    function Add(const Line: String): IXMLNode;
    function Insert(const Index: Integer; const Line: String): IXMLNode;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRecordMemofieldList }

  TXMLRecordMemofieldList = class(TXMLNodeCollection, IXMLRecordMemofieldList)
  protected
    { IXMLRecordMemofieldList }
    function Add: IXMLRecordMemofield;
    function Insert(const Index: Integer): IXMLRecordMemofield;

    function Get_Item(Index: Integer): IXMLRecordMemofield;
  end;

{ Global Functions }

function GetRecordSet(Doc: IXMLDocument): IXMLRecordSet;
function LoadRecordSet(const FileName: string): IXMLRecordSet;
function NewRecordSet: IXMLRecordSet;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetRecordSet(Doc: IXMLDocument): IXMLRecordSet;
begin
  Result := Doc.GetDocBinding('RecordSet', TXMLRecordSet, TargetNamespace) as IXMLRecordSet;
end;

function LoadRecordSet(const FileName: string): IXMLRecordSet;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('RecordSet', TXMLRecordSet, TargetNamespace) as IXMLRecordSet;
end;

function NewRecordSet: IXMLRecordSet;
begin
  Result := NewXMLDocument.GetDocBinding('RecordSet', TXMLRecordSet, TargetNamespace) as IXMLRecordSet;
end;

{ TXMLRecordSet }

procedure TXMLRecordSet.AfterConstruction;
begin
  RegisterChildNode('table', TXMLTable);
  ItemTag := 'table';
  ItemInterface := IXMLTable;
  inherited;
end;

function TXMLRecordSet.Get_Table(Index: Integer): IXMLTable;
begin
  Result := List[Index] as IXMLTable;
end;

function TXMLRecordSet.Add: IXMLTable;
begin
  Result := AddItem(-1) as IXMLTable;
end;

function TXMLRecordSet.Insert(const Index: Integer): IXMLTable;
begin
  Result := AddItem(Index) as IXMLTable;
end;

{ TXMLTable }

procedure TXMLTable.AfterConstruction;
begin
  RegisterChildNode('record', TXMLRecord_);
  ItemTag := 'record';
  ItemInterface := IXMLRecord_;
  inherited;
end;

function TXMLTable.Get_Code: String;
begin
  Result := AttributeNodes['code'].NodeValue;
end;

procedure TXMLTable.Set_Code(Value: String);
begin
  SetAttribute('code', Value);
end;

function TXMLTable.Get_Record_(Index: Integer): IXMLRecord_;
begin
  Result := List[Index] as IXMLRecord_;
end;

function TXMLTable.Add: IXMLRecord_;
begin
  Result := AddItem(-1) as IXMLRecord_;
end;

function TXMLTable.Insert(const Index: Integer): IXMLRecord_;
begin
  Result := AddItem(Index) as IXMLRecord_;
end;

{ TXMLRecord_ }

procedure TXMLRecord_.AfterConstruction;
begin
  RegisterChildNode('field', TXMLRecordField);
  RegisterChildNode('memofield', TXMLRecordMemofield);
  FField := CreateCollection(TXMLRecordFieldList, IXMLRecordField, 'field') as IXMLRecordFieldList;
  FMemofield := CreateCollection(TXMLRecordMemofieldList, IXMLRecordMemofield, 'memofield') as IXMLRecordMemofieldList;
  inherited;
end;

function TXMLRecord_.Get_Need: Boolean;
begin
  Result := AttributeNodes['need'].NodeValue;
end;

procedure TXMLRecord_.Set_Need(Value: Boolean);
begin
  SetAttribute('need', Value);
end;

function TXMLRecord_.Get_Delete: Boolean;
begin
  Result := AttributeNodes['delete'].NodeValue;
end;

procedure TXMLRecord_.Set_Delete(Value: Boolean);
begin
  SetAttribute('delete', Value);
end;

function TXMLRecord_.Get_Author: String;
begin
  Result := AttributeNodes['author'].NodeValue;
end;

procedure TXMLRecord_.Set_Author(Value: String);
begin
  SetAttribute('author', Value);
end;

function TXMLRecord_.Get_Qcdate: UnicodeString;
begin
  Result := AttributeNodes['qcdate'].Text;
end;

procedure TXMLRecord_.Set_Qcdate(Value: UnicodeString);
begin
  SetAttribute('qcdate', Value);
end;

function TXMLRecord_.Get_Field: IXMLRecordFieldList;
begin
  Result := FField;
end;

function TXMLRecord_.Get_Memofield: IXMLRecordMemofieldList;
begin
  Result := FMemofield;
end;

{ TXMLRecordField }

function TXMLRecordField.Get_Code: String;
begin
  Result := AttributeNodes['code'].NodeValue;
end;

procedure TXMLRecordField.Set_Code(Value: String);
begin
  SetAttribute('code', Value);
end;

{ TXMLRecordFieldList }

function TXMLRecordFieldList.Add: IXMLRecordField;
begin
  Result := AddItem(-1) as IXMLRecordField;
end;

function TXMLRecordFieldList.Insert(const Index: Integer): IXMLRecordField;
begin
  Result := AddItem(Index) as IXMLRecordField;
end;

function TXMLRecordFieldList.Get_Item(Index: Integer): IXMLRecordField;
begin
  Result := List[Index] as IXMLRecordField;
end;

{ TXMLRecordMemofield }

procedure TXMLRecordMemofield.AfterConstruction;
begin
  ItemTag := 'line';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLRecordMemofield.Get_Code: String;
begin
  Result := AttributeNodes['code'].NodeValue;
end;

procedure TXMLRecordMemofield.Set_Code(Value: String);
begin
  SetAttribute('code', Value);
end;

function TXMLRecordMemofield.Get_Line(Index: Integer): String;
begin
  Result := List[Index].NodeValue;
end;

function TXMLRecordMemofield.Add(const Line: String): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Line;
end;

function TXMLRecordMemofield.Insert(const Index: Integer; const Line: String): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Line;
end;

{ TXMLRecordMemofieldList }

function TXMLRecordMemofieldList.Add: IXMLRecordMemofield;
begin
  Result := AddItem(-1) as IXMLRecordMemofield;
end;

function TXMLRecordMemofieldList.Insert(const Index: Integer): IXMLRecordMemofield;
begin
  Result := AddItem(Index) as IXMLRecordMemofield;
end;

function TXMLRecordMemofieldList.Get_Item(Index: Integer): IXMLRecordMemofield;
begin
  Result := List[Index] as IXMLRecordMemofield;
end;

end.