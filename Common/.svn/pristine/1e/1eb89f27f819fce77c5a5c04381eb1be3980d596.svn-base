unit uBaseIntf;
{$I ERPVersion.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Forms, XmlIntf, DBClient,
  Dialogs, ApConst, DB, DBGrids;

type
  //基础类接口
  IHRObject = interface(IInterface)
    ['{11B032A1-2818-4FF7-ABA6-720AF54413F2}']
    function PostMessage(MsgType: Integer; Msg: Variant): Variant;  //发送消息
  end;
  //基础窗体接口
  IBaseForm = interface(IHRObject)
    ['{5E87522C-CA9A-44B0-AA9B-81AB41035124}']
    procedure SetAliaName(const Value: Variant);
    function GetAliaName: Variant;
    procedure SetAddress(const Value: String);
    function GetAddress: String;
    function GetControl(ControlName: String): TObject;     //取窗口上的控件
    function ShowForm(ModalType: Integer; var Param: Variant): Integer;  //显示窗口
    function ISec: TObject;  //特有, 返回TZjhTool
    property Address: string read GetAddress write SetAddress;
    property AliaName: Variant read GetAliaName write SetAliaName;
  end;
  //
  IMainForm = Interface(IBaseForm)
    ['{941ADE26-3F41-4102-A7BE-F7C717293693}']
    function FindChild(const ChildName: String): IBaseForm;
    //function InitChild(Child: IBaseForm; Param: Variant): Variant;
    function GetForm(const Msg: Variant; bShow: Boolean = True): IBaseForm;
    function Passport(const AID, AKey: String; bShowErrorInfo: Boolean = False): Boolean;
    function GetBuffers(const Index: String): TComponent;
    procedure DataSetBeforePost(DataSet: TDataSet);  //为TZjhDataSet服务
    property Buffers[const Index: String]: TComponent read GetBuffers;
  end;
  //
  IMainData = interface
    ['{51AF77CC-3B4E-4E69-A67E-6F6EBDADC5A6}']
    function CostDeptDisabled: Boolean;
    function ChangeStatus(wfClass: Integer; const TBID: String; CurStatus,
      NewStatus: Integer; Errors: TStringList): Boolean;
    function ChangeStatus2(wfClass: Integer; const TBID: String; CurStatus,
      NewStatus: Integer; ADBName: String; Errors: TStringList): Boolean;
    function SetLists(s: TStrings; const SQLText: String;
      const Default: String = ''; IsSysList: Boolean = false): Integer;
    procedure ClearBuffer;
    function Version: Integer;
    //
    function GetUserID: String;
    function GetAccount: String;
    function GetUserCorp: String;
    function GetCurrCorp: String;
    function GetCostDept: String;
    function GetSysCode: String;
    procedure SetUserID(const Value: String);
    procedure SetAccount(const Value: String);
    procedure SetUserCorp(const Value: String);
    procedure SetCurrCorp(const Value: String);
    procedure SetCostDept(const Value: String);
    procedure SetSysCode(const Value: String);
    //
    function GetDCOM: TCustomRemoteServer;
    function GetDBName: String;
    function GetServerIP: String;
    function GetSessionID: String;
    function GetMultiBookEnabled: Boolean;
    procedure SetSessionID(const Value: String);
    procedure SetMultiBookEnabled(const Value: Boolean);
    procedure SetServerIP(const Value: String);
    procedure SetDBName(const Value: String);
    //
    property UserID: String read GetUserID write SetUserID;     //登入帐号ID
    property Account: String read GetAccount write SetAccount;   //登入帐号
    property UserCorp: String read GetUserCorp write SetUserCorp; //用户所属公司别
    property CurrCorp: String read GetCurrCorp write SetCurrCorp; //当前公司别
    property CostDept: String read GetCostDept write SetCostDept; //用户当前所在公司之成本中心代码
    property SysCode: String read GetSysCode write SetSysCode;   //当前子系统ID
    //
    property DCOM: TCustomRemoteServer read GetDCOM;
    property DBName: String read GetDBName write SetDBName;
    property ServerIP: String read GetServerIP write SetServerIP;
    property SessionID: String read GetSessionID write SetSessionID;   //登录Session, ID
    property MultiBookEnabled: Boolean read GetMultiBookEnabled write SetMultiBookEnabled; //启用集团版
  end;
  //
  IHRChoice = interface(IHRObject)
    ['{FC23C027-CB20-44BB-8673-3A809837A11E}']
    function AddItem(const Args: array of String): Integer; overload;
    function Execute(AItems: TStrings; Index: Integer): Boolean;
    function GetControl(ControlName: String): TObject;     //取窗口上的控件
  end;
  //
  IBaseFrame = Interface(IHRObject)
    ['{E29CAC43-7D28-4A89-96C7-DB2B52E5C23F}']
    //
    function GetMasterKey: Variant;
    procedure SetMasterKey(const Value: Variant);
    property MasterKey: Variant read GetMasterKey write SetMasterKey;
    //
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    property Active: Boolean read GetActive write SetActive;
    //
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    //
    procedure UpdateParent(const AOwner: TObject; const Param: Variant);
    function GetControl(ControlName: String): TObject;     //取窗口上的控件
  end;
  //报表数据源
  IReportSource = interface
    ['{89849D87-9836-4943-91E6-C81D3814CF97}']
    procedure GetReportSource(Sender: TObject; Items: TList);
  end;
  //报表自定义函数
  IReportFunction = interface
    ['{BBE027D1-12F8-4B3D-AD59-F849AB04EEED}']
    procedure GetReportFunction(Sender: TObject; Items: TStrings);
    function UserDefPrint(Sender: TObject; const Key: String;
      var Text: String): Boolean;
  end;
  //报表是否输出之确认
  IReportConfirm = interface
    ['{07F8AE21-F16A-481D-86B8-4DD181DB0AE6}']
    procedure ReportConfirmOutput(Sender: TObject; var Allow: Boolean);
    procedure ReportConfirmType(AType: Integer; var Allow: Boolean);
  end;
  //内部系统报表报告
  IReportDefault = interface
    ['{C6D86BA6-0EE7-4A82-9E2B-8CD2E0FBAB29}']
    procedure GetReportDefault(Sender: TObject; Items: TStrings);
  end;
  //系统报表输出记录
  IReportRecord = interface
    ['{73D507C7-95FA-4A51-97D9-63C7B54196C6}']
    procedure ReportRecord(Sender: TObject; const ReportName: String;
      rfPrint: Boolean);
  end;
  //用于定义QuickRpt
  IHRReport = interface
	['{6E0D6ADE-792E-4764-AEEF-C1BDA89879A1}']
    function GetQuickRep: TObject;
	  function DataSetCount: Integer;
    procedure LinkDataSet(const Index: Integer; DataSet: TDataSet);
    procedure Execute(rfPrint: Boolean);
  end;
  //Email接口
  IEmail = interface
    ['{726C4642-CEF9-4580-ABE7-A322D8C5EEC2}']
    function GetCCAddress: TStrings;
    function GetToAddress: TStrings;
    function GetAttachmentFiles: TStrings;
    procedure SetSubject(const Value: String);
    procedure SetBody(const Value: String);
    function GetSubject: String;
    function GetBody: String;
    function GetLog: String;
    function Send: Boolean;
    procedure GetPropertys(Items: TStrings);
    procedure SetProperty(const AName: String; Value: Variant);
    function GetProperty(const AName: String): Variant;
    property ToAddress: TStrings read GetToAddress;
    property CCAddress: TStrings read GetCCAddress;
    property AttachmentFiles: TStrings read GetAttachmentFiles;
    property Subject: String read GetSubject write SetSubject;
    property Body: String read GetBody write SetBody;
    property Log: String read GetLog;
  end;
  //foreach接口
  IEnumerator = interface
    ['{6F7EB1D5-5E19-4EB0-869C-C02D55522A3B}']
    function MoveNext: Boolean;
    function Current: Pointer;
    procedure Reset;
  end;
  //用于配合返回html表格
  IDataTable = interface
    ['{D578A3AD-04EC-46A6-B032-2F1C7F415A80}']
    procedure Reset;
    function MoveNext: Boolean;
    function ColumnCount: Integer;
    function GetColumnValue(AColumn: Integer): Variant;
    function GetColumnTitle(AColumn: Integer): Variant;
  end;
  IGetDisplayText = interface
    ['{CB7C0D36-C020-42B5-885C-F9AB9BF35674}']
    procedure GetDisplayText(const Sender: TField; var Text: String);
  end;
  IGetDataTable = interface
    function GetDataTable: IDataTable;
  end;
  IGetMailSubject = interface
    ['{A978BAE0-32E0-42D8-B325-7743E258A074}']
    function GetMailSubject: String;
  end;
  IGetMailBody = interface
    ['{8B915DE7-2499-458E-BC27-E8E0FFBEA710}']
    function GetMailBody: String;
  end;
  //选择对话框
  ISelectDialog = Interface
    ['{BC9F12C9-2272-472F-8959-F84723E2CB4E}']
    procedure Display(const Sender: TObject; const Param: Variant);
    function Execute(const Args: array of TObject; const Param: Variant): Variant;
  end;
  //
  IInitTable = Interface(IBaseForm)
    ['{77FCC5A4-50EA-4AD7-B09F-2447FCDF8C66}']
    procedure Execute(const Target: TObject);
  end;
  //
  IBaseCommit = Interface(IHRObject)
    ['{F5E3A490-7333-4BED-AEC0-F5E20D425B9A}']
    function GetSource: TObject;
    function GetKeyField: String;
    procedure SetSource(Value: TObject);
    procedure SetKeyField(Value: String);
    property Source: TObject read GetSource write SetSource;
    property KeyField: String read GetKeyField write SetKeyField;
    function Execute(Param: Variant): Boolean;
  end;
  //多语言处理组件
  IMutiLanguage = interface(IHRObject)
    ['{F4C167A9-5CF8-4E9A-AA76-945328E58FAF}']
    function GetDataLangID: Integer;     //数据语言, 从数据库中取出的数据
    function GetWindowLangID: Integer;   //窗口语言, 要展示给用户的语言
    function GetProgramLangID: Integer;  //源码语言
    procedure SetDataLangID(Value: Integer);
    procedure SetWindowLangID(Value: Integer);
    function AsObject(Sender: TObject): Boolean;
    function AsString(const Value: String): String;
    function AsData(const Key, DefValue: String): String;
    //
    property ProgramLangID: Integer read GetProgramLangID;
    property DataLangID: Integer read GetDataLangID write SetDataLangID;
    property WindowLangID: Integer read GetWindowLangID write SetWindowLangID;
  end;
  //插件接口
  IPlugins = interface
    ['{B4BE8B5E-DEBB-4555-A857-3D7EFEFD6571}']
    procedure Init(Root: IXmlNode);
    function CheckEnvironment: Boolean;
    procedure Install(Sender: TObject);
  end;
  IOutputMessage = interface
    ['{D6E5CC4B-A301-432B-986D-15BCA9484891}']
    procedure OutputMessage(const Value: String);
  end;
  TMsgLevelOption = (MSG_HINT, MSG_WARING, MSG_ERROR, MSG_DEBUG);
  IOutputMessage2 = interface
    ['{A1330F86-D61B-423D-ADE3-AB31DA33F8A9}']
    procedure OutputMessage(Sender: TObject; const Value: String;
      MsgLevel: TMsgLevelOption);
  end;
  //注册类
  IClassRegister = interface
    ['{06C423E1-8F86-4FE5-94AD-79821F6E43AF}']
    procedure RegClass(const AClass: TComponentClass);
    procedure UnRegClass(const AClass: TComponentClass);
    function FindRegClass(const AClassName: string): TComponentClass;
    function GetClassItem(const AClassName: String): PHRClassItem;
    function CreateClass(const AClassName: string; AOwner: TComponent): TComponent;
    //
    procedure RegClassFile(const AClassFile: String; ASystemFile: Boolean);
    procedure LoadClassFile(const AClassFile: String);
    function GetClassFile(const AClassName: String): String;
    procedure ReleaseFile(const strFile: String);
    procedure SaveToConfig(const bplFile: String);
    //
    function GetExtName: String;
    procedure SetExtName(const Value: string);
    function GetClassNames: TStringList;
    function GetClassFiles: TStringList;
    property ExtName: string read GetExtName write SetExtName;
    property ClassFiles: TStringList read GetClassFiles;
    property ClassNames: TStringList read GetClassNames;
  end;
  //
  IUpdateDBName = interface
    ['{86AC0CE3-9D76-46B3-B19F-B88D9E6DD6A5}']
    procedure SetDBName(const Value: String);
    function GetDBName: String;
  end;
  //缓存对象
  IDataBuffer = interface
    ['{94800031-425F-4480-989C-3F114202B0F2}']
    function Init(Item: IXmlNode; const SQLCmd: String;
      const Args: array of String): Boolean;
    function Read(const KeyValue: String; const Args: array of String): Variant;
    procedure Ready;
    procedure Clear;
    //
    function GetProperty(const PropName: String): Variant;
    procedure SetProperty(const PropName: String; PropValue: Variant);
    procedure SetTitles(Args: array of Variant);
    procedure SetGridTitle(DBGrid: TDBGrid);
    function GetDataSet: TDataSet;
    function GetSelf: TComponent;
  end;
  //插件管理器
  IHRPlugins = interface
    ['{52717EDD-50DA-4059-BBCE-C5D27C070DD8}']
    procedure EnrollPlugins(Sender: TComponent);
    procedure RemovePlugins(Sender: TComponent);
  end;
  //插件搜索功能
  IZLSearchService = interface
  	['{DBAD456B-98EE-440B-99C1-FD16FD62D348}']
    procedure SearchService(Sender: TComponent; SQLWhere: TObject);
  end;
  //财务分类帐抛转
  ILGCAmount = interface
    ['{6C3EAFA2-4A3A-41E0-9B87-D0D311A2600F}']
    procedure Execute(const OID, OTBNo, ObjCode, MoneyCode: String);
  end;
  ILGLedger = interface
    ['{01F9F9C2-B898-4003-BD1D-3C8A68B42CFE}']
    function getNeedCAmount(const OID, CType: String): Double;
    function writeCAmount(const OID, CType: String; CAmount: Double): Boolean;
    procedure refreshCDetail;
  end;
  //考勤机设备接口
  IAttMachine = interface
    ['{B8C64FDF-E05A-42E7-878E-471815128515}']
    //设备联接
    function OpenConnection(cdsMachine: TDataSet): Boolean;
    procedure CloseConnection;
    //同步时间
    function ModifyDateTime: Boolean;
    //清空设备
    function DeleteAllUser: Boolean;
    //从考勤机中删除一个卡号
    function DeleteOneUser(PersonCode: String; AddrNo: Integer): Boolean;
    //发卡作业
    function StartUpdate: Boolean;
    function AddUser(const PersonCode, PersonName, CardNo: String): Boolean;
    function SaveUpdate: Boolean;
    //检验作业
    function BeginVerify: Boolean;
    function VerifyUser(var PersonCode, PersonName, CardNo: String): Boolean;
    function VerifyOneUser(PersonCode: string; Var PersonName, CardNo: String): Boolean; //Added By Sonny
    procedure EndVerify;
    //读取考勤数据
    function GetDataFile(const DataFile: String): Boolean;
    //选择性删除考勤机数据
    procedure SetFlag(Flag: Boolean);
  end;
  //用于人资系统自定义函数
  IPersonInfo = interface
    ['{F3C97EA7-E57C-4CBF-8598-C11394458013}']
    function getDataSet: TDataSet;
    function getPersonCode: String;
    function getWorkMonth: String;
  end;
  IBuildFunction = interface
    ['{38ECCCF6-81DB-4324-9F36-75F469255F31}']
    function getFunctionText: String;
    procedure Init(const FuncName: String);
  end;
  //取得报价单价
  IHRGetPrice = interface
    ['{1DD72F30-FB3E-4B3B-9883-2AE64D7FBCD4}']
    function GetOriPrice: Boolean;
    //
    procedure SetCorpCode(const Value: String);
    procedure SetPartCode(const Value: String);
    procedure SetPriceDate(const Value: TDate);
    procedure SetPriceNum(const Value: Double);
    procedure SetPriceType(const Value: Integer);
    procedure SetPropertys(const AName: String; const Value: Variant);
    //
    function GetCorpCode: String;
    function GetPartCode: String;
    function GetPriceDate: TDate;
    function GetPriceNum: Double;
    function GetPriceType: Integer;
    function GetPropertys(const AName: String): Variant;
    //
    property CorpCode: String read GetCorpCode write SetCorpCode;
    property PartCode: String read GetPartCode write SetPartCode;
    property PriceDate: TDate read GetPriceDate write SetPriceDate;
    property PriceNum: Double read GetPriceNum write SetPriceNum;
    property PriceType: Integer read GetPriceType write SetPriceType;
    property Propertys[const AName: String]: Variant read GetPropertys write SetPropertys;
  end;
  //常用于主窗体显示前的选择对话框
  IHRShowReady = interface
    ['{7CA5C952-6EB1-4DC2-A137-ADCC2AB7476C}']
    function ShowReady: Boolean;
  end;
  IHRCheckMenuCode = interface
    ['{4665BA80-BAE3-4499-B8E6-841748FCE625}']
    function CheckMenuCode(Sender: TObject; var MenuCode: String): Boolean;
  end;
  IAppBean = interface
    ['{50C5BD56-70EA-4819-B355-EA8E27BF869E}']
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean;
    procedure SetSessionObject(Value: TObject);
  end;
  //窗体皮肤插件
  IPluginsSkin = interface
    ['{30732535-0AD4-4230-A2C3-8F4A81035588}']
    procedure UpdateFace(Sender: TComponent);
  end;
  //注册和取消注册类
  procedure RegClass(const AClass: TComponentClass);
  procedure UnRegClass(const AClass: TComponentClass);
  function CreateClass(const ClassName: string; AOwner: TComponent = nil): TComponent;
  function CreateClassEx(const ClassName: string; AOwner: TComponent = nil): TComponent;
  (*------------------------------------------------------------------------------
  函数名称:CreateChildForm
  函数功能:在ERP系统中根据类名查找子窗口实例,找到后返回窗口实例指针,否者创建该窗口
  参数说明:
    ClassName:类名称
    AOwner:类实例的所有者
  返回值:查找或创建成功则返回窗口实例指针,否则返回nil
  备注:
  作者:                 版本:              时间:
  function CreateChildForm(const ClassName: string; AOwner: TComponent = nil): TComponent;
  //显示窗体
  函数名称:ShowFormEx
  函数功能:根据类名显示ERP系统中的窗口,并返回结果
  参数说明:
    ClassName:类名称
    Param:传入和传出参数
    ModalType:模态类型,取值如下,默认为0
      CONST_FORM_SHOW = 0;
      CONST_FORM_SHOWMODAL = 1;
      CONST_FORM_SHOWCHILD = 2;
    AOwner:所有者
  返回值:返回ModalResult值
  备注:
    调用者例子:
    var
      vTemp: Variant;
    begin
      vTemp := VarArrayOf(['Code_', 'Name_', 'Desc_']);
      ShowFormEx('TSelPart', vTemp);
    end;
    处理者例子:
    procedure btnOKClick(Sender: TObject);
    var
      vTemp: Variant;
      sCode, sName, sDesc: string;
    begin
      Result := mrOK;
      if VarIsArrayOf(InputParam) then
      begin
        sCode := InputParam[0];
        sName := InputParam[1];
        sDesc := InputParam[2];
      end;
      vTemp := VarArrayOf([cdsPart.FieldByName(sCode).AsString,
        cdsPart.FieldByName(sName).AsString,
        cdsPart.FieldByName(sDesc).AsString]);
      OutputParam := vTemp;
      Close;
    end;
  function ShowFormEx(const ClassName: string; var Param: Variant; ModalType: Integer = 0; AOwner: TComponent = nil): Variant; overload;
  函数名称:ShowFormEx
  函数功能:根据类名显示ERP系统中的窗口,并返回结果
  参数说明:
    ClassName:类名称
    ModalType:模态类型,取值如下,默认为0
      CONST_FORM_SHOW = 0;
      CONST_FORM_SHOWMODAL = 1;
      CONST_FORM_SHOWCHILD = 2;
  返回值:返回ModalResult值
  备注:
    使用方法参考上面
  function ShowFormEx(const ClassName: string; ModalType: Integer = 0): Variant; Overload;
  ------------------------------------------------------------------------------*)
const
  //消息
  CONST_MSG              = 0;
  CONST_DATA             = 1;
  CONST_GETVALUE         = 2;
  CONST_DEFAULT          = 3;
  CONST_BUFFERS_GETSELF  = 4;
  CONST_BUFFERS_CLEARALL = 5;
  CONST_BUFFERS_ADDITEM  = 6;
  CONST_WORKFLOW         = 88;
  CONST_GOTORECORD       = 99;
  CONST_ADMESSAGE        = 100;
  CONST_CREATEPARAM      = 101;
  CONST_SECMESSAGE       = 104; //用于TZjhTool给主窗体发送消息
  CONST_BARCODE          = 201; //用于条码数据
  CONST_VALUE            = 202;
  CONST_SECURITY         = 300;

var
  PKGManger: IClassRegister;
  TEMP_VARIANT: Variant;
  DM: IMainData;

  function MainIntf: IMainForm;
  function Chinese: IMutiLanguage;

implementation

{$IFDEF VINE}
uses NullLanguage, ZLClassManagement;
{$ELSE}
uses NullLanguage;
{$ENDIF}

var
  pub_MainForm: IMainForm;
  pub_Chinese: IMutiLanguage;

procedure RegClass(const AClass: TComponentClass);
begin
  {$IFDEF VINE}
  if not Assigned(PKGManger) then
    PKGManger := TZLClassManagement.Create(Application);
  {$ENDIF}
  if Assigned(PKGManger) then
    PKGManger.RegClass(AClass);
end;

procedure UnRegClass(const AClass: TComponentClass);
begin
  if Assigned(PKGManger) then
    PKGManger.UnRegClass(AClass)
end;

function CreateClass(const ClassName: string; AOwner: TComponent = nil): TComponent;
begin
  if Assigned(PKGManger) then
    Result := PKGManger.CreateClass(ClassName, AOwner)
  else
    Result := nil;
end;

function CreateClassEx(const ClassName: string; AOwner: TComponent = nil): TComponent;
var
  i: Integer;
  FormChild: TForm;
begin
  Result := nil;
  for i := 0 to Screen.FormCount - 1 do
  begin
    FormChild := Screen.Forms[i];
    if FormChild.ClassNameIs(ClassName) then
    begin
      Result := FormChild;
      Break;
    end;
  end;
  if not Assigned(Result) then
    Result := PKGManger.CreateClass(ClassName, AOwner);
end;

{
function CreateChildForm(const ClassName: string; AOwner: TComponent = nil): TComponent;
var
  i: Integer;
  FormChild: TForm;
begin
  Result := nil;
  for i := 0 to Screen.FormCount - 1 do
  begin
    FormChild := Screen.Forms[i];
    if FormChild.ClassNameIs(ClassName) and (FormChild.FormStyle <> fsNormal) then
    begin
      Result := FormChild;
      Break;
    end;
  end;
  if not Assigned(Result) then
    Result := CreateClass(ClassName, AOwner);
end;

function _ShowFormEx(const ClassName: string; var Param: Variant;
  ModalType: Integer; AOwner: TComponent): Variant;
var
  AClass: TComponent;
begin
  Result := Null;
  AClass := CreateClass(ClassName, AOwner);
  if Assigned(AClass) then
  begin
    if Supports(AClass, IBaseForm) then
      Result := (AClass as IBaseForm).ShowForm(ModalType, Param)
    else if AClass is TForm then
      TForm(AClass).Show;
  end;
end;

function ShowFormEx(const ClassName: string; var Param: Variant;
  ModalType: Integer = 0; AOwner: TComponent = nil): Variant; overload;
begin
  Result := _ShowFormEx(ClassName, Param, ModalType, AOwner);
end;

function ShowFormEx(const ClassName: string; ModalType: Integer = 0): Variant; Overload;
begin
  Result := _ShowFormEx(ClassName, TEMP_VARIANT, ModalType, nil);
end;
}

function MainIntf: IMainForm;
begin
  Result := nil;
  if not Assigned(pub_MainForm) then
  begin
    if Assigned(Application.MainForm) then
      if Supports(Application.MainForm, IMainForm) then
        pub_MainForm := Application.MainForm as IMainForm;
  end;
  Result := pub_MainForm;
end;

function Chinese: IMutiLanguage;
var
  strFile: String;
begin
  if not Assigned(pub_Chinese) then
  begin
    strFile := ExtractFilePath(Application.ExeName) + 'MutiLang.mdb';
    if FileExists(strFile) then
      pub_Chinese := CreateClass('TMutiLanguage', nil) as IMutiLanguage;
    if not Assigned(pub_Chinese) then
      pub_Chinese := TNullLanguage.Create(nil) as IMutiLanguage;
  end;
  Result := pub_Chinese;
end;

initialization
  PKGManger := nil;
  pub_Chinese := nil;
  DM := nil;

end.
