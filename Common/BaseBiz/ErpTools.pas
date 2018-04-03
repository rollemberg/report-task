unit ErpTools;
{$I ERPVersion.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ToolWin, ComCtrls, ExtCtrls, DBCtrls, StdCtrls, Buttons,
  DB, ADODB, ImgList, DBClient, DBGrids, SConnect, TypInfo, AppData, AppBean,
  Excel2000, Word2000, OleServer, DateUtils, ShellAPI, IniFiles, ApConst,
  ZjhCtrls, InfoBox, uBaseIntf, Math, uBuffer, XMLDoc, XMLIntf, KnowAll,
  SQLServer, MainData, AppService, AppDB, ComObj;

type
  //仅用于 GetDBGrid 函数中
  TTmpDataSource = class(TDataSource)
  public
    property DataLinks;
  end;
  IHRTableDefault = interface
    ['{C10408F3-2307-4CE8-8DB2-FD98D580405E}']
    procedure ReadDefault(Sender: TDataSet; const TableName: String);
  end;
  ICaclStdCost = interface
    ['{822E517B-6ECD-41C2-AE3C-39C0100B76C0}']
    procedure SetDataSet(Value: TZjhDataSet);
    procedure SetProductCode(const Value: String);
    procedure SetPackageNo(const Value: String);
    procedure SetBomNum(Value: Double);
    function Execute: Double;
  end;
  IZLAnyToAcc = interface
    ['{24798A6C-5E60-470B-9E50-570783D19F20}']
    procedure ATA_Init(const ACode, ATBNo: String; ATBDate: TDateTime);
    procedure ATA_Begin(const WorkType: String);
    procedure ATA_End;
    function AddDebit(Index: Integer): PHRAnyToAccRecord; overload;
    function AddDebit(const AccCode: String): PHRAnyToAccRecord; overload;
    function AddCredit(Index: Integer): PHRAnyToAccRecord; overload;
    function AddCredit(const AccCode: String): PHRAnyToAccRecord; overload;
  end;
  TEnrollImportSource = function(const SrcID, SrcTBNo: String): Boolean of Object;
  IToAccBook = interface
    ['{6D7BAEBE-0B2D-4800-90AF-03B3AA6AA1ED}']
    procedure AccDataInit(Sender: IBaseForm; var BookCode, SrcTB: String; var SrcTBDate: TDateTime);
    procedure AccDataInput(cdsAccData: TDataSet; EnrollSource: TEnrollImportSource);
    procedure TalkAccTBNo(const SrcID, ABNo: String);
    procedure AccDataEnd;
  end;
  IHRCreateML = interface
  ['{F3D38493-258E-4665-B859-0F2AB1488728}']
    //
    procedure SetMakeNo(const Value: String);
    procedure SetMakeIt(const Value: Integer);
    function GetMakeNo: String;
    function GetMakeIt: Integer;
    //
    property MakeNo: String read GetMakeNo write SetMakeNo;
    property MakeIt: Integer read GetMakeIt write SetMakeIt;
    function MKDBToML: Boolean;
    //
  end;
  //增强型数据集
  TDictionary = Class
  private
    FTag: Integer;
    FID: TStringList;
    FData: TStringList;
    function GetID(Index: Integer): string;
    function GetData(Index: Integer): string;
    procedure SetID(Index: Integer; const Value: string);
    procedure SetData(Index: Integer; const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    property ID: TStringList read FID;
    property Data: TStringList read FData;
    function IndexOf(const ACode: String): Integer;
    function AddItem(const ACode, AName: String): Integer;
    property Tag: Integer read FTag write FTag;
    property IDs[Index: Integer]: string read GetID write SetID;
    property Datas[Index: Integer]: string read GetData write SetData;
  end;
  //处理小数点精度问题
  THRFixDecimal = class(TComponent)
  private
    LocalCurrency: String;
    cdsUnit: TZjhDataSet;
    cdsMoney: TZjhDataSet;
    procedure OpenMoney;
  public
    procedure ClearAll;
    function AsCurrency(const Value: Double): Double; overload;
    function AsCurrency(const ACurrency: String; const Value: Double): Double; overload;
    function AsUnit(const AUnit: String; const Value: Double): Double;
    function AsValue(const Value: Double; const Decimal: Integer): Double;
  end;
  //
  TBIWorkRange = class
  public
    MonthBegin: String;
    MonthEnd: String;
    DayBegin: TDatetime;
    DayEnd: TDatetime;
    procedure Clear;
    function OfRange(const AMonth: String): Boolean; overload;
    function OfRange(const ADate: TDateTime): Boolean; overload;
  end;
  TBIMonth = class
  private
    FValue: String;
    FDayBegin: TDatetime;
    FDayEnd: TDatetime;
    FIsInit: Boolean;
    FIsLocked: Boolean;
    FMoved: Integer;
    FIsDefault: Boolean;
  public
    property Value: String read FValue;
    property DayBegin: TDatetime read FDayBegin;
    property DayEnd: TDatetime read FDayEnd;
    property IsInit: Boolean read FIsInit;
    property IsLocked: Boolean read FIsLocked;
    property MovedState: Integer read FMoved;
    property IsDefault: Boolean read FIsDefault;
    procedure LoadFrom(const DataSet: TDataSet);
    procedure Clear;
    function OfRange(const ADate: TDateTime): Boolean;
    function PriorMonth: String;
  end;
  TBookInfo = class(TComponent)
  private
    FActive: Boolean;
    FBookCode: String;
    cdsData: TZjhDataSet;
    FItems: TObjectBuffer;
    //
    FInitMonth: TBIMonth;
    FEndMonth: TBIMonth;
    FDefaultMonth: TBIMonth;
    FWorkRange: TBIWorkRange;
    procedure SetBookCode(const Value: String);
    function GetItemCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function CreateSingle(const ABookCode: String): TBookInfo;
    procedure Reload;
    //
    property Items: TObjectBuffer read FItems;
    property ItemCount: Integer read GetItemCount;
    function GetItem(const AMonth: String): TBIMonth;
    //
    property InitMonth: TBIMonth read FInitMonth;       //开帐年月
    property EndMonth: TBIMonth read FEndMonth;         //最后年月
    property DefaultMonth: TBIMonth read FDefaultMonth; //默认工作年月
    property WorkRange: TBIWorkRange read FWorkRange;   //允许工作范围
    property BookCode: String read FBookCode write SetBookCode;
    property Active: Boolean read FActive;
  end;
  //
  TRecordExportACReq = class
  private
    FOriAmount: Double;
    FExRate: Double;
    FMoneyCode: String;
    FAmount: Double;
    FDrCrChange: Boolean;
    procedure SetExRate(const Value: Double);
    procedure SetMoneyCode(const Value: String);
    procedure SetOriAmount(const Value: Double);
    procedure SetAmount(const Value: Double);
    procedure SetDrCrChange(const Value: Boolean);
  public
    SrcID: String;
    SrcTBNo: String;
    Dr: Boolean;
    AccCode: String;
    Desp: String;
    CostDept: String; //兼容老版本而存在，V2012及以后不要再使用
    ObjCode: String;
    HasError: Boolean;
    AllowZero: Boolean; //允许原币为0
    ObjCodeArray: TArrayRecord;
    procedure CheckAndRepair;
  public
    property MoneyCode: String read FMoneyCode write SetMoneyCode;
    property OriAmount: Double read FOriAmount write SetOriAmount;
    property ExRate: Double read FExRate write SetExRate;
    property Amount: Double read FAmount write SetAmount;
    property DrCrChange: Boolean read FDrCrChange write SetDrCrChange;
  end;
  //
  IExportACReq = interface
    ['{56D4CAB9-4B0D-444B-B2B4-87CD9094A1B7}']
    function Init(Source: TZjhDataSet; const SrcTB, BookCode: String): Boolean;
    function EnrollSource(const SrcTBNo: String; SrcTBDate: TDatetime): Boolean;
    function AppendItem: TRecordExportACReq;
    function GetDrCrDiffAmount: Double;
    function Save: Boolean;
    //取系统参数中之会计科目
    function GetAccCode(const ATitle, Section, KeyCode: String): String;
    function GetSubAccCode(const ATitle, Section, KeyCode,
      MoneyCode: String): String;
  end;
  //自定义查询，后须取消 Jason at 2010/9/20
  ISearchFrame = Interface
    ['{702FBAA6-28DA-40C2-B2AE-20921E329385}']
    procedure Init(const MaxRecord: Integer = 0);
    function AddParam(const ACode, AName: String;
      const Default: String = ''): TField; overload;
    function AddParam(const ACode, AName, Default: String;
      AType: Integer; const AWindow: String = ''): TField; overload;
    //
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
    //
    property Active: Boolean read GetActive write SetActive;
    property DataSet: TZjhDataSet read GetDataSet write SetDataSet;
    property ViewGrid: TDBGrid read GetViewGrid write SetViewGrid;
    property DefaultText: String read GetDefaultText write SetDefaultText;
    property SQLTemplate: String read GetSQLTemplate write SetSQLTemplate;
    property SQLOrder: String read GetSQLOrder write SetSQLOrder;
    property OnSearchClick: TNotifyEvent read GetOnSearchClick write SetOnSearchClick;
  end;
  IFraDocument = Interface
    ['{CBB60526-EE87-4D1D-9800-C29959261D58}']
    function GetActive: Boolean;
    function GetDefRootName: String;
    function GetPathName: String;
    function GetReadOnly: Boolean;
    function GetRootID: String;
    function GetRootName: String;
    //
    procedure SetActive(const Value: Boolean);
    procedure SetDefRootName(const Value: String);
    procedure SetPathName(const Value: String);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetRootID(const Value: String);
    procedure SetRootName(const Value: String);
    //
    property DefRootName: String read GetDefRootName write SetDefRootName;
    property RootID: String read GetRootID write SetRootID;
    property RootName: String read GetRootName write SetRootName;
    property PathName: String read GetPathName write SetPathName;
    property Active: Boolean read GetActive write SetActive;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    //
    procedure RefreshView(const Flag: Boolean);
    function AddItem(const AName, NewName: String): Boolean;
    function GetItem(const AName: String): Boolean;
    function DeleteItem(const AName: String): Boolean;
    function Own: TFrame;
  end;
  IFraFlow = Interface
    ['{A3D9A8A2-56C5-4DFA-B0AA-BCC9A09B6EBC}']
    procedure SetReadOnly(const Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetMasterKey(const Value: String);
    function GetMasterKey: String;
    //
    property MasterKey: String read GetMasterKey write SetMasterKey;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    //
    function GotoRecord(const AKey: Variant): Boolean; overload;
    function GotoRecord(ADataSet: TObject; const AField: Variant): Boolean; overload;
    procedure DeleteRecord(const AKey: String);
    procedure SaveRecord;
    //
    procedure Init(ASec: TObject);
    function own: TFrame;
  end;
  IFraStockCW = Interface
    ['{69BD33C1-EE96-4008-AC72-60F149ECE57A}']
    function GetActive: Boolean;
    function GetReadOnly: Boolean;
    function GetPID: String;
    function GetPartCode: String;
    function GetWHCode: String;
    function GetTBNo: String;
    function GetTBDate: TDateTime;
    //
    procedure SetActive(const Value: Boolean);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetPartCode(const Value: String);
    procedure SetPID(const Value: String);
    procedure SetWHCode(const Value: String);
    procedure SetTBNo(const Value: String);
    procedure SetTBDate(const Value: TDateTime);
    //
    property Active: Boolean read GetActive write SetActive;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property PID: String read GetPID write SetPID;
    property PartCode: String read GetPartCode write SetPartCode;
    property WHCode: String read GetWHCode write SetWHCode;
    //
    procedure RefreshView(const Flag: Boolean);
    function Own: TFrame;
    function PostMessage(MsgType: Integer; Msg: Variant):Variant;
  end;
  //处理报表变体
  TReportParam = record
    Values: Variant;
    procedure RegValues(Items: TStrings);
    function Decode(const Key: String; var Text: String): Boolean;
  end;
  //目录管理器
  THRDirectory = class
  private
    FDirectory: String;
    FFilter: string;   //当前所有文件
    FFolders: TStringList; //当前所有子目录
    FFiles: TStringList;
    procedure Clear;
    function GetFiles: TStrings;
    procedure SetDirectory(const Value: String);
    function GetItem(Index: Integer): String;
    function GetFolders: TStrings;
    procedure SetFilter(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure Refresh;
    function ItemCount: Integer;
    property Items[Index: Integer]: String read GetItem; default;
    property Folders: TStrings read GetFolders;
    property Files: TStrings read GetFiles;
    property Directory: String read FDirectory write SetDirectory;
    property Filter: string read FFilter write SetFilter;
  end;
  //函数管理器中之参数解析
  TParamParse = class
  private
    FData: String;
    FParam: TStringList;
    function GetParams(Index: Integer): String;
    procedure SetData(const Value: String);
  public
    constructor Create(const ParamValue: String);
    destructor Destroy; override;
    procedure Parse;
    function ParamCount: Integer;
    property Params[Index: Integer]: String read GetParams;
    property Data: String read FData write SetData;
  end;
  TZLXMLRecords = class
  public
    procedure SaveToNode(root: IXMLNode; DataSet: TDataSet;
      Field_List: array of string);
    procedure LoadFromNode(root: IXMLNode; DataSet: TDataSet);
    procedure LoadFromFile(const xmlFile: String; DataSet: TZjhDataSet);
  end;
  //调用后台AppBean专用
  TDebugService = class(TComponent)
  private
    FService: TComponentClass;
    FError: OleVariant;
    FData: OleVariant;
    FParam: OleVariant;
    Session: TServiceSession;
    SQLServer: TSQLServer;
    FState: TAppServiceState;
    FDataIn: TAppDataSet;
    FErrorOut: TAppDataSet;
    FDataOut: TAppDataSet;
    procedure SetService(const Value: TComponentClass);
    procedure SetParam(const Value: OleVariant);
    function ExecuteService: OleVariant;
    procedure SetState(const Value: TAppServiceState);
    procedure InitSession;
    function GetMessages: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; virtual;
    function Exec(const AFirstParam: String): Boolean;
  public
    property Service: TComponentClass read FService write SetService;
    property Messages: String read GetMessages;
    property State: TAppServiceState read FState write SetState;
    property Param: OleVariant read FParam write SetParam;
    property Data: OleVariant read FData;
    property Error: OleVariant read FError;
    property DataIn: TAppDataSet read FDataIn;
    property DataOut: TAppDataSet read FDataOut;
    property ErrorOut: TAppDataSet read FErrorOut;
  end;
  {$message 'TAppBuildSQL 不是一个好的对象，后续不要再使用！Jason at 2014/8/24'}
  TAppBuildSQL = class(TBuildSQL2)
  private
    app1: TDebugService;
    app2: TAppService2;
    FService: String;
    FServiceClass: TComponentClass;
    function GetDataOut: TAppDataSet;
    procedure SetService(const Value: String);
    procedure SetServiceClass(const Value: TComponentClass);
    function GetMessages: String;
    function GetDataIn: TAppDataSet;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(const ASelect: String; const AOrder: String = ''): Boolean; override;
    property DataIn: TAppDataSet read GetDataIn;
    property DataOut: TAppDataSet read GetDataOut;
    property Service: String read FService write SetService;
    property ServiceClass: TComponentClass read FServiceClass write SetServiceClass;
    property Messages: String read GetMessages;
  end;
  //返回系统主配置文件
  function GetSystemConfigFile: String;
  //返回系统配置文件中所设置的路径
  function GetSystemPath(const ID: String): String;
  //
  procedure nodo();
  //产生N个相同的空白字符
  function Space(const intLength: Integer; const data: char = ' '): String;
  // 仅允许通过的字符，用于 KeyPress 事件。
  procedure AllowChar(var Key: Char; Option: AllowCharOption);
  // 将指定组件以全屏方式显示，主要用于Chart等。
  procedure FullScreenShow(AOwner: TWinControl; const Caption: String;
    MaxShow: Boolean = True);
  procedure ShowView(AOwner: TWinControl; DataSet: TDataSet);
  // 将指定字段如 "1.基本单据" 之 索引标识 "1." 去除掉
  function RemoveIndexFlag(const Value: String): String;
  // 求指定字段的显示长度
  function GetFieldSize(Field: TField): Integer;
  // 判断指定的属是否存在
  function HasProperty(AComponent: TComponent; APropertyName: String;
    tkValue: TTypeKind =  tkClass): Boolean;
  //返回单据状态之资源文件编号
  function GetStatusResID(DataSet: TDataSet; IsHistory: Boolean): Integer;
  function CDate(Value: TDateTime): String;
  //
  procedure SetDefaultText(Source, Targer: TEdit);
  //处理字符串之取值、赋值问题  Author Jason 2003
  function StrField(Items: TStrings; Field: TField): String;
  function IntField(Items: TStrings; const Text: String): Integer;
  //取代[Delphi]InputBox函数
  function ErpInput(const ATitle, APrompt: String;
    const ADefault: String = ''; const ACancel: String = ''): String;
  procedure ViewMoneyGrid(Sec: TZjhTool; DG: TDBGrid; const Args: array of string);
  function FindColumn(AGrid: TDBGrid; const strField: String): TColumn;
  function GetStdDate(const Sender: TField): String;
  function CYearMonth(const WorkMonth: Integer): TDateTime;
  function YMToDate(const YM: String): TDateTime;
  function H16ToH10(const Text: String; intLength: Integer): String;
  //显示详细规格
  procedure ShowBewrite(Sender: TForm; DataSource: TDataSource; const FieldName: String);
  //将金额显示为英文表示
  function EnglishMoney(const Value: Double): String;
  //模拟系统按键,  mCount指定按键次数
  procedure SendKey(const mKey: Word; mShiftState: TShiftState;
    mCount: Integer = 1);
  //取得TZjhTool控件
  function GetSec(Sender: TWinControl): TZjhTool;
  procedure DisplayRecTotal(DataSet: TDataSet; Sender: TObject); overload;
  // 将指定的 DBGrid 转出到 Excel 中
  procedure DBGridToExcel(DBGrid: TDBGrid);
  // 将指定的 DBGrid 转出到 Word 中
  procedure DBGridToWord(DBGrid: TDBGrid);
  // 将指定的 DBGrid 转出到 Txt 文件中
  procedure DBGridToText(DBGrid: TDBGrid);
  //将金额转成中文大写
  function QtyToChar(Qty: Double):String;
  function SplitNum(const ATitle: String; Val: Double; var v1,v2: Double): Boolean;
  //处理料号计算精度
  function GetDigit(PartCode: string): Smallint;
  //将多个文件打包
  procedure BatchSave(const FileName: String; DeleteSource: Boolean;
    const Args: array of String);
  procedure BatchLoad(const FileName: String; DeleteSource: Boolean;
    FileItems: TStrings);
  function VarIsGuid(const Value: String): Boolean;
  //取得指定币别的汇率
  function GetExRate(const Currency: String; CurDate: TDateTime;
    const StdRate: Integer = -1): Double;
  //小数点处理对象
  function FixDecimal: THRFixDecimal;
  //读取数据集的默认值
  procedure ReadDefault(DataSet: TDataSet; const TableName: String);
  //返回MRP的Total仓别
  function MRPTOTAL: String;
  //修理当前库存档
  procedure RepairStockNum(const ADBName: String; PartCode: String = '');
  //全局对象缓存器
  function AppBuff: TComponentBuffer;
  //启动DCOM公用函数，老版本使用
  function OpenConnection(DCOM: TSocketConnection; const FServerIP, KeyCard,
    Account, Password: String): Boolean;
  //QuickRpt报表要使用
  procedure UpdateReportDataSet(const Source, Target: TDataSet);
  function GetResString(dll: THandle; ResIndex: Integer): String;
  //创建集团单号
  function GroupCreateTBNo(const TBDate: TDateTime): String;
  //procedure ResSetImageFromJpeg(AImage: TImage; dll: THandle; ResName: Integer);
  //显示多行讯息对话框
  procedure ShowErrorWind(Errors: TStrings; const WindCaption: String = ''); overload;
  procedure ShowErrorWind(Errors: string; const WindCaption: String = ''); overload;
  //将数据表中的数据转到Excel中进行编辑并再传回来
  procedure ExcelUpdate(Sec: TObject; DBGrid: TObject; const KeyNo: Integer);
  //发送Erp消息，此函数后需取消
  function SendErpInfo(const UserTo, Subject, Body, AppUser: String; Job,
    Email, SMS: Boolean): Boolean;
  //取USB序列号
  function USB_GetSerialNum: String;
  //根据单别，显示对象窗体并调用CONST_GOTORECORD
  function ShowTBDetail(AGrid: TDBGrid; const Args: array of String): IBaseForm;
  //根据币别输出金额千分位
  function ErpFormatAmount(const Amount: Double; Currency: String = ''): String;
  //取得指定集合默认序号
  function GetDefaultIndex(Items: TStrings; const Default: String): Integer;
  //自动建立并返回无框式置顶消息框
  function GetMessageDialog(AOwner: TComponent): IOutputMessage2;
  //检查并关闭无框式置顶消息框
  procedure CloseMessageDialog(AOwner: TComponent; Timeout: Cardinal = 500);
  //向主窗体发送消息
  procedure OutputMessage(Sender: TObject; const Value: String;
    MsgLevel: TMsgLevelOption);
  //自动生成唯一条码
  function MyRandom15: String;
  //系统向导
  procedure WizardBox(const AProjectCode: String; const AutoPlay: Boolean = False);
  //系统帮助
  procedure HelpBox(const DocID, AText: String; const ACaption: String = '';
    DlgType: TMsgDlgType = mtInformation);
  //关闭系统组合窗体
  procedure DestroyVirForm;
  //支持Excel，或WPS
  function createExcelApp: OleVariant;
var
  MSG_DO_OK: String;
  RES_NODO: String;

implementation

uses QuickRpt, QRCtrls;

var
  Local_FixDecimal: THRFixDecimal;
  Local_AppBuff: TComponentBuffer;

function GetResString(dll: THandle; ResIndex: Integer): String;
var
  iSize: Integer;
  Buffer: array [0..1024] of char;
begin
  iSize := LoadString(dll,ResIndex,Buffer,1024);
  Result := Copy(buffer,1,iSize);
end;

{
procedure ResSetImageFromJpeg(AImage: TImage; dll: THandle; ResName: Integer);
var
  jpg: TJpegImage;
  res: TResourceStream;
begin
  jpg := TJpegImage.Create;
  try
    res := TResourceStream.CreateFromID(dll,ResName,'JPG');
    try
      jpg.LoadFromStream(res);
      AImage.Picture.Assign(jpg);
    finally
      res.Free;
    end;
  finally
    jpg.Free;
  end;
end;
}

//小数点处理对象
function FixDecimal: THRFixDecimal;
begin
  if not Assigned(Local_FixDecimal) then
    Local_FixDecimal := THRFixDecimal.Create(Application);
  Result := Local_FixDecimal;
end;

function AppBuff: TComponentBuffer;
begin
  if not Assigned(Local_AppBuff) then
    Local_AppBuff := TComponentBuffer.Create(Application, nil);
  Result := Local_AppBuff;
end;

procedure nodo();
begin
  MessageBox(0,PChar(RES_NODO),'Information',MB_ICONINFORMATION);
end;

function Space(const intLength: Integer; const data: char): String;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to intLength do
    Result := Result + data;
end;

procedure AllowChar(var Key: Char; Option: AllowCharOption);
begin
  if not ((Key >= '0') and (Key <= '9') or (SmallInt(Key) = 8)) then Key := #0;
end;

function RemoveIndexFlag(const Value: String): String;
begin
  if Pos('.',Value) > 0 then
    Result := Copy(Value,Pos('.',Value) + 1,Length(Value))
  else
    Result := Value;
end;

procedure FullScreenShow(AOwner: TWinControl; const Caption: String;
  MaxShow: Boolean);
var
  win: TForm;
  wc: TWinControl;
  m_Align: TAlign;
  lt, wh: TPoint;
begin
  win := TForm.Create(Application);
  win.Width := 640; //AOwner.Width + 1;
  win.Height := 420; //AOwner.Height + 1;
  win.Caption := Caption;
  win.BorderIcons := [biSystemMenu,biMinimize,biMaximize];
  win.BorderStyle := bsSingle;
  win.ControlStyle := [];
  win.Position := poDesktopCenter;
  if MaxShow then win.WindowState := wsMaximized;
  wc := AOwner.Parent;
  m_Align := AOwner.Align;
  lt.X := AOwner.Left; lt.Y := AOwner.Top;
  wh.X := AOwner.Width; wh.Y := AOwner.Height;
  AOwner.Parent := win;
  try
    AOwner.Align := alClient;
    win.ShowModal;
  finally
    AOwner.Align := m_Align;
    AOwner.Left := lt.X; AOwner.Top := lt.Y;
    AOwner.Width := wh.X; AOwner.Height := wh.Y;
    AOwner.Parent := wc;
    win.Free;
  end;
end;

procedure ShowView(AOwner: TWinControl; DataSet: TDataSet);
var
  win: TForm;
  DBGrid: TDBGrid;
  DataSource: TDataSource;
begin
  win := TForm.Create(AOwner);
  win.Width := 640; //AOwner.Width + 1;
  win.Height := 420; //AOwner.Height + 1;
  win.Caption := 'MessageBox';
  win.BorderIcons := [biSystemMenu,biMinimize,biMaximize];
  win.BorderStyle := bsSingle;
  win.ControlStyle := [];
  win.Position := poDesktopCenter;
  try
    DataSource := TDataSource.Create(win);
    DBGrid := TDBGrid.Create(win);
    try
      DBGrid.Parent := win;
      DataSource.DataSet := DataSet;
      DBGrid.DataSource := DataSource;
      DBGrid.Align := alClient;
      win.ShowModal;
    finally
      FreeAndNil(DBGrid);
      FreeAndNil(DataSource);
    end;
  finally
    FreeAndNil(win);
  end;
end;

function GetFieldSize(Field: TField): Integer;
begin
  case Field.DataType of
  ftString: Result := Field.Size;
  ftSmallint: Result := 6;
  ftInteger: Result := 12;
  ftWord: Result := 12;
  ftBoolean: Result := 2;
  ftFloat: Result := 12;
  ftCurrency: Result := 12;
  ftDate: Result := 10;
  ftTime: Result := 8;
  ftDateTime: Result := 20;
  ftAutoInc: Result := 12;
  ftLargeint: Result := 16;
  ftGuid: Result := 36;
  else Result := 12;
  end;
end;

function HasProperty(AComponent: TComponent; APropertyName: String;
  tkValue: TTypeKind): Boolean;
var
  PropInfo: PPropInfo;
begin
  Result := False;
  PropInfo := GetPropInfo(AComponent.ClassInfo,APropertyName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkValue) then
  begin
    Result := True;
  end;
end;

{ TDictionary }

constructor TDictionary.Create;
begin
  inherited;
  FID := TStringList.Create;
  FData := TStringList.Create;
end;

destructor TDictionary.Destroy;
begin
  FData.Free;
  FID.Free;
  inherited;
end;

function TDictionary.AddItem(const ACode, AName: String): Integer;
begin
  Result := FID.Add(ACode);
  FData.Add(AName);
end;

function TDictionary.IndexOf(const ACode: String): Integer;
begin
  Result := FID.IndexOf(ACode);
end;

function TDictionary.GetID(Index: Integer): string;
begin
  Result := FID.Strings[Index];
end;

procedure TDictionary.SetID(Index: Integer; const Value: string);
begin
  FID.Strings[Index] := Value;
end;

function TDictionary.Count: Integer;
begin
  Result := FID.Count;
end;

function TDictionary.GetData(Index: Integer): string;
begin
  Result := FData.Strings[Index];
end;

procedure TDictionary.SetData(Index: Integer; const Value: string);
begin
  FData.Strings[Index] := Value;
end;

procedure SetDefaultText(Source, Targer: TEdit);
begin
  if Source.Text = '' then Exit;
  if (Targer.Text = '*') or (Targer.Text = '') then
    Targer.Text := Source.Text;
end;

function StrField(Items: TStrings; Field: TField): String;
var
  i: Integer;
begin
  Result := Field.AsString;
  if Field.IsNull then i := 0 else i := Field.AsInteger;
  if Assigned(Items) then
  if (i > -1) and (i < Items.Count) then
  if Field.DataSet.Active then
  if (Field.DataSet.RecordCount <> 0) or (Field.DataSet.State in [dsEdit, dsInsert]) then
    Result := Items.Strings[i];
end;

function IntField(Items: TStrings; const Text: String): Integer;
var
  Site: Integer;
begin
  Result := 0;
  if not Assigned(Items) then Exit;
  if Items.IndexOf(Text) > -1 then
    Result := Items.IndexOf(Text)
  else if Length(Text) = 1 then
    begin
      Site := StrToIntDef(Text,-1);
      if Site in [0..Items.Count-1] then
        Result := Site;
    end;
end;

function ErpInput(const ATitle, APrompt, ADefault, ACancel: String): String;
var
  R: Variant;
  AIntf: IHRObject;
begin
  Result := ADefault;
  AIntf := CreateClass('TFrmInput', Application) as IHRObject;
  if Assigned(AIntf) then
    begin
      R := AIntf.PostMessage(CONST_DEFAULT,
        VarArrayOf([ATitle, APrompt, ADefault, ACancel]));
      if not VarIsNull(R) then
        Result := VarToStr(R)
      else
        Result := ACancel;
    end
  else
    raise Exception.Create('Create TFrmInput Error.');
end;

function CDate(Value: TDateTime): String;
var
  FormatSettings: TFormatSettings;
begin
  FormatSettings.ShortDateFormat := 'YYYY/MM/DD';
  FormatSettings.DateSeparator := '/';
  Result := FormatDateTime('YYYY/MM/DD', Value, FormatSettings);
end;

procedure BatchSave(const FileName: String; DeleteSource: Boolean;
  const Args: array of String);
var
  i: Integer;
  si: Int64;
  Buff: array[0..MAX_PATH] of char;
  SF, TF: TFileStream;
begin
  //保存至统一文件
  TF := TFileStream.Create(FileName,fmCreate);
  try
    //文件头-版本号
    TF.Write('dfm1',4);
    //文件头-简要描述
    si := Length(FileName); TF.Write(si,SizeOf(si));
    StrCopy(Buff,PChar(FileName)); TF.Write(Buff,si);
    //文件头-文件数目
    i := High(Args); TF.Write(i,SizeOf(i));
    //开始合并文件
    for i := Low(Args) to High(Args) do
    begin
      SF := TFileStream.Create(Args[i],fmOpenRead);
      try
        //写入文件名
        si := Length(Args[i]); TF.Write(si,SizeOf(si));
        StrCopy(Buff,PChar(Args[i])); TF.Write(Buff,si);
        //写入文件内容
        si := SF.Size; TF.Write(si,SizeOf(si)); TF.CopyFrom(SF,si);
      finally
        SF.Free;
      end;
      if DeleteSource then DeleteFile(Args[i]);
    end;
  finally
    TF.Free;
  end;
end;

procedure BatchLoad(const FileName: String; DeleteSource: Boolean;
  FileItems: TStrings);
var
  i, k: Integer;
  si: Int64;
  str: String;
  Buff: array[0..MAX_PATH] of char;
  SF, TF: TFileStream;
begin
  //保存至统一文件
  TF := TFileStream.Create(FileName,fmOpenRead);
  try
    //文件头-版本号
    TF.Read(Buff,4);
    //文件头-简要描述
    TF.Read(si,SizeOf(si)); TF.Read(Buff,si);
    //文件头-文件数目
    TF.Read(k,SizeOf(k));
    for i := 0 to k do
    begin
      //读入文件名
      TF.Read(si,SizeOf(si)); TF.Read(Buff,si);
      str := ChangeFileExt(FileName,ExtractFileExt(Copy(Buff,0,si)));
      FileItems.Add(str);
      //写入文件内容
      SF := TFileStream.Create(str,fmCreate);
      try
        TF.Read(si,SizeOf(si)); SF.CopyFrom(TF,si);
      finally
        SF.Free;
      end;
    end;
  finally
    TF.Free;
  end;
  if DeleteSource then DeleteFile(FileName);
end;

procedure ViewMoneyGrid(Sec: TZjhTool; DG: TDBGrid; const Args: array of string);
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := Low(Args) to High(Args) do sl.Add(Args[i]);
    if not Sec.Pass('MoneyDisplay',False) then
    begin
      with DG do for i := Columns.Count - 1 downto 0 do
        if sl.IndexOf(Columns[i].FieldName) > -1 then Columns.Delete(i);
    end;
  finally
    FreeAndNil(sl);
  end;
end;

function FindColumn(AGrid: TDBGrid; const strField: String): TColumn;
var
  i: Integer;
begin
  Result := nil;
  with AGrid do
  for i := 0 to Columns.Count - 1 do
  begin
    if UpperCase(Columns[i].FieldName) = UpperCase(strField) then
    begin
      Result := Columns[i];
      Break;
    end;
  end;
end;

function GetSec(Sender: TWinControl): TZjhTool;
var
  i: Integer;
  Items: TList;
begin
  Result := nil;
  Items := TList.Create;
  try
    Items.Add(Sender.Owner);
    if Sender.Parent <> nil then
    begin
      Items.Add(Sender.Parent);
      if Sender.Parent.Parent <> nil then
      begin
        Items.Add(Sender.Parent.Parent);
        if Sender.Parent.Parent.Parent <> nil then
          Items.Add(Sender.Parent.Parent.Parent);
      end;
    end;
    if Sender.Owner.Owner <> nil then
    begin
      Items.Add(Sender.Owner.Owner);
      if Sender.Owner.Owner.Owner <> nil then
        Items.Add(Sender.Owner.Owner.Owner);
    end;
    for i := 0 to Items.Count -1 do
    begin
      if TObject(Items.Items[i]) is TComponent then
        if Supports(TComponent(Items.Items[i]), IBaseForm) then
        begin
          Result := (TComponent(Items.Items[i]) as IBaseForm).ISec as TZjhTool;
          Break;
        end;
    end;
  finally
    Items.Free;
  end;
end;

procedure DisplayRecTotal(DataSet: TDataSet; Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Text := Format('%d / %d',[DataSet.RecNo,DataSet.RecordCount])
  else if Sender is TLabel then
    TLabel(Sender).Caption := 'Record: ' + Format('%d / %d',[DataSet.RecNo,DataSet.RecordCount])
  else if Sender is TPanel then
    TPanel(Sender).Caption := 'Record: ' + Format('%d / %d',[DataSet.RecNo,DataSet.RecordCount])
  else
    Raise Exception.CreateFmt(Chinese.AsString('不能支持的类型：'),[Sender.ClassName]);
end;

procedure DBGridToExcel(DBGrid: TDBGrid);
var
  i,j: Integer;
  Site: TBytes;
  ExcelApp: TExcelApplication;
  ExcelBook: TExcelworkBook;
  ExcelSheet: TExcelWorkSheet;
begin
  if DBGrid.DataSource.DataSet.RecordCount = 0 then
  begin
    MsgBox(Chinese.AsString('无数据可转换！'));
    Exit;
  end;
  ExcelApp := TExcelApplication.Create(Nil);
  ExcelBook := TExcelWorkBook.Create(Nil);
  ExcelSheet := TExcelWorkSheet.Create(Nil);
  try
    ExcelApp.Connect;
  except
    MessageDlg(Chinese.AsString('调用失败：Microsoft_Excel 没有安装或运行出错！'),mtError, [mbOk], 0);
    Abort;
  end;
  ExcelApp.Visible[0] := True;
  ExcelApp.Workbooks.Add(Null,0);
  ExcelBook.ConnectTo(ExcelApp.Workbooks[1]);
  ExcelSheet.ConnectTo(ExcelApp.Worksheets[1] as _WorkSheet);
  begin
    for i := 0 to DBGrid.FieldCount-1  do // Add Title
      ExcelSheet.Cells.Item[1,i+1] := DBGrid.Columns[i].Title.Caption;
    with DBGrid.DataSource.DataSet do
    begin //Add Body
      DisableControls;
      Site := Bookmark;
      First;
      try
        for i := 1  to RecordCount do
        begin
          for j := 1 to DBGrid.Columns.Count do
            Excelsheet.Cells.Item[i+1,j] :=  DBGrid.Fields[j-1].AsString;
          Next;
        end;
      except
        on E: Exception do MsgBox(E.Message);
      end;
      BookMark := Site;
      EnableControls;
    end;
    ExcelSheet.Cells.Select;
    ExcelSheet.Columns.AutoFit;
    ExcelSheet.Cells.Item[1,1].Select;
    ExcelSheet.Free;
    ExcelBook.Free;
    ExcelApp.Free;
  end;
end;

procedure DBGridToWord(DBGrid: TDBGrid);
var
  str: String;
  BMark: TBytes;
  i,j: Integer;
  strList: TStringList;
  WordApp: TWordApplication;
  WordDoc: TWordDocument;
  Para1,Para2,Para3,Para4,Para5: OleVariant;
begin
  if  DBGrid.DataSource.DataSet.Eof then
  begin
    MsgBox(Chinese.AsString('无数据可转换！'));
    Exit;
  end;
  WordApp := TWordApplication.Create(DBGrid.Owner);
  WordDoc := TWordDocument.Create(DBGrid.Owner);
  try
    WordApp.Connect;
  except
    MessageDlg(Chinese.AsString('调用失败：Microsoft Word 没有安装或运行出错！'),mtError, [mbOk], 0);
    Abort;
  end;
  Para1 := EmptyParam;
  Para2 := EmptyParam;
  Para3 := 1;
  Para4 := EmptyParam;
  Para5 := EmptyParam;
  WordApp.Visible := True;
  WordApp.Documents.Add(Para1,Para2,Para4,Para5);
  WordDoc.ConnectTo(WordApp.Documents.Item(Para3));
  strList := TStringList.Create();
  strList.Clear;
  Str := '';
  for i := 0 to DBGrid.FieldCount - 1  do //Add title
    Str := Concat(Str, DBGrid.Columns[i].Title.Caption)+'  ';
  strList.Add(Copy(Str,1,length(str)-1));
  Str := '';
  with DBGrid.DataSource.DataSet do
  begin
    DisableControls;
    BMark := BookMark;
    First;
    for i := 1  to RecordCount do  //Add Body
    begin
      for j := 1 to DBGrid.Columns.Count do
        Str := Concat(Str, DBGrid.Fields[j-1].AsString)+'  ';
      Next;
      strList.Add(Copy(Str,1,length(str)-1));
      Str := '';
    end;
    EnableControls;
    BookMark := BMark;
  end;
  WordDoc.PageSetup.Orientation := 1;
  WordDoc.Range.InsertAfter(strList.Text);
  WOrdDoc.Disconnect;
  WordApp.Disconnect;
  strList.Free;
  WordDoc.Free;
  WordApp.Free;
end;

procedure DBGridToText(DBGrid: TDBGrid);
var
  i,j: Integer;
  Site: TBytes;
  SDlg: TSaveDialog;
  StrList: TStringList;
  str: String;
begin
  if DBGrid.DataSource.DataSet.RecordCount = 0 then
  begin
    MsgBox(Chinese.AsString('无数据可转换！'));
    Exit;
  end;
  SDlg := TSaveDialog.Create(DBGrid.Owner);
  SDlg.Title := Chinese.AsString('表格导出到文本文件');
  SDlg.DefaultExt := 'Txt';
  SDlg.Filter := '*.Txt';
  StrList := TStringList.Create();
  Str := '';
  if SDlg.Execute then
  begin
    for i := 0 to DBGrid.FieldCount - 1  do // Add Title
      Str := Concat(Str, DBGrid.Columns[i].Title.Caption)+',';
    StrList.Add(Copy(Str,1,length(str)-1));
    Str := '';
    with DBGrid.DataSource.DataSet do
    begin //Add Body
      DisableControls;
      Site := Bookmark;
      First;
      for i := 1  to RecordCount do
      begin
        for j := 1 to DBGrid.Columns.Count do
          Str := Concat(Str, DBGrid.Fields[j-1].AsString)+',';
        Next;
        StrList.Add(Copy(Str,1,length(str)-1));
        Str := '';
      end;
      EnableControls;
    end;
    StrList.SaveToFile(SDlg.FileName);
    ShellExecute(DBGrid.Parent.Handle,nil,PChar(sDlg.FileName),nil,nil,SW_ShowNormal);
  end;
  StrList.Free;
  SDlg.Free;
end;

function QtyToChar(Qty:Double):String;
//Const
//   Con: Array [0..3] Of String[2] =('','拾','佰','仟');
//   DD: Array [0..9] Of String[2] =(Chinese.AsString('零'),Chinese.AsString('壹'),'贰','参','肆','伍','陆','柒','捌','玖');
var
  Str: String;
  i,r: Byte;
  Con: Array [0..3] Of String; //[2];
  DD: Array [0..9] Of String; //[2];
Begin
  Con[0] := '';
  Con[1] := Chinese.AsString('拾');
  Con[2] := Chinese.AsString('佰');
  Con[3] := Chinese.AsString('仟');
  DD[0] := Chinese.AsString('零');
  DD[1] := Chinese.AsString('壹');
  DD[2] := Chinese.AsString('贰');
  DD[3] := Chinese.AsString('参');
  DD[4] := Chinese.AsString('肆');
  DD[5] := Chinese.AsString('伍');
  DD[6] := Chinese.AsString('陆');
  DD[7] := Chinese.AsString('柒');
  DD[8] := Chinese.AsString('捌');
  DD[9] := Chinese.AsString('玖');
  if qty < 0 Then qty := -qty;
  Str:=FormatFloat('#',Qty*100);
  Result := '';
  for  R:=1 to Length(Str) Do
  begin
    i := StrToInt(Str[Length(Str)-r+1]);
    Case R of
      1: Result:=DD[i] + Chinese.AsString('分');
      2: Result:=DD[i] + Chinese.AsString('角') + Result;
    else
      if i > 0 then
         Result := DD[i] + Con[(r-3) Mod 4] + Result
      else
        if (Copy(Result,1,2) <> Chinese.AsString('零')) then  Result := Chinese.AsString('零') + Result;
    end;
    if R<Length(Str) Then
    case R of
      2 :  Result := Chinese.AsString('元') + Result;
      6 :  Result := Chinese.AsString('万') + Result;
     10 :  Result := Chinese.AsString('仟') + Result;
    end;
  end;
  while Pos(Chinese.AsString('零元'),Result) > 0 do Delete(Result,Pos(Chinese.AsString('零元'),Result),2);
  while Pos(Chinese.AsString('零万'),Result) > 0 do Delete(Result,Pos(Chinese.AsString('零万'),Result),2);
  while Pos(Chinese.AsString('零仟'),Result) > 0 do Delete(Result,Pos(Chinese.AsString('零仟'),Result),2);
  Result := Result + Chinese.AsString('整');
end;

function SplitNum(const ATitle: String; Val: Double;
  var v1, v2: Double): Boolean;
var
  R: Variant;
  AIntf: IHRObject;
begin
  Result := False;
  AIntf := CreateClass('TDlgSplitNum', Application) as IHRObject;
  if Assigned(AIntf) then
    begin
      R := AIntf.PostMessage(CONST_DEFAULT, VarArrayOf([ATitle, Val]));
      if not VarIsNull(R) then
      begin
        v1 := StrToFloatDef(R, 0);
        v2 := Val - v1;
        Result := True;
      end;
    end
  else
    raise Exception.Create('Create TDlgSplitNum Error.');
end;

function GetDigit(PartCode: string): Smallint;
begin
  {$IFDEF ERP2011}
  Result := 2;
  with MainData.cdsSQL do
  begin
    Close;
    CommandText := Format('Select R.AccDigit_ from PartPurRate R '
      + ' inner join Part P on P.Unit_=R.Unit_ and P.Code_=''%s''',[PartCode]);
    Open;
    if not eof then
      Result := FieldByName('AccDigit_').AsInteger;
    Close;
  end;
  {$ELSE}
  Result := 4;
  with MainData.cdsSQL do
  begin
    Close;
    CommandText := Format('Select N.Digit_ from NumericUnit N '
      + ' inner join Part P on P.Unit_=N.Code_ and P.Code_=''%s''',[PartCode]);
    Open;
    if not eof then
      Result := FieldByName('Digit_').AsInteger;
    Close;
  end;
  {$ENDIF}
end;

function GetStdDate(const Sender: TField): String;
begin
  if not Sender.IsNull then
    Result := FormatDateTime('YYYY/MM/DD', Sender.AsDateTime)
  else
    Result := '';
end;

function CYearMonth(const WorkMonth: Integer): TDateTime;
var
  Year, Month: Integer;
begin
  Year := StrToInt(Copy(IntToStr(WorkMonth),1,4));
  Month := StrToInt(Copy(IntToStr(WorkMonth),5,2));
  Result := EncodeDate(Year, Month, 1);
end;

function YMToDate(const YM: String): TDateTime;
begin
  Result := StrToDateTime(Copy(YM,1,4)+'/'+Copy(YM,5,2)+'/'+'01');
end;

//SendKey
procedure SendKey(const mKey: Word; mShiftState: TShiftState;
  mCount: Integer = 1); { 模拟系统按键,  mCount指定按键次数 }
const
  cExtended: set of Byte = [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_HOME,
    VK_END, VK_PRIOR, VK_NEXT, VK_INSERT, VK_DELETE];
  procedure pKeyboardEvent(mKey, mScanCode: Byte; mFlags: Longint);
  var
    vKeyboardMsg: TMsg;
  begin
    keybd_event(mKey, mScanCode, mFlags, 0);
    while PeekMessage(vKeyboardMsg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE) do
    begin
      TranslateMessage(vKeyboardMsg);
      DispatchMessage(vKeyboardMsg);
    end;
  end; { pKeyboardEvent }
  procedure pSendKeyDown(mKey: Word; mGenUpMsg: Boolean);
  var
    vScanCode: Byte;
    vNumState: Boolean;
    vKeyBoardState: TKeyboardState;
  begin
    if (mKey = VK_NUMLOCK) then begin
      vNumState := ByteBool(GetKeyState(VK_NUMLOCK) and 1);
      GetKeyBoardState(vKeyBoardState);
      if vNumState then
        vKeyBoardState[VK_NUMLOCK] := (vKeyBoardState[VK_NUMLOCK] and not 1)
      else vKeyBoardState[VK_NUMLOCK] := (vKeyBoardState[VK_NUMLOCK] or 1);
      SetKeyBoardState(vKeyBoardState);
      Exit;
    end;
    vScanCode := Lo(MapVirtualKey(mKey, 0));
    if (mKey in cExtended) then begin
      pKeyboardEvent(mKey, vScanCode, KEYEVENTF_EXTENDEDKEY);
      if mGenUpMsg then
        pKeyboardEvent(mKey, vScanCode,
          KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP)
    end else begin
      pKeyboardEvent(mKey, vScanCode, 0);
      if mGenUpMsg then pKeyboardEvent(mKey, vScanCode, KEYEVENTF_KEYUP);
    end;
  end; { pSendKeyDown }
  procedure pSendKeyUp(mKey: Word);
  var
    vScanCode: Byte;
  begin
    vScanCode := Lo(MapVirtualKey(mKey, 0));
    if mKey in cExtended then
      pKeyboardEvent(mKey, vScanCode, KEYEVENTF_EXTENDEDKEY and KEYEVENTF_KEYUP)
    else pKeyboardEvent(mKey, vScanCode, KEYEVENTF_KEYUP);
  end; { pSendKeyUp }
var
  I: Integer;
begin
  for I := 1 to mCount do begin
    if ssShift in mShiftState then pSendKeyDown(VK_SHIFT, False);
    if ssCtrl in mShiftState then pSendKeyDown(VK_CONTROL, False);
    if ssAlt in mShiftState then pSendKeyDown(VK_MENU, False);
    pSendKeyDown(mKey, True);
    if ssShift in mShiftState then pSendKeyUp(VK_SHIFT);
    if ssCtrl in mShiftState then pSendKeyUp(VK_CONTROL);
    if ssAlt in mShiftState then pSendKeyUp(VK_MENU);
  end;
end; { SendKey }

function H16ToH10(const Text: String; intLength: Integer): String;
var
  i, sn: Integer;
  ss: String;
begin
  sn := 0; //将16进制转为10进制
  for i := 1 to Length(Text) do
    sn := sn shl 4 + StrToInt('0x' + Copy(Text,i,1));
  ss := Space(intLength, '0') + IntToStr(sn);
  Result := Copy(ss, Length(ss)-intLength+1,intLength);
end;

function GetExRate(const Currency: String; CurDate: TDateTime;
  const StdRate: Integer): Double;
var
  SQLCmd: String;
  {$IFDEF ERP2011}
  cdsMoney: TZjhDataSet;
  {$ENDIF}
  RateType: Integer;
begin
  Result := 0;
  if Trim(Currency) = '' then Exit;
  //
  if StdRate = -1 then
    RateType := nreg.ReadInit('system','SYS00008')
  else
    RateType := StdRate;
  {$IFDEF ERP2011}
  case RateType of
  0: //固定汇率
    SQLCmd := 'Select Rate_ From Money Where StartDate_ is NULL';
  1: //浮动汇率
    SQLCmd := Format('Select Code_,Name_,Rate_ From Money Where '
      + 'StartDate_=''%s''',[FormatDatetime('YYYY/MM/DD',CurDate)]);
  2: //月初
    SQLCmd := Format('Select Code_,Name_,Rate_ From Money Where '
      + 'StartDate_=''%s''',[FormatDatetime('YYYY/MM/DD',MonthBof(CurDate))]);
  else // 三旬汇率
    if DayOf(CurDate) > 20 then
      SQLCmd := Format('Select Code_,Name_,Rate_ From Money Where '
        + 'StartDate_=''%s''',[FormatDatetime('YYYY/MM/21',CurDate)])
    else if DayOf(CurDate) > 10 then
      SQLCmd := Format('Select Code_,Name_,Rate_ From Money Where '
        + 'StartDate_=''%s''',[FormatDatetime('YYYY/MM/11',CurDate)])
    else
      SQLCmd := Format('Select Code_,Name_,Rate_ From Money Where '
        + 'StartDate_=''%s''',[FormatDatetime('YYYY/MM/01',CurDate)]);
  end;
  cdsMoney := TZjhDataSet.Create(DM.DCOM);
  try
    with cdsMoney do
    begin
      RemoteServer := DM.DCOM;
      CommandText := SQLCmd + ' and Code_=''' + Currency + '''';
      Open;
      if not Eof then
        Result := FieldByName('Rate_').AsFloat;
      Close;
    end;
  finally
    FreeAndNil(cdsMoney);
  end;
  {$ELSE}
  SQLCmd := '';
  case RateType of
  0: //固定汇率
    SQLCmd := Format('Select Rate_ From MoneyUnit where Code_=''%s''', [Currency]);
  1: //月结汇率
    SQLCmd := Format('select Rate_ from MoneyRate where Code_=''%s'' and '
      + 'RateType_=1 and StartDate_=''%s''',[Currency, FormatDatetime('YYYY/MM/DD', MonthBof(CurDate))]);
  2: //三旬汇率
    if DayOf(CurDate) > 20 then
      SQLCmd := Format('select Rate_ from MoneyRate where Code_=''%s'' and '
        + 'RateType_=2 and StartDate_=''%s''',[Currency, FormatDatetime('YYYY/MM/21', CurDate)])
    else if DayOf(CurDate) > 10 then
      SQLCmd := Format('select Rate_ from MoneyRate where Code_=''%s'' and '
        + 'RateType_=2 and StartDate_=''%s''',[Currency, FormatDatetime('YYYY/MM/11', CurDate)])
    else
      SQLCmd := Format('select Rate_ from MoneyRate where Code_=''%s'' and '
        + 'RateType_=2 and StartDate_=''%s''',[Currency, FormatDatetime('YYYY/MM/01',CurDate)]);
  3: //浮动汇率
    SQLCmd := Format('select Rate_ from MoneyRate where Code_=''%s'' and '
      + 'RateType_=3 and StartDate_=''%s''',[Currency, FormatDatetime('YYYY/MM/DD', CurDate)]);
  else
    raise Exception.CreateFmt(Chinese.AsString('没有取到 %s 于 %s 的汇率（类别=%d），请检查设置！'),
      [Currency, CDate(CurDate), RateType]);
  end;
  if SQLCmd <> '' then
    Result := CM.DBRead(SQLCmd, 0);
  {$ENDIF}
  if Result <= 0 then
    raise Exception.CreateFmt(Chinese.AsString('没有取到 %s 于 %s 的汇率，请检查设置！'),
      [Currency, CDate(CurDate)]);
  //Result := MainIntf.PostMessage(CONST_GetExRate, VarArrayOf([RateType, CurDate, Currency]));
end;

function VarIsGuid(const Value: String): Boolean;
begin
  Result := (Length(Value) = 38) and (Copy(Value,1,1) = '{') and (Copy(Value,38,1)='}');
end;

function GetStatusResID(DataSet: TDataSet; IsHistory: Boolean): Integer;
var
  Status: Integer;
begin
  if DataSet.Active then
    begin
      Status := DataSet.FieldByName('Status_').AsInteger;
      if IsHistory then
        Result := 1004
      else if Status = -1 then
        Result := 1003
      else
        Result := 1000 + Status;
    end
  else
    Result := 0;
end;

{ THRFixDecimal }

function THRFixDecimal.AsCurrency(const ACurrency: String;
  const Value: Double): Double;
var
  iDecimal: Integer;
begin
  OpenMoney;
  iDecimal := 2;
  with cdsMoney do
  begin
    if not Active then Open;
    if Locate('Code_', Trim(ACurrency), [loCaseInsensitive]) then
      iDecimal := FieldByName('Decimal_').AsInteger;
  end;
  Result := AsValue(RoundTo(Value, -8), iDecimal);
end;

function THRFixDecimal.AsCurrency(const Value: Double): Double;
begin
  OpenMoney;
  Result := AsCurrency(LocalCurrency, Value);
end;

procedure THRFixDecimal.OpenMoney;
begin
  if not Assigned(cdsMoney) then
  begin
    cdsMoney := TZjhDataSet.Create(Self);
    with cdsMoney do
    begin
      RemoteServer := DM.DCOM;
      {$IFDEF ERP2011}
      CommandText := 'Select Code_,Rate_,Decimal_ From Money '
        + 'Where StartDate_ is Null';
      {$ELSE}
      CommandText := 'Select Code_,Decimal_,LocalDefault_ From MoneyUnit '
      {$ENDIF}
    end;
  end;
  //
  with cdsMoney do
  begin
    if not Active then
    begin
      Open;
      while not Eof do
      begin
        {$IFDEF ERP2011}
        if FieldByName('Rate_').AsFloat = 1 then
        begin
          LocalCurrency := Trim(FieldByName('Code_').AsString);
          Break;
        end;
        {$ELSE}
        if FieldByName('LocalDefault_').AsBoolean then
        begin
          LocalCurrency := Trim(FieldByName('Code_').AsString);
          Break;
        end;
        {$ENDIF}
        Next;
      end;
    end;
  end;
end;

function THRFixDecimal.AsUnit(const AUnit: String;
  const Value: Double): Double;
var
  iDecimal: Integer;
begin
  {$IFDEF ERP2011}
  //打开数据集
  if not Assigned(cdsUnit) then
  begin
    cdsUnit := TZjhDataSet.Create(Self);
    with cdsUnit do
    begin
      RemoteServer := DM.DCOM;
      CommandText := 'SELECT Unit_,AccDigit_ FROM PartPurRate Order by Unit_';
    end;
  end;
  //进行数据集修理
  iDecimal := 2;
  with cdsUnit do
  begin
    if not Active then Open;
    if Locate('Unit_', AUnit, [loCaseInsensitive]) then
      iDecimal := FieldByName('AccDigit_').AsInteger;
  end;
  {$ELSE}
  //打开数据集
  if not Assigned(cdsUnit) then
  begin
    cdsUnit := TZjhDataSet.Create(Self);
    with cdsUnit do
    begin
      RemoteServer := DM.DCOM;
      CommandText := 'select Code_,Digit_ from NumericUnit order by Code_';
    end;
  end;
  //进行数据集修理
  with cdsUnit do
  begin
    if not Active then Open;
    if Locate('Code_', AUnit, [loCaseInsensitive]) then
      iDecimal := FieldByName('Digit_').AsInteger
    else
      raise Exception.CreateFmt(Chinese.AsString('没有取到 %s 的单位精度设置，请检查设置！'),
        [AUnit]);
  end;
  {$ENDIF}
  Result := AsValue(Value, iDecimal);
end;

function THRFixDecimal.AsValue(const Value: Double;
  const Decimal: Integer): Double;
var
  sBuff: String;
  sTmp1, nValue: Double;
  nFlag: Boolean;
begin
  {
  Delphi使用的四舍五入使用的是银行家算法，不可在华人地区使用
  -- Jason 2006/7/22
  }
  //处理负数.
  nFlag := False;
  if Value < 0 then
    nFlag := True;
  nValue := ABS(Value);
  sTmp1 := StrToFloat(Format('10e%d', [Decimal - 1]));
  sBuff := FloatToStr(nValue * sTmp1);
  if Pos('.', sBuff) > 0 then
  begin
    sBuff := Copy(sBuff, 1, Pos('.', sBuff) + 1);
    if sBuff[Length(sBuff)] >= '5' then
      sBuff := FloatToStr((StrToFloat(sBuff) + 1));
    sBuff := Copy(sBuff, 1, Pos('.', sBuff) - 1);
  end;
  if nFlag then
    Result := -(StrToFloat(sBuff) / sTmp1)
  else
    Result := StrToFloat(sBuff) / sTmp1;
  {
  如果要使用传统的四舍五入方法，可以使用下面函数：

  function RoundClassic(R: Real): Int64;
  begin
    Result:= Trunc(R);
    if Frac(R) >= 0.5 then
      Result:= Result + 1;
  end;
  }
end;

procedure THRFixDecimal.ClearAll;
begin
  if Assigned(cdsMoney) then
    cdsMoney.Active := False;
  if Assigned(cdsUnit) then
    cdsUnit.Active := False;
end;

procedure ShowBewrite(Sender: TForm;
  DataSource: TDataSource; const FieldName: String);
var
  i: Integer;
  Child: TForm;
  Found: Boolean;
  DBMemo1: TDBMemo;
begin
  Found := False;
  if Sender = nil then Exit;
  for i := 0 to Sender.ComponentCount - 1 do
    if (Sender.Components[i].ClassName = 'TFrmBewrite') then
    begin
      DBMemo1 := (Sender.Components[i] as IBaseForm).GetControl('DBMemo1') as TDBMemo;
      if DBMemo1.DataSource = DataSource then
      begin
        Found := True;
        Break;
      end;
    end;
  if Found then
    begin
      Child := ((Sender.Components[i]) as TForm);
      Child.Show;
    end
  else
    begin
      Child := CreateClass('TFrmBewrite', Sender) as TForm;
      if Assigned(Child) then
      begin
        DBMemo1 := (Child as IBaseForm).GetControl('DBMemo1') as TDBMemo;
        DBMemo1.DataSource := DataSource;
        DBMemo1.DataField := FieldName;
        with Child do
        begin
          //Modify by Jason at 2007/1/25
          Caption := Chinese.AsString('详细规格');
          Top := Sender.Top + Sender.Height - 100;
          Left := Sender.Left + Sender.Width - 165;
          Show;
        end;
      end;
    end;
end;

procedure ReadDefault(DataSet: TDataSet; const TableName: String);
var
  Obj: TComponent;
  AIntf: IHRTableDefault;
begin
  Obj := CreateClass('THRTableDefault');
  try
    AIntf := Obj as IHRTableDefault;
    if Assigned(AIntf) then
      AIntf.ReadDefault(DataSet, TableName);
  finally
    AIntf := nil;
    FreeAndNil(Obj);
  end;
end;

//返回MRP的Total仓别
function MRPTOTAL: String;
begin
  Result := 'TOTAL';
  if not DM.CostDeptDisabled then //启动成本仓管理
    Result := DM.CostDept;
end;

//修理当前库存档
procedure RepairStockNum(const ADBName: String; PartCode: String);
{var
  cdsTmp: TZjhDataSet;
  EnableCostDept: Boolean;
}
begin
  {
  //取得成本部门的参数
  cdsTmp := TZjhDataSet.Create(nil);
  try
    EnableCostDept := False;
    with cdsTmp do
    begin
      Database := ADBName;
      CommandText := Format('Select Init_ From SysValues '
        + 'Where Root_=''%s'' and Code_=''%s''',
        ['system', 'SYS08008']);
      Open;
      if not Eof then
        EnableCostDept := FieldByName('Init_').AsInteger > 0;
      //建立各成本中心之总库别
      if EnableCostDept then
        begin
          Active := False;
          CommandText := 'Select Code_ from CS_CostDept Where Enabled_=1';
          Open;
          while not Eof do
          begin
            if PartCode = '' then
              begin
                //建立各主要库别
                CM.ExecSQL(Format('Insert into StockNum (WHCode_,PartCode_) Select ''%s'' + WHCode_,Code_ From Part '
                  + 'Where not Exists(select * From StockNum where WHCode_= ''%s'' + Part.WHCode_ and PartCode_=Part.Code_)',
                  [FieldByName('Code_').AsString, FieldByName('Code_').AsString]), ADBName);
                //建立Total库别
                CM.ExecSQL(Format('Insert into StockNum (WHCode_,PartCode_) Select ''%s'',Code_ From Part '
                  + 'Where not Exists(select * From StockNum where WHCode_=''%s'' and PartCode_=Part.Code_)',
                  [FieldByName('Code_').AsString, FieldByName('Code_').AsString]), ADBName);
              end
            else
              begin
                CM.ExecSQL(Format('Insert into StockNum (WHCode_,PartCode_) Select ''%s'' + WHCode_,Code_ From Part '
                  + 'Where not Exists(select * From StockNum where WHCode_= ''%s'' + Part.WHCode_ and PartCode_=Part.Code_) '
                  + 'and Code_=''%s'' ', [FieldByName('Code_').AsString, FieldByName('Code_').AsString, PartCode]), ADBName);
                CM.ExecSQL(Format('Insert into StockNum (WHCode_,PartCode_) Select ''%s'',Code_ From Part '
                  + 'Where not Exists(select * From StockNum where WHCode_=''%s'' and PartCode_=Part.Code_) '
                  + 'and Code_=''%s'' ', [FieldByName('Code_').AsString, FieldByName('Code_').AsString, PartCode]), ADBName);
              end;
            Next;
          end;
        end
      else
        begin
          if PartCode = '' then
            begin
              //建立各主要库别
              CM.ExecSQL('Insert into StockNum (WHCode_,PartCode_) Select WHCode_,Code_ From Part '
                + 'Where not Exists(select * From StockNum where WHCode_=Part.WHCode_ and PartCode_=Part.Code_)', ADBName);
              //建立Total库别
              CM.ExecSQL(Format('Insert into StockNum (WHCode_,PartCode_) Select ''%s'',Code_ From Part '
                + 'Where not Exists(select * From StockNum where WHCode_=''%s'' and PartCode_=Part.Code_)',
                ['TOTAL', 'TOTAL']), ADBName);
            end
          else
            begin
              CM.ExecSQL(Format('Insert into StockNum (WHCode_,PartCode_) Select WHCode_,Code_ From Part '
                + 'Where not Exists(select * From StockNum where WHCode_=Part.WHCode_ and PartCode_=Part.Code_) '
                + 'and Code_=''%s'' ', [PartCode]), ADBName);
              CM.ExecSQL(Format('Insert into StockNum (WHCode_,PartCode_) Select ''%s'',Code_ From Part '
                + 'Where not Exists(select * From StockNum where WHCode_=''%s'' and PartCode_=Part.Code_) '
                + 'and Code_=''%s'' ' ,['TOTAL', 'TOTAL', PartCode]), ADBName);
            end
        end;
    end;
  finally
    cdsTmp.Free;
  end;
  }
end;

{ TBookInfo }

procedure TBookInfo.SetBookCode(const Value: String);
begin
  if FBookCode <> Value then
  begin
    FBookCode := Value;
    Reload;
  end;
end;

procedure TBookInfo.Reload;
var
  Item: TBIMonth;
begin
  FActive := False;
  FItems.Clear;
  //
  FInitMonth.Clear;
  FEndMonth.Clear;
  FDefaultMonth.Clear;
  FWorkRange.Clear;
  //
  with cdsData do
  begin
    Active := False;
    CommandText := Format('select YearMonth_,IsInit_,Locked_,IsCurrYM_,BeginDate_,EndDate_,Moved_ from PMLockedD '
      + 'where PMCode_=''%s'' order by YearMonth_ desc', [FBookCode]);
    Open;
    while not Eof do
    begin
      Item := TBIMonth.Create;
      Item.LoadFrom(cdsData);
      FItems.AddItem(Item.Value, Item);
      //结束年月
      if FEndMonth.FDayBegin = 0 then
        FEndMonth.LoadFrom(cdsData);
      //工作年月
      if not FieldByName('Locked_').AsBoolean then
      begin
        if FWorkRange.MonthBegin = '' then
        begin
          //结束工作年月
          FWorkRange.MonthEnd := FieldByName('YearMonth_').AsString;
          FWorkRange.DayEnd := FieldByName('EndDate_').AsDateTime;
        end;
        //开始工作年月
        FWorkRange.MonthBegin := FieldByName('YearMonth_').AsString;
        FWorkRange.DayBegin := FieldByName('BeginDate_').AsDateTime;
        //默认年月
        if FDefaultMonth.FValue = '' then
          FDefaultMonth.LoadFrom(cdsData);
      end;
      //默认年月
      if FieldByName('IsCurrYM_').AsBoolean then
        FDefaultMonth.LoadFrom(cdsData);
      //开帐年月
      if FieldByName('IsInit_').AsBoolean then
      begin
        FInitMonth.LoadFrom(cdsData);
        Break;
      end;
      Next;
    end;
  end;
  //检查参数完整性
  if FInitMonth.Value = '' then
    raise Exception.CreateFmt(Chinese.AsString('%s 帐未设置好开帐年月，无法继续作业！'), [FBookCode])
  else if FWorkRange.MonthBegin = '' then
    raise Exception.CreateFmt(Chinese.AsString('%s 帐找不到可用(未关帐)年月，无法继续作业！'), [FBookCode]);
  FActive := True;
end;

class function TBookInfo.CreateSingle(const ABookCode: String): TBookInfo;
var
  Item: TBookInfo;
begin
  Item := AppBuff.Get([Self.ClassName, ABookCode]) as TBookInfo;
  if not Assigned(Item) then
  begin
    Item := TBookInfo.Create(Application);
    AppBuff.AddItem([Self.ClassName, ABookCode], Item);
    Item.BookCode := ABookCode;
  end;
  Result := Item;
end;

constructor TBookInfo.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TObjectBuffer.Create(nil);
  cdsData := TZjhDataSet.Create(Self);
  cdsData.RemoteServer := DM.DCOM;
  //
  FInitMonth := TBIMonth.Create;
  FEndMonth := TBIMonth.Create;
  FDefaultMonth := TBIMonth.Create;
  FWorkRange := TBIWorkRange.Create;
end;

destructor TBookInfo.Destroy;
begin
  FInitMonth.Free;
  FEndMonth.Free;
  FDefaultMonth.Free;
  FWorkRange.Free;
  //
  FItems.Free;
  cdsData.Free;
  inherited;
end;

function TBookInfo.GetItem(const AMonth: String): TBIMonth;
begin
  Result := FItems.Get(AMonth) as TBIMonth;
end;

function TBookInfo.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

{ TBIWorkRange }

procedure TBIWorkRange.Clear;
begin
  MonthBegin := ''; MonthEnd := ''; DayBegin := 0; DayEnd := 0;
end;

function TBIWorkRange.OfRange(const AMonth: String): Boolean;
begin
  Result := (AMonth >= MonthBegin) and (AMonth <= MonthEnd);
end;

function TBIWorkRange.OfRange(const ADate: TDateTime): Boolean;
begin
  Result := (ADate >= DayBegin) and (ADate <= DayEnd);
end;

{ TBIMonth }

procedure TBIMonth.Clear;
begin
  FValue := '';
  FDayBegin := 0;
  FDayEnd := 0;
  FIsInit := False;
  FIsLocked := False;
  FMoved := 0;
  FIsDefault := False;
end;

procedure TBIMonth.LoadFrom(const DataSet: TDataSet);
begin
  with DataSet do
  begin
    FValue     := FieldByName('YearMonth_').AsString;
    FDayBegin  := FieldByName('BeginDate_').AsDateTime;
    FDayEnd    := FieldByName('EndDate_').AsDateTime;
    FIsInit    := FieldByName('IsInit_').AsBoolean;
    FIsLocked  := FieldByName('Locked_').AsBoolean;
    FMoved     := FieldByName('Moved_').AsInteger;
    FIsDefault := FieldByName('IsCurrYM_').AsBoolean;
  end;
end;

function TBIMonth.OfRange(const ADate: TDateTime): Boolean;
begin
  Result := (ADate >= DayBegin) and (ADate <= DayEnd);
end;

function TBIMonth.PriorMonth: String;
begin
  Result := FormatDatetime('YYYYMM', IncMonth(YMToDate(FValue), -1));
end;

{ TRecordExportACReq }

procedure TRecordExportACReq.SetOriAmount(const Value: Double);
begin
  FOriAmount := Value;
  FAmount := FixDecimal.AsCurrency(FOriAmount * FExRate);
end;

procedure TRecordExportACReq.SetMoneyCode(const Value: String);
begin
  FMoneyCode := Value;
end;

procedure TRecordExportACReq.SetExRate(const Value: Double);
begin
  FExRate := Value;
  FAmount := FixDecimal.AsCurrency(FOriAmount * FExRate);
end;

procedure TRecordExportACReq.SetAmount(const Value: Double);
begin
  FAmount := FixDecimal.AsCurrency(Value);
end;

procedure TRecordExportACReq.SetDrCrChange(const Value: Boolean);
begin
  FDrCrChange := Value;
end;

procedure TRecordExportACReq.CheckAndRepair;
begin
  if not AllowZero then
  begin
    if OriAmount = 0 then
      HasError := True;
  end;
  //注：在结转汇率时，会出现原币为0，母币有金额的特例
  if FDrCrChange and ((OriAmount < 0) or (Amount < 0)) then
  begin
    Dr := not Dr;
    FOriAmount := - FOriAmount;
    FAmount := - FAmount;
  end;
end;

function EnglishMoney(const Value: Double): String;
var
  t1 :integer;
  //------------------------
  //将阿拉伯数字转成英文字串
  //------------------------
  function num2ceng(strArabic:string):string;//不带小数点英文转换中文
  const
    sw: array[2..9] of string  =('twenty','thirty','forty','fifty','sixty','seventy','eighty','ninety');
    gw: array[1..19] of string =('one','two','three','four','five','six','seven','eight','nine','ten','eleven','twelve','thirteen','fourteen','fifteen','sixteen','seventeen','eighteen','nineteen');
    exp: array[1..4] of string =('','thousand','million','billion');
  var
    t, j: integer;
    ts: string;
    glb: Integer;
    function readu1000(ss:string):string;
    var
      t,code:integer;
    begin
      result := '';
      while ss[1]='0' do
        begin
          delete(ss,1,1);
          if length(ss)=0 then exit;//控制全是0情况
        end;
      if length(ss)=3 then
        begin
          result := result + gw[ord(ss[1])-ord('0')];
          result := result + ' hundred ';
          delete(ss,1,1);
        end;
      while ss[1]='0' do
        begin
          delete(ss,1,1);
          if length(ss)=0 then exit;
        end;
     if length(ss)<>0 then
      if result <> '' then
        result := result + 'and ';
      if (glb = 1) and (t1<>1) then //超过百位时候处理最后3位
        if result='' then
          result := result + 'and ';
      begin
        val(ss,t,code);
        if t<20 then result :=result+gw[t]
        else if t mod 10=0 then result:=result+sw[t div 10]
        else result := result+sw[trunc(t/10)]+'-'+gw[t mod 10];
     end;
    end;
  begin
    result :='';
    t := pos('.',strArabic);
    if t=0 then t:=length(strArabic)+1;
    while (t mod 3<>1)do
      begin
        t:=t+1;
        strArabic:='0'+ strArabic;
      end;
    t1:=(t-1) div 3;
    for glb := t1 downto 1 do
    begin
      ts:='';
        for j:=1 to 3 do
        begin
          ts:=ts+ strArabic[1];
          delete(strArabic,1,1);
        end;
      result := result + readu1000(ts);
      if ts<>'000' then result := result+' '+exp[glb]+' ';
    end;
    if length(strArabic)<>0 then
    begin
      delete(strArabic,1,1);
      result := result + 'and ';
      result :=result + readu1000(strArabic);
    end;
  end;
const
  gw:array[1..10] of string =('0','one','two','three','four','five','six','seven','eight','nine');
var
  p,i,iTemp:integer;
  s, strArabic:string;
begin
  strArabic := FloatToStr(Value);
  result := '';
  s := strarabic;
  p := pos('.',strarabic);
  if p = 0 then
  begin
    result := num2ceng(strarabic)+'Only';
    exit;
  end
  else
  begin
    i := length(s)-p;//计算小数点后面有几位
    delete(strarabic,p,i+1);//删除小数点后面数字
    iTemp := Round(Value * 100) mod 100;
    result := num2ceng(strarabic)+'cents ' + num2ceng(IntToStr(iTemp));
  end;
end;

function OpenConnection(DCOM: TSocketConnection; const FServerIP, KeyCard,
  Account, Password: String): Boolean;
var
  app: TAppService;
  FSessionID: String;
begin
  Result := False;
  if DCOM.Connected then
    DCOM.Close;
  if IsIPAddress(FServerIP) then
    DCOM.Address := FServerIP
  else
    DCOM.Host := FServerIP;
  //登入系统
  DCOM.Open;
  app := TAppService.Create(nil);
  try
    app.RemoteServer := DCOM;
    app.Service := 'TAppLogin';
    app.Param := VarArrayOf([Account, Password, Format('%s/%s/%s',
      [ApConst.ComputerName(), GuidNull, ApConst.NBGetAdapterAddress()])]);
    if app.Execute then
      begin
        FSessionID := app.Data[0];
        //FAppServer := app.Data[1];
        //if FAppServer = '' then
        //  FAppServer := FServerIP;
        DCOM.AppServer.LoginID := FSessionID;
        Result := True;
      end
    else
      raise Exception.Create(app.Messages);
  finally
    app.Free;
  end;
end;

procedure UpdateReportDataSet(const Source, Target: TDataSet);
var
  i: Integer;
begin
  with Source.Owner do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TQuickRep) and ((TQuickRep(Components[i])).DataSet = Source) then
        (TQuickRep(Components[i])).DataSet := Target;
      if (Components[i] is TQRSubDetail) and ((TQRSubDetail(Components[i])).DataSet = Source) then
        (TQRSubDetail(Components[i])).DataSet := Target;
      if (Components[i] is TQRDBText) and ((TQRDBText(Components[i])).DataSet = Source) then
        (TQRDBText(Components[i])).DataSet := Target;
    end;
  end;
end;

{ TReportParam }

procedure TReportParam.RegValues(Items: TStrings);
var
  i: Integer;
begin
  if VarIsNull(Values) then
    begin

    end
  else if VarIsArray(Values) then
    begin
      for i := VarArrayLowBound(Values,1) to VarArrayHighBound(Values,1) do
        Items.Add(Format('<Param%d>', [i]));
    end
  else
    Items.Add('<Param>');
end;

function TReportParam.Decode(const Key: String; var Text: String): Boolean;
var
  i: Integer;
  str: String;
  MinVal, MaxVal: Integer;
begin
  Result := False;
  if Key = '<Param>' then
    begin
      if not VarIsArray(Values) then
      begin
        Text := VarToStr(Values);
        Result := True;
      end;
    end
  else if (Copy(Key, 1, 6) = '<Param') and (Copy(Key, Length(Key), 1) = '>') then
  begin
    str := Copy(Key, 7, Length(Key));
    str := Copy(str, 1, Length(str) - 1);
    i := StrToIntDef(str, -1);
    if i > -1 then
    begin
      if VarIsArray(Values) then
      begin
        MinVal := VarArrayLowBound(Values,1);
        MaxVal := VarArrayHighBound(Values,1);
        if i in [MinVal..MaxVal] then
        begin
          Text := Values[i];
          Result := True;
        end;
      end;
    end;
  end;
end;

//创建集团单号
function GroupCreateTBNo(const TBDate: TDateTime): String;
var
  nTB: TTBRecord;
  App: TAppService;
begin
  nTB.Name := 'OK'; nTB.Sys := 2;
  App := TAppService.Create(nil);
  try
    App.Database := 'Common';
    App.Service := 'TAppCreateTBNo';
    App.Param := VarArrayOf([nTB.Name, nTB.Sys, TBDate]);
    if App.Execute then
      Result := VarToStr(App.Data)
    else
      raise Exception.Create(App.Messages);
  finally
    App.Free;
  end;
end;


procedure ShowErrorWind(Errors: TStrings; const WindCaption: String = '');
var
  AIntf: IBaseForm;
begin
  AIntf := CreateClass('TFrmShowMsg', Application) as IBaseForm;
  if Assigned(AIntf) then
    begin
      (AIntf.GetControl('') as TForm).Visible := False;
      if WindCaption <> '' then
        (AIntf.GetControl('') as TForm).Caption := WindCaption;
      AIntf.PostMessage(CONST_MSG, Errors.Text);
      AIntf.ShowForm(CONST_FORM_SHOWMODAL, TEMP_VARIANT);
      AIntf := nil;
    end
  else
    ShowMessage(Errors.Text);
end;

procedure ShowErrorWind(Errors: string; const WindCaption: String = '');
var
  AIntf: IBaseForm;
  AParam: Variant;
begin
  AParam := VarArrayOf([Errors, WindCaption]);
  AIntf := CreateClass('TFrmShowMsg', Application) as IBaseForm;
  if Assigned(AIntf) then begin
    (AIntf.GetControl('') as TForm).Visible := False;
    AIntf.PostMessage(CONST_MSG, Errors);
    AIntf.ShowForm(CONST_FORM_SHOWMODAL, AParam);
    AIntf := nil;
  end;
end;

procedure ExcelUpdate(Sec: TObject; DBGrid: TObject; const KeyNo: Integer);
var
  Obj: TComponent;
  AIntf: IHRObject;
begin
  Obj := CreateClass('TZLExcelUpdate', nil);
  try
    AIntf := Obj as IHRObject;
    AIntf.PostMessage(CONST_DEFAULT, VarArrayOf([Integer(Sec), Integer(DBGrid), KeyNo]));
  finally
    AIntf := nil;
    Obj.Free;
  end;
end;

function SendErpInfo(const UserTo, Subject, Body, AppUser: String;
  Job, Email, SMS: Boolean): Boolean;
var
  UserID: String;
  oRs: TZjhDataSet;
  function GetMyCofferID(const AType: Integer): String;
  var
    cdsTmp: TZjhDataSet;
  begin
    cdsTmp := TZjhDataSet.Create(nil);
    try
      with cdsTmp do
      begin
        RemoteServer := DM.DCOM;
        CommandText := Format('Select DirID_ From DirCoffer '
          + 'Where Owner_=''%s'' and Type_=%d', [DM.UserID, AType]);
        Open;
        if not Eof then
          Result := FieldByName('DirID_').AsString
        else
          Result := DM.UserID;
        Close;
      end;
    finally
      FreeAndNil(cdsTmp);
    end;
  end;
  procedure AppendToJobs;
  var
    cdsTmp: TZjhDataSet;
  begin
    cdsTmp := TZjhDataSet.Create(nil);
    with cdsTmp do
    try
      RemoteServer := DM.DCOM;
      TableName := 'UserJobs';
      CommandText := 'Select top 0 * from UserJobs';
      Open;
      Append;
      //AppUser_,AppDate_,Name_,WorkUser_,StopTime_,FinalUser_,FinalTime_,Final_
      FieldByName('PID_').AsString := NewGuid();
      FieldByName('ID_').AsString := NewGuid();
      FieldByName('Subject_').AsString := Subject;
      FieldByName('Body_').AsString := Body;
      FieldByName('DateFrom_').AsDateTime := Date();
      FieldByName('DateTo_').AsDateTime := Date();
      FieldByName('AppUser_').AsString := DM.Account;
      FieldByName('AppDate_').AsDateTime := Now();
      FieldByName('WorkUser_').AsString := UserTo;
      FieldByName('FinalUser_').AsString := DM.Account;
      FieldByName('Final_').AsBoolean := False;
      PostPro(0);
    finally
      FreeAndNil(cdsTmp);
    end;
  end;
begin
  //注：UserTo 及 AppUser 为 Account.Code_,
  oRs := TZjhDataSet.Create(DM.DCOM);
  with oRs do
  try
    RemoteServer := DM.DCOM;
    Database := 'Common';
    TableName := 'SysRecord';
    CommandText := 'Select top 0 * from SysRecord';
    Open;
    //先存档
    Append;
    FieldByName('MsgID_').AsString := NewGuid();
    FieldByName('MailBox_').AsString := DM.Account;
    FieldByName('PID_').AsString := GetMyCofferID(DOC_PRIVATE_MailOut);
    FieldByName('CorpCode_').AsString := DM.CurrCorp;
    FieldByName('ReceiveUser_').AsString := UserTo;
    FieldByName('AppUser_').AsString := AppUser;
    FieldByName('AppDate_').AsDateTime := Now();
    FieldByName('Subject_').AsString := Subject;
    FieldByName('Body_').AsString := Body;
    FieldByName('Email_').AsInteger := iif(Email,1,0);
    FieldByName('SMS_').AsInteger := iif(SMS,1,0);
    FieldByName('Status_').AsInteger := 1;
    FieldByName('TID_').AsInteger := 1002;
    Post;
    //再发送
    UserID := VarToStr(GroupBuff.ReadValue('Account', UserTo, 'ID_'));
    Append;
    if UserID <> '' then
      begin
        FieldByName('MailBox_').AsString := UserTo;
        FieldByName('PID_').Value := UserID;
        FieldByName('Body_').AsString := Body;
        if Job then //需要回复
          AppendToJobs;
      end
    else
      begin
        FieldByName('MailBox_').AsString := DM.Account;
        FieldByName('PID_').Value := DM.UserID;
        FieldByName('Body_').AsString := Body + vbCrLf + '====================' + vbCrLf
          + Format(Chinese.AsString('此邮件无法送给 %s ，已被退件！'), [UserTo]);
      end;
    FieldByName('ReceiveUser_').AsString := UserTo;
    FieldByName('AppUser_').AsString := AppUser;
    FieldByName('AppDate_').AsDateTime := Now();
    FieldByName('Subject_').AsString := Subject;
    FieldByName('Email_').AsInteger := iif(Email,1,0);
    FieldByName('SMS_').AsInteger := iif(SMS,1,0);
    FieldByName('TID_').AsInteger := 1002;
    FieldByName('Status_').AsInteger := 0;
    PostPro(0);
    Close;
    Result := True;
  finally
    FreeAndNil(oRs);
  end;
end;

{ THRDirectory }

constructor THRDirectory.Create;
begin
  FFilter := '*.*';
  FDirectory := ExtractFilePath(Application.ExeName);
  FFolders := TStringList.Create;
  FFiles := TStringList.Create;
  Refresh;
end;

destructor THRDirectory.Destroy;
begin
  FreeAndNil(FFiles);
  FreeAndNil(FFolders);
  inherited;
end;

procedure THRDirectory.Clear;
begin
  FFolders.Clear;
  FFiles.Clear;
end;

function THRDirectory.GetFolders: TStrings;
begin
  Result := FFolders;
end;

function THRDirectory.GetFiles: TStrings;
begin
  Result := FFiles;
end;

function THRDirectory.ItemCount: Integer;
begin
  Result := FFiles.Count + FFolders.Count;
end;

function THRDirectory.GetItem(Index: Integer): String;
begin
  if (Index > -1) and (Index < ItemCount) then
    begin
      if Index < FFolders.Count then
        Result := FFolders.Strings[Index]
      else
        Result := FFiles.Strings[Index - FFolders.Count];
    end
  else
    Raise Exception.CreateFmt('List index out of bounds (%d)', [Index]);
end;

procedure THRDirectory.SetDirectory(const Value: String);
begin
  if FDirectory <> Value then
  begin
    FDirectory := Value;
    Refresh;
  end;
end;

procedure THRDirectory.SetFilter(const Value: string);
begin
  if FFilter <> Value then
  begin
    FFilter := Value;
    Refresh;
  end;
end;

procedure THRDirectory.Refresh;
var
  sr: TSearchRec;
begin
  Clear;
  if FDirectory <> '' then
  begin
    //取所有符合条件的文件.
    if FindFirst(FDirectory + FFilter, faAnyFile, sr) = 0 then
    begin
      repeat
        if FileExists(FDirectory + sr.Name) then
          FFiles.Add(FDirectory + sr.Name)
        else if (sr.Name <> '.') and (sr.Name <> '..')
          and DirectoryExists(FDirectory + sr.Name) then
          FFolders.Add(FDirectory + sr.Name);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;
end;

{ TParamParse }

constructor TParamParse.Create(const ParamValue: String);
begin
  FData := ParamValue;
  FParam := TStringList.Create;
  Parse;
end;

destructor TParamParse.Destroy;
begin
  FParam.Free;
  inherited;
end;

function TParamParse.GetParams(Index: Integer): String;
begin
  Result := FParam.Strings[Index];
end;

function TParamParse.ParamCount: Integer;
begin
  Result := FParam.Count;
end;

procedure TParamParse.Parse;
var
  s0, s1: String;
begin
  FParam.Clear;
  s0 := FData;
  while Pos(',', s0) > 0 do
  begin
    s1 := Copy(s0, 1, Pos(',', s0) - 1);
    FParam.Add(Trim(s1));
    s0 := Copy(s0, Pos(',', s0) + 1, Length(s0));
  end;
  if Trim(s0) <> '' then
    FParam.Add(Trim(s0));
end;

procedure TParamParse.SetData(const Value: String);
begin
  if FData <> Value then
  begin
    FData := Value;
    Parse;
  end;
end;

function USB_GetSerialNum: String;
var
  dll: THandle;
  tempByte: Byte;
  pAppID, pNullByte: PByte;
  i, j, ulFlags, hContextHandle: Integer;
  Buffer: array [0 .. 7] of Byte;
  CreateContext: function(hContextHandle: PHandle;
    ulFlags, ulApiVersion: Integer): Integer; stdcall;
  DeleteContext: function(hContextHandle: THandle): Integer; stdcall;
  OpenDevice: function(hContextHandle: Integer; ulFlags: Integer;
    var pAppID: Byte): Integer; stdcall;
  GetProperty: function(hContextHandle: Integer; ulFlags: Integer;
    var pRefData, pPropData: Byte; ulPropSize: Integer): Integer; stdcall;
begin
  Result := '';
  dll := LoadLibrary('Security.dll');
  if dll = 0 then Exit;
  try
    pAppID := nil;
    CreateContext := GetProcAddress(dll, 'epas_CreateContext');
    if Assigned(CreateContext) then
      begin
        OpenDevice := GetProcAddress(dll, 'epas_OpenDevice');
        GetProperty := GetProcAddress(dll, 'epas_GetProperty');
        DeleteContext := GetProcAddress(dll, 'epas_DeleteContext');
        ulFlags := 0;
        CreateContext(@hContextHandle, ulFlags, $100);
        try
          if OpenDevice(hContextHandle, $1, pAppID^) = RET_OK then
          begin
            //取序列号
            pNullByte := nil;
            GetProperty(hContextHandle, $7, pNullByte^, Buffer[0], 8);
            for i := 0 to 1 do
            begin
              tempByte := Buffer[i];
              Buffer[i] := Buffer[3 - i];
              Buffer[3 - i] := tempByte
            end;
            for j := 4 to 5 do
            begin
              tempByte := Buffer[j];
              Buffer[j] := Buffer[7 - j + 4];
              Buffer[7 - j + 4] := tempByte;
            end;
            for i := 0 to 7 do
              Result := Result + IntToHex(Buffer[i], 2);
          end;
        finally
          DeleteContext(hContextHandle);
        end;
      end;
  finally
    FreeLibrary(dll);
  end;
end;

function ShowTBDetail(AGrid: TDBGrid; const Args: array of String): IBaseForm;
var
  i: Integer;
  DataSet: TDataSet;
  ATB, TBNo, AClassName: String;
  function GetTBCode(S: String): String;
  var
    i, n: Integer;
  begin
    Result := '';
    n := 0;
    //获取最后一个'-'位置。
    for i := 1 to 10 do
      if S[i] = '-' then n := i;
    if n > 0 then
      Result := Copy(S, 1, n - 1);
  end;
begin
  Result := nil;
  DataSet := AGrid.DataSource.DataSet;
  if not Assigned(DataSet) then
    Exit;
  for i := Low(Args) to High(Args) do
  begin
    if AGrid.SelectedField = DataSet.FieldByName(Args[i]) then
    begin
      TBNo := DataSet.FieldByName(Args[i]).AsString;
      ATB := GetTBCode(TBNo);
      AClassName := VarToStrDef(Buff.ReadValue('TranT', ATB, 'Class_'), '');
      if AClassName <> '' then
        Result := ViewDetail(AClassName, TBNo);
    end;
  end;
end;

{ TZLXMLRecords }

procedure TZLXMLRecords.LoadFromNode(root: IXMLNode; DataSet: TDataSet);
var
  fd: TField;
  rec, item: IXMLNode;
begin
  with DataSet do
  begin
    rec := root.ChildNodes.First;
    while Assigned(rec) do
    begin
      if rec.NodeName = 'record' then
      begin
        DataSet.Append;
        item := rec.ChildNodes.First;
        while Assigned(item) do
        begin
          if item.NodeName = 'field' then
          begin
            fd := DataSet.FindField(item.Attributes['code']);
            if Assigned(fd) then
              fd.Value := item.NodeValue;
          end;
          item := item.NextSibling;
        end;
      end;
      rec := rec.NextSibling;
    end;
    DataSet.Post;
  end;
end;

procedure TZLXMLRecords.LoadFromFile(const xmlFile: String; DataSet: TZjhDataSet);
var
  xml: TXMLDocument;
  root, table, recs: IXMLNode;
  strTable: String;
  bFlag: Boolean;
begin
  if not FileExists(xmlFile) then
    raise Exception.CreateFmt(Chinese.AsString('没有找到字典文件：'), [xmlFile]);
  strTable := DataSet.TableName;
  xml := TXMLDocument.Create(Application);
  try
    xml.LoadFromFile(xmlFile);
    if xml.DocumentElement.NodeName = 'database' then
      begin
        root := xml.DocumentElement.ChildNodes.FindNode('tables');
        if Assigned(root) then
          begin
            bFlag := False;
            table := root.ChildNodes.First;
            while Assigned(table) do
            begin
              if UpperCase(table.Attributes['code']) = UpperCase(strTable) then
              begin
                bFlag := True;
                recs := table.ChildNodes.FindNode('records');
                if Assigned(recs) then
                  begin
                    Self.LoadFromNode(recs, DataSet);
                  end
                else
                  raise Exception.Create(Chinese.AsString('字典文件中找不到默认记录！'));
                Break;
              end;
              table := table.NextSibling;
            end;
            if not bFlag then
              raise Exception.CreateFmt(Chinese.AsString('字典文件中找不到指定的表：%s'), [strTable]);
          end
        else
          raise Exception.CreateFmt(Chinese.AsString('非数据字典文件：%s'), [xmlFile]);
          end
          else
            raise Exception.CreateFmt(Chinese.AsString('非数据字典文件：%s'),
              [xmlFile]);
        finally
          xml.Free;
        end;
      end;

      procedure TZLXMLRecords.SaveToNode(root: IXMLNode; DataSet: TDataSet;
        Field_List: array of string);
      var
        i: Integer;
        fn: String;
        rec, Item: IXMLNode;
      begin
        with DataSet do
        begin
          First;
          while not Eof do
          begin
            rec := root.AddChild('record');
            for i := Low(Field_List) to High(Field_List) do
            begin
              fn := Field_List[i];
        item := rec.AddChild('field');
        item.Attributes['code'] := fn;
        item.NodeValue := DataSet.FieldByName(fn).Value;
      end;
      Next;
    end;
  end;
end;

{ TDebugService }

constructor TDebugService.Create(AOwner: TComponent);
begin
  inherited;
  Session := TServiceSession.Create;
  SQLServer := TSQLServer.Create;
  FErrorOut := TAppDataSet.Create;
  FDataIn := TAppDataSet.Create;
  FDataOut := TAppDataSet.Create;
end;

destructor TDebugService.Destroy;
begin
  FDataOut.Free;
  FDataIn.Free;
  FErrorOut.Free;
  SQLServer.Free;
  Session.Free;
  inherited;
end;

function TDebugService.Exec(const AFirstParam: String): Boolean;
begin
  Self.Param := VarArrayOf([AFirstParam, FDataIn.GetVariant()]);
  if Self.Execute() then
    begin
      FDataOut.SetVariant(Data);
      Result := True;
    end
  else
    begin
      FErrorOut.SetVariant(Data);
      Result := False;
    end;
end;

function TDebugService.Execute: Boolean;
var
  R: OleVariant;
begin
  try
    InitSession;
    R := Self.ExecuteService();
    FState := appReady;
    Result := R[0] = RET_OK;
    if Result then
      begin
        FData := R[1];
        FError := NULL;
      end
    else
      begin
        FData := NULL;
        FError := R[1];
      end;
  except
    on E: Exception do
    begin
      FState := appError;
      FError := Self.ClassName + ':' + E.Message;
      Result := False;
    end;
  end;
end;

function TDebugService.ExecuteService: OleVariant;
var
  app: TAppBean;
  Ret: OleVariant;
begin
  Result := VarArrayCreate([0,1],varVariant);
  Result[0] := RET_ERROR;
  Result[1] := '';
  if not Assigned(FService) then
  begin
    Result[1] := '调用错误，ServiceClass 不能为空！';
    Exit;
  end;
  Ret := NULL;
  app := FService.Create(Self) as TAppBean;
  try
    app.Session := Session;
    try
      if app.Execute(Param, Ret) then
        Result[0] := RET_OK;
      Result[1] := Ret;
    except
      on E: Exception do
        Result[1] := FService.ClassName + ':' + E.Message;
    end;
  finally
    app.Free;
  end;
end;

function TDebugService.GetMessages: String;
var
  i: Integer;
begin
  if VarIsArray(FError) then
    begin
      Result := '';
      for i := 0 to VarArrayHighBound(FError, 1) do
      begin
        if Result = '' then
          Result := FError[i]
        else
          Result := Result + vbCrLf + FError[i];
      end;
    end
  else
    Result := VarToStr(FError);
end;

procedure TDebugService.InitSession;
var
  cdsTmp: TAppQuery;
begin
  if SQLServer.Open then
  begin
    cdsTmp := TAppQuery.Create(Self);
    try
      with cdsTmp do
      begin
        Connection := SQLServer.Connection;
        SQL.Text := Format('select * from Account '
          + 'where Code_=N''%s''',
          [DM.Account]);
        Open;
        if not Eof then
          begin
            Session.UserID := FieldByName('ID_').AsString;
            Session.UserCode := FieldByName('Code_').AsString;
            Session.UserName := FieldByName('Name_').AsString;
            Session.CurrCorp := FieldByName('CorpCode_').AsString;
          end
        else
          raise Exception.CreateFmt('无法取得用户 %s 的资料！', [DM.Account]);
      end;
    finally
      cdsTmp.Free;
    end;
  end;
  //
  Session.CostDeptEnabled := not DM.CostDeptDisabled;
  Session.CostDept := DM.CostDept;
  Session.ID := DM.SessionID;
  Session.ServerIP := '127.0.0.1';
  Session.Connection := SQLServer.Connection;
end;

procedure TDebugService.SetParam(const Value: OleVariant);
begin
  FParam := Value;
end;

procedure TDebugService.SetService(const Value: TComponentClass);
begin
  FService := Value;
end;

procedure TDebugService.SetState(const Value: TAppServiceState);
begin
  FState := Value;
end;

function GetSystemConfigFile: String;
var
  strFile: String;
begin
  //默认值
  Result := ExtractFilePath(Application.ExeName) + 'ee.xml';
  //优先使用zl框架配置文件
  strFile := ExtractFilePath(Application.ExeName) + 'zl.xml';
  if FileExists(strFile) then
    Result := strFile;
  //最优先使用系统传入配置文件
  if ParamCount() = 1 then
  begin
    strFile := ParamStr(1);
    if Pos('.xml', strFile) > 0 then
      begin
        if ExtractFilePath(strFile) = '' then
          strFile := ExtractFilePath(Application.ExeName) + strFile;
        if FileExists(strFile) then
          Result := strFile;
      end;
  end;
end;

function GetSystemPath(const ID: String): String;
{$IFDEF ERP2012}
var
  xml: TXMLDocument;
  sys, item: IXMLNode;
  strFile, PathTmp: String;
{$ENDIF}
begin
  Result := '';
  {$IFDEF ERP2012}
  xml := TXMLDocument.Create(Application);
  try
    strFile := GetSystemConfigFile();
    if not FileExists(strFile) then
      raise Exception.CreateFmt('没有找到安装配置文件：%s', [strFile]);
    xml.LoadFromFile(strFile);
    sys := xml.DocumentElement.ChildNodes.FindNode('system');
    if Assigned(sys) then
    begin
      item := sys.ChildNodes.First;
      while Assigned(item) do
      begin
        if item.NodeName = 'path' then
        begin
          if item.Attributes['id'] = id then
          begin
            PathTmp := item.NodeValue;
            if Pos(':\', PathTmp) > 0 then
              Result := PathTmp
            else
              Result := ExtractFilePath(Application.ExeName) + PathTmp;
            Break;
          end;
        end;
        item := item.NextSibling;
      end;
    end;
  finally
    xml.Free;
  end;
  if Result = '' then
    raise Exception.CreateFmt(Chinese.AsString('在系统配置文件 %s 中未找到系统配置段：%s'), [strFile, ID]);
  {$ELSE}
  if ID = 'config' then
    Result := ExtractFilePath(Application.ExeName) + '2052\'
  else if ID = 'menufile' then
    Result := ExtractFilePath(Application.ExeName) + 'Menu\'
  else if ID = 'datadict' then
    Result := ExtractFilePath(Application.ExeName) + 'Database\';
  {$ENDIF}
end;

function ErpFormatAmount(const Amount: Double; Currency: String = ''): String;
var
  Decimal: Integer;
begin
  if CompareText(Currency, '') = 0 then
    Currency := nreg.ReadString('public', 'SYS11015', 'CNY');
  {$IFDEF ERP2011}
  if not Buff.ValueExists('Money', Currency) then
    raise Exception.CreateFmt(Chinese.AsString('未找到当前币别：%s'), [Currency]);
  Decimal := StrToInt(VarToStrDef(Buff.ReadValue('Money', Currency, 'Decimal_'),'0'));
  {$ELSE}
  with Buff.GetItem('MoneyUnit') do
  begin
    if not Active then Open;
    if Locate('Code_', Currency, []) then
      Decimal := FieldByName('Decimal_').AsInteger
    else
      raise Exception.CreateFmt(Chinese.AsString('未找到当前币别：%s'), [Currency])
  end;
  {$ENDIF}
  Result  := Format('%*.*n',[18, Decimal, Amount]);
end;

//Create: Jason at 2012/12/31
function GetDefaultIndex(Items: TStrings; const Default: String): Integer;
begin
  Result := -1;
  if Items.IndexOf(Default) > -1 then
    Result := Items.IndexOf(Default)
  else if Items.Count > 0 then
    Result := 0;
  {调用范例：
  cboCurrency.ItemIndex := GetDefaultIndex(cboCurrency.Items, 'CNY');
  }
end;

function GetMessageDialog(AOwner: TComponent): IOutputMessage2;
var
  i: Integer;
  Dialog: TForm;
begin
  Dialog := nil;
  for i := 0 to AOwner.ComponentCount - 1 do
  begin
    if AOwner.Components[i].ClassNameIs('TDialogMessage') then
    begin
      Dialog := AOwner.Components[i] as TForm;
      Break;
    end;
  end;
  if not Assigned(Dialog) then
    Dialog := CreateClass('TDialogMessage', AOwner) as TForm;
  //if not Dialog.Visible then
  Dialog.Show;
  Dialog.WindowState := wsNormal;
  Result := (Dialog as IOutputMessage2)
end;

procedure CloseMessageDialog(AOwner: TComponent; Timeout: Cardinal);
var
  i: Integer;
  Dialog: TForm;
begin
  for i := 0 to AOwner.ComponentCount - 1 do
  begin
    if AOwner.Components[i].ClassNameIs('TDialogMessage') then
    begin
      if Timeout > 0 then
        Sleep(Timeout);
      Dialog := AOwner.Components[i] as TForm;
      Dialog.Close;
      Break;
    end;
  end;
end;

procedure OutputMessage(Sender: TObject; const Value: String;
  MsgLevel: TMsgLevelOption);
begin
  if Assigned(Application.MainForm) then
  begin
    if Supports(Application.MainForm, IOutputMessage2) then
      (Application.MainForm as IOutputMessage2).OutputMessage(Sender, Value, MsgLevel)
    else if Supports(Application.MainForm, IOutputMessage) then
      (Application.MainForm as IOutputMessage).OutputMessage(Value);
  end;
end;

function MyRandom15: String;
var
  CurDate: TTimeStamp;
begin
  CurDate := DateTimeToTimeStamp(Now());
  Result := IntToHex(CurDate.Date, 5) + IntToHex(CurDate.Time, 7) + IntToHex(Random(4095), 3);
end;

procedure WizardBox(const AProjectCode: string; const AutoPlay: Boolean);
var
  Obj: TComponent;
  AIntf: IBaseForm;
begin
  Obj := CreateClass('TFrmTipWizard', Application);
  if Assigned(Obj) then
    begin
      try
        if Supports(Obj, IBaseForm) then
        begin
          AIntf := Obj as IBaseForm;
          AIntf.PostMessage(CONST_ADMESSAGE, VarArrayOf([AProjectCode, AutoPlay]));
        end;
      finally
        AIntf := nil;
      end;
    end
  else
    MsgBox(Chinese.AsString('无法调用系统向导服务，请联系系统管理员！'));
end;

procedure HelpBox(const DocID, AText, ACaption: String;
  DlgType: TMsgDlgType);
var
  Obj: TComponent;
  AIntf: IHRObject;
begin
  Obj := CreateClass('TDlgHelpBox', Application);
  if Assigned(Obj) then
    begin
      try
        if Supports(Obj, IHRObject) then
        begin
          AIntf := Obj as IHRObject;
          AIntf.PostMessage(CONST_DEFAULT, VarArrayOf([ACaption, AText, DocID, DlgType]));
        end;
      finally
        AIntf := nil;
      end;
    end
  else
    MsgBox(AText, ACaption);
end;

procedure DestroyVirForm;
var
  i: Integer;
begin
  for i := Screen.FormCount - 1 downto 0 do
  begin
    if Screen.Forms[i] <> Application.MainForm then
      if Screen.Forms[i].ClassNameIs('TVirForm') then
      begin
        if Supports(Application.MainForm, IOutputMessage2) then
        begin
          (Application.MainForm as IOutputMessage2).OutputMessage(Application.MainForm,
            Format('Free Object: %s, %s', [Screen.Forms[i].ClassName,Screen.Forms[i].Caption]),
            MSG_DEBUG);
        end;
        Screen.Forms[i].Destroy;
      end;
  end;
end;

function createExcelApp: OleVariant;
begin
  try
    Result := CreateOleObject('Excel.Application');
  except
    Result := CreateOleObject('ET.Application');
  end;
end;

{ TAppBuildSQL }

constructor TAppBuildSQL.Create(AOwner: TComponent);
begin
  inherited;
  app2 := TAppService2.Create(Self);
end;

destructor TAppBuildSQL.Destroy;
begin
  if Assigned(app1) then
    app1.Free;
  app2.Free;
  inherited;
end;

function TAppBuildSQL.Execute(const ASelect, AOrder: String): Boolean;
var
  str: String;
begin
  str := Self.BuildCommand(ASelect, AOrder);
  OutputMessage(Self.Owner, str, MSG_DEBUG);
  if Assigned(Self.FServiceClass) then
    begin
      app1 := TDebugService.Create(Self);
      app1.DataIn.FieldDefs.AutoMode := True;
      app1.DataIn.Append.FieldByName('SQLCommand').AsString := str;
      app1.Service := Self.FServiceClass;
      Result := app1.Exec('search');
    end
  else
    begin
      if Self.FService = '' then
        raise Exception.Create('Service is NULL.');
      app2.DataIn.FieldDefs.AutoMode := True;
      app2.DataIn.Append.FieldByName('SQLCommand').AsString := str;
      app2.Service := Self.FService;
      Result := app2.Exec('search');
    end;
end;

function TAppBuildSQL.GetDataIn: TAppDataSet;
begin
  if Assigned(app1) then
    Result := app1.DataIn
  else
    Result := app2.DataIn;
end;

function TAppBuildSQL.GetDataOut: TAppDataSet;
begin
  if Assigned(app1) then
    Result := app1.DataOut
  else
    Result := app2.DataOut;
end;

function TAppBuildSQL.GetMessages: String;
begin
  if Assigned(app1) then
    Result := app1.Messages
  else
    Result := app2.Messages;
end;

procedure TAppBuildSQL.SetService(const Value: String);
begin
  FService := Value;
end;

procedure TAppBuildSQL.SetServiceClass(const Value: TComponentClass);
begin
  FServiceClass := Value;
end;

end.


