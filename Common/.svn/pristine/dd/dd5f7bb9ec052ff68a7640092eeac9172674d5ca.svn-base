unit ZjhCtrls;
{$I ERPVersion.Inc}

interface

uses Windows, Messages, Classes, Controls, Forms, Graphics, StdCtrls,
  ExtCtrls, CommCtrl, Buttons, Dialogs, DB, DBCtrls, ADODB, ImgList,
  OleCtrls, DBGrids, Registry, ToolWin, Variants, Grids, IniFiles, ShellAPI,
  Mask, DBClient, ComCtrls, Menus, OleServer, RecError, Provider,
  DateUtils, xmldom, XMLIntf, XMLDoc, uBaseIntf, SyncObjs, Math;

type
  TDragOverControl = Class(TControl)
  public
    property OnDragOver;
  end;

  TDBIniFile = class(TIniFile)
  private
    FReportField: TWideMemoField;
    procedure SetReportField(const Value: TWideMemoField);
  public
    property ReportField: TWideMemoField read FReportField write SetReportField;
    destructor Destroy; override;
  end;

  TSourceTypeOption = (stDeactive, stADOTable, stADOQuery, stADOStoredProc,
     stClientDataSet,stZjhDataSet,stOtherSource);

  TRecordMoveOption = (rmFirst,rmPrior,rmNext,rmLast);
  TRecordMoveEvent = procedure(Sender: TObject; rmAction: TRecordMoveOption;
    var DoDefault: Boolean) of object;

  TDataTool = Class
  private
    FDataLink: TDataLink;
    FError: TStringList;
    function GetDataSource: TDataSource;
    function GetSourceType: TSourceTypeOption;
    procedure SetDataSource(const Value: TDataSource);
  public
    constructor Create();
    destructor Destroy();override;
  public
    function RecordMove(rmAction: TRecordMoveOption): Boolean; overload;
    function Append(): Boolean; overload;
    function Edit(): Boolean; overload;
    function Delete(): Boolean; overload;
    procedure Save(); overload;
    function Requery(): Boolean; overload;
  public
    function RecordMove(dsSource: TDataSource; rmAction: TRecordMoveOption; var ErrorInfo: String): Boolean; overload;
    function Append(dsSource: TDataSource; var ErrorInfo: String): Boolean; overload;
    function Edit(dsSource: TDataSource; var ErrorInfo: String): Boolean; overload;
    function Delete(dsSource: TDataSource; var ErrorInfo: String): Boolean; overload;
    procedure Save(dsSource: TDataSource; var ErrorInfo: String); overload;
    function Requery(dsSource: TDataSource; var ErrorInfo: String): Boolean; overload;
  public
    property SourceType: TSourceTypeOption read GetSourceType;
    property DataSource: TDataSource read GetDataSource write SetDataSource stored True;
    property Error: TStringList read FError;
  end;
  //缩放窗体工具
  TZoomObjectRecord = record
    Obj: TObject;
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
  end;
  TFontControl = class(TControl)
  public
    property Font;
  end;
  TZoomWindow = class(TComponent)
  private
    FCurFontSize: Integer;
    FOldFontSize: Integer;
    FItems: TStringList;
    FList: array of TZoomObjectRecord;
    procedure SetCurFontSize(const Value: Integer);
    function GetItems: TStrings;
    function FindControl(AObj: TObject): Integer;
    procedure UpdateFace(ATarget: TObject);
    procedure SaveFace(ATarget: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetFontList(AList: TStrings);
    procedure Refresh(ATarget: TObject);
    class procedure RefreshForm(ATarget: TComponent);
    property Items: TStrings read GetItems;
  published
    property CurFontSize: Integer read FCurFontSize write SetCurFontSize;
    property OldFontSize: Integer read FOldFontSize;
  end;

  TZjhSkin = class(TComponent)
  private
    FIni: TIniFile;
    m_IniFile: String;
    FSection: String;
    FAutoStart: Boolean;
    FAutoCreate: Boolean;
    FProtectObject: TStringList;
    FFormShow: TNotifyEvent;
    FFormCreate: TNotifyEvent;
    FOnAfterRefresh: TNotifyEvent;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetObj(o: TDBGrid); overload;
    procedure SetObj(o: TRadioButton); overload;
    procedure SetObj(o: TStatusBar); overload;
    procedure SetObj(o: TMenuItem); overload;
    procedure SetObj(o: TToolBar); overload;
    procedure SetObj(o: TDBEdit); overload;
    procedure SetINIFile(const Value: String);
    procedure SetAutoStart(const Value: Boolean);
    //procedure DBGridTitleClick(Column: TColumn);

    // Add By Liangjun at 2006/12/14 表格外观设置,给负数显示红色
    procedure SysDBGridDrawColumnCellNegRed(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SysDBGridDrawColumnCellNegRedShell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);

  protected
    procedure OpenSkinFile; virtual;
  public
    // Add by Liangjun at 2006/12/14 给DBGrid负数显示红色(当DisaplyFormat中有;时)
    //------------------
    //当DBGrid原来有OnDrawColumnCell时保存老的OnDrawColumnCell
    SysOrgDrawColumnCellList: TStringList;
    DrawColumnCellArray: array of TDrawColumnCellEvent;
    //替换OnDrawColumnCell
    procedure SetSysOnDrawColumnCell(o: TDBGrid);
    //------------------

    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function Ini: TIniFile;
    property IniFile: String read m_IniFile write SetIniFile;
    procedure SkinComponent(o: TComponent);
    procedure Refresh(Sender: TObject);
    procedure SetFormSite(Sender: TForm);
    procedure EasyDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  published
    property AutoStart: Boolean read FAutoStart write SetAutoStart default True;
    property Section: String read FSection write FSection;
    property ProtectObject: TStringList read FProtectObject write FProtectObject;
    property OnAfterRefresh: TNotifyEvent read FOnAfterRefresh write FOnAfterRefresh;
  end;

  {
  TSecurityInfomation = Record
    Check: Boolean;
    DataSet: TDataSet;
    ID: String;
  end;
  }
  
  TZjhMainMenuItem = Record
    Text: String;
    Kind: Integer;
    //Site: Integer;
    Data: Pointer;
    Face: TMenuItem;
  end;

  TZjhMainMenu = class(TObject)
  private
    function GetMenuItems(Index: Integer): TZjhMainMenuItem;
  protected
  public
    //constructor Create;
    destructor Destroy; override;
  public
    MenuItems: array of TZjhMainMenuItem;
    property Items[Index: Integer]: TZjhMainMenuItem read GetMenuItems; default;
    procedure Add(const AText: String; Kind: Integer = 0; Site: Integer = 0);
    procedure Remove(const Kind: Integer);
    function IndexOf(const Kind: Integer): Integer;
    function Count: Integer;
  end;
  //
  TZjhSecEvent = procedure(Kind: Integer; Sender: TObject) of object;
  TReportFormatOption = (rfPrint,rfPreview,rfEmail,rfFax,rfWord,rfExcel,rfDBF,rfPDF,rfTxt);
  TReportFormatOptions = set of TReportFormatOption;
  QDefaultOption = (doRecordMove,doAppend,doEdit,doDelete,doSave,doRequery,
    doFind,doConfirm,doUnChange,doCancelLation,doOutput);
  QDefaultOptions = set of QDefaultOption;
  TOnChangeStatusEvent = procedure(Sender: TObject; NewStatus: Integer) of object;
  TOnUpdateStatusEvent = procedure(Sender: TObject; doAction: QDefaultOption;
    var Allow: Boolean) of object;
  TOnBeforeExecuteEvent = procedure(Sender: TObject; doAction: QDefaultOption;
    var Allow: Boolean) of object;
  //TReportOutputEvent = procedure(Sender: TObject; rfAction: TReportFormatOption;
  //  var DoDefault: Boolean) of object;

  TZjhTool = class(TComponent)
  private
    { Private declarations }
    FUpdateStatus: Boolean;
    FSecurity: Boolean;
    FPassport: String;
    m_DefaultOptions: QDefaultOptions;
    FDataTool: TDataTool;
    FOnRefresh: TNotifyEvent;
    FMainTool: Boolean;
    FFormActivate: TNotifyEvent;
    FFormClose: TCloseEvent;
    FOnAppend: TNotifyEvent;
    FOnDelete: TNotifyEvent;
    FOnEdit: TNotifyEvent;
    FOnSave: TNotifyEvent;
    FOnRequery: TNotifyEvent;
    FOnFind: TNotifyEvent;
    FOnUpdateStatus: TOnUpdateStatusEvent;
    FOnUpdateSecurity: TNotifyEvent;
    FOnBeforeExecute: TOnBeforeExecuteEvent;
    FOnChangeStatus: TOnChangeStatusEvent;
    FOnRecordMove: TRecordMoveEvent;
    //FOnReportOutput: TReportOutputEvent;
    FSecMenu: TZjhMainMenu;
    FOnSecEvent: TZjhSecEvent;
    FDataLink: TFieldDataLink;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    function GetPassport: String;
    procedure SetPassport(const Value: String);
  protected
    { Protected declarations }
    function GetSourceType: TSourceTypeOption;
    procedure ChangeStatus(NewStatus: Integer);
  public
    { Public declarations }
    //FSecurityID: String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    property Passport: String read GetPassport write SetPassport;
  public
    function Pass(const strKey: String; bError: Boolean): Boolean;
    procedure PutMessage(Value: String);
    procedure PutError(Value: String);
    procedure Refresh(Sender: TObject);
    function Append(): Boolean;
    function Delete(): Boolean;
    function Edit(): Boolean;
    function Requery(): Boolean;
    function Save(): Boolean;
    function SecEvent(Kind: Integer; Sender: TObject): Boolean;
    function AskEnabled(Sender: TObject; doAction: QDefaultOption): Boolean;
    function AskExecute(Sender: TObject; doAction: QDefaultOption): Boolean;
    function RecordMove(rmAction: TRecordMoveOption): Boolean;
    procedure Find;
    procedure DataActiveChange(Sender: TObject);
    function PostMessage(Sender: TObject; MsgType: Integer): Variant;
    //procedure SetSecurityInfo(const AID: String; ADataSet: TDataSet);
    //
    property DataTool: TDataTool read FDataTool write FDataTool;
    property SecMenu: TZjhMainMenu read FSecMenu write FSecMenu;
    property UpdateStatus: Boolean read FUpdateStatus write FUpdateStatus;
    procedure UpdateSecurity; //更新安全设置
  published
    { Published declarations }
    //property SecurityID: String read FSecurityID write SetSecurityID;
    property MainTool: Boolean read FMainTool write FMainTool default True;
    property DataSource: TDataSource read GetDataSource write SetDataSource stored True;
    property SourceType: TSourceTypeOption read GetSourceType;
    property DefaultOptions: QDefaultOptions read m_DefaultOptions
      write m_DefaultOptions stored True default [doRecordMove];
    property Security: Boolean read FSecurity write FSecurity default True;
    //
    property OnRefresh: TNotifyEvent read FOnRefresh write FOnRefresh;
    property OnUpdateStatus: TOnUpdateStatusEvent read FOnUpdateStatus write FOnUpdateStatus;
    property OnBeforeExecute: TOnBeforeExecuteEvent read FOnBeforeExecute write FOnBeforeExecute;
    property OnAppend: TNotifyEvent read FOnAppend write FOnAppend;
    property OnDelete: TNotifyEvent read FOnDelete write FOnDelete;
    property OnEdit: TNotifyEvent read FOnEdit write FOnEdit;
    property OnRecordMove: TRecordMoveEvent read FOnRecordMove write FOnRecordMove;
    property OnRequery: TNotifyEvent read FOnRequery write FOnRequery;
    property OnSave: TNotifyEvent read FOnSave write FOnSave;
    property OnFind: TNotifyEvent read FOnFind write FOnFind;
    property OnUpdateSecurity: TNotifyEvent read FOnUpdateSecurity write FOnUpdateSecurity;
    property OnChangeStatus: TOnChangeStatusEvent read FOnChangeStatus write FOnChangeStatus;
    //property OnReportOutput: TReportOutputEvent read FOnReportOutput write FOnReportOutput;
    property OnSecEvent: TZjhSecEvent read FOnSecEvent write FOnSecEvent;
  end;

  TChildDataSet = type TStringList;
  TOnRequestScrollEvent = procedure(Sender: TObject; const ChildIndex: Integer;
    var AllowScroll: Boolean) of object;
  TZjhDataSet = class(TCustomClientDataSet)
  private
    m_Children: TChildDataSet;
    //m_SQL: TStringList;
    m_TableName: String;
    FOnRequestScroll: TOnRequestScrollEvent;
    FDatabase: String;
    FUpdateKey: Boolean;
    FFinalManage: Boolean;
    procedure SetTableName(const Value: String);
    procedure mReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure SetUpdateKey(const Value: Boolean);
    procedure SetFinalManage(const Value: Boolean);
  protected
    procedure DoAfterScroll; override;
    procedure DoBeforePost; override;
    procedure DoOnNewRecord; override;
    procedure DoBeforeApplyUpdates(var OwnerData: OleVariant); override;
    procedure DoBeforeGetRecords(var OwnerData: OleVariant); override;
    procedure DoBeforeRowRequest(var OwnerData: OleVariant); override;
    procedure DoBeforeExecute(var OwnerData: OleVariant); override;
    function DoGetRecords(Count: Integer; out RecsOut: Integer; Options: Integer;
       const CommandText: WideString; Params: OleVariant): OleVariant; override;
    procedure DoBeforeDelete; override;
    procedure DoBeforeEdit; override;
  public
    function DataRequest(Data: OleVariant): OleVariant; override;
  public
    //property ProviderEOF;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RequestScroll;
    procedure PostPro(MaxErrors: Integer);
    {
    procedure PostPro(const Keys: array of string); overload;
    procedure PostPro(const AKey: string = ''); overload;
    }
    procedure GetMorePacket(const SQLText: String);
    function AddChildren(ChildDataSet: TZjhDataSet;
      const ChildID, MasterID: String; const SQLText: String = ''): Integer;
    property Children: TChildDataSet read m_Children;
    property UpdateKey: Boolean read FUpdateKey write SetUpdateKey;
  published
    //property SQL: TStringList read m_SQL write m_SQL;
    property OnRequestScroll: TOnRequestScrollEvent read FOnRequestScroll
      write FOnRequestScroll;
    property TableName: String read m_TableName write SetTableName stored True;
    property Database: String read FDatabase write FDatabase;
    property FinalManage: Boolean read FFinalManage write SetFinalManage default False;
  published
    property Active;
    property Aggregates;
    property AggregatesActive;
    property AutoCalcFields;
    property CommandText;
    property ConnectionBroker;
    property Constraints;
    property DataSetField;
    property DisableStringTrim;
    property FileName;
    property Filter;
    property Filtered;
    property FilterOptions;
    property FieldDefs;
    property IndexDefs;
    property IndexFieldNames;
    property IndexName;
    property FetchOnDemand;
    property MasterFields;
    property MasterSource;
    property ObjectView;
    property PacketRecords;
    property Params;
    property ProviderName;
    property ReadOnly;
    property RemoteServer;
    property StoreDefs;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
    property OnReconcileError;
    property BeforeApplyUpdates;
    property AfterApplyUpdates;
    property BeforeGetRecords;
    property AfterGetRecords;
    property BeforeRowRequest;
    property AfterRowRequest;
    property BeforeExecute;
    property AfterExecute;
    property BeforeGetParams;
    property AfterGetParams;
  end;

  TFormCoat = class(TComponent)
  private
    lst: TList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function Add(Item: TWinControl): Integer;
    function ShowTab(Value: Integer): Boolean;
    function GetForm(Index: Integer): IBaseForm;
  end;
  
  TZjhDateRange = class(TWinControl)
  private
    { Private declarations }
    FPopupMenu: TPopupMenu;
    FMinDate: TDateTimePicker;
    FMaxDate: TDateTimePicker;
    FButton: TSpeedButton;
    FCheckBox: TCheckBox;
    procedure BoxResize(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure MenuClick(Sender: TObject);
    function GetMinDate: TDateTime;
    procedure SetMinDate(const Value: TDateTime);
    function GetMaxDate: TDateTime;
    procedure SetMaxDate(const Value: TDateTime);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    function GetCaption: String;
    procedure SetCaption(const Value: String);
    function GetChecked: Boolean;
    procedure SetChecked(const Value: Boolean);
  public
    { Public declarations }
    property Min: TDateTime read GetMinDate write SetMinDate;
    property Max: TDateTime read GetMaxDate write SetMaxDate;
    procedure SetRange(Index: Integer);
    property dtpFrom: TDateTimePicker read FMinDate;
    property dtpTo: TDateTimePicker read FMaxDate;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Checked: Boolean read GetChecked write SetChecked default True;
    property Caption: String read GetCaption write SetCaption;
  end;
  //ERP专用数据包裹
  TErpPack = class
  private
    FData: OleVariant;
    FLabel: String;
    function GetData(Index: Integer): OleVariant;
    procedure SetData(Index: Integer; const Value: OleVariant);
  public
    function Init(const Values: array of Variant): TErpPack;
    property Lable: String read FLabel write FLabel;
    property Data[Index: Integer]: OleVariant read GetData write SetData; default;
  end;
  //
  TSelectCodeEvent = procedure(K: Integer; V: TErpPack) of object;
  TSelectCode = class(TComponent)
  private
    { Private declarations }
    FKing: Integer;
    FActiveMulti: Boolean;
    FMultiSelect: Boolean;
    FParam: TMemIniFile;
    FOnSelected: TSelectCodeEvent;
    procedure SetKing(const Value: Integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Select(V: TErpPack): Boolean;
  published
    { Published declarations }
    function Param: TMemIniFile;
    property Kind: Integer read FKing write SetKing default 0;
    property OnSelected: TSelectCodeEvent read FOnSelected write FOnSelected;
    property ActiveMulti: Boolean read FActiveMulti write FActiveMulti stored False;
    property MultiSelect: Boolean read FMultiSelect write FMultiSelect stored False;
  end;
  //建树形用数据集
  TTVPartner = class(TComponent)
  private
    FTreeView: TTreeView;
    FRemoteServer: TCustomRemoteServer;
    FExpanded: Boolean;
    FVirNode: Boolean;
    FEmptyName: String;
    FDataSet: TDataSet;
  public
    constructor Create(AOwner: TComponent); override;
  public
    Root: TTreeNode;
    function IsVirtual(Node: TTreeNode): Boolean;
    procedure Delete(Item: TTreeNode; HasData: Boolean);
    function AppendNode(ARoot: TTreeNode; const ACode, AName: String): TTreeNode;
    function Execute(const ACodeField, ANameField: String): Integer; overload;
    function Execute(const SQLCmd: String): Integer; overload;
    procedure Clear(Sender: TTreeView);
  published
    property RemoteServer: TCustomRemoteServer read FRemoteServer write FRemoteServer;
    property TreeView: TTreeView read FTreeView write FTreeView;
    property EmptyName: String read FEmptyName write FEmptyName;
    property Expanded: Boolean read FExpanded write FExpanded default True;
    property VirNode: Boolean read FVirNode write FVirNode default False;
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

  //建立树形维护窗体
  TTFPartner = class(TComponent)
  private
    FSec: TZjhTool;
    FTreeView: TTreeView;
    FDataSet: TDataSet;
    FScrollSource: Integer;
    FKeyCode, FKeyName: String;
    m_AfterScroll: TDataSetNotifyEvent;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure DataSetAfterScroll(DataSet: TDataSet);
    procedure SecAppend(Sender: TObject);
    procedure SecFind(Sender: TObject);
    procedure SecDelete(Sender: TObject);
    procedure DataSetBeforeInsert(DataSet: TDataSet);
    procedure DataSetCode_Validate(Sender: TField);
    procedure DataSetName_Validate(Sender: TField);
    procedure TreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
  protected
    function ErpInput(const ATitle, APrompt: String;
      const ADefault: String = ''; const ACancel: String = ''): String;
  public
    constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
    function Execute: Boolean; virtual;
  published
    property TreeView: TTreeView read FTreeView write FTreeView;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property Sec: TZjhTool read FSec write FSec;
    property KeyCode: String read FKeyCode write FKeyCode;
    property KeyName: String read FKeyName write FKeyName;
  end;
  //
  TZjhTreeView = class(TTreeView)
  private
    FBitMap: TBitMap;
    FInterDrawing: boolean;
    procedure PaintBei;
    procedure SetBitMap(const Value: TBitmap);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    property Background: TBitmap read FBitMap write SetBitMap;
  end;
  //
  TImeWinControl = Class(TWinControl)
  public
    property ImeMode;
  end;
  //转传票作业
  PHRAnyToAccRecord = ^THRAnyToAccRecord;
  THRAnyToAccRecord = record
    DrCr: Char;
    AccCode: String;
    Desp: String;
    OriAmount: Double;
    Currency: String;
    ExRate: Double;
    ObjCode: String;
    Flag: String;
    CostDept: String; //Add by jrlee at 2006/9/8
  end;
  THRAnyToAcc = class(TComponent)
  private
    FItems: TList;
    FTBDate: TDateTime;
    FAccTB: String;
    FManageNo: String;
    FABSource: String;
    FSourceTBNo: String;
    //FSelect: TSelectCode;
    //FOnExecuted: TNotifyEvent;
    FAccTBNo: String;
    FSelectObject: TSelectCode;
    {$IFDEF ERP2011}
    FTagValue: String;
    {$ENDIF}
    //FWorkClassName: String;
    function GetItems(Index: Integer): PHRAnyToAccRecord;
    procedure SetTBDate(const Value: TDateTime);
    procedure SetAccTB(const Value: String);
    procedure SetManageNo(const Value: String);
    procedure SetSourceTBNo(const Value: String);
    procedure SetSelectObject(const Value: TSelectCode);
    {$IFDEF ERP2011}
    procedure SetTagValue(const Value: String);
    {$ENDIF}
    //procedure DefaultSelected(Kind: Integer; V: TErpPack);
    //procedure SetOnExecuted(const Value: TNotifyEvent);
    //procedure SetWorkClassName(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    function Count: Integer;
    function Add(const DrCr: Char): PHRAnyToAccRecord;
    property Items[Index: Integer]: PHRAnyToAccRecord read GetItems; default;
    property TBDate: TDateTime read FTBDate write SetTBDate;
    property ManageNo: String read FManageNo write SetManageNo;
    property AccTB: String read FAccTB write SetAccTB;
    property ABSource: String read FABSource;
    property AccTBNo: String read FAccTBNo;
    property SourceTBNo: String read FSourceTBNo write SetSourceTBNo;
    {$IFDEF ERP2011}
    property TagValue: String read FTagValue write SetTagValue;
    {$ENDIF}
  public
    procedure Reset(const ACode, ATBNo: String);
    function Execute(AKind: Integer): Boolean;
  published
    property SelectObject: TSelectCode read FSelectObject write SetSelectObject;
    //property OnExecuted: TNotifyEvent read FOnExecuted write SetOnExecuted;
  end;
  TBookManageOperate = (bmoInsert, bmoAppend, bmoDelete, bmoInit, bmoEnabled, bmoDisabled, bmoReset, bmoCurrent);
  IBookManage = interface
    ['{792F4C9E-9DED-4FB6-818D-91D6C00E1D68}']
    function AllowUpdate(Operate: TBookManageOperate; const CurMonth: String): Boolean;
    function GetOperateState: TBookManageOperate;
    procedure BeforeUpdate;
    procedure AfterUpdate;
  end;
  // Find Tool
  TCreateSQLWhere = class
  private
    m_DefaultText: String;
    m_SQLText: String;
    m_AllRecord: Boolean;
    FDataSet: TZjhDataSet;
    FMaxRecord: String;
    function GetSQLText: String;
    //function HasValue: Boolean;
  public
    procedure AddParam(Text: String);
    procedure AddParamStr(FieldName,Value: String); overload;
    procedure AddParamStr(FieldName: String; Val1,Val2: String); overload;
    procedure AddParamStrBt(FieldName: String; Val1,Val2: Variant);
    procedure AddParamBool(FieldName: String; Val: Boolean);
    procedure AddParamInt(FieldName: String; Val: Integer);overload;
    procedure AddParamInt(FieldName: String; Val1,val2: Integer); overload;
    procedure AddParamFloat(FieldName: String; Val1,val2: Double);
    procedure AddParamDate(FieldName: String; Val1, Val2: TDate); overload;
    procedure AddParamDate(FieldName: String; Val: TDate); overload;
    procedure AddParamRad(FieldName: String; const s: Integer);
    property DefaultText: String read m_DefaultText write m_DefaultText;
    property AllRecord: Boolean read m_AllRecord write m_AllRecord;
    property SQLText: String read GetSQLText write m_SQLText;
  public
    property DataSet: TZjhDataSet read FDataSet write FDataSet;
    procedure SetMaxRecord(const ACheck: TCheckBox; const AEdit: TEdit);
    procedure AddObject(const KeyField: String; const Args: array of TObject;
      AType: Integer = 0);
    function Execute(const SQLTemplate: String; const SQLOrder: String = ''): Boolean; overload;
    function Execute(cdsSearch: TDataSet; const SQLTemplate: String;
      const SQLOrder: String = ''): Boolean; overload;
    procedure CheckAllPlugins(Sender: TComponent);
  end;
  //加强版 TCreateSQLWhere
  TBuildSQL = class(TComponent, IOutputMessage2)
  private
    f: TCreateSQLWhere;
    FMaxRecord: String;
    procedure SetDataSet(const Value: TZjhDataSet);
    procedure SetDefaultText(const Value: String);
    function GetAllRecord: Boolean;
    procedure SetAllRecord(const Value: Boolean);
    function GetDefaultText: String;
    function GetDataSet: TZjhDataSet;
    function CDate(Value: TDateTime): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //专用于如exists之类条件
    procedure AddParam(const AParam: String);
    //多栏位模糊查找
    procedure ParamByLink(const AFields: array of string; const Value: String);
    //查找栏位是否允许为空
    procedure ParamByNull(const AField: String; Value: Boolean = True);
    //
    procedure AddObject(const AField: String;
      const Args: array of TObject; AType: Integer = 0);
    //
    procedure SetMaxRecord(const ACheck: TCheckBox; const AEdit: TEdit);
    //一个参数
    procedure ParamByField(const AField, Value: String); overload;
    procedure ParamByField(const AField: String; Value: Integer); overload;
    procedure ParamByField(const AField: String; Value: Double); overload;
    procedure ParamByField(const AField: String; Value: TDateTime); overload;
    procedure ParamByField(const AField: String; Value: Boolean); overload;
    //二个参数
    procedure ParamByBetween(const AField: String; const Value1, Value2: String); overload;
    procedure ParamByBetween(const AField: String; const Value1, Value2: Integer); overload;
    procedure ParamByBetween(const AField: String; const Value1, Value2: Double); overload;
    procedure ParamByBetween(const AField: String; const Value1, Value2: TDateTime); overload;
    //多个参数
    procedure ParamByRange(const AField: String; Values: array of String); overload;
    procedure ParamByRange(const AField: String; Values: array of Integer); overload;
    procedure ParamByRange(const AField: String; Values: array of Double); overload;
  public
    function Execute(const ASelect: String; const AOrder: String = ''): Boolean; virtual;
    function GetCommandText(const ASelect: String; const AOrder: String): String;
    //IOutputMessage2
    procedure OutputMessage(Sender: TObject; const Value: String; MsgLevel: TMsgLevelOption);
  public
    property AllRecord: Boolean read GetAllRecord write SetAllRecord;
    property DataSet: TZjhDataSet read GetDataSet write SetDataSet;
    property DefaultText: String read GetDefaultText write SetDefaultText;
  end;
  //加强版 TBuildSQL
  TBuildSQL2 = class(TComponent)
  private
    FDataSet: TDataSet;
    FDefaultText: String;
    FSQLText: String;
    FAllRecord: Boolean;
    FMaxRecord: String;
    function CDate(Value: TDateTime): String;
    procedure AddParamStr(FieldName,Value: String); overload;
    function GetCommandText: string;
  public
    constructor Create(AOwner: TComponent); override;
    //设置最大载入笔数
    procedure SetMaxRecord(const ACheck: TCheckBox; const AEdit: TEdit);
    //专用于如exists之类条件
    procedure AddParam(const AParam: String);
    //多栏位模糊查找
    procedure ParamByLink(const AFields: array of string; const Value: String);
    //查找栏位是否允许为空
    procedure ParamByNull(const AField: String; Value: Boolean = True);
    //一个参数
    procedure ParamByField(const AField, Value: String); overload;
    procedure ParamByField(const AField: String; Value: Integer); overload;
    procedure ParamByField(const AField: String; Value: Double); overload;
    procedure ParamByField(const AField: String; Value: TDateTime); overload;
    procedure ParamByField(const AField: String; Value: Boolean); overload;
    //二个参数
    procedure ParamByBetween(const AField: String; const Value1, Value2: String); overload;
    procedure ParamByBetween(const AField: String; const Value1, Value2: Integer); overload;
    procedure ParamByBetween(const AField: String; const Value1, Value2: Double); overload;
    procedure ParamByBetween(const AField: String; const Value1, Value2: TDateTime); overload;
    //多个参数
    procedure ParamByRange(const AField: String; Values: array of String); overload;
    procedure ParamByRange(const AField: String; Values: array of Integer); overload;
    procedure ParamByRange(const AField: String; Values: array of Double); overload;
  public
    function Execute(const SQLTemplate: String; const SQLOrder: String = ''): Boolean; virtual;
    function BuildCommand(const SQLTemplate: String; const SQLOrder: String = ''): string; virtual;
    property DataSet: TDataSet read FDataSet;
    property DefaultText: String read FDefaultText write FDefaultText;
    property MaxRecord: string read FMaxRecord write FMaxRecord;
    property CommandText: string read GetCommandText;
  end;
  //自定义表格
  TZjhDBGrid = class(TDBGrid)
  private
    FSortOnClickTitle: Boolean;
    //点击DBGrid标题并按标题排序
    function GridSortByColumn(Grid: TCustomDBGrid; Column: TColumn): Boolean;
  protected
    procedure TitleClick(Column: TColumn); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property SortOnClickTitle: Boolean read FSortOnClickTitle write FSortOnClickTitle default True;
  end;
  {$message 'TPYIME 后续可以移到 BaseApp 中！Jason at 2014/1/22'}
  TPYIMERecord = record
    Code: string;
    Value: string;
  end;
  TPYIME = class(TComponent)
  private
    FDict: array of TPYIMERecord;
    function GetPinyin(const AValue: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetShortCode(const AValue: string): string;
  end;
  //本月第一天
  function MonthBof(Value: TDate):Tdate;
  //本月最后天
  function MonthEof(Value: TDate):Tdate;
  // 返回一个临时文件名
  function GetTempFile(const ExtName: String = '.tmp'): String;
  //批次字段复制
  procedure CopyFields(Target, Source: TDataSet;
    const Args: array of String); overload;
  procedure CopyFields(Target: TDataSet; const Args1: array of String;
    Source: TDataSet; const Args2: array of String); overload;
  procedure CopyFields(Target: TDataSet; const Args1: String;
    Source: TDataSet; const Args2: String = ''); overload;
  procedure CopyFields2(Source, Target: TDataSet;
    const Args: array of String);
  //设置DBGird外观
  function GetColOptions(Col: TColumn): String;
  procedure SetColOptions(ACol: TColumn; const Value: String);
  procedure SetDBGridIndex(AGrid: TDBGrid);
  function OpenConfigFile(const RootName: DOMString;
    var Root: IXMLNode): TXMLDocument;
  //在指定的字符串 Value 中，查找指定字符串 SubStr，并替换为 RplStr
  function Replace(const Value, SubStr, RplStr: String): String;
  // 将字符型数字进行"修理"
  function FixIntStr(const Value: String; Default: Integer): String;
  //读取单据状态的图标显示
  procedure SetImageRes(Image: TImage; ResID: Integer);
  //显示对象窗体，并调用CONST_GOTORECORD
  function ViewDetail(const ClassName: String; const Param: Variant): IBaseForm;

const
  ActionStr: array[TReconcileAction] of string = ('Skip', 'Abort', 'Merge',
    'Correct', 'Cancel', 'Refresh');
  UpdateKindStr: array[TUpdateKind] of string = ('Modified', 'Inserted',
    'Deleted');
  SCaption = 'Update Error - %s';
  SUnchanged = '<Unchanged>';
  SBinary = '(Binary)';
  SAdt = '(ADT)';
  SArray = '(Array)';
  SFieldName = 'Field Name';
  SOriginal = 'Original Value';
  SConflict = 'Conflicting Value';
  SValue = ' Value';
  SNoData = '<No Records>';
  SNew = 'New';
  CONST_UPDATEDATABASE = 987654321;

procedure Register;

implementation

uses Consts, SysUtils, ActnList, ApConst, InfoBox, AppDB, AppBean;

var
  __PYIME: TPYIME;

{$R *.res}

procedure Register;
begin
  RegisterComponents(SOFTWARE_NAME, [TZjhSkin]);
  RegisterComponents(SOFTWARE_NAME, [TZjhTool]);
  RegisterComponents(SOFTWARE_NAME, [TZjhDataSet]);
  RegisterComponents(SOFTWARE_NAME, [TZjhDateRange]);
  RegisterComponents(SOFTWARE_NAME, [TSelectCode]);
  RegisterComponents(SOFTWARE_NAME, [TTVPartner]);
  RegisterComponents(SOFTWARE_NAME, [TTFPartner]);
  RegisterComponents(SOFTWARE_NAME, [TZjhTreeView]);
  RegisterComponents(SOFTWARE_NAME, [THRAnyToAcc]);
  RegisterComponents(SOFTWARE_NAME, [TZjhDBGrid]);
end;

{ TDBIniFile }

destructor TDBIniFile.Destroy;
begin
  inherited;
  if Assigned(FReportField) then
  begin
    with FReportField.DataSet do
      if not (State in [dsEdit,dsInsert]) then Edit;
    FReportField.LoadFromFile(Self.FileName);
    DeleteFile(Self.FileName);
  end;
end;

procedure TDBIniFile.SetReportField(const Value: TWideMemoField);
begin
  FReportField := Value;
  if Assigned(Value) then Value.SaveToFile(Self.FileName);
end;

{ TZjhTool }

constructor TZjhTool.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TFieldDataLink.Create;
  FDataTool := TDataTool.Create;
  FDataLink.OnActiveChange := DataActiveChange;
  DefaultOptions := [doRecordMove];
  //SecurityID := GuidNull;
  FMainTool := True;
  FFormActivate := TForm(Self.Owner).OnActivate;
  FFormClose := TForm(Self.Owner).OnClose;
  FUpdateStatus := True;
  FSecMenu := TZjhMainMenu.Create;
  FSecurity := True;
end;

destructor TZjhTool.Destroy;
begin
  FreeAndNil(FDataLink);
  FreeAndNil(FSecMenu);
  FreeAndNil(FDataTool);
  inherited;
end;

procedure TZjhTool.Refresh(Sender: TObject);
begin
  if Assigned(FOnRefresh) then FOnRefresh(Sender);
end;

function TZjhTool.GetDataSource: TDataSource;
begin
  Result := FDataTool.DataSource;
end;

procedure TZjhTool.SetDataSource(const Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  FDataTool.DataSource := Value;
end;

procedure TZjhTool.PutError(Value: String);
begin
  ibox.Text(Value);
end;

procedure TZjhTool.PutMessage(Value: String);
begin
  ibox.Text(Value);
end;

//-----------------------------------------------------------------------------
procedure TZjhTool.Find;
begin
  if Assigned(FOnFind) then
    FOnFind(Self);
end;

procedure TZjhTool.ChangeStatus(NewStatus: Integer);
var
  doAction: QDefaultOption;
begin
  if NewStatus = 1 then
    begin
      if not Pass('Final',True) then Exit;
      doAction := doConfirm
    end
  else if NewStatus = 0 then
    begin
      if not Pass('Cancel',True) then Exit;
      doAction := doUnChange
    end
  else //if NewStatus = -1
    begin
      if not Pass('Recycle',True) then Exit;
      if not ureg.ReadBool('system', 'VineClient', False) then
      begin
        if MessageDlg(Chinese.AsString('警告：数据作废后不可执行还原！您真的要这样做吗？'),
          mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
      end;
      doAction := doCancelLation;
    end;
  if AskExecute(Self,doAction) then
  begin
    if Assigned(FOnChangeStatus) then
      FOnChangeStatus(Self,NewStatus);
  end;
end;

function TZjhTool.Append(): Boolean;
begin
  Result := False;
  if not Pass('Append',True) then
    Exit;
  if AskExecute(Self,doAppend) then
  begin
    if not Assigned(FOnAppend) then
      begin
        if FDataTool.Append() then
          begin
            PutMessage(Chinese.AsString('已经增加了一条新的记录。'));
            Result := True;
          end
        else
          PutError(FDataTool.Error.Text);
      end
    else
      begin
        Result := True;
        FOnAppend(Self);
      end;
  end;
  if Result then
    FUpdateStatus := True;
end;

function TZjhTool.Edit(): Boolean;
begin
  Result := False;
  if not Pass('Modify',True) then
    Exit;
  if AskExecute(Self,doEdit) then
  begin
    if not Assigned(FOnEdit) then
      begin
        if FDataTool.Edit() then
          begin
            PutMessage(Chinese.AsString('记录已处于编辑状态。'));
            Result := True;
          end
        else
          PutError(FDataTool.Error.Text);
      end
    else
      FOnEdit(Self);
  end;
end;

function TZjhTool.Delete(): Boolean;
begin
  Result := False;
  if not Pass('Delete',True) then Exit;
  if AskExecute(Self,doDelete) then
  begin
    if not Assigned(FOnDelete) then
      begin
        if FDataTool.Delete() then
          begin
            PutMessage(Chinese.AsString('记录已被删除。'));
            Result := True;
          end
        else
          PutError(FDataTool.Error.Text);
      end
    else
      begin
        Result := True;
        FOnDelete(Self);
      end;
  end;
  if Result then FUpdateStatus := True;
end;

function TZjhTool.Save: Boolean;
begin
  Result := False;
  try
    if not Pass('Modify',True) then Exit;
    if AskExecute(Self,doSave) then
    begin
      if not Assigned(FOnSave) then
        begin
          FDataTool.Save();
          PutMessage(Chinese.AsString('记录被保存。'));
          Result := True;
        end
      else
        begin
          FOnSave(Self);
          Result := True;
        end;
    end;
  except
    on E: Exception do ShowMessage(E.Message);
  end;
end;

function TZjhTool.RecordMove(rmAction: TRecordMoveOption): Boolean;
var
  Msg: String;
  DoDefault: Boolean;
  function Move(): Boolean;
  begin
    Result := FDataTool.RecordMove(rmAction);
    case rmAction of
    rmFirst: Msg := Chinese.AsString('已到第一条记录。');
    rmPrior: Msg := Chinese.AsString('已移到上一条记录。');
    rmNext: Msg := Chinese.AsString('已到下一条记录。');
    rmLast: Msg := Chinese.AsString('已到最后一条记录。');
    end;
    if not Result then
      begin
        if FDataTool.Error.Count > 0 then PutError(FDataTool.Error.Text);
      end
    else
      PutMessage(Msg);
  end;
begin
  //ShowMessage('RecordMove');
  Result := False;
  if AskExecute(Self,doRecordMove) then
  begin
    DoDefault := False;
    if Assigned(FOnRecordMove) then
      begin
        FOnRecordMove(Self,rmAction,DoDefault);
        if DoDefault then Result := Move() else Result := True;
      end
    else
      Result := Move();
  end;
  if Result then FUpdateStatus := True;
end;

function TZjhTool.Requery: Boolean;
begin
  Result := False;
  try
    if AskExecute(Self,doRequery) then
    begin
      if not Assigned(FOnRequery) then
        begin
          if FDataTool.Requery() then
          begin
            PutMessage(Chinese.AsString('记录集已经刷新。'));
            Result := True;
          end;
        end
      else
        begin
          FOnRequery(Self);
          Result := True;
        end;
    end;
  except
    on E: Exception do ShowMessage(E.Message);
  end;
  //Modify by Jason 2006/11/2
  {
  Result := False;
  if AskExecute(Self,doRequery) then
  begin
    if not Assigned(FOnRequery) then
      begin
        if FDataTool.Requery() then
          begin
            PutMessage(Chinese.AsString('记录集已经刷新。'));
            Result := True;
          end
        else
          PutError(FDataTool.Error.Text);
      end
    else
      FOnRequery(Self);
  end;
  }
end;

function TZjhTool.GetSourceType: TSourceTypeOption;
begin
  Result := FDataTool.SourceType;
end;

function TZjhTool.AskEnabled(Sender: TObject;
  doAction: QDefaultOption): Boolean;
begin
  Result := False;
  if Assigned(Self.DataSource) and Assigned(DataSource.DataSet) then
  begin
    Result := doAction in DefaultOptions;
    with DataSource.DataSet do
    begin
      case doAction of
      doRecordMove,doAppend,doDelete,doEdit,doSave,doRequery:
        if not Active then Result := False;
      doConfirm,doUnChange,doCancelLation:
        begin
            if Active and (RecordCount > 0) then
            begin
              if (FindField('CorpCode_') <> nil)
                and (FindField('Enabled_') <> nil)
                and (FindField('Enabled_').DataType = ftBoolean) then
              begin
                case doAction of
                doConfirm:      Result := not FieldByName('Enabled_').AsBoolean;
                doUnChange:     Result :=     FieldByName('Enabled_').AsBoolean;
                doCancelLation: Result :=     FieldByName('Enabled_').AsBoolean;
                end;
              end;
            end
          else
            Result := False;
        end
      end;
    end;
  end;
  if Assigned(FOnUpdateStatus) then begin
    FOnUpdateStatus(Sender,doAction,Result);
  end
end;

function TZjhTool.AskExecute(Sender: TObject;
  doAction: QDefaultOption): Boolean;
var
  Allow: Boolean;
begin
  Allow := AskEnabled(Self,doAction);
  if Allow and Assigned(FOnBeforeExecute) then
     FOnBeforeExecute(Sender,doAction,Allow);
  Result := Allow;
end;

function TZjhTool.Pass(const strKey: String; bError: Boolean): Boolean;
begin
  {
  Execute      //01
  Final        //02: 單據確認
  Append       //03
  Modify       //04
  Delete       //05
  Print        //06
  PrintSet     //07
  Cancel       //08: 單據撤消
  MoneyDisplay //09
  MoneyModify  //10
  Output       //11
  FreeFlow     //12
  DownFile     //13
  ShareMyData  //14
  Recycle      //15: 單據作廢
  ReadCED      //16: 查看 CED
  }
  if FSecurity and FMainTool then
    begin
      Result := MainIntf.Passport(Self.Passport, strKey, bError)
    end
  else
    Result := True;
end;

function TZjhTool.SecEvent(Kind: Integer; Sender: TObject): Boolean;
begin
  Result := False;
  if SecMenu.IndexOf(Kind) > -1 then
  begin
    if Assigned(FOnSecEvent) then FOnSecEvent(Kind, Sender);
    Result := True;
  end;
end;

procedure TZjhTool.DataActiveChange(Sender: TObject);
begin
  FUpdateStatus := True;
end;

function TZjhTool.PostMessage(Sender: TObject; MsgType: Integer): Variant;
begin
  case MsgType of
   1:  //刷新
    begin
      Result := Self.Requery;
    end;
   2:  //预览
    begin
      //Result := ReportOutput(rfPreview);
    end;
   3:  //快印
    begin
      //Result := ReportOutput(rfPrint);
    end;
   4:  //搜寻
    begin
      Find;
      Result := True;
    end;
   5:  //增加
    begin
      Result := Append;
    end;
   6:  //删除
    begin
      Result := Delete;
    end;
   7:  //修改
    begin
      Result := Edit;
    end;
   9:  //保存
    begin
      Result := Save;
    end;
   8:  //确认
    begin
      ChangeStatus(1);
      Result := True;
    end;
  10: //撤消
    begin
      ChangeStatus(0);
      Result := True;
    end;
  11: //作废
    begin
      ChangeStatus(-1);
      Result := True;
    end;
  12: //上笔
    begin
      Result := RecordMove(rmPrior);
    end;
  13: //下笔
    begin
      Result := RecordMove(rmNext);
    end;
  14: //到头
    begin
      Result := RecordMove(rmFirst);
    end;
  15: //到尾
    begin
      Result := RecordMove(rmLast);
    end;
  else
    if Supports(Self.Owner, IBaseForm) then
      Result := (Self.Owner as IBaseForm).PostMessage(CONST_SECMESSAGE, MsgType)
    else
      Result := False;
  end;
end;

procedure TZjhTool.UpdateSecurity;
begin
  if Assigned(FOnUpdateSecurity) then
    FOnUpdateSecurity(Self);
end;

function TZjhTool.GetPassport: String;
begin
  if FPassport = '' then
    begin
      if Assigned(Self.Owner) then
        begin
          Result := '';
          if Supports(Owner, IBaseForm) then
            Result := (Owner as IBaseForm).AliaName;
          if Result = '' then
            Result := Owner.ClassName;
        end
      else
        Result := 'FREEMAN';
    end
  else
    Result := FPassport;
end;

procedure TZjhTool.SetPassport(const Value: String);
begin
  FPassport := Value;
end;

{ TZjhDataSet }

constructor TZjhDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DM) then
    Self.RemoteServer := DM.DCOM;
  //m_SQL := TStringList.Create;
  m_Children := TChildDataSet(TStringList.Create);
  FetchOnDemand := False;
  ProviderName := 'dspSQL';
  OnReconcileError := mReconcileError;
  FUpdateKey := True;
end;

destructor TZjhDataSet.Destroy;
begin
  if Assigned(m_Children) then
  begin
    m_Children.Free; m_Children := nil;
  end;
  inherited;
end;

procedure TZjhDataSet.mReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  if sreg.ReadBool('AppSvr','Debug', False) then
    Action := HandleReconcileError(DataSet, UpdateKind, E)
  else
    raise Exception.Create(Chinese.AsString('将修改保存到服务器没有成功，主要原因：') + vbCrLf + E.Message);
end;

procedure TZjhDataSet.PostPro(MaxErrors: Integer);
//var
//  i: Integer;
//  Keys: array of string;
begin
  if State in [dsEdit,dsInsert] then Post;
  if (ChangeCount > 0) then
  begin
    {
    //解决有关于如Part更新问题，Jason Modify, 2006/5/25
    for i := 0 to Fields.Count - 1 do
    begin
      if pfInKey in Fields[i].ProviderFlags then
      begin
        SetLength(Keys, High(Keys) + 2);
        Keys[High(Keys)] := Fields[i].FullName;
      end;
    end;
    if High(Keys) > -1 then
      PostPro(Keys)
    else
    }
    ApplyUpdates(MaxErrors)
  end;
end;

{
procedure TZjhDataSet.PostPro(const Keys: array of string);
var
  fd: TField;
  i, k: Integer;
  mDefault: TCursor;
  sUpdate, sWhere: String;
  Args: array of Variant;
  cdsTmp: TClientDataSet;
begin
  if State in [dsEdit,dsInsert] then Post;
  //
  if m_TableName = '' then
    raise Exception.Create('PostPro Error: TableName = NULL');
  mDefault := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  cdsTmp := TClientDataSet.Create(Self);
  try
    cdsTmp.Data := Delta;
    SetLength(Args, cdsTmp.Fields.Count);
    with cdsTmp do
    for i := 1 to RecordCount div 2 do
    begin
      //取修改前记录
      RecNo := i * 2 -1;
      for k := 0 to Fields.Count - 1 do
        Args[k] := Fields[k].Value;
      //取更新关键字段
      sWhere := '';
      for k := Low(Keys) to High(Keys) do
      begin
        fd := FindField(Keys[k]);
        if Assigned(fd) then
          sWhere := sWhere + Format('%s=''%s'' and ', [fd.FullName, fd.AsString]);
      end;
      if (sWhere <> '') then
        sWhere := Copy(sWhere, 1, Length(sWhere)-5)
      else
        raise Exception.Create('PostPro Error: Where = NULL');
      //取修改后记录
      Next;
      sUpdate := '';
      for k := 0 to Fields.Count - 1 do
      begin
        if (Fields[k].Value <> Args[k]) then
        begin
          if not Fields[k].IsNull then
            sUpdate := sUpdate + Format('%s=''%s'',',[Fields[k].FullName, Fields[k].AsString]);
        end;
      end;
      if sUpdate <> '' then
        sUpdate := Copy(sUpdate, 1, Length(sUpdate)-1)
      else
        raise Exception.Create('PostPro Error: Update = NULL');
      sUpdate := Format('Update %s Set %s Where %s', [m_TableName, sUpdate, sWhere]);
      MainIntf.PostMessage(CONST_MAININTF_COMMAND, VarArrayOf([sUpdate, FDatabase]));
    end;
    MergeChangeLog;
  finally
    Screen.Cursor := mDefault;
    FreeAndNil(cdsTmp);
    Args := nil;
  end;
end;

procedure TZjhDataSet.PostPro(const AKey: string);
begin
  if AKey <> '' then
    PostPro([AKey])
  else
    PostPro(['UpdateKey_']);
end;
}

function TZjhDataSet.AddChildren(ChildDataSet: TZjhDataSet;
  const ChildID, MasterID, SQLText: String): Integer;
var
  SQLCmd: String;
begin
  //m_HasChildren := True;
  if SQLText = '' then
    SQLCmd := Format('%s=%s=%s',[MasterID,ChildID,ChildDataSet.CommandText]) + ' Where %s=''%s'''
  else
    SQLCmd := Format('%s=%s=%s',[MasterID,ChildID,SQLText]);
  Result := m_Children.AddObject(SQLCmd,ChildDataSet);
end;

procedure TZjhDataSet.DoBeforeApplyUpdates(var OwnerData: OleVariant);
begin
  if m_TableName <> '' then OwnerData := TableName;
  if FDatabase <> '' then
    OwnerData := VarArrayOf([CONST_UPDATEDATABASE, FDatabase, OwnerData]);
  inherited;
end;

procedure TZjhDataSet.DoBeforeGetRecords(var OwnerData: OleVariant);
begin
    //(Application.MainForm as IMainForm).PostMessage(CONST_MAINFORM_DoOnBeforeGetRecords, Integer(Self));
  {
  OwnerData := Self.CommandText;
  	if Assigned(DM) and (DM.Version = 2008) then
    begin
      //if SQL.Count > 0 then
      //  OwnerData := VarArrayOf([Self.PacketRecords, SQL.Text]);
	  OwnerData := VarArrayOf([Self.PacketRecords, SQL.Text])
    end
  else
    OwnerData := Self.CommandText;
  }
  if FDatabase <> '' then
    OwnerData := VarArrayOf([CONST_UPDATEDATABASE, FDatabase, OwnerData]);
  inherited DoBeforeGetRecords(OwnerData);
end;

function TZjhDataSet.DataRequest(Data: OleVariant): OleVariant;
begin
  if FDatabase <> '' then
    Result := AppServer.AS_DataRequest(ProviderName,
      VarArrayOf([CONST_UPDATEDATABASE,FDatabase, Data]));
  inherited DataRequest(Data);
end;

procedure TZjhDataSet.DoBeforeRowRequest(var OwnerData: OleVariant);
begin
  if FDatabase <> '' then
    OwnerData := VarArrayOf([CONST_UPDATEDATABASE, FDatabase, OwnerData]);
  inherited DoBeforeRowRequest(OwnerData);
end;

procedure TZjhDataSet.DoBeforeExecute(var OwnerData: OleVariant);
begin
  ibox.DebugText(CommandText);
  if FDatabase <> '' then
    OwnerData := VarArrayOf([CONST_UPDATEDATABASE, FDatabase, OwnerData]);
  inherited DoBeforeExecute(OwnerData);
end;

procedure TZjhDataSet.GetMorePacket(const SQLText: String);
var
  cdsTmp: TZjhDataSet;
begin
  cdsTmp := TZjhDataSet.Create(nil);
  try
    cdsTmp.RemoteServer := Self.RemoteServer;
    cdsTmp.CommandText := SQLText;
    cdsTmp.Database := Self.Database;
    cdsTmp.Open;
    AppendData(cdsTmp.Data, True);
  finally
    cdsTmp.Free;
  end;
end;

procedure TZjhDataSet.SetTableName(const Value: String);
begin
  if m_TableName <> Value then
  begin
    if ((CommandText = '') or (CommandText = 'SELECT * FROM ' + m_TableName))
      and (Value <> '') then
      CommandText := 'SELECT * FROM ' + Value;
    m_TableName := Value;
  end;
end;

procedure TZjhDataSet.RequestScroll;
var
  i: Integer;
  savCursor: TCursor;
  ScrollAllow: Boolean;
  ErpDataSetB: TZjhDataSet;
  Item,MasterID,ChildID,SQLCmd: String;
  procedure StartScrollDataSet;
  begin
    MasterID := FieldByName(MasterID).AsString;
    SQLCmd := Format(SQLCmd,[ChildID,MasterID]);
    ErpDataSetB := Children.Objects[i] as TZjhDataSet;
    ScrollAllow := True;
    if Assigned(FOnRequestScroll) then FOnRequestScroll(Self,i,ScrollAllow);
    if ScrollAllow then
    begin
      with ErpDataSetB do
      begin
        DisableControls;
        if Active then
          begin
            Filtered := False;
            if not Locate(ChildID,MasterID,[]) then GetMorePacket(SQLCmd);
            //ShowMessage(SQLCmd);
          end
        else
          begin
            CommandText := SQLCmd;
            Open;
          end;
        Filter := ChildID + '=''' + MasterID +'''';
        Filtered := True;
        EnableControls;
      end;
    end;
  end;
begin
  if not Active then Exit;
  savCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    for i := 0 to Children.Count - 1 do
    begin
      Item := Children.Strings[i];
      MasterID := Copy(Item,1,pos('=',Item) - 1);
      Item := Copy(Item,pos('=',Item) + 1,Length(Item));
      ChildID  := Copy(Item,1,pos('=',Item) - 1);
      SQLCmd := Copy(Item,Length(ChildID) + 2,Length(Item));
      if Assigned(Children.Objects[i]) and (Children.Objects[i] is TZjhDataSet)
        and (not VarIsNull(FieldByName(MasterID).Value))
      then StartScrollDataSet;
    end;
  finally
    Screen.Cursor := savCursor;
  end;
end;

procedure TZjhDataSet.DoOnNewRecord;
var
  F: TField;
begin
  if Assigned(Application.MainForm) and Supports(Application.MainForm, IMainForm) then
  begin
    if Assigned(DM) then
    begin
      F := Self.FindField('CorpCode_');
      if Assigned(F) then F.AsString := DM.CurrCorp;
      F := Self.FindField('AppUser_');
      if Assigned(F) then F.AsString := DM.Account;
      F := Self.FindField('AppDate_');
      if Assigned(F) then F.AsDateTime := Now();
    end;
    //(Application.MainForm as IMainForm).PostMessage(CONST_MAINFORM_DoOnNewRecord, Integer(Self));
  end;
  inherited;
end;

procedure TZjhDataSet.DoBeforePost;
begin
  if FUpdateKey then
  begin
    if Assigned(Application.MainForm) and Supports(Application.MainForm, IMainForm) then
    begin
      MainIntf.DataSetBeforePost(Self);
    end;
  end;
  inherited;
end;

procedure TZjhDataSet.DoAfterScroll;
begin
  if Children.Count > 0 then RequestScroll;
  inherited;
end;

function TZjhDataSet.DoGetRecords(Count: Integer; out RecsOut: Integer;
  Options: Integer; const CommandText: WideString;
  Params: OleVariant): OleVariant;
var
  OwnerData: OleVariant;
begin
  //改进输入ibox.DebugText, 原放在DoBeforeGetRecords中
  //DoGetRecords(0, RecsOut, Byte(Options), '', Unassigned);
  if (Count <> 0) or (Options <> Byte(grReset)) or (Params <> Unassigned) then
    ibox.DebugText(CommandText);
  //
  DoBeforeGetRecords(OwnerData);
  if VarIsEmpty(Params) and (Self.Params.Count > 0) then
    Params := PackageParams(Self.Params);
  {$IFDEF ERPDEBUG}
  try
    Result := AppServer.AS_GetRecords(ProviderName, Count, RecsOut, Options,
      CommandText, Params, OwnerData);
  except
    on E: Exception do
    begin
      if Assigned(Self.Owner) then
        begin
          if Assigned(Self.Owner.Owner) then
            MsgBox(Self.Owner.Owner.ClassName + vbCrLf + Self.Owner.ClassName
              + vbCrLf + Self.Name + vbCrLf + E.Message + vbCrLf
              + 'use ' + Self.FDatabase + vbCrLf + CommandText)
          else
            MsgBox(Self.Owner.ClassName + vbCrLf + E.Message + vbCrLf
              + 'use ' + Self.FDatabase + vbCrLf + CommandText);
        end
      else
        MsgBox(E.Message + vbCrLf + 'use ' + Self.FDatabase + vbCrLf + CommandText);
    end;
  end;
  {$ELSE}
  Result := AppServer.AS_GetRecords(ProviderName, Count, RecsOut, Options,
    CommandText, Params, OwnerData);
  {$ENDIF}
  UnPackParams(Params, Self.Params);
  DoAfterGetRecords(OwnerData);
end;

procedure TZjhDataSet.SetUpdateKey(const Value: Boolean);
begin
  FUpdateKey := Value;
end;

procedure TZjhDataSet.SetFinalManage(const Value: Boolean);
begin
  FFinalManage := Value;
end;

procedure TZjhDataSet.DoBeforeEdit;
begin
  if FFinalManage then
  begin
    if FieldByName('Final_').AsBoolean then
    begin
      MsgBox(Chinese.AsString('数据已确认不允许修改，若确需修改请先撤消确认状态！'));
      Abort;
    end;
  end;
  inherited;
end;

procedure TZjhDataSet.DoBeforeDelete;
begin
  if FFinalManage then
  begin
    if FieldByName('Final_').AsBoolean then
    begin
      MsgBox(Chinese.AsString('数据已确认不允许删除，若确需删除请先撤消确认状态！'));
      Abort;
    end;
  end;
  inherited;
end;

{ TDataTool }

constructor TDataTool.Create;
begin
  inherited;
  FDataLink := TDataLink.Create;
  FError := TStringList.Create;
end;

destructor TDataTool.Destroy;
begin
   FDataLink.Free;
   FError.Free;
   inherited;
end;

function TDataTool.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDataTool.SetDataSource(const Value: TDataSource);
begin
  if Value <> FDatalink.Datasource then
    FDataLink.DataSource := Value;
end;

function TDataTool.GetSourceType: TSourceTypeOption;
begin
  Result := stDeactive;
  if not Assigned(FDataLink.DataSource) then Exit;
  if not FDataLink.DataSource.DataSet.Active then Exit;
  with FDataLink.DataSource.DataSet do
  begin
    if ClassNameIs('TADOTable') then
      Result := stADOTable
    else if ClassNameIs('TADOQuery') then
      Result := stADOQuery
    else if ClassNameIs('TADOStoredProc') then
      Result := stADOStoredProc
    else if ClassNameIs('TClientDataSet') then
      Result := stClientDataSet
    else if ClassNameIs('TZjhDataSet') then
      Result := stZjhDataSet
    else
      Result := stOtherSource;
  end;
end;

function TDataTool.Append: Boolean;
begin
  Error.Clear;
  Result := False;
  if Assigned(DataSource) and (SourceType in [stADOTable,stADOQuery,
    stClientDataSet,sTZjhDataSet])
  then
    begin
      DataSource.DataSet.Append();
      Result := True;
    end
  else
    Error.Add(Chinese.AsString('当前状态下，不允许增加记录！'));
end;

function TDataTool.Delete: Boolean;
begin
  Error.Clear;
  Result := False;
  if DataSource.DataSet.RecordCount > 0 then
    begin
      if MessageBox(0,PChar(Chinese.AsString('您真的要删除当前记录吗？')),
        PChar(Chinese.AsString('确认删除')), MB_YESNO + MB_ICONQUESTION) = IDYES
      then
      begin
        DataSource.DataSet.Delete();
        Result := True;
      end;
    end
  else
    begin
      if DataSource.DataSet.State in [dsInsert] then
        DataSource.DataSet.Cancel
      else
        Error.Add(Chinese.AsString('当前状态下，不允许删除记录！'));
    end;
end;

function TDataTool.Edit: Boolean;
begin
  Error.Clear;
  Result := False;
  try
    DataSource.DataSet.Edit;
    Result := True;
  except
    on E: Exception do Error.Add(E.Message);
  end;
  {
  if Assigned(DataSource) and (DataSource.DataSet.State <> dsEdit)
    and (SourceType in [stADOTable,stADOQuery,stClientDataSet,sTZjhDataSet])
  then
    begin
      if not (DataSource.DataSet as TZjhDataSet).ReadOnly then
        begin
         DataSource.DataSet.Edit();
         Result := True;
        end
      else
        Error.Add(RES_DATASET_READONLY);
    end
  else Error.Add(RES_TDATATOOL_EDIT_DISABLED);
  }
end;

function TDataTool.RecordMove(rmAction: TRecordMoveOption): Boolean;
begin
  Error.Clear;
  Result := False;
  if SourceType = stDeactive then
  begin
    Error.Add(Chinese.AsString('记录源没有打开，无法执行！'));
    Exit;
  end;
  //开始移动
  case rmAction of
  rmFirst:
    begin
      DataSource.DataSet.First();
    end;
  rmPrior:
    begin
      if not DataSource.DataSet.Bof then DataSource.DataSet.Prior();
    end;
  rmNext:
    begin
      if (not DataSource.DataSet.Eof) then DataSource.DataSet.Next();
    end;
  rmLast:
    begin
      DataSource.DataSet.Last;
    end;
  end;
  Result := True;
end;

function TDataTool.RecordMove(dsSource: TDataSource;
  rmAction: TRecordMoveOption; var ErrorInfo: String): Boolean;
var
  mDataSource: TDataSource;
  mErrorText: String;
begin
  mDataSource := DataSource;
  mErrorText := Error.Text;
  DataSource := dsSource;
  Result := Self.RecordMove(rmAction);
  ErrorInfo := Error.Text;
  DataSource := mDataSource;
  Error.Text := mErrorText;
end;

function TDataTool.Requery: Boolean;
begin
  Error.Clear;
  Result := False;
  if Assigned(DataSource) then
    with DataSource do
    begin
      case SourceType of
      stADOTable:
        begin
          DataSet.Refresh();
          Result := True;
        end;
      stADOQuery:
        begin
          with DataSet as TADOQuery do Requery([eoAsyncFetch]);
          Result := True;
        end;
      stADOStoredProc,stClientDataSet,sTZjhDataSet:
        begin
          DataSet.Close();
          DataSet.Open();
          Result := True;
        end;
      else
        Error.Add(Chinese.AsString('记录源没有打开，无法执行！'));
      end;
    end
  else
    Error.Add(Chinese.AsString('记录源没有打开，无法执行！'));
end;

procedure TDataTool.Save;
var
  i: Integer;
begin
  Error.Clear;
  if not Assigned(DataSource) then
    raise Exception.Create(Chinese.AsString('记录源没有打开，无法执行！'));
  case SourceType of
  stADOTable,stADOQuery:
    with DataSource.DataSet do
    begin
      if State in [dsEdit,dsInsert] then Post();
    end;
  stClientDataSet:
    with (DataSource.DataSet as TClientDataSet) do
    begin
      if State in [dsEdit,dsInsert] then Post;
      if (ChangeCount > 0) then ApplyUpdates(0);
    end;
  sTZjhDataSet:
    with (DataSource.DataSet as TZjhDataSet) do
    begin
      PostPro(0);
      for i := 0 to Children.Count - 1 do
        (Children.Objects[i] as TZjhDataSet).PostPro(0);
    end;
  else
    Raise Exception.Create(Chinese.AsString('记录源没有打开，无法执行！'));
  end;
end;

function TDataTool.Append(dsSource: TDataSource;
  var ErrorInfo: String): Boolean;
var
  mDataSource: TDataSource;
  mErrorText: String;
begin
  mDataSource := DataSource;
  mErrorText := Error.Text;
  DataSource := dsSource;
  Result := Self.Append();
  ErrorInfo := Error.Text;
  DataSource := mDataSource;
  Error.Text := mErrorText;
end;

function TDataTool.Delete(dsSource: TDataSource;
  var ErrorInfo: String): Boolean;
var
  mDataSource: TDataSource;
  mErrorText: String;
begin
  mDataSource := DataSource;
  mErrorText := Error.Text;
  DataSource := dsSource;
  Result := Self.Delete();
  ErrorInfo := Error.Text;
  DataSource := mDataSource;
  Error.Text := mErrorText;
end;

function TDataTool.Edit(dsSource: TDataSource;
  var ErrorInfo: String): Boolean;
var
  mDataSource: TDataSource;
  mErrorText: String;
begin
  mDataSource := DataSource;
  mErrorText := Error.Text;
  DataSource := dsSource;
  Result := Self.Edit();
  ErrorInfo := Error.Text;
  DataSource := mDataSource;
  Error.Text := mErrorText;
end;

function TDataTool.Requery(dsSource: TDataSource;
  var ErrorInfo: String): Boolean;
var
  mDataSource: TDataSource;
  mErrorText: String;
begin
  mDataSource := DataSource;
  mErrorText := Error.Text;
  DataSource := dsSource;
  Result := Self.Requery();
  ErrorInfo := Error.Text;
  DataSource := mDataSource;
  Error.Text := mErrorText;
end;

procedure TDataTool.Save(dsSource: TDataSource;
  var ErrorInfo: String);
var
  mDataSource: TDataSource;
  mErrorText: String;
begin
  try
    mDataSource := DataSource;
    mErrorText := Error.Text;
    DataSource := dsSource;
    try
      Self.Save();
    finally
      DataSource := mDataSource;
      Error.Text := mErrorText;
    end;
  except
    on E: Exception do ErrorInfo := E.Message;
  end;
end;

{ TZjhSkinCustom }

constructor TZjhSkin.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TForm then
    FSection := TForm(AOwner).Name
  else if AOwner is TFrame then
    FSection := TFrame(AOwner).Name;
  ProtectObject := TStringList.Create;
  //
  OpenSkinFile;
  AutoStart := True;
  FAutoCreate := FIni.ReadBool('System','Create',False);
  if (AOwner is TForm) and (not (csDesigning in Owner.ComponentState)) then
  begin
    FFormShow := TForm(AOwner).OnShow;
    FFormCreate := TForm(AOwner).OnCreate;
    TForm(AOwner).OnShow := Self.FormShow;
    TForm(AOwner).OnCreate := Self.FormCreate;
  end;
end;

procedure TZjhSkin.Refresh(Sender: TObject);
var
  i: Integer;
  Obj: TObject;
begin
  if not Assigned(Sender) then Obj := Self.Owner else Obj := Sender;
  OpenSkinFile;
  FAutoCreate := FIni.ReadBool('System','Create',False);
  if Obj is TForm then
    with TForm(Obj) do
    begin
      if Self.Section = '' then Self.Section := ClassName;
      //Caption := GetStr('Caption',Caption);
      for i := 0 to ComponentCount - 1 do
        SkinComponent(Components[i]);
      if Assigned(Menu) then
        for i := 0 to Menu.Items.Count - 1 do SetObj(Menu.Items[i]);
    end
  else if Obj is TFrame then
    with TFrame(Obj) do
    begin
      if Self.Section = '' then Self.Section := ClassName;
      for i := 0 to ComponentCount - 1 do SkinComponent(Components[i]);
    end
  else if Obj is TControl then
    SkinComponent(TControl(Obj));
  if Assigned(FOnAfterRefresh) then FOnAfterRefresh(Self);
  //if Errors.Count > 0 then ShowMessage(Errors.Text);
end;

procedure TZjhSkin.OpenSkinFile;
var
  strPath: String;
begin
  if Assigned(FIni) then FIni.Free;
  strPath := ExtractFilePath(Application.ExeName);
  FIni := TIniFile.Create(strPath + CONFIG_FILE);
  try
    //IniFile := FIni.ReadString('Language','Default',strPath + 'Skin.Ini');
    IniFile := FIni.ReadString('Language','Default','Skin.Ini');
  finally
    FIni.Free;
  end;
  FIni := TIniFile.Create(strPath + IniFile);
end;

destructor TZjhSkin.Destroy;
begin
  if Assigned(FProtectObject) then FProtectObject.Free;
  if Assigned(FIni) then FIni.Free;
  inherited;
end;

procedure TZjhSkin.SetIniFile(const Value: String);
begin
  if m_IniFile <> Value then
  begin
    m_IniFile := Value;
    if FIni <> nil then
    begin
      FIni.Free; FIni := nil;
    end;
  end;
end;
{
function TZjhSkin.GetStr(const strName, Value: String): String;
begin
  Result := Value;
  if Assigned(FIni) and (strName > '') and (ProtectObject.IndexOf(strName) = -1) then
  begin
    Result := FIni.ReadString(Section,strName,Value);
    if FAutoCreate and (Result = Value) then
      FIni.WriteString(Section,strName,Value);
  end;
end;

function TZjhSkin.GetStr(Index: Integer; const Value: String): String;
var
  strKey: String;
begin
  Result := Value;
  strKey := '0000' + IntToStr(Index);
  strKey := Copy(strKey,Length(strKey) - 3,4);
  if Assigned(FIni) and (ProtectObject.IndexOf(strKey) = -1) then
  begin
    Result := FIni.ReadString(Section + '.Msg',strKey,Value);
    if FAutoCreate and (Result = Value) then
      FIni.WriteString(Section + '.Msg',strKey,Value);
  end;
end;
}
procedure TZjhSkin.SetObj(o: TRadioButton);
var
  i: Integer;
begin
  //o.Caption := GetStr(o.Name,o.Caption);
  for i := 0 to o.ControlCount - 1 do SkinComponent(o.Controls[i]);
end;

procedure TZjhSkin.SetObj(o: TDBGrid);
var
  i: Integer;
  c: TColumn;
  PReadOnly: Boolean;
  strTmp: String;
  cfgIni: TIniFile;
  xml: TXMLDocument;
  Root, Child, Node, Col: IXMLNode;
  mNegRed: boolean;  //Add by Liangjun at 2006/12/14 是否有负数需显示红色
  function SetDBColumn(AGrid: TDBGrid; const Value: String; AIndex: Integer): TColumn;
  var
    i: Integer;
    t_Str, t_Field: String;
  begin
    Result := nil;
    if (Value = '') or (Length(Value) < 25) or (Copy(Value,25,1) <> '|') then Exit;
    t_Str := Copy(Value,26,Length(Value));
    t_Field := Copy(t_Str,1,Pos('|',t_Str) - 1);
    with AGrid do for i := 0 to Columns.Count - 1 do
    begin
      if UpperCase(t_Field) = UpperCase(Columns[i].FieldName) then
      begin
        Columns[i].Index := AIndex;
        Result := AGrid.Columns[i];
        Break;
      end;
    end;
  end;
begin
  mNegRed := False;
  PReadOnly := False;
  o.ImeMode := imDontCare;
  o.ImeName := '';
  if Assigned(o.DataSource) then
    with o.DataSource do
    begin
      if DataSet is TClientDataSet then
        PReadOnly := TClientDataSet(DataSet).ReadOnly;
      if DataSet is TZjhDataSet then
        PReadOnly := TZjhDataSet(DataSet).ReadOnly;
    end
  else
    PReadOnly := True;
  if o.ReadOnly then PReadOnly := True;
  //Add by MYY @06-06-08:解决当DBGrid无数据时的Bug.
  if (o.Columns.Count = 1) and (o.Columns[0].Title.Caption = '') then Exit;
  for i := 0 to o.Columns.Count - 1 do
  begin
    c := o.Columns.Items[i];
    //c.Title.Caption := GetStr(o.Name + '.Column' + IntToStr(i),c.Title.Caption);
    if PReadOnly or c.ReadOnly then
      begin
        c.Font.Color := clNavy;
        c.Title.Font.Color := clNavy;
      end
    else
      begin
        c.Font.Color := clWindowText;
        c.Title.Font.Color := clWindowText;
      end;
  end;
  //
  xml := OpenConfigFile(o.Owner.Name, Root);
  try
    Child := Root.ChildNodes.FindNode(o.Name);
    if Child <> nil then
      begin
        for i := 0 to o.Columns.Count - 1 do
        begin
          Node := Child.ChildNodes.FindNode('C' + IntToStr(i));
          if Node <> nil then
          begin
            Col := Node.ChildNodes.FindNode('Format');
            if Col <> nil then
            begin
              SetColOptions(o.Columns[i],Col.Text);
              if Assigned(SetDBColumn(o,Col.Text,i)) then
              begin
                Col := Node.ChildNodes.FindNode('Title');
                if Col <> nil then
                begin
                  o.Columns[i].Title.Caption := Col.Text;
                end;
                Col := Node.ChildNodes.FindNode('DisplayFormat');
                if (Col <> nil) and (o.Columns[i].Field <> nil)
                  and (o.Columns[i].Field is TNumericField) then
                begin
                  TNumericField(o.Columns[i].Field).DisplayFormat := Col.Text;
                  if Pos(';',Col.Text) <> 0 then   //负数需显示红色
                      mNegRed := True;
                end;
              end;
            end;
          end;
          if mNegRed then
            SetSysOnDrawColumnCell(o);
        end;  //for
        SetDBGridIndex(o);
      end
    else
      begin
        cfgIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.dat');
        try
          strTmp := o.Owner.ClassName + '.' + o.Name;
          if cfgIni.SectionExists(strTmp) then
          begin
            for i := 0 to o.Columns.Count - 1 do
              SetColOptions(o.Columns[i],cfgIni.ReadString(strTmp,'C' + IntToHex(i,2),''));
            for i := 0 to o.Columns.Count - 1 do
              SetDBColumn(o,cfgIni.ReadString(strTmp,'C' + IntToHex(i,2),''),i);
          end;
        finally
          cfgIni.Free;
        end;
        SetDBGridIndex(o);
      end;
  finally
    FreeAndNil(xml);
  end;
  {
  if not Assigned(o.OnTitleClick) then
    o.OnTitleClick := Self.DBGridTitleClick;
  }
end;

function OpenConfigFile(const RootName: DOMString;
  var Root: IXMLNode): TXMLDocument;
var
  xml: TXMLDocument;
  strFile: String;
begin
  strFile := ExtractFilePath(Application.ExeName) + 'Config.xml';
  xml := TXMLDocument.Create(Application);
  if FileExists(strFile) then
    xml.LoadFromFile(strFile)
  else
    begin
      xml.Active := True;
      xml.FileName := strFile;
    end;
  if xml.DocumentElement = nil then
  begin
    if GetSystemDefaultLangID = 2052 then
      xml.Encoding := 'GB2312'
    else if GetSystemDefaultLangID = 1028 then
      xml.Encoding := 'BIG5';
    xml.AddChild('Options').Attributes['CreateDate'] := DateTimeToStr(Now());
  end;
  Root := xml.DocumentElement.ChildNodes.FindNode(RootName);
  if Root = nil then
    Root := xml.DocumentElement.AddChild(RootName);
  Result := xml;
end;

// 设置数据源排序问题
procedure SetDBGridIndex(AGrid: TDBGrid);
var
  i: Integer;
  Col: TColumn;
  Ini: TIniFile;
  ADataSet: TZjhDataSet;
  Section: String;
  t_IndexField: String;
  xml: TXMLDocument;
  Root, Child, Node: IXMLNode;
  function FindFromListBox(const FieldName: String): TColumn;
  var
    i: Integer;
  begin
    Result := nil;
    with AGrid do for i := 0 to Columns.Count - 1 do
    begin
      if Columns[i].FieldName = FieldName then
      begin
        Result := Columns[i];
        Break;
      end;
    end;
  end;
begin
  if not (Assigned(AGrid.DataSource) and Assigned(AGrid.DataSource.DataSet)
    and (AGrid.DataSource.DataSet is TZjhDataSet)) then Exit;
  ADataSet := TZjhDataSet(AGrid.DataSource.DataSet);
  t_IndexField := '';
  //
  xml := OpenConfigFile(AGrid.Owner.Name, Root);
  try
    Child := Root.ChildNodes.FindNode(AGrid.Name);
    if Child <> nil then
      begin
        for i := 0 to AGrid.Columns.Count - 1 do
        begin
          Node := Child.ChildNodes.FindNode('I' + IntToStr(i));
          if not Assigned(Node) then Break;
          Col := FindFromListBox(Node.Text);
          if Assigned(Col) then t_IndexField := t_IndexField + Col.FieldName + ';';
        end;
        if t_IndexField <> '' then
          ADataSet.IndexFieldNames := Copy(t_IndexField,1,Length(t_IndexField)-1);
      end
    else
      begin
        Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.dat');
        try
          Section := AGrid.Owner.ClassName + '.' + AGrid.Name;
          // 读取索引资料
          for i := 0 to AGrid.Columns.Count - 1 do
          begin
            if not Ini.ValueExists(Section,'I' + IntToHex(i,2)) then Break;
            Col := FindFromListBox(Ini.ReadString(Section,'I' + IntToHex(i,2),''));
            if Assigned(Col) then t_IndexField := t_IndexField + Col.FieldName + ';';
          end;
          if t_IndexField <> '' then
            ADataSet.IndexFieldNames := Copy(t_IndexField,1,Length(t_IndexField)-1);
        finally
          FreeAndNil(Ini);
        end;
      end;
  finally
    FreeAndNil(xml);
  end;
end;

procedure TZjhSkin.SetObj(o: TStatusBar);
begin
end;

procedure TZjhSkin.SetObj(o: TToolBar);
begin
end;

procedure TZjhSkin.SetObj(o: TMenuItem);
var
  i: Integer;
begin
  if o.Caption = '-' then Exit;
  for i := 0 to o.Count - 1 do SetObj(o.Items[i]);
end;

procedure TZjhSkin.SetObj(o: TDBEdit);
var
  PReadOnly: Boolean;
begin
  PReadOnly := False;
  if Assigned(o.DataSource) then
    begin
      with o.DataSource do
      begin
        if DataSet is TClientDataSet then
          if (DataSet as TClientDataSet).ReadOnly then PReadOnly := True;
        if DataSet is TZjhDataSet then
          if (DataSet as TZjhDataSet).ReadOnly then PReadOnly := True;
      end;
    end
  else
    PReadOnly := True;
  //
  if PReadOnly or o.ReadOnly then
    o.Color := clBtnFace
  else
    o.Color := clWindow;
  o.ImeMode := imDontCare;
  o.ImeName := '';
end;

procedure TZjhSkin.SkinComponent(o: TComponent);
var
  i: Integer;
begin
  try
    if o is TWinControl then
    begin
      TImeWinControl(o).ImeMode := imDontCare;
      TImeWinControl(o).ImeName := '';
    end;
    if o is TControl then
      TDragOverControl(o).OnDragOver := EasyDragOver;
    if o is TDBGrid then
      SetObj(o as TDBGrid)
    else if o is TPageControl then
      begin
        if TPageControl(o).TabPosition = tpTop then
          TPageControl(o).MultiLine := False
      end
    else if o is TRadioButton then SetObj(o as TRadioButton)
    else if o is TStatusBar then SetObj(o as TStatusBar)
    else if o is TMenuItem then SetObj(TMenuItem(o))
    else if o is TCoolBar then
      with TCoolBar(o) do for i := 0 to ComponentCount - 1 do SkinComponent(Components[i])
    else if o is TToolBar then SetObj(o as TToolBar)
    else if o is TCustomPanel then
      with TCustomPanel(o) do  for i := 0 to ComponentCount - 1 do SkinComponent(Components[i])
    else if o is TDBEdit then SetObj(o as TDBEdit)
    else if o is TEdit then
      with TEdit(o) do
      begin
        if ReadOnly then Color := clBtnFace else Color := clWhite;
        ImeMode := imDontCare;
        ImeName := '';
      end;
  except
    on E: Exception do ShowMessage(E.Message);
  end;
end;

procedure TZjhSkin.FormCreate(Sender: TObject);
begin
  if Assigned(FFormCreate) then FFormCreate(Sender);
  if AutoStart then Self.Refresh(Self.Owner);
end;

procedure TZjhSkin.FormShow(Sender: TObject);
begin
  if Sender is TForm then SetFormSite(Sender as TForm);
  if Assigned(FFormShow) then FFormShow(Sender);
end;

procedure TZjhSkin.SetFormSite(Sender: TForm);
var
  i: Integer;
  SkinForm: TForm;
  function HasForm(Value: Integer): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to Screen.FormCount - 1 do
    begin
      if Screen.Forms[i] <> SkinForm then
      with Screen.Forms[i] do
      begin
        if (FormStyle <> fsMDIForm) and (Screen.Forms[i].Visible)
          and (Top = Value) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
begin
  if not SkinForm.Visible then
  begin
    SkinForm.ClassName; //此句不可去掉，否则对位功能无效，原因暂不清楚，可能是 Delphi6 的 Debug
    Exit;
  end;
  with SkinForm do
  begin
    // 协调子窗体位置
    if (FormStyle <> fsMDIForm) and (Position = poDefault) then
    begin
      for i := 0 to 4 do
      begin
        if not HasForm(i * 22) then
        begin
          Top := i * 22;
          Left := i * 22;
          Break;
        end;
      end;
    end;
  end;
end;

function GetColOptions(Col: TColumn): String;
begin
  if Col.Visible then
    Result := Format('T|%s|%s|%s|%s|%s',
      [IntToHex(Col.Width,4),IntToHex(Col.Font.Color,8),
      IntToHex(Col.Color,8),Col.FieldName,Col.Title.Caption])
  else
    Result := Format('F|%s|%s|%s|%s|%s',
      [IntToHex(65,4),IntToHex(Col.Font.Color,8),
      IntToHex(Col.Color,8),Col.FieldName,Col.Title.Caption]);
end;

procedure SetColOptions(ACol: TColumn; const Value: String);
var
  i: Integer;
  Col: TColumn;
  t_Str, t_Field, t_Caption: String;
begin
  Col := nil;
  //1|FFFF|FFFFFFFF|FFFFFFFF|FieldName|CAPTION
  if (Value = '') or (Length(Value) < 25) or (Copy(Value,25,1) <> '|') then Exit;
  t_Str := Copy(Value,26,Length(Value));
  t_Field := Copy(t_Str,1,Pos('|',t_Str) - 1);
  t_Caption := Copy(t_Str,Pos('|',t_Str) + 1,Length(Value));
  if ACol.Grid is TDBGrid then
    begin
      with TDBGrid(ACol.Grid) do for i := 0 to Columns.Count - 1 do
      begin
        if UpperCase(t_Field) = UpperCase(Columns[i].FieldName) then
        begin
          Col := Columns[i];
          Break;
        end;
      end;
    end
  else
    Col := ACol;
  if not Assigned(Col) then Exit;
  Col.Visible := Copy(Value,1,1) <> 'F';
  if Col.Visible then Col.Width := StrToIntDef('$' + Copy(Value,3,4),Col.Width);
  Col.Font.Color := TColor(StrToIntDef('$' + Copy(Value,8,8),Integer(Col.Font.Color)));
  Col.Color := TColor(StrToIntDef('$' + Copy(Value,17,8),Integer(Col.Color)));
  Col.Title.Caption := t_Caption;
end;

{ TFormCoat }

constructor TFormCoat.Create(AOwner: TComponent);
begin
  inherited;
  lst := TList.Create;
end;

destructor TFormCoat.Destroy;
begin
  if Assigned(lst) then lst.Free;
  inherited;
end;

function TFormCoat.Add(Item: TWinControl): Integer;
begin
  Result := lst.Add(Item);
  Item.Parent := Self.Owner as TWinControl;
end;

function TFormCoat.ShowTab(Value: Integer): Boolean;
var
  ChangeEvent: TNotifyEvent;
begin
  try
    TTabSheet(Self.Owner).PageControl.ActivePageIndex := Value;
    if Value = 0 then
    begin
      ChangeEvent := TTabSheet(Self.Owner).PageControl.OnChange;
      if Assigned(ChangeEvent) then ChangeEvent(Self);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TFormCoat.GetForm(Index: Integer): IBaseForm;
var
  i: Integer;
  TabSheet: TTabSheet;
begin
  try
    if Index = -1 then
      i := TTabSheet(Self.Owner).PageControl.ActivePageIndex
    else
      i := Index;
    TabSheet := TTabSheet(Self.Owner).PageControl.Pages[i];
    if TabSheet.ControlCount > 0 then
      Result := (TabSheet.Controls[0]).Owner as IBaseForm
    else
      Result := nil;
  except
    Result := nil;
  end;
end;

{
procedure TZjhSkin.DBGridTitleClick(Column: TColumn);
var
  Fd: TField;
  strIndex: String;
  DataSet: TZjhDataSet;
begin
  inherited;
  strIndex := '';
  with Column do
  begin
    if Assigned(Grid.DataSource) and Assigned(Grid.DataSource.DataSet) then
    begin
      if Grid.DataSource.DataSet.Active then
      begin
        if Grid.DataSource.DataSet is TZjhDataSet then
        begin
          DataSet := Grid.DataSource.DataSet as TZjhDataSet;
          if UpperCase(FieldName) = UpperCase('TBCode') then
            strIndex := 'TB_;TBNo_'
          else if UpperCase(FieldName) = UpperCase('CusName') then
            strIndex := 'CusCode_'
          else if UpperCase(FieldName) = UpperCase('SupName') then
            strIndex := 'SupCode_'
          else if UpperCase(FieldName) = UpperCase('DeptName') then
            strIndex := 'DeptCode_'
          else if UpperCase(FieldName) = UpperCase('ReasonName') then
            strIndex := 'ReasonCode_'
          else
            begin
              fd := DataSet.FindField(FieldName);
              if Assigned(Fd) and (Fd.FieldKind = fkData) then
                strIndex := FieldName;
            end;
          if strIndex <> '' then
            DataSet.IndexFieldNames := strIndex;
        end;
      end;
    end;
  end;
end;
}
{
procedure TZjhTool.CreateReport(Sender: TDataSource = nil);
var
  pDS: TDataSource;
  ReportCommand,ReportData: string;
  TempReport: TextFile;
  i: integer;
  function GetPutoffice(var FileName: String): Boolean;
  var
    Reg: TRegistry;
  begin
    Result := False;
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Longwin\PutOffice', True) then
    begin
      if not Reg.ValueExists('ExePath') then
        Reg.WriteString('ExePath',ExtractFilePath(Application.ExeName) + 'PutOffice.exe');
      FileName := Reg.ReadString('ExePath');
      Reg.CloseKey();
      Result := FileExists(FileName);
    end;
  end;
begin
  if Sender <> nil then pDS := Sender else pDS := FDataTool.DataSource;
  ReportCommand := '';
  if pDS <> nil then
  begin
    if GetPutoffice(ReportCommand) then
    begin
      AssignFile(TempReport, 'c:\~Report.Txt');
      Rewrite(TempReport);
      Writeln(TempReport, '@head');
      Writeln(TempReport, '@body');
      with pDS.DataSet do
      begin
        First;
        while not Eof do begin
          for i:=0 to Fields.Count-1 do begin
            if i=0 then
                ReportData:= ' '
            else
                ReportData:=ReportData + ' @';
            ReportData:=ReportData + Fields.Fields[i].AsString;
          end;
          Writeln(TempReport, ReportData);
          Next;
        end;
      end;
      Writeln(TempReport, '@foot');
      Writeln(TempReport, '@end');
      CloseFile(TempReport);
      ReportCommand:=ReportCommand + ' ' + ReportTemplate + '@c:\~Report.txt';
      try
        WinExec(PChar(ReportCommand),0);
      except
        PutError(RES_LEGATE_PUTOFFICE_ERROR);
      end;
      //ShowMessage(ReportData);
    end
    else PutError(Format(RES_LEGATE_PUTOFFICE_NOTFOUND,[ReportCommand]));
  end;
end;
}

function TZjhSkin.Ini: TIniFile;
begin
  Result := FIni;
end;

procedure TZjhSkin.SetAutoStart(const Value: Boolean);
begin
  FAutoStart := Value;
end;

destructor TZjhMainMenu.Destroy;
begin
  MenuItems := nil;
  inherited;
end;

function TZjhMainMenu.GetMenuItems(Index: Integer): TZjhMainMenuItem;
begin
  if (Index < Low(MenuItems)) or (Index > High(MenuItems)) then
    Raise Exception.CreateFmt('Index[%d] > Range',[Index]);
  Result := MenuItems[Index];
end;

procedure TZjhMainMenu.Add(const AText: String; Kind, Site: Integer);
var
  i: Integer;
begin
  i := High(MenuItems);
  SetLength(MenuItems, i + 2);
  i := i + 1;
  MenuItems[i].Text := AText;
  if Kind <> 0 then
    MenuItems[i].Kind := Kind
  else
    MenuItems[i].Kind := i + 1;
  //MenuItems[i].Site := Site;
  MenuItems[i].Data := nil;
  //
  if Site > -1 then
  begin
    MenuItems[i].Face := TMenuItem.Create(Application);
    MenuItems[i].Face.Caption := MenuItems[i].Text;
    MenuItems[i].Face.Tag := MenuItems[i].Kind;
  end;
end;

procedure TZjhMainMenu.Remove(const Kind: Integer);
var
  k, i: Integer;
begin
  k := High(MenuItems);
  for i := Low(MenuItems) to k do
  begin
    if MenuItems[i].Kind = Kind then
    begin
      MenuItems[i].Text := MenuItems[k].Text;
      MenuItems[i].Kind := MenuItems[k].Kind;
      MenuItems[i].Face := MenuItems[k].Face;
      //
      MenuItems[k].Face.Free;
      SetLength(MenuItems, k);
      Exit;
    end;
  end;
end;

function TZjhMainMenu.Count: Integer;
begin
  Result := High(MenuItems) + 1;
end;

function TZjhMainMenu.IndexOf(const Kind: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := Low(MenuItems) to High(MenuItems) do
  begin
    if MenuItems[i].Kind = Kind then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

{ TZjhDateRange }

constructor TZjhDateRange.Create(AOwner: TComponent);
var
  Item: TMenuItem;
begin
  inherited;
  Self.Height := 21;
  Self.Width := 249;
  //
  FCheckBox := TCheckBox.Create(Self);
  FCheckBox.Parent := Self;
  if Assigned(AOwner) and (AOwner is TForm) then
    FCheckBox.Font.Size := (AOwner as TForm).Font.Size;
  FCheckBox.Caption := '';
  FCheckBox.Width := 13;
  FCheckBox.Checked := True;
  FCheckBox.Visible := True;
  //
  //
  FMinDate := TDateTimePicker.Create(Self);
  FMinDate.Parent := Self;
  FMinDate.Visible := True;
  FMinDate.Date := Date();
  FMinDate.Name := 'MinDate';
  //
  FMaxDate := TDateTimePicker.Create(Self);
  FMaxDate.Parent := Self;
  FMaxDate.Visible := True;
  FMaxDate.Date := Date();
  FMaxDate.Name := 'MaxDate';
  //
  //
  FPopupMenu := TPopupMenu.Create(Self);
  //
  Item := TMenuItem.Create(Self);
  Item.Caption := Chinese.AsString('今天');
  Item.Tag := 1;
  Item.OnClick := MenuClick;
  Item.Visible := True;
  FPopupMenu.Items.Add(Item);
  //
  Item := TMenuItem.Create(Self);
  Item.Caption := Chinese.AsString('昨天');
  Item.Tag := 2;
  Item.OnClick := MenuClick;
  Item.Visible := True;
  FPopupMenu.Items.Add(Item);
  //
  Item := TMenuItem.Create(Self);
  Item.Caption := Chinese.AsString('本周');
  Item.Tag := 3;
  Item.OnClick := MenuClick;
  Item.Visible := True;
  FPopupMenu.Items.Add(Item);
  //
  Item := TMenuItem.Create(Self);
  Item.Caption := Chinese.AsString('上周');
  Item.Tag := 4;
  Item.OnClick := MenuClick;
  Item.Visible := True;
  FPopupMenu.Items.Add(Item);
  //
  Item := TMenuItem.Create(Self);
  Item.Caption := Chinese.AsString('本月');
  Item.Tag := 5;
  Item.OnClick := MenuClick;
  Item.Visible := True;
  FPopupMenu.Items.Add(Item);
  //
  Item := TMenuItem.Create(Self);
  Item.Caption := Chinese.AsString('上月');
  Item.Tag := 6;
  Item.OnClick := MenuClick;
  Item.Visible := True;
  FPopupMenu.Items.Add(Item);
  //
  Item := TMenuItem.Create(Self);
  Item.Caption := Chinese.AsString('本年');
  Item.Tag := 7;
  Item.OnClick := MenuClick;
  Item.Visible := True;
  FPopupMenu.Items.Add(Item);
  //
  Item := TMenuItem.Create(Self);
  Item.Caption := Chinese.AsString('去年');
  Item.Tag := 8;
  Item.OnClick := MenuClick;
  Item.Visible := True;
  FPopupMenu.Items.Add(Item);
  //
  //
  FButton := TSpeedButton.Create(Self);
  FButton.Parent := Self;
  FButton.Flat := True;
  FButton.Caption := Chinese.AsString('时段选择');
  FButton.Left := 15;
  FButton.Width := 4 * FCheckBox.Font.Size + 28;
  FButton.Font.Color := clBlue;
  FButton.Font.Size := FCheckBox.Font.Size;
  FButton.Visible := True;
  FButton.OnClick := ButtonClick;
  FButton.PopupMenu := FPopupMenu;
  //
  SetRange(5);
end;

procedure TZjhDateRange.BoxResize(Sender: TObject);
var
  sz, wd: Integer;
begin
  FCheckBox.Height := Self.Height - 1;
  FButton.Height := Self.Height - 1;
  FMinDate.Height := Self.Height;
  FMaxDate.Height := Self.Height;
  //
  sz := FCheckBox.Width + FButton.Width + 2;
  wd := Self.Width - sz - 2;
  FMinDate.Width := wd div 2;
  FMaxDate.Width := wd div 2;
  FMinDate.Left := sz + 1;
  FMaxDate.Left := sz + FMinDate.Width + 2;
end;

procedure TZjhDateRange.MenuClick(Sender: TObject);
begin
  if (Sender is TMenuItem) then
    SetRange(TMenuItem(Sender).Tag);
end;

destructor TZjhDateRange.Destroy;
var
  i: Integer;
begin
  FreeAndNil(FCheckBox);
  FreeAndNil(FButton);
  FreeAndNil(FMinDate);
  FreeAndNil(FMaxDate);
  for i := FPopupMenu.Items.Count - 1 downto 0 do
    FPopupMenu.Items.Items[i].Free;
  FPopupMenu.Items.Clear;
  inherited;
end;

procedure TZjhDateRange.ButtonClick(Sender: TObject);
begin
  FButton.PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

function TZjhDateRange.GetMinDate: TDateTime;
begin
  Result := FMinDate.Date;
end;

function TZjhDateRange.GetMaxDate: TDateTime;
begin
  Result := FMaxDate.Date;
end;

procedure TZjhDateRange.SetMinDate(const Value: TDateTime);
begin
  FMinDate.DateTime := Value;
end;

procedure TZjhDateRange.SetMaxDate(const Value: TDateTime);
begin
  FMaxDate.DateTime := Value;
end;

procedure TZjhDateRange.WMPaint(var Message: TWMPaint);
begin
  BoxResize(Self);
  inherited;
end;

function TZjhDateRange.GetCaption: String;
begin
  Result := FButton.Caption;
end;

procedure TZjhDateRange.SetCaption(const Value: String);
begin
  FButton.Caption := Value;
  FButton.Font.Size := FCheckBox.Font.Size;
  FButton.Width := 4 * FCheckBox.Font.Size + 28;
  FButton.Font.Name := 'Tahoma';
end;

function TZjhDateRange.GetChecked: Boolean;
begin
  Result := FCheckBox.Checked;
end;

procedure TZjhDateRange.SetChecked(const Value: Boolean);
begin
  FCheckBox.Checked := Value;
end;

procedure TZjhDateRange.SetRange(Index: Integer);
var
  CurDate: TDateTime;
begin
  CurDate := Date();
  case Index of
  1: //今天
    begin
      Min := CurDate;
      Max   := CurDate;
    end;
  2: //昨天
    begin
      CurDate  := IncDay(CurDate, -1);
      Min   := CurDate;
      Max   := CurDate;
    end;
  3: //本周
    begin
      Min   := CurDate - DayOfWeek(CurDate) + 1;
      Max   := Min + 6;
    end;
  4: //上周
    begin
      CurDate  := CurDate - 7;
      Min   := CurDate - DayOfWeek(CurDate) + 1;
      Max   := Min + 6;
    end;
  5: //本月
    begin
      Min   := CurDate - DayOf(CurDate) + 1;
      Max   := IncMonth((CurDate - DayOf(CurDate) + 1),1) - 1;
    end;
  6: //上月
    begin
      CurDate  := IncMonth(CurDate, -1);
      Min  := CurDate - DayOf(CurDate) + 1;
      Max   := IncMonth((CurDate - DayOf(CurDate) + 1),1) - 1;
    end;
  7: //本年
    begin
      CurDate := IncMonth(CurDate, 1-MonthOf(CurDate));
      Min := CurDate - DayOf(CurDate) + 1;
      CurDate := IncMonth(CurDate, 12-MonthOf(CurDate));
      Max   := IncMonth((CurDate - DayOf(CurDate) + 1),1) - 1;
    end;
  8: //去年
    begin
      CurDate := IncYear(CurDate, -1);
      CurDate := IncMonth(CurDate, 1-MonthOf(CurDate));
      Min := CurDate - DayOf(CurDate) + 1;
      CurDate := IncMonth(CurDate, 12-MonthOf(CurDate));
      Max   := IncMonth((CurDate - DayOf(CurDate) + 1),1) - 1;
    end;
  end;
end;

procedure TZjhSkin.EasyDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source.ClassNameIs('TToolButton')
    and (TToolButton(Source).Name = 'ToolButton') then
    Accept := True;
end;

function MonthBof(Value: TDate):Tdate;
begin
  ReSult := Value - DayOf(Value) + 1;
end;

function MonthEof(Value: Tdate):Tdate;
begin
  Result := IncMonth((Value - DayOf(Value) + 1),1) - 1;
end;

function GetTempFile(const ExtName: String): String;
var
  i: Integer;
  Guid: TGuid;
  TmpPath,strTmp: String;
begin
  SetLength(TmpPath,MAX_PATH);SetLength(Result,MAX_PATH);
  TmpPath := Copy(TmpPath,1,GetTempPath(MAX_PATH,PChar(TmpPath)));
  if TmpPath = '' then Raise Exception.Create('Not get temp filename!');
  CreateGuid(Guid);
  Result := '';
  strTmp := GuidToString(Guid);
  for i := 2 to Length(strTmp) - 1 do
    if Copy(strTmp,i,1) <> '-' then
      Result := Result + Copy(strTmp,i,1);
  Result := TmpPath + Result + ExtName;
end;

procedure CopyFields(Target, Source: TDataSet;
  const Args: array of String);
var
  i: Integer;
begin
  for i := Low(Args) to High(Args) do
    Target.FieldByName(Args[i]).Value := Source.FieldByName(Args[i]).Value;
end;

procedure CopyFields(Target: TDataSet; const Args1: array of String;
  Source: TDataSet; const Args2: array of String);
var
  i: Integer;
begin
  for i := Low(Args1) to High(Args1) do
    Target.FieldByName(Args1[i]).Value := Source.FieldByName(Args2[i]).Value;
end;

procedure CopyFields2(Source, Target: TDataSet;
  const Args: array of String);
var
  i: Integer;
  fd: TField;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := Low(Args) to High(Args) do
      sl.Add(Args[i]);
    for i := 0 to Source.Fields.Count - 1 do
    begin
      if sl.IndexOf(Source.Fields[i].FullName) = -1 then
      begin
        fd := Target.FindField(Source.Fields[i].FullName);
        if Assigned(fd) then fd.Value := Source.Fields[i].Value;
      end;
    end;
  finally
    FreeAndNil(sl);
  end;
end;

procedure CopyFields(Target: TDataSet; const Args1: String;
  Source: TDataSet; const Args2: String);
var
  s1, s2, f1, f2: String;
begin
  s1 := Trim(Args1);  if Args2 = '' then s2 := s1 else s2 := Trim(Args2);
  if (Length(s1) > 0) and (Copy(s1,Length(s1),1) <> ',') then s1 := s1 + ',';
  if (Length(s2) > 0) and (Copy(s2,Length(s2),1) <> ',') then s2 := s2 + ',';
  if not (Target.State in [dsInsert, dsEdit, dsCalcFields]) then Target.Edit;
  while (Pos(',',s1) > 0) and (Pos(',',s2) > 0) do
  begin
    f1 := Trim(Copy(s1,1,Pos(',',s1)-1));
    f2 := Trim(Copy(s2,1,Pos(',',s2)-1));
    Target.FieldByName(f1).Value := Source.FieldByName(f2).Value;
    s1 := Trim(Copy(s1,Pos(',',s1)+1,Length(s1)));
    s2 := Trim(Copy(s2,Pos(',',s2)+1,Length(s2)));
  end;
  if s1 <> '' then
    Target.FieldByName(s1).Value := Source.FieldByName(s2).Value;
end;

{ TSelectCode }

constructor TSelectCode.Create(AOwner: TComponent);
begin
  inherited;
  FKing := 0;
  FParam := TMemIniFile.Create('');
end;

destructor TSelectCode.Destroy;
begin
  FreeAndNil(FParam);
  inherited;
end;

function TSelectCode.Param: TMemIniFile;
begin
  Result := FParam;
end;

function TSelectCode.Select(V: TErpPack): Boolean;
begin
  if Assigned(FOnSelected) then
    FOnSelected(FKing, V);
  Result := not FMultiSelect;
end;

procedure TSelectCode.SetKing(const Value: Integer);
begin
  FKing := Value;
  FActiveMulti := False;
end;

{ TErpPack }

function TErpPack.GetData(Index: Integer): OleVariant;
begin
  Result := FData[Index];
end;

function TErpPack.Init(const Values: array of Variant): TErpPack;
begin
  FData := VarArrayOf(Values);
  Result := Self;
end;

procedure TErpPack.SetData(Index: Integer; const Value: OleVariant);
begin
  FData[Index] := Value;
end;

{ TTVPartner }

function TTVPartner.AppendNode(ARoot: TTreeNode; const ACode,
  AName: String): TTreeNode;
var
  MData: ^String;
begin
  if not Assigned(TreeView) then
    Raise Exception.Create('Property[TreeView] is error.');
  New(MData); MData^ := ACode;
  if Trim(AName) = '' then
    Result := TreeView.Items.AddChildObject(ARoot,EmptyName,MData)
  else
    Result := TreeView.Items.AddChildObject(ARoot,AName,MData);
  if Result.Level > 0 then
  begin
    Result.ImageIndex := 1;
    Result.SelectedIndex := 2;
  end;
  if VirNode then
  begin
    New(MData); MData^ := '';
    TreeView.Items.AddChild(Result,'').Data := MData;
  end;
end;

procedure TTVPartner.Clear(Sender: TTreeView);
var
  i: Integer;
  p: ^String;
begin
  with Sender do for i := Items.Count - 1 downto 0 do
  begin
    p := Items[i].Data;
    Dispose(p);
    Items[i].Delete;
  end;
end;

function TTVPartner.Execute(const ACodeField, ANameField: String): Integer;
begin
  Result := -1;
  if not Assigned(FDataSet) then Exit;
  with FDataSet do
  begin
    First;
    while not Eof do
    begin
      AppendNode(Root,FieldByName(ACodeField).AsString,
        FieldByName(ANameField).AsString);
      Next;
    end;
    Result := RecordCount;
  end;
  //处理自动展开的问题
  if not Expanded then Exit;
  with TreeView do
  begin
    if Items.Count > 1 then
      begin
        Items[1].Selected := True;
        Items[1].Expand(False);
      end
    else if Items.Count > 0 then
      begin
        Items[0].Selected := True;
        Items[0].Expand(False);
      end;
  end;
end;

procedure TTVPartner.Delete(Item: TTreeNode; HasData: Boolean);
var
  P: ^String;
begin
  if HasData then
  begin
    P := Item.Data; Dispose(P);
  end;
  Item.Delete;
end;

function TTVPartner.Execute(const SQLCmd: String): Integer;
var
  m_DataSet: TDataSet;
begin
  Result := -1;
  if not Assigned(FRemoteServer) then Exit;
  m_DataSet := FDataSet;
  FDataSet := TZjhDataSet.Create(Self);
  try
    with TZjhDataSet(FDataSet) do
    begin
      RemoteServer := Self.RemoteServer;
      CommandText := SQLCmd;
      Open;
      Result := Self.Execute(Fields[0].FieldName,Fields[1].FieldName);
    end;
  finally
    FDataSet.Free;
    FDataSet := m_DataSet;
  end;
end;

function TTVPartner.IsVirtual(Node: TTreeNode): Boolean;
begin
  Result := ((Node.Count = 1)) and (Node[0].Text = '')
    and (String(Node[0].Data^) = '');
end;

constructor TTVPartner.Create(AOwner: TComponent);
begin
  inherited;
  FEmptyName := '';
  FExpanded := True;
  FVirNode := False;
end;

{ TTFPartner }

constructor TTFPartner.Create(AOwner: TComponent);
begin
  inherited;
  m_AfterScroll := nil;
end;

function TTFPartner.Execute: Boolean;
var
  F: TField;
  Partner: TTVPartner;
begin
  Result := False;
  if not (Assigned(FTreeView) and Assigned(FDataSet) and Assigned(FSec)) then Exit;
  if not Assigned(FTreeView.OnChange) then
    FTreeView.OnChange := Self.TreeViewChange;
  if not Assigned(FTreeView.OnEditing) then
    FTreeView.OnEditing := Self.TreeViewEditing;
  //
  if Assigned(FDataSet.AfterScroll) then
    m_AfterScroll := FDataSet.AfterScroll;
  FDataSet.AfterScroll := DataSetAfterScroll;
  if not Assigned(FDataSet.BeforeInsert) then
    FDataSet.BeforeInsert := DataSetBeforeInsert;
  //
  if not Assigned(FSec.OnAppend) then
    FSec.OnAppend := SecAppend;
  if not Assigned(FSec.OnFind) then
    FSec.OnFind := SecFind;
  if not Assigned(FSec.OnDelete) then
    FSec.OnDelete := SecDelete;
  F := FDataSet.FindField(FKeyCode);
  if Assigned(F) and (F is TWideStringField) then
    TWideStringField(F).OnValidate := Self.DataSetCode_Validate;
  F := FDataSet.FindField(FKeyName);
  if Assigned(F) and (F is TWideStringField) then
    TWideStringField(F).OnValidate := Self.DataSetName_Validate;
  //
  FScrollSource := 3;
  Partner := TTVPartner.Create(Self);
  try
    Partner.TreeView := FTreeView;
    Partner.DataSet := FDataSet;
    Partner.Root := Partner.AppendNode(nil,GuidNull,Chinese.AsString('所有资料'));
    with FDataSet do
    begin
      Open;
      DisableControls;
      Partner.Execute(KeyCode,KeyName);
      EnableControls;
    end;
  finally
    FScrollSource := 0;
    Partner.Free;
  end;
  FTreeView.OnChange(FTreeView,FTreeView.Selected);
  Result := True;
end;

procedure TTFPartner.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Node.Level = 0 then Exit;
  if FScrollSource <> 0 then Exit;
  FScrollSource := 1;
  FDataSet.Locate(KeyCode,String(Node.Data^),[]);
  if Assigned(m_AfterScroll) then m_AfterScroll(FDataSet);
  FScrollSource := 0;
end;

procedure TTFPartner.DataSetAfterScroll(DataSet: TDataSet);
var
  i: Integer;
  strDel: String;
  Root : TTreeNode;
begin
  if FScrollSource <> 0 then Exit;
  FScrollSource := 2;
  Root := FTreeView.Items[0];
  with FDataSet do strDel := FieldByName(KeyCode).AsString;
  for i:=0 to Root.Count-1 do
  begin
   if String(Root[i].Data^) = strDel then
    begin
      Root[i].Selected := True;
      Break;
    end;
  end;
  FScrollSource := 0;
  if Assigned(m_AfterScroll) then m_AfterScroll(FDataSet);
end;

procedure TTFPartner.SecAppend(Sender: TObject);
var
  Partner: TTVPartner;
  AID, ACode: String;
begin
  ACode := UpperCase(Trim(ErpInput(Chinese.AsString('增加代码'),Chinese.AsString('增加新的代码：    '),'',GuidNull)));
  if (ACode = '') or (ACode = GuidNull) then Exit;
  if FDataSet.Locate(KeyCode,ACode,[]) then
  begin
    MsgBox(Chinese.AsString(Format('代码 %s 已经存在，不允许重复！',[ACode])));
    Exit;
  end;
  with FDataSet do
  begin
    FScrollSource := 4;
    Tag := 1;
    try
      AID := NewGuid();
      Append;
      FieldByName(KeyCode).AsString := ACode;
      FieldByName(KeyName).AsString := Chinese.AsString('<新的代码>');
      Post;
      FScrollSource := 0;
      Partner := TTVPartner.Create(Self);
      try
        Partner.TreeView := FTreeView;
        Partner.AppendNode(FTreeView.Items[0],AID,Chinese.AsString('<新的代码>')).Selected := True;
      finally
        Partner.Free;
      end;
    finally
      Tag := 0;
    end;
  end;
end;

procedure TTFPartner.SecFind(Sender: TObject);
var
  t_Code: String;
begin
  t_Code := ErpInput(Chinese.AsString('定位查询'),Chinese.AsString('请输入定位代码：    '),'');
  if t_Code <> '' then
    FDataSet.Locate(KeyCode,t_Code,[loCaseInsensitive]);
end;

procedure TTFPartner.SecDelete(Sender: TObject);
var
  Node: TTreeNode;
begin
  if (FTreeView.Selected.Parent = nil)
    or (FTreeView.Selected = nil) then Exit;
  if MessageDlg(Chinese.AsString('您真的要删除当前记录吗？'),
    mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    Node := FTreeView.Selected;
    FDataSet.Delete;
    FTreeView.Items.Delete(Node);
  end;
end;

procedure TTFPartner.DataSetName_Validate(Sender: TField);
begin
  if FDataSet.Tag <> 0 then Exit;
  if (FTreeView.Selected.Parent = nil) or (FTreeView.Selected = nil) then Exit;
  FTreeView.Selected.Text := Trim(Sender.AsString);
end;

procedure TTFPartner.DataSetCode_Validate(Sender: TField);
begin
  with FDataSet do
  begin
    if Trim(FieldByName(KeyName).AsString) <> '' then
    begin
      MsgBox(Chinese.AsString('名称不为空，不允许更改代码！'));
      Abort;
    end;
  end;
end;

procedure TTFPartner.DataSetBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  if DataSet.Tag = 0 then Abort;
end;

function TTFPartner.ErpInput(const ATitle, APrompt, ADefault,
  ACancel: String): String;
var
  R: Variant;
  Child: IHRObject;
begin
  Result := ADefault;
  Child := CreateClass('TFrmInput', Application) as IHRObject;
  if Assigned(Child) then
    begin
      R := Child.PostMessage(CONST_DEFAULT,
        VarArrayOf([ATitle, APrompt, ADefault, ACancel]));
      if not VarIsNull(R) then
        Result := VarToStr(R)
      else
        Result := ACancel;
    end
  else
    raise Exception.Create('Create TFrmInput Error.');
end;

procedure TTFPartner.TreeViewEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  inherited;
  AllowEdit := False;
end;

procedure TZjhTreeView.PaintBei;
var
  ps: PAINTSTRUCT;
  DC, drawDC1, drawDC2: HDC;
  drawBMP1, drawBMP2, oldBMP1, oldBMP2: HBitmap;
  iWidth, iHeight, ibmpWidth, ibmpHeight, I, J, K, W: integer;
begin
  // 避免
  FInterDrawing := True;
  // 加个try!
  try
    BeginPaint(Handle, Ps);
    // 再加一个try,嘿嘿!
    try
      DC := Ps.hdc;
      iWidth := ClientWidth;
      iHeight := ClientHeight;
      drawDC1 := CreateCompatibleDC(DC);
      drawBMP1 := CreateCompatibleBitmap(DC, iWidth, iHeight);
      oldBMP1 := SelectObject(drawDC1, drawBMP1);
      SendMessage(Handle, WM_PAINT, drawDC1, 0);
      drawDC2 := CreateCompatibleDC(DC);
      drawBMP2 := CreateCompatibleBitmap(DC, iWidth, iHeight);
      oldBMP2 := SelectObject(drawDC2, drawBMP2);
      iBmpWidth := Background.Width;
      iBmpHeight := Background.Height;
      K := ClientWidth div iBmpWidth;
      W := ClientHeight div iBmpHeight;
      for I := 0 to K do
        for J := 0 to W do
          BitBlt(drawDC2, I * iBmpWidth, J * iBmpHeight, iBmpWidth, iBmpHeight, Background.Canvas.Handle, 0, 0, SRCCOPY);
      TransparentBlt(drawDC2, 0, 0, iWidth, iHeight, drawDC1, 0, 0, iWidth, iHeight, ColorToRGB(clWindow));
      BitBlt(DC, 0, 0, iWidth, iHeight, drawDC2, 0, 0, SRCCOPY);
      SelectObject(drawDC1, oldBMP1);
      DeleteObject(drawDC1);
      DeleteObject(drawBMP1);
      SelectObject(drawDC2, oldBMP2);
      DeleteObject(drawDC2);
      DeleteObject(drawBMP2);
    finally
      EndPaint(Handle, Ps);
    end;
  finally
    FInterDrawing := False;
  end;
end;

procedure TZjhTreeView.SetBitMap(const Value: TBitmap);
begin
  if FBitMap <> Value then
  begin
    FBitMap := Value;
    if HandleAllocated then Invalidate;
  end;
end;

procedure TZjhTreeView.WMPaint(var Message: TWMPaint);
begin
  if (csDesigning in ComponentState)
    or (FBitMap = nil) or FInterDrawing then
    inherited
  else
    PaintBei;
end;

procedure TZjhTreeView.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_ERASEBKGND:
    begin
      Message.Result := 1;
      if (csDesigning in ComponentState)
        or (FBitMap = nil) or FInterDrawing then
          inherited;
      Exit;
    end;
    WM_HSCROLL,
    WM_VSCROLL,
    WM_MOUSEWHEEL,
    WM_LBUTTONDOWN,
    WM_LBUTTONDBLCLK,
    WM_MBUTTONDOWN,
    WM_MBUTTONDBLCLK,
    WM_KEYUP:
      InvalidateRect(Handle, nil, False);
  end;
  inherited;
end;

{ THRAnyToAcc }

function THRAnyToAcc.Add(const DrCr: Char): PHRAnyToAccRecord;
var
  P: PHRAnyToAccRecord;
begin
  New(P);
  FItems.Add(P);    
  P.OriAmount := 0;
  P.ExRate := 1;
  P.DrCr := DrCr;
  Result := P;
end;

function THRAnyToAcc.Count: Integer;
begin
  Result := FItems.Count;
end;

constructor THRAnyToAcc.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TList.Create;
  Reset('', '');
end;

destructor THRAnyToAcc.Destroy;
begin
  Reset('', '');
  FItems.Free;
  inherited;
end;

procedure THRAnyToAcc.Reset(const ACode, ATBNo: String);
var
  i: Integer;
  P: PHRAnyToAccRecord;
begin
  FManageNo := '';
  FTBDate := Date();
  //
  FABSource := ACode;
  FSourceTBNo := ATBNo;
  if FManageNo = '' then
    FManageNo := FSourceTBNo;
  //
  if Assigned(FItems) then
  begin
    for i := 0 to FItems.Count - 1 do
    begin
      P := FItems.Items[i];
      Dispose(P);
    end;
    FItems.Clear;
  end;
end;

procedure THRAnyToAcc.SetAccTB(const Value: String);
begin
  FAccTB := Value;
end;

procedure THRAnyToAcc.SetManageNo(const Value: String);
begin
  FManageNo := Value;
end;

{$IFDEF ERP2011}
procedure THRAnyToAcc.SetTagValue(const Value: String);
begin
  FTagValue := Value;
end;
{$ENDIF}

procedure THRAnyToAcc.SetTBDate(const Value: TDateTime);
begin
  FTBDate := Value;
end;

function THRAnyToAcc.GetItems(Index: Integer): PHRAnyToAccRecord;
begin
  Result := FItems.Items[Index];
end;

{
procedure THRAnyToAcc.Display;
var
  Child: IBaseForm;
  AIntf: ISelectDialog;
begin
  if FWorkClassName <> '' then
    Child := MainIntf.GetForm(FWorkClassName, True)
  else
    Child := MainIntf.GetForm('TFrmAnyToAcc', True);
  if Assigned(Child) then
  begin
    if not Assigned(FSelect) then
    begin
      FSelect := TSelectCode(Self);
      FSelect.OnSelected := DefaultSelected;
    end;
    AIntf := (Child.GetControl('') as TForm) as ISelectDialog;
    if Assigned(AIntf) then
      AIntf.Display(FSelect, Integer(Self));
  end;
end;

procedure THRAnyToAcc.DefaultSelected(Kind: Integer; V: TErpPack);
begin
  FAccTBNo := VarToStr(V[0]);
  if Assigned(FOnExecuted) then
    FOnExecuted(Self);
end;

procedure THRAnyToAcc.SetOnExecuted(const Value: TNotifyEvent);
begin
  FOnExecuted := Value;
end;
}

procedure THRAnyToAcc.SetSourceTBNo(const Value: String);
begin
  FSourceTBNo := Value;
end;

procedure THRAnyToAcc.SetSelectObject(const Value: TSelectCode);
begin
  FSelectObject := Value;
end;

function THRAnyToAcc.Execute(AKind: Integer): Boolean;
var
  Child: IBaseForm;
  AIntf: ISelectDialog;
begin
  Result := False;
  if Assigned(FSelectObject) then
  begin
    FSelectObject.Kind := AKind;
    Child := MainIntf.GetForm('TFrmAnyToAcc', True);
    if Assigned(Child) then
    begin
      AIntf := (Child.GetControl('') as TForm) as ISelectDialog;
      if Assigned(AIntf) then
        AIntf.Display(FSelectObject, Integer(Self));
      Result := True;
    end;
  end;
end;

procedure TZjhSkin.SysDBGridDrawColumnCellNegRed(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Column.Field is TNumericField then
  begin
    if Pos(';',TNumericField(Column.Field).DisplayFormat)<>0 then
    begin
      if Column.Field.Value < 0 then
        TDBGrid(Sender).Canvas.Font.Color := clRed;
    end;
  end;
  TDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);

end;

procedure TZjhSkin.SysDBGridDrawColumnCellNegRedShell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  mI: integer;
  mDrawColumnCellEvent: TDrawColumnCellEvent;
begin
  if Column.Field is TNumericField then
  begin
    if Pos(';',TNumericField(Column.Field).DisplayFormat)<>0 then
    begin
      if Column.Field.Value < 0 then
        TDBGrid(Sender).Canvas.Font.Color := clRed;
    end;
  end;

  mI := SysOrgDrawColumnCellList.IndexOf(TDBGrid(Sender).Owner.Name+'.'+TDBGrid(Sender).Name);
  if mI <> -1 then
  begin
    mDrawColumnCellEvent := DrawColumnCellArray[mI];

    mDrawColumnCellEvent(Sender, Rect, DataCol, Column, State);
  end

end;

procedure TZjhSkin.SetSysOnDrawColumnCell(o: TDBGrid);
var
  mI : integer;
begin
  if not Assigned(o.OnDrawColumnCell) then
  begin
    o.DefaultDrawing := False;
    o.OnDrawColumnCell := SysDBGridDrawColumnCellNegRed; 
  end
  else
  begin
    o.DefaultDrawing := False;
    if not Assigned(SysOrgDrawColumnCellList) then
      SysOrgDrawColumnCellList := TStringList.create;

    if SysOrgDrawColumnCellList.IndexOf(o.Owner.Name+'.'+o.Name) = -1 then
    begin
      mI := SysOrgDrawColumnCellList.add(o.Owner.Name+'.'+o.Name);
      if High(DrawColumnCellArray) < mI then
        SetLength(DrawColumnCellArray, mI+1);
      DrawColumnCellArray[mI] := o.OnDrawColumnCell;
      o.OnDrawColumnCell := SysDBGridDrawColumnCellNegRedShell;
    end;
  end;
end;

{ TCreateSQLWhere }

procedure TCreateSQLWhere.AddParam(Text: String);
var
  bWhereFlag: Boolean;
begin
  bWhereFlag := not ((Length(DefaultText) = 0) and (Length(m_SQLText) = 0));
  m_SQLText := m_SQLText + iif(bWhereFlag,' and ',' where ') + Text;
end;

procedure TCreateSQLWhere.AddParamStr(FieldName, Value: String);
var
  V: String;
begin
  V := Trim(Value);
  if (Length(V)>0) and (V <> '*') then
  begin
    if (Copy(Value, 1, 1) = ' ') and (Pos(' ', V) > 0) then
      begin
        if Copy(V, Length(V), 1) = '*' then
          V := Copy(V, 1, Length(V) - 1);
        V := StringReplace(V,' ','%', [rfReplaceAll]);
        AddParam(FieldName + ' like N''%' + V + '%''');
      end
    else if (Copy(V,1,1) = '*') or (Copy(V,Length(V),1) = '*') then
      begin
        if (Copy(V,1,1) = '*') and (Copy(V,Length(V),1) = '*') then
          begin
            V := Copy(V,2,Length(V)-2);
            AddParam(FieldName + ' like N' + '''%' + V + '%' + '''');
          end
        else if (Copy(V,1,1) = '*') then
          begin
            V := Copy(V,2,Length(V)-1);
            AddParam(FieldName + ' like N' + '''%' + V + '''');
          end
        else // if (Copy(V,Length(V),1) = '*') then
          begin
            V := Copy(V,1,Length(V)-1);
            AddParam(FieldName + ' like N' + '''' + V + '%''');
          end;
      end
    else if UpperCase(V) = UpperCase('NULL') then
      AddParam(Format('(%s is null or %s='''')',[FieldName,FieldName]))
    else if (Length(V) > 2) and (Copy(V,1,1)='[') and (Copy(V,Length(V),1)=']') then
      begin
        V := Replace(V, ',', ''',''');
        AddParam(Format('(%s in (N''%s''))',[FieldName, Copy(V,2,Length(V)-2)]));
      end
    else if Pos('..', V) > 0 then //范围查询
      begin
        AddParam(Format('(%s between N''%s'' and N''%s'')',
          [FieldName, Copy(V, 1, Pos('..',V) - 1),
          Copy(V, Pos('..', V) + 2, Length(V))]));
      end
    else if Copy(V, 1, 2) = '<>' then //不等于查询
      begin
        AddParam(Format('(%s <> N''%s'')', [FieldName, Copy(V, 3, Length(V))]));
      end
    else
      AddParam(FieldName + ' = N''' + V + '''');
  end;
  if V = '*' then AllRecord := true;
end;

procedure TCreateSQLWhere.AddParamStr(FieldName, Val1, Val2: String);
var
  Str: String;
begin
  Str := '';
  if (Length(Val1) <> 0) and (Val1 <> '*') then
    Str := FieldName + '>=''' + Val1 + '''';
  if (Length(Val2) <> 0) and (Val2 <> '*') then
  begin
    if Length(Str) <> 0 then
      Str := Str + ' and ' + FieldName + '<=''' + Val2 + ''''
    else
      Str := FieldName + '<=''' + Val2 + '''';
  end;
  if Str <> '' then AddParam(Str)
  else AllRecord := True;
end;


procedure TCreateSQLWhere.AddParamInt(FieldName:String; Val: Integer);
begin
  //if Val >= 0 then
  AddParam(FieldName + '=' + IntToStr(Val));
end;

procedure TCreateSQLWhere.AddParamInt(FieldName:String; Val1,Val2: Integer);  //xgl
begin
  AddParam(FieldName + ' BetWeen ' + '''' + IntToStr(Val1) + ''''
    + ' and ' + '''' + IntToStr(Val2) + '''');
end;

procedure TCreateSQLWhere.AddParamStrBt(FieldName: String; Val1,
  Val2: Variant);
begin
  AddParam(FieldName + ' Between ' + '''' + Val1 + ''''
    + ' and ' + '''' + Val2 + '''');
end;

procedure TCreateSQLWhere.AddParamBool(FieldName: String; Val: Boolean);
begin
  AddParam(FieldName + iif(Val,'=1','=0'));
end;

procedure TCreateSQLWhere.AddParamDate(FieldName:String; Val1,Val2: TDate);
begin
  AddParam(FieldName + ' between ' + '''' + DateToStr(Val1)
    + '''' + ' and ' + '''' + DateToStr(Val2) + '''');
end;

procedure TCreateSQLWhere.AddParamDate(FieldName: String; Val: TDate);
begin
  AddParam(FieldName + '=''' + DateToStr(Val) + '''');
end;

procedure TCreateSQLWhere.AddParamRad(FieldName: String; const s: Integer);
begin
  if (s<5) and (s>-2) then
  begin
    case s of
      -1: AddParam(FieldName + ' = '+ IntToStr(s));
      0: AddParam(FieldName  + ' = '+ IntToStr(s));
      1: AddParam(FieldName  + ' = '+IntToStr(s));
      2: AddParam(FieldName  + ' = '+IntToStr(s));
      3: AddParam(FieldName  + ' = '+IntToStr(s));
      4: AddParam(FieldName  + ' = '+IntToStr(s));
    end;
  end;
end;

procedure TCreateSQLWhere.AddObject(const KeyField: String;
  const Args: array of TObject; AType: Integer);
var
  k: Integer;
  chk: Boolean;
  function GetObjectText(const Arg: TObject): String;
  begin
    if Arg is TCustomEdit then
      Result := TCustomEdit(Arg).Text
    else if Arg is TCustomComboBox then
      begin
        if AType = 1 then
          Result := IntToStr(TComboBox(Arg).ItemIndex)
        else
          Result := TComboBox(Arg).Text;
      end
    else if Arg is TDateTimePicker then
      Result := FormatDateTime('YYYY/MM/DD', TDateTimePicker(Arg).Date)
    else
      Exception.CreateFmt(Chinese.AsString('不支持的参数类别：%s'),[Arg.ClassName]);
  end;
begin
  if High(Args) in [0..2] then
    begin
      chk := True; k := 0;
      if Args[0] is TCheckBox then
      begin
        chk := TCheckBox(Args[0]).Checked;
        k := 1;
      end;
      if not chk then Exit;
      case High(Args) - k of
      0: AddParamStr(KeyField, GetObjectText(Args[k]));
      1: AddParamStr(KeyField, GetObjectText(Args[k]), GetObjectText(Args[k+1]));
      end;
    end
  else
    Raise Exception.CreateFmt(Chinese.AsString('不支持的参数数目：%d'), [High(Args)]);
end;

function TCreateSQLWhere.Execute(const SQLTemplate, SQLOrder: String): Boolean;
var
  s1: String;
  savCur: TCursor;
begin
  if not Assigned(FDataSet) then
    raise Exception.Create('DataSet 不能为 nil ！');
  Result := False;
  FDataSet.Active := False;
  if SQLText = '' then
  begin
    MsgBox(Chinese.AsString('请输入查询条件! '));
    Exit;
  end;
  s1 := SQLTemplate;
  if Pos('%s', SQLTemplate) > 0 then
    s1 := Format(s1, [FMaxRecord]);
  with FDataSet do
  begin
    Active := False;
    CommandText := s1 + ' ' + Self.SQLText + ' ' + Trim(SQLOrder);
    savCur := Screen.Cursor;
    try
      Screen.Cursor := crHourGlass;
      Open;
      Result := True;
    finally
      Screen.Cursor := savCur;
    end;
  end;
end;

function TCreateSQLWhere.Execute(cdsSearch: TDataSet; const SQLTemplate,
  SQLOrder: String): Boolean;
var
  s1: String;
begin
  Result := False;
  FDataSet.Active := False;
  with cdsSearch do
  begin
    First;
    while not Eof do
    begin
      if (FieldByName('Check_').AsInteger <> 0)
        and (Copy(FieldByName('Code_').AsString,1,1) <> '@') then
      begin
        if FieldByName('Optior').AsString = '' then
          AddParamStr(FieldByName('Code_').AsString,FieldByName('Value_').AsString)
        else
          AddParam(Format('%s%s''%s''',[FieldByName('Code_').AsString,
            FieldByName('Optior').AsString,FieldByName('Value_').AsString]));
      end;
      Next;
    end;
  end;
  if SQLText = '' then
  begin
    MsgBox(Chinese.AsString('请输入查询条件! '));
    Exit;
  end;
  s1 := SQLTemplate;
  if Pos('%s', SQLTemplate) > 0 then
  begin
    if cdsSearch.Locate('Code_','@MaxRecord',[]) then
      s1:= Format(s1,[iif(cdsSearch.FieldByName('Check_').AsInteger > 0,
        'Top ' + FixIntStr(cdsSearch.FieldByName('Value_').AsString,50),'')]);
  end;
  with FDataSet do
  begin
    Active := False;
    CommandText := s1 + ' ' + Self.SQLText + ' ' + SQLOrder;
    try
      Screen.Cursor := crHourGlass;
      Open;
      Result := True;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TCreateSQLWhere.SetMaxRecord(const ACheck: TCheckBox;
  const AEdit: TEdit);
begin
  FMaxRecord := iif(ACheck.Checked,'Top ' + FixIntStr(AEdit.Text,50),'');
end;

procedure TCreateSQLWhere.CheckAllPlugins(Sender: TComponent);
var
  i: Integer;
  Obj: TComponent;
begin
  if Assigned(Sender.Owner) then
  for i := 0 to Sender.Owner.ComponentCount - 1 do
  begin
    Obj := TComponent(Sender.Owner.Components[i]);
    if Supports(Obj, IZLSearchService) then
      (Obj as IZLSearchService).SearchService(Sender, Self);
  end;
end;

procedure TCreateSQLWhere.AddParamFloat(FieldName: String; Val1,
  val2: Double);
begin
  AddParam(Format('(%s between %g and %g)', [FieldName, Val1, Val2]));
end;

{
function TCreateSQLWhere.HasValue: Boolean;
begin
  Result := Length(m_SQLText) > 0;
end;
}

function TCreateSQLWhere.GetSQLText: String;
begin
  if Length(m_SQLText) = 0 then
    Result := iif(m_AllRecord,iif(Length(DefaultText)=0,' ',DefaultText),'')
  else
    Result := ' ' + m_DefaultText + m_SQLText;
end;

{ TBuildSQL }

constructor TBuildSQL.Create(AOwner: TComponent);
begin
  inherited;
  f := TCreateSQLWhere.Create;
  if AOwner is TZjhDataSet then
    DataSet := AOwner as TZjhDataSet;
end;

destructor TBuildSQL.Destroy;
begin
  f.Free;
  inherited;
end;

function TBuildSQL.Execute(const ASelect, AOrder: String): Boolean;
begin
  Result := f.Execute(ASelect, AOrder);
end;

function TBuildSQL.GetAllRecord: Boolean;
begin
  Result := f.AllRecord;
end;

function TBuildSQL.GetCommandText(const ASelect, AOrder: String): String;
var
  s1: String;
begin
  Result := '';
  if f.SQLText = '' then
  begin
    MsgBox(Chinese.AsString('请输入查询条件! '));
    Exit;
  end;
  s1 := ASelect;
  if Pos('%s', ASelect) > 0 then
    s1 := Format(s1, [FMaxRecord]);
  Result := s1 + ' ' + f.SQLText + ' ' + Trim(AOrder);
end;

function TBuildSQL.GetDataSet: TZjhDataSet;
begin
  Result := f.DataSet;
end;

function TBuildSQL.GetDefaultText: String;
begin
  Result := f.DefaultText;
end;

procedure TBuildSQL.OutputMessage(Sender: TObject; const Value: String;
  MsgLevel: TMsgLevelOption);
begin
  if Assigned(Self.Owner) then
    begin
      if Assigned(Application.MainForm) then
      begin
        if Supports(Application.MainForm, IOutputMessage2) then
          (Application.MainForm as IOutputMessage2).OutputMessage(Self.Owner, Value, MsgLevel);
      end;
    end
  else
    begin
      if Assigned(Application.MainForm) then
      begin
        if Supports(Application.MainForm, IOutputMessage2) then
          (Application.MainForm as IOutputMessage2).OutputMessage(Self, Value, MsgLevel);
      end;
    end;
end;

procedure TBuildSQL.AddObject(const AField: String;
  const Args: array of TObject; AType: Integer);
var
  k: Integer;
  chk: Boolean;
  function GetObjectText(const Arg: TObject): String;
  begin
    if Arg is TCustomEdit then
      Result := SafeString(TCustomEdit(Arg).Text)
    else if Arg is TCustomComboBox then
      begin
        if AType = 1 then
          Result := IntToStr(TComboBox(Arg).ItemIndex)
        else
          Result := SafeString(TComboBox(Arg).Text);
      end
    else if Arg is TDateTimePicker then
      Result := FormatDateTime('YYYY/MM/DD', TDateTimePicker(Arg).Date)
    else
      Exception.CreateFmt(Chinese.AsString('不支持的参数类别：%s'),[Arg.ClassName]);
  end;
begin
  if High(Args) in [0..2] then
    begin
      chk := True; k := 0;
      if Args[0] is TCheckBox then
      begin
        chk := TCheckBox(Args[0]).Checked;
        k := 1;
      end;
      if not chk then Exit;
      case High(Args) - k of
      0: ParamByField(AField, GetObjectText(Args[k]));
      1: ParamByBetween(AField, GetObjectText(Args[k]), GetObjectText(Args[k+1]));
      end;
    end
  else
    Raise Exception.CreateFmt(Chinese.AsString('不支持的参数数目：%d'), [High(Args)]);
end;

procedure TBuildSQL.AddParam(const AParam: String);
begin
  f.AddParam('(' + AParam + ')');
end;

procedure TBuildSQL.ParamByLink(const AFields: array of string;
  const Value: String);
var
  AField: String;
  SQLCmd: String;
  str: String;
begin
  str := Replace(SafeString(Value), '*', '');
  if str <> '' then
  begin
    for AField in AFields do
      SQLCmd := SQLCmd + Format('(%s like N''%%%s%%'') or ', [AField, str]);
    if SQLCmd <> '' then
      AddParam(Copy(SQLCmd, 1, Length(SQLCmd) - 4));
  end;
end;

procedure TBuildSQL.ParamByNull(const AField: String; Value: Boolean);
begin
  if Value then
    AddParam(Format('%s is null', [AField]))
  else
    AddParam(Format('%s is not null', [AField]));
end;

procedure TBuildSQL.ParamByField(const AField: String; Value: Double);
begin
  AddParam(Format('%s=%g', [AField, Value]));
end;

procedure TBuildSQL.ParamByField(const AField: String; Value: TDateTime);
begin
  AddParam(Format('%s=''%s''', [AField, CDate(Value)]));
end;

procedure TBuildSQL.ParamByField(const AField, Value: String);
begin
  f.AddParamStr(AField, SafeString(Value));
end;

procedure TBuildSQL.ParamByField(const AField: String; Value: Integer);
begin
  AddParam(Format('%s=%d', [AField, Value]));
end;

procedure TBuildSQL.ParamByField(const AField: String; Value: Boolean);
begin
  if Value then
    AddParam(Format('%s=1', [AField]))
  else
    AddParam(Format('%s=0', [AField]));
end;

procedure TBuildSQL.ParamByBetween(const AField: String; const Value1,
  Value2: TDateTime);
begin
  AddParam(Format('%s between ''%s'' and ''%s''', [AField, CDate(Value1), CDate(Value2)]));
end;

procedure TBuildSQL.ParamByBetween(const AField: String; const Value1,
  Value2: Double);
begin
  AddParam(Format('%s between %g and %g', [AField, Value1, Value2]));
end;

procedure TBuildSQL.ParamByBetween(const AField, Value1, Value2: String);
begin
  AddParam(Format('%s between ''%s'' and ''%s''', [AField, SafeString(Value1), SafeString(Value2)]));
end;

procedure TBuildSQL.ParamByBetween(const AField: String; const Value1,
  Value2: Integer);
begin
  AddParam(Format('%s between %d and %d', [AField, Value1, Value2]));
end;

procedure TBuildSQL.ParamByRange(const AField: String;
  Values: array of Integer);
var
  AValue: Integer;
  SQLCmd: String;
begin
  for AValue in Values do
    SQLCmd := SQLCmd + Format('%d,', [AValue]);
  if SQLCmd <> '' then
    AddParam(Format('%s in (%s)', [AField, Copy(SQLCmd, 1, Length(SQLCmd) - 1)]));
end;

procedure TBuildSQL.ParamByRange(const AField: String; Values: array of Double);
var
  AValue: Double;
  SQLCmd: String;
begin
  for AValue in Values do
    SQLCmd := SQLCmd + Format('%g,', [AValue]);
  if SQLCmd <> '' then
    AddParam(Format('%s in (%s)', [AField, Copy(SQLCmd, 1, Length(SQLCmd) - 1)]));
end;

procedure TBuildSQL.ParamByRange(const AField: String; Values: array of String);
var
  AValue: String;
  SQLCmd: String;
begin
  for AValue in Values do
    SQLCmd := SQLCmd + Format('''%s'',', [SafeString(AValue)]);
  if SQLCmd <> '' then
    AddParam(Format('%s in (%s)', [AField, Copy(SQLCmd, 1, Length(SQLCmd) - 1)]));
end;

procedure TBuildSQL.SetAllRecord(const Value: Boolean);
begin
  f.AllRecord := Value;
end;

procedure TBuildSQL.SetDataSet(const Value: TZjhDataSet);
begin
  f.DataSet := Value;
end;

procedure TBuildSQL.SetDefaultText(const Value: String);
begin
  f.DefaultText := Value;
end;

procedure TBuildSQL.SetMaxRecord(const ACheck: TCheckBox; const AEdit: TEdit);
begin
  FMaxRecord := iif(ACheck.Checked, 'top ' + FixIntStr(AEdit.Text, 100), '');
  f.SetMaxRecord(ACheck, AEdit);
end;

function TBuildSQL.CDate(Value: TDateTime): String;
var
  FormatSettings: TFormatSettings;
begin
  FormatSettings.ShortDateFormat := 'YYYY/MM/DD';
  FormatSettings.DateSeparator := '/';
  Result := FormatDateTime('YYYY/MM/DD', Value, FormatSettings);
end;

function Replace(const Value, SubStr, RplStr: String): String;
begin
  Result := StringReplace(Value, SubStr, RplStr, [rfReplaceAll]);
end;

function FixIntStr(const Value: String; Default: Integer): String;
begin
  Result := IntToStr(StrToIntDef(Value,Default));
end;

procedure SetImageRes(Image: TImage; ResID: Integer);
var
  Obj: TComponent;
  AIntf: IHRObject;
begin
  Obj := CreateClass('TImageOfResID', nil);
  if Assigned(Obj) then
  try
    AIntf := Obj as IHRObject;
    AIntf.PostMessage(CONST_DEFAULT, VarArrayOf([Integer(Image), ResID]));
  finally
    AIntf := nil;
    Obj.Free;
  end;
  //MainIntf.PostMessage(CONST_MAINFORM_SETIMAGERES,
  //  VarArrayOf([Integer(Image), ResID]));
end;

function ViewDetail(const ClassName: String;
  const Param: Variant): IBaseForm;
var
  AIntf: IBaseForm;
begin
  AIntf := nil;
  if VarIsArray(Param) or (VarToStr(Param) <> '') then
    begin
      AIntf := MainIntf.GetForm(ClassName, True);
      if Assigned(AIntf) then
        begin
          AIntf.PostMessage(CONST_GOTORECORD, Param);
          if AIntf.GetControl('') is TCustomForm then
            TCustomForm(AIntf.GetControl('')).Show;
        end
      else
        MsgBox(Chinese.AsString(Format('MainIntf.GetForm(%s) 执行失败！', [ClassName])), 'ViewDetail');
    end
  else
    MsgBox(Chinese.AsString(Format('%s 调用参数错误！', [ClassName])), 'ViewDetail');
  Result := AIntf;
end;

{ TDBGridEx }

function TZjhDBGrid.GridSortByColumn(Grid: TCustomDBGrid; Column: TColumn): Boolean;
const
  //↑↓Λ  ▲▼△▽Δ
  sUp = '^';
  sDown = 'v';
var
  cFieldName: string;
  i: integer;
  DataSet: TDataSet;
  procedure SetTitle;
  var
    ii: integer;
    cStr: string;
    c: TColumn;
  begin
    for ii := 0 to TDBGrid(Column.Grid).Columns.Count - 1 do begin
      c := TDBGrid(Column.Grid).Columns[ii];
      cStr := c.Title.Caption;
      if (Pos(sUp, cStr) = 1) or (Pos(sDown, cStr) = 1) then begin
        Delete(cStr, 1, 1);
        c.Title.Caption := cStr;
      end;
    end;
  end;
begin
  Result := False;
  if not Assigned(Grid.DataSource) then Exit;
  DataSet := Grid.DataSource.DataSet;
  if not Assigned(DataSet) then Exit;
  if not DataSet.Active then Exit;
  SetTitle;
  if Column.Field.FieldKind = fkLookup then
    cFieldName := Column.Field.KeyFields
  else
    if Column.Field.FieldKind = fkCalculated then
      cFieldName := Column.Field.KeyFields
    else
      cFieldName := Column.FieldName;
{
  if DataSet is TCustomADODataSet then begin
    s := TCustomADODataSet(DataSet).Sort;
    if s = '' then begin
      s := cFieldName;
      Column.Title.Caption := sUp + Column.Field.DisplayName;
    end else begin
      if Pos(cFieldName, s) <> 0 then begin
        i := Pos('DESC', s);
        if i <= 0 then begin
          s := s + ' DESC';
          Column.Title.Caption := sDown + Column.Field.DisplayName;
        end else begin
          Column.Title.Caption := sUp + Column.Field.DisplayName;
          Delete(s, i, 4);
        end;
      end else begin
        s := cFieldName;
        Column.Title.Caption := sUp + Column.Field.DisplayName;
      end;
    end;
    TCustomADODataSet(DataSet).Sort := s;
    Result := True;
  end;
}
  if DataSet is TCustomClientDataSet then begin
    SetTitle;
    if TClientDataSet(DataSet).IndexFieldNames <> '' then begin
      i := TClientDataSet(DataSet).IndexDefs.IndexOf('i' + Column.FieldName);
      if i = -1 then begin
        with TClientDataSet(DataSet).IndexDefs.AddIndexDef do begin
          Name := 'i' + Column.FieldName;
          Fields := Column.FieldName;
          DescFields := Column.FieldName;
        end;
      end;
      TClientDataSet(DataSet).IndexFieldNames := '';
      TClientDataSet(DataSet).IndexName := 'i' + Column.FieldName;
      Column.Title.Caption := sDown + Column.Title.Caption;
    end else begin
      TClientDataSet(DataSet).IndexName := '';
      TClientDataSet(DataSet).IndexFieldNames := Column.Fieldname;
      Column.Title.Caption := sUp + Column.Title.Caption;
    end;
    Result := True;
  end;
end;

constructor TZjhDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSortOnClickTitle := True;
end;

destructor TZjhDBGrid.Destroy;
begin
  inherited;
end;

procedure TZjhDBGrid.TitleClick(Column: TColumn);
begin
  inherited;
  if FSortOnClickTitle then
    GridSortByColumn(Self, Column);
end;

{ TZoomWindow }

constructor TZoomWindow.Create(AOwner: TComponent);
begin
  inherited;
  FOldFontSize := 8; //默认8号字
  FCurFontSize := 8 + ureg.ReadInteger('system', 'ZoomFace', 0) * 2;
  if not FCurFontSize in [8..20] then
    FCurFontSize := 8;
  FItems := TStringList.Create;
end;

destructor TZoomWindow.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TZoomWindow.GetFontList(AList: TStrings);
var
  i, k, w, h: Integer;
begin
  for i := 0 to 6 do //最大20号字
  begin
    k := 8 + 2 * i;
    w := Ceil((k / 8) * 800);
    h := Ceil((k / 8) * 600);
    if (w <= Screen.Width) and (h <= Screen.Height) then
      AList.Add(Format('%d号字(%d*%d)', [k , w, h]))
    else
      Break;
  end;
end;

function TZoomWindow.GetItems: TStrings;
begin
  Result := FItems;
end;

procedure TZoomWindow.SetCurFontSize(const Value: Integer);
begin
  if Value in [8..20] then
  begin
    if FCurFontSize <> Value then
    begin
      FOldFontSize := FCurFontSize;
      FCurFontSize := Value;
    end;
  end;
end;

procedure TZoomWindow.Refresh(ATarget: TObject);
begin
  if FCurFontSize = FOldFontSize then
    Exit;
  try
    SaveFace(ATarget);
    //ShowMessage(FItems.Text);
    UpdateFace(ATarget);
  finally
    SetLength(FList, 0);
  end;
end;

class procedure TZoomWindow.RefreshForm(ATarget: TComponent);
var
  Zoom: TZoomWindow;
begin
  Zoom := TZoomWindow.Create(ATarget);
  try
    Zoom.CurFontSize := 8 + ureg.ReadInteger('system', 'ZoomFace', 0) * 2;
    Zoom.Refresh(ATarget);
  finally
    Zoom.Free;
  end;
end;

procedure TZoomWindow.SaveFace(ATarget: TObject);
var
  i: Integer;
begin
  if ATarget is TControl then
  begin
    with TControl(ATarget) do
    begin
      if FindControl(ATarget) = -1 then
      begin
        SetLength(FList, Length(FList) + 1);
        FList[High(FList)].Obj := ATarget;
        FList[High(FList)].Left := Left;
        FList[High(FList)].Top := Top;
        FList[High(FList)].Width := Width;
        FList[High(FList)].Height := Height;
        FItems.Add(Name); //此句未来须删除！
      end;
    end;
  end;
  //设置子对象
  if ATarget is TComponent then
  begin
    with TComponent(ATarget) do
    begin
      for i := 0 to ComponentCount - 1 do
        Self.SaveFace(Components[i]);
    end;
  end;
end;

procedure TZoomWindow.UpdateFace(ATarget: TObject);
var
  i: Integer;
  ALeft, ATop, AWidth, AHeight: Integer;
  Rec: TZoomObjectRecord;
  ZoomRate: Double;
begin
  ZoomRate := FCurFontSize / FOldFontSize;
  if ATarget is TControl then
  begin
    i := FindControl(ATarget);
    if i = -1 then
      raise Exception.Create('SaveFace 存在问题！');
    Rec := FList[i];
    ALeft := Ceil(Rec.Left * ZoomRate);
    ATop := Ceil(Rec.Top * ZoomRate);
    AWidth := Ceil(Rec.Width * ZoomRate);
    AHeight := Ceil(Rec.Height * ZoomRate);
    with TControl(ATarget) do
    begin
      if ATarget is TForm  then
        begin
          if TForm(ATarget).WindowState <> wsMaximized then
          begin
            if TForm(ATarget).Top > 10 then
            begin
              Left := Ceil(Rec.Left / ZoomRate);
              Top := Ceil(Rec.Top / ZoomRate);
            end;
            Width := AWidth; Height := AHeight;
          end;
        end
      else if ATarget is TDBGrid then
        begin
          Left := ALeft; Top := ATop;
          Width := AWidth; Height := AHeight;
          with TDBGrid(ATarget) do
          begin
            TitleFont.Size := FCurFontSize;
            for i := 0 to Columns.Count - 1 do
            begin
              Columns[i].Title.Font.Size := FCurFontSize;
              Columns[i].Font.Size := FCurFontSize;
              Columns[i].Width := Ceil(ZoomRate * Columns[i].Width)
            end;
          end;
        end
      else if ATarget is TListView then
        begin
          Left := ALeft; Top := ATop;
          Width := AWidth; Height := AHeight;
          with TListView(ATarget) do
          begin
            for i := 0 to Columns.Count - 1 do
            begin
              Columns[i].Width := Ceil(ZoomRate * Columns[i].Width)
            end;
          end;
        end
      else if ATarget is TStatusBar then
        begin
          Left := ALeft; Top := ATop;
          Width := AWidth; Height := AHeight;
          with TStatusBar(ATarget) do
          begin
            if not SimplePanel then
            begin
              for i := 0 to Panels.Count - 1 do
              begin
                Panels[i].Width := Ceil(ZoomRate * Panels[i].Width);
              end;
            end;
          end;
        end
      else if ATarget is TLabel then
        begin
          Left := ALeft; Top := ATop;
          if not TLabel(ATarget).AutoSize then
          begin
            Width := AWidth; Height := AHeight;
          end;
        end
      else
        begin
          Left := ALeft; Top := ATop;
          Width := AWidth; Height := AHeight;
          //MsgBox('%d, %d, %d, %d', [Rect.Left, Rect.Top, Rect.Right, Rect.Bottom]);
        end;
      TFontControl(ATarget).Font.Size := FCurFontSize;
    end;
  end;
  //设置子对象
  if ATarget is TComponent then
  begin
    with TComponent(ATarget) do
    begin
      for i := 0 to ComponentCount - 1 do
        Self.UpdateFace(Components[i]);
    end;
  end;
end;

function TZoomWindow.FindControl(AObj: TObject): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to High(FList) do
  begin
    if FList[i].Obj = AObj then
    begin
      Result := i;
      Break;
    end;
  end;
end;

{ TPYIME }

constructor TPYIME.Create(AOwner: TComponent);
var
  i: Integer;
  str, imeFile: string;
  sl: TStringList;
begin
  inherited;
  sl := TStringList.Create;
  try
    imeFile := ExtractFilePath(Application.ExeName) + 'pinyin.dict';
    if FileExists(imeFile) then
    begin
      sl.LoadFromFile(imeFile);
      SetLength(FDict, sl.Count);
      for i := 0 to sl.Count - 1 do
      begin
        str := sl.Strings[i];
        if Pos('=', str) > 0 then
        begin
          FDict[i].Code := Copy(str, 1, Pos('=', str) - 1);
          FDict[i].Value := Copy(str, Pos('=', str) + 1, Length(str));
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

destructor TPYIME.Destroy;
begin
  SetLength(FDict, 0);
  inherited;
end;

function TPYIME.GetPinyin(const AValue: string): string;
var
  i: Integer;
begin
  Result := AValue;
  for i := Low(FDict) to High(FDict) do
  begin
    if Pos(AValue, FDict[i].Value) > 0 then
    begin
      Result := FDict[i].Code;
      Break;
    end;
  end;
end;

class function TPYIME.GetShortCode(const AValue: string): string;
var
  i: Integer;
begin
  Result := '';
  if not Assigned(__PYIME) then
    __PYIME := TPYIME.Create(Application);
  for i := 1 to Length(AValue) do
    Result := Result + Copy(__PYIME.GetPinyin(Copy(AValue, i, 1)), 1, 1);
end;

//生成国标汉字表
//procedure CreateFile_GB2312;
//var
//  s3, s4: AnsiString;
//  i, j: Integer;
//  sl: TStringList;
//  strFile: string;
//begin
//  //GB2312范围： 0xA1A1(41377) - 0xFEFE(65278)
//  //其中汉字范围： 0xB0A1(45217) - 0xF7FE(63486)
//  SetLength(s3, 2);
//  sl := TStringList.Create;
//  try
//    for i := StrToInt('0xB0') to StrToInt('0xF7') do
//    begin
//      s4 := '';
//      for j := StrToInt('0xA1') to StrToInt('0xFE') do
//      begin
//        s3[1] := AnsiChar(i);
//        s3[2] := AnsiChar(j);
//        s4 := s4 + s3;
//      end;
//      sl.Add(s4);
//    end;
//    strFile := ExtractFilePath(Application.ExeName) + 'GB2312.txt';
//    sl.SaveToFile(strFile);
//  finally
//    sl.Free;
//  end;
//end;

//将原字典文件转换为新的格式，记得转换后再手工调试 张弓 2014/3/5
{
procedure TForm2.FormCreate(Sender: TObject);
var
  i, j: Integer;
  sl1, sl2, sl3: TStringList;
  srcFile, tarFile: string;
  str, s1, s2: string;
begin
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  sl3 := TStringList.Create;
  try
    srcFile := 'D:\MIMRC\Partner\CDROM\Server\gb2312-pinyin.txt';
    tarFile := 'D:\MIMRC\Partner\CDROM\Server\pinyin.dict';
    sl1.LoadFromFile(srcFile);
    for i := 0 to sl1.Count - 1 do
    begin
      str := sl1.Strings[i];
      s1 := Copy(str, 1, 1);
      s2 := Copy(str, Pos('(', str) + 1, Length(str));
      s2 := Copy(s2, 1, Length(s2)-2);
      j := sl2.IndexOf(s2);
      if j = -1 then
        begin
          sl2.Add(s2);
          sl3.Add(s1);
        end
      else
        sl3.Strings[j] := sl3.Strings[j] + s1;
    end;
    for i := 0 to sl2.Count - 1 do
      Memo1.Lines.Add(sl2.Strings[i] + '=' + sl3.Strings[i]);
    Memo1.Lines.SaveToFile(tarFile);
  finally
    sl1.Free;
    sl2.Free;
    sl3.Free;
  end;
end;
}

{ TBuildSQL2 }

constructor TBuildSQL2.Create(AOwner: TComponent);
begin
  inherited;
  FAllRecord := False;
  if AOwner is TDataSet then
  begin
    if (AOwner is TClientDataSet) or (AOwner is TZjhDataSet) or (AOwner is TAppQuery) then
      FDataSet := AOwner as TDataSet
    else
      raise Exception.CreateFmt('%s 不支持 %s 数据集', [Self.ClassName, AOwner.ClassName]);
  end;
end;

function TBuildSQL2.Execute(const SQLTemplate, SQLOrder: String): Boolean;
var
  sql: String;
  savCur: TCursor;
begin
  Result := False;
  if not Assigned(FDataSet) then
    raise Exception.Create('DataSet 不能为 nil ！');
  if not FAllRecord then
  begin
    if (FDefaultText = '') and (FSQLText = '') then
      raise Exception.Create('请输入查询条件! ');
  end;
  sql := BuildCommand(SQLTemplate, SQLOrder);
  with FDataSet do
  begin
    Active := False;
    if FDataSet is TClientDataSet then
      TClientDataSet(FDataSet).CommandText := sql
    else if FDataSet is TZjhDataSet then
      TZjhDataSet(FDataSet).CommandText := sql
    else if FDataSet is TAppQuery then
      TAppQuery(FDataSet).CommandText := sql
    else
      raise Exception.CreateFmt('%s 不支持 %s 数据集', [Self.ClassName, FDataSet.ClassName]);
    savCur := Screen.Cursor;
    try
      Screen.Cursor := crHourGlass;
      Open;
      Result := True;
    finally
      Screen.Cursor := savCur;
    end;
  end;
end;

function TBuildSQL2.BuildCommand(const SQLTemplate, SQLOrder: String): string;
begin
  if Pos('%s', SQLTemplate) > 0 then
    Result := Format(SQLTemplate, [FMaxRecord]) + ' ' + FDefaultText + ' ' + FSQLText + ' ' + Trim(SQLOrder)
  else
    Result := SQLTemplate + ' ' + FDefaultText + ' ' + FSQLText + ' ' + Trim(SQLOrder);
end;

procedure TBuildSQL2.ParamByLink(const AFields: array of string;
  const Value: String);
var
  AField: String;
  SQLCmd: String;
  str: String;
begin
  str := Replace(SafeString(Value), '*', '');
  if str <> '' then
  begin
    for AField in AFields do
      SQLCmd := SQLCmd + Format('(%s like N''%%%s%%'') or ', [AField, str]);
    if SQLCmd <> '' then
      AddParam(Copy(SQLCmd, 1, Length(SQLCmd) - 4));
  end;
end;

procedure TBuildSQL2.ParamByNull(const AField: String; Value: Boolean);
begin
  if Value then
    AddParam(Format('%s is null', [AField]))
  else
    AddParam(Format('%s is not null', [AField]));
end;

procedure TBuildSQL2.ParamByField(const AField: String; Value: Double);
begin
  AddParam(Format('%s=%g', [AField, Value]));
end;

procedure TBuildSQL2.ParamByField(const AField: String; Value: TDateTime);
begin
  AddParam(Format('%s=''%s''', [AField, CDate(Value)]));
end;

procedure TBuildSQL2.ParamByField(const AField, Value: String);
begin
  AddParamStr(AField, SafeString(Value));
end;

procedure TBuildSQL2.ParamByField(const AField: String; Value: Integer);
begin
  AddParam(Format('%s=%d', [AField, Value]));
end;

procedure TBuildSQL2.ParamByField(const AField: String; Value: Boolean);
begin
  if Value then
    AddParam(Format('%s=1', [AField]))
  else
    AddParam(Format('%s=0', [AField]));
end;

procedure TBuildSQL2.ParamByBetween(const AField: String; const Value1,
  Value2: TDateTime);
begin
  AddParam(Format('%s between ''%s'' and ''%s''', [AField, CDate(Value1), CDate(Value2)]));
end;

procedure TBuildSQL2.ParamByBetween(const AField: String; const Value1,
  Value2: Double);
begin
  AddParam(Format('%s between %g and %g', [AField, Value1, Value2]));
end;

procedure TBuildSQL2.ParamByBetween(const AField, Value1, Value2: String);
begin
  AddParam(Format('%s between ''%s'' and ''%s''', [AField, SafeString(Value1), SafeString(Value2)]));
end;

procedure TBuildSQL2.ParamByBetween(const AField: String; const Value1,
  Value2: Integer);
begin
  AddParam(Format('%s between %d and %d', [AField, Value1, Value2]));
end;

procedure TBuildSQL2.ParamByRange(const AField: String;
  Values: array of Integer);
var
  AValue: Integer;
  SQLCmd: String;
begin
  for AValue in Values do
    SQLCmd := SQLCmd + Format('%d,', [AValue]);
  if SQLCmd <> '' then
    AddParam(Format('%s in (%s)', [AField, Copy(SQLCmd, 1, Length(SQLCmd) - 1)]));
end;

procedure TBuildSQL2.ParamByRange(const AField: String; Values: array of Double);
var
  AValue: Double;
  SQLCmd: String;
begin
  for AValue in Values do
    SQLCmd := SQLCmd + Format('%g,', [AValue]);
  if SQLCmd <> '' then
    AddParam(Format('%s in (%s)', [AField, Copy(SQLCmd, 1, Length(SQLCmd) - 1)]));
end;

procedure TBuildSQL2.ParamByRange(const AField: String; Values: array of String);
var
  AValue: String;
  SQLCmd: String;
begin
  for AValue in Values do
    SQLCmd := SQLCmd + Format('''%s'',', [SafeString(AValue)]);
  if SQLCmd <> '' then
    AddParam(Format('%s in (%s)', [AField, Copy(SQLCmd, 1, Length(SQLCmd) - 1)]));
end;

procedure TBuildSQL2.AddParamStr(FieldName, Value: String);
var
  V: String;
begin
  V := Trim(Value);
  if (Length(V)>0) and (V <> '*') then
  begin
    if (Copy(Value, 1, 1) = ' ') and (Pos(' ', V) > 0) then
      begin
        if Copy(V, Length(V), 1) = '*' then
          V := Copy(V, 1, Length(V) - 1);
        V := StringReplace(V,' ','%', [rfReplaceAll]);
        AddParam(FieldName + ' like N''%' + V + '%''');
      end
    else if (Copy(V,1,1) = '*') or (Copy(V,Length(V),1) = '*') then
      begin
        if (Copy(V,1,1) = '*') and (Copy(V,Length(V),1) = '*') then
          begin
            V := Copy(V,2,Length(V)-2);
            AddParam(FieldName + ' like N' + '''%' + V + '%' + '''');
          end
        else if (Copy(V,1,1) = '*') then
          begin
            V := Copy(V,2,Length(V)-1);
            AddParam(FieldName + ' like N' + '''%' + V + '''');
          end
        else // if (Copy(V,Length(V),1) = '*') then
          begin
            V := Copy(V,1,Length(V)-1);
            AddParam(FieldName + ' like N' + '''' + V + '%''');
          end;
      end
    else if UpperCase(V) = UpperCase('NULL') then
      AddParam(Format('(%s is null or %s='''')',[FieldName,FieldName]))
    else if (Length(V) > 2) and (Copy(V,1,1)='[') and (Copy(V,Length(V),1)=']') then
      begin
        V := Replace(V, ',', ''',''');
        AddParam(Format('(%s in (N''%s''))',[FieldName, Copy(V,2,Length(V)-2)]));
      end
    else if Pos('..', V) > 0 then //范围查询
      begin
        AddParam(Format('(%s between N''%s'' and N''%s'')',
          [FieldName, Copy(V, 1, Pos('..',V) - 1),
          Copy(V, Pos('..', V) + 2, Length(V))]));
      end
    else if Copy(V, 1, 2) = '<>' then //不等于查询
      begin
        AddParam(Format('(%s <> N''%s'')', [FieldName, Copy(V, 3, Length(V))]));
      end
    else
      AddParam(FieldName + ' = N''' + V + '''');
  end;
  if V = '*' then FAllRecord := true;
end;

procedure TBuildSQL2.AddParam(const AParam: String);
var
  bWhereFlag: Boolean;
  Text: string;
begin
  Text := '(' + AParam + ')';
  bWhereFlag := not ((Length(DefaultText) = 0) and (Length(FSQLText) = 0));
  FSQLText := FSQLText + iif(bWhereFlag,' and ',' where ') + Text;
end;

procedure TBuildSQL2.SetMaxRecord(const ACheck: TCheckBox;
  const AEdit: TEdit);
begin
  FMaxRecord := iif(ACheck.Checked, 'top ' + FixIntStr(AEdit.Text, 100), '');
end;

function TBuildSQL2.GetCommandText: string;
begin
  Result := '';
  if Assigned(FDataSet) then
    begin
      if FDataSet is TClientDataSet then
        Result := TClientDataSet(FDataSet).CommandText
      else if FDataSet is TZjhDataSet then
        Result := TZjhDataSet(FDataSet).CommandText
      else if FDataSet is TAppQuery then
        Result := TAppQuery(FDataSet).CommandText
      else
        raise Exception.CreateFmt('%s 不支持 %s 数据集', [Self.ClassName, FDataSet.ClassName]);
    end
  else
    raise Exception.Create('DataSet 不能为 nil ！');
end;

function TBuildSQL2.CDate(Value: TDateTime): String;
var
  FormatSettings: TFormatSettings;
begin
  FormatSettings.ShortDateFormat := 'YYYY/MM/DD';
  FormatSettings.DateSeparator := '/';
  Result := FormatDateTime('YYYY/MM/DD', Value, FormatSettings);
end;

end.


