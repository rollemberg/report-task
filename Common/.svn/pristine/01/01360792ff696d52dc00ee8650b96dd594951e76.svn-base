unit ApConst;

interface

uses
  Windows, Messages, SysUtils, Classes, nb30, SConnect, Variants, IniFiles, Forms,
  StdCtrls, ComCtrls, Controls, IdHashMessageDigest;

  function sreg: TIniFile;
  function ureg: TIniFile;

type
  TIntroInfo = Record
    FormName: String;
    Code, Param: String;
    Final: Boolean;
  end;
  TMenuRecord = record
    iType: Integer;
    sID, sClass, sName, sForm, sRemark: String;
  end;
  
  TAccountCard = record
    LoginID: String;
    UserID, Account, UserName: String;
    CorpCode, Computer: String;
    LoginTime: TDateTime;
  end;
  
  //异动单别记录
  TTBRecord = record
    ID: String;
    Name: String;    //自定义单别
    SysTB: String;   //系统单别
    //Code: String;    //TB ID
    Table: String;   //SourceTable Name
    //Caption: String; //
    History: Boolean;
    MinDate, MaxDate: TDate;
    Currency: String;
    Mode: String;    //Y M D or ' '
    AutoNo: Boolean;
    Sys: Integer;
    InitNo: Boolean;
  end;

  TSystemVersion = (svWindow95, svWindow98, svWindow2000, svWinNT4,
    svWindowXP, svUnknown);

  TShortcutFile = Record
    ExecFile: String;
    ExecParam: String;
    WorkingPath: String;
    Description: String;
  end;

  THRClassItem = Record
    ClassObject: TComponentClass;
    FileName: String;
    Comment: String;
  end;
  PHRClassItem = ^THRClassITem;
  THRPackageItem = Record
    FileName: String;
    Readme: String;    //TComponentClass;
    Manager: String;   //TComponentClass;
    System: Boolean;
    Handle: THandle;
    RefCount: Integer; //引用计数
  end;
  PHRPackageItem = ^THRPackageItem;

  AllowCharOption = (acNumeric,acASCII);
  TViewFileOption = (vfPrint, vfSaveAs);
  TViewFileOptions = set of TViewFileOption;

  function GetMachNo(Buffer: PChar): Integer;
  function IsIPAddress(const Value: String): Boolean;
  function NBGetAdapterAddress: String;
  function NBGetVolumnNo: string;
  //对称加密函数
  function Encrypt(Value: String; const PSW: String; Flag: Boolean): String; overload
  procedure Encrypt(Value: PChar; Size: Integer; const PSW: String); overload;
  //启动DCOM公用函数
  //procedure OpenConnection(DCOM: TSocketConnection; const Address, KeyCard,
  //  Account, Password: String);
  //取得当前计算机名称
  function ComputerName: String;
  // 返回一个新的Guid
  function NewGuid(): String;
  function iif(const bFlag: Boolean; const Str1,Str2: String): String; overload;
  function iif(const bFlag: Boolean; val1,val2: Integer): Integer; overload;
  function iif(const bFlag: Boolean; val1,val2: Double): Double; overload;
  // 格式化提示信息
  procedure MsgBox(const AValue: String; const ACaption: String = 'Message'); overload;
  procedure MsgBox(AValue: Integer; const ACaption: String = 'Message'); overload;
  procedure MsgBox(const AFmt: String; const Args: array of const); overload;
  // 将一个Guid类型的字符串去掉{}及-符号
  function GuidFixStr(const Value: String): String;
  function IsNull(Value, Default: Variant): Variant;
  //取得系统目录
  function GetWinSys: String;
  //计算md5值
  function md5(S: String): String;
  //
  function GetDiskInfo(DriveChar: Char; const Flag: Integer): string;
  //载入、保存控件选项值  Author: Jason 2003.12.11
  procedure LoadOptions(Sender: TForm); overload;
  procedure SaveOptions(Sender: TForm); overload;
  procedure LoadOptions(const Section: String; const Args: array of TComponent); overload;
  procedure SaveOptions(const Section: String; const Args: array of TComponent); overload;
  //软件运行根目录
  function SystemRootPath: String;
  //清除特殊字母，防止SQL注入攻击
  function SafeString(const Value: String): String;

const
  SECURITY_PASSWORD = 'WinErp';
  //SECURITY_PASSWORD = 'CERCErp';
  SOFTWARE_NAME = 'MIMRC';
  CONFIG_FILE = 'CERCERP.INI';

  MAX_DOCPACKAGE = 10240; //10K 每数据包

  RET_OK : Integer = 0;
  RET_ERROR : Integer = -9999;
  RET_OTHERERROR : smallint = -1;
  RET_READONLY : smallint = -2;
  vbCrLf: String = #13 + #10;
  Max_Viability: smallint = 120;  //最大生命值，120秒
  NO_LOGON: smallint = -1;       //没有登录
  GUIDNULL: String       = '{00000000-0000-0000-0000-000000000000}';
  BOM_PACKAGE: String    = '{1DCAC19C-9D70-42A0-B56F-465DA13AAC05}';
  BOM_APS_ID: String     = '{7BCDC431-B33C-4EBF-892C-0166F9030E58}';

  ERPCTL_GUID: String    = '{51299635-2790-40B2-B70B-A0CA48B91DBC}';
  AR_GUID: String        = '{B1CB7984-3A92-4AF5-A87E-187EEF98C36F}';
  AP_GUID: String        = '{428F7B97-DA65-49E0-A3FE-B21630D6B5CF}';
  ADMIN_GUID: String     = '{B85954D9-C80E-4F00-8FD7-F94300AABEF0}';
  DEPUTE_GUID: String    = '{A4391D5F-144E-4270-8FC5-C6E343D5143F}';
  MACHNO_GUID: String    = '{DAB8ECD7-69D8-4161-A364-CA71A387C154}';
  ERPFAQ_GUID: String    = '{28703D8A-7835-4A90-A5F3-91DEF6246C5D}';
  SYS_NEWFLOW_RUN_GUID: String = '{9D07B139-6675-4ADD-BED1-8E7CF3BA9AF5}';
  BOM_RD_GUID: String    = '{DC2A4438-9AFD-478D-988B-8AEF36974A2D}';
  SUPERUSER_GUID: String = '{2C7E183E-F040-4369-B921-6BEBFAD6D78C}';

  //内部子系统固定代码
  SYS_ADMIN_GUID: String  = '{B85954D9-C80E-4F00-8FD7-F94300AABEF0}';
  SYS_PERSON_GUID: String = '{5B8B5550-BCB6-4457-9E51-721C0BA0D845}';

  //内部权限组别代码
  GROUP_SALES_GUID: String = '{517E247F-7DD2-4996-9FC5-CEAA14FBC029}';
  GROUP_PUR_GUID: String   = '{AA98C163-C451-44DD-99D4-1CB3801C661B}';
  GROUP_STOCK_GUID: String = '{9AB0B1F8-AD91-439B-AD2E-12CAFBA42648}';
  GROUP_QC_GUID: String    = '{E8324985-05E2-4C87-B9A2-535D190AB656}';
  GROUP_PMC_GUID: String   = '{ED602EFC-0D7B-4A5C-8A71-6741D829D796}';
  GROUP_SGB_GUID: String   = '{26179CEE-5584-4A65-BB59-50075F80410B}';

  //固定功能代码
  FUNC_SYSRIGHT_GUID = '{AD094DD8-BE81-49AA-93B2-DBBD4054F4AF}';

  DOWNLOAD_UPDATE: String = '{91FFE14C-1A4A-4122-87F4-04F9ED847A1D}';
  DOWNLOAD_SETUP: String  = '{769D630E-6045-4F46-8356-9D1C70EA046B}';
  DOWNLOAD_README: String = '{D4F78F10-9EF4-4397-8116-0155AAC1AFF3}';
  DOWNLOAD_REPORT: String = '{37980A6D-9C47-45FD-9C73-5F0FAEB35A5C}';

  ERROR_OWNERDATA_FORMAT = -12;
  RET_PARAM_ERROR = -13;
  RET_NOPASS = -14;
  
  //每次最大记录数
  CDS_MAXRECORDS: Integer = 1000;

  // use to TCERCERP.EXEC
  APS_CHANGETBSTATUS = 1;
  APS_CONFIRM = 2;
  //APS_GETUSERINFO = 7;
  //APS_LOGOUT = 9;
  //APS_LOGIN = 11;

  // 任务标识
  TASK_MRP = 1;             //运行MRP
  TASK_MadeAttendCard = 2;  //生成考勤"电子工卡"
  TASK_CountABNORMITY = 3;  //统计考勤异动
  TASK_COUNTRECARDBTABLE = 4; //统计考勤数
  TASK_CALCULATESALARY = 5;   //计算一个月的薪资
  TASK_TRAN_QA = 6;
  TASK_TRAN_QB = 7;

  COLOR_BOX_TITLE = 14606560; //clMoneyGreen; //表单面板颜色

  // 系统日志类别
  SH_SECURITY = 1;
  SH_SYSTASK_INFO = 2;
  SH_SYSTASK_ERROR = 3;
  SH_SysMsg_NoSend = 1001; //'未发出消息';
  SH_PhoneMsg_NoSend = 1002; //'未发出短讯';
  SH_SysMsg_Send = 1003; //'已发出消息';
  SH_ERROR = 999;
  
  //==================
  //Work Flow 单别标识
  //-----------------
  wfNone        =   0;
  {
  wfTran        =   1;
  wfOrd         =   2;
  wfPur         =   3;
  wfMake        =   4;
  wfMakeList    =   5;
  wfCheckStock  =   6;
  wfTranEA      =   7;
  wfECN         =   8;
  wfRequest     =   9;
  wfQuestion    =  10;
  wfQuotaion    =  11;
  wfAccAB       =  12;
  wfSalesDetail =  13;
  wfOrdW        =  14;
  wfSysInform   =  15;
  wfMrpReq      =  16;
  wfMakeMJ      =  17;
  wfTradeQuoPI  =  18;
  wfTradeShip   =  19;
  wfNewBOM      =  20;
  wfCRFile      =  21;
  //==================
  wfTranReq     =  50;
  wfTranReqJA   =  80;
  wfTranReqJB   =  81;
  //==================
  wfTranReqJO   =  85;
  wfTranReqJP   =  88;
  wfTickit      =  91;
  //==================
  // 异动单 A 类
  //-----------------
  wfTranAA      = 100;
  wfTranAB      = 101;
  wfTranAC      = 102;
  wfTranAD      = 103;
  wfTranAE      = 104;
  wfTranAF      = 105;
  wfTranAG      = 106;
  wfTranAH      = 107;
  wfTranAI      = 108; //委外领料退回单
  wfTranAJ      = 109;
  //-----------------
  wfTranAK      = 110;
  wfTranAL      = 111;
  wfTranAM      = 112;
  wfTranAN      = 113;
  wfTranAQ      = 114;
  wfTranAR      = 115;
  //==================
  // 异动单 B 类
  //-----------------
  wfTranBA      = 200;
  wfTranBB      = 201;
  wfTranBC      = 202;
  wfTranBD      = 203;
  wfTranBE      = 204;
  wfTranBF      = 205;
  wfTranBG      = 206; //委外加工领料单
  wfTranBH      = 207;
  wfTranBI      = 208;
  wfTranBJ      = 209;
  wfTranBP      = 210;
  wfTranBR      = 211;
  wfTranBQ      = 212;
  wfTranAP      = 213;
  //==================
  // 异动单 B 类
  //-----------------
  wfTranCC      = 250;
  wfTranCD      = 251;
  //==================
  // 人事考勤薪资类
  //-----------------
  wfAssign      = 301;
  wfEngage      = 302;
  wfEdu         = 303;

  // 绩效管理系统类
  wfWorkReport  = 401;
  wfCSRegister  = 402;

  //固定资产
  wfPASysAA     = 700;
  wfPASysAB     = 701;
  wfPASysAC     = 702;
  wfTranAP_EC   = 703;

  // 文档管理系统
  wfFileFlow  = 501;
  //wfFileFlowBA  = 551;

  wfEmail       = 600;
  //总务
  wfGARequest   = 800;
  wfGAPurReq    = 801;
  wfGAPur       = 802;
  wfGATranAB    = 803;
  wfGATranAE    = 804;
  wfGATranAF    = 805;
  wfGATranAH    = 806;
  wfGATranAZ    = 807;
  wfGATranBA    = 808;
  wfGATranBG    = 809;
  wfGATranBR    = 810;
  wfGATranCG    = 811;
  wfHGPact      = 820;
  wfXTran       = 901;
  wfARTran      = 902;
  wfAPTran      = 903;
  }
  // 菜单库菜单之类别号
  MENU_TYPE_HIDDEN  : smallint = 0;
  MENU_TYPE_STANDARD: smallint = 1;
  MENU_TYPE_SEARCH  : smallint = 2;
  MENU_TYPE_SETUP   : smallint = 3;
  MENU_TYPE_TOOLS   : smallint = 4;

  // 异动单据分类号
  TRAN_SYS_TRAN     : smallint = 1;
  TRANT_SYS_ORDW    : smallint = 2;
  TRANT_SYS_PEASON  : smallint = 3;
  TRANT_SYS_ACC     : smallint = 4;

  //文档操作日志类型
  ohBrowser  : smallint =  0; //查看
  ohAppend   : smallint =  1; //新增
  ohDelete   : smallint =  2; //删除
  ohPrint    : smallint =  3; //列印
  ohBorrow   : smallint =  4; //借出
  ohRename   : smallint =  5; //改名
  ohDownLoad : smallint =  6; //下载
  ohOverload : smallint =  7; //覆盖
  ohMove     : smallint =  8; //移动
  ohClear    : smallint =  9; //清除
  ohUpdate   : smallint = 10; //归还
  ohCopy     : smallint = 11; //复制
  ohRecover  : smallint = 12; //还原
  ohEncrypt  : smallint = 13; //
  ohUnencrypt: smallint = 14; //


  //其它代码档类别编码
  //SYSLIST_01      : String = 'SYSLIST.1';  //采购人员
  SYSLIST_Sells   : String = 'SYSLIST.2';  //业务人员
  SYSLIST_Area    : String = 'SYSLIST.3';  //区域代码
  SYSLIST_04      : String = 'SYSLIST.4';  //省份名称
  SYSLIST_05      : String = 'SYSLIST.5';  //宗教
  SYSLIST_06      : String = 'SYSLIST.6';  //民族
  SYSLIST_07      : String = 'SYSLIST.7';  //学历
  SYSLIST_08      : String = 'SYSLIST.8';  //薪资级别
  SYSLIST_Country : String = 'SYSLIST.9';  //国别
  SYSLIST_10      : String = 'SYSLIST.10'; //资产大类代码
  SYSLIST_Bank    : String = 'SYSLIST.11'; //银行代码
  SYSLIST_12      : String = 'SYSLIST.12'; //资产保管位置
  SYSLIST_13      : String = 'SYSLIST.13'; //会计常用摘要
  SYSLIST_14      : String = 'SYSLIST.14'; //应付款差异代码
  //SYSLIST_15      : String = 'SYSLIST.15'; //仓管人员
  //SYSLIST_16      : String = 'SYSLIST.16'; //物控人员
  SYSLIST_17      : String = 'SYSLIST.17'; //应收款差异代码
  SYSLIST_18      : String = 'SYSLIST.18'; //客户类别
  SYSLIST_SupType : String = 'SYSLIST.19'; //厂商类别
  SYSLIST_20      : String = 'SYSLIST.20'; //产品大类
  SYSLIST_21      : String = 'SYSLIST.21'; //语言类别
  SYSLIST_22      : String = 'SYSLIST.22'; //绩效项目
  SYSLIST_23      : String = 'SYSLIST.23'; //工厂部门
  SYSLIST_24      : String = 'SYSLIST.24'; //客户档(料号)
  SYSLIST_25      : String = 'SYSLIST.25'; //厂商档(料号)
  SYSLIST_26      : String = 'SYSLIST.26'; //共用件资料
  SYSLIST_27      : String = 'SYSLIST.27'; //附属件资料
  SYSLIST_28      : String = 'SYSLIST.28'; //不良原因代码
  //SYSLIST_29      : String = 'SYSLIST.29'; //品管人员
  SYSLIST_30      : String = 'SYSLIST.30'; //机台类别


  // 文档系统之特殊资料夹
  DIR_RECYCLED:         String = '{204CAC1F-9D06-4320-85C3-871D592BB162}';
  DIR_RECYCLED_HISTORY: String = '{64D5DA6A-8166-4D0E-9B91-9858EE12A22D}';
  DOC_PART_GUID:        String = '{5A985B89-2E4F-4E9E-B22C-2C76C8A41DC4}';
  DOC_CUS_GUID:         String = '{70C50524-7D07-40F7-A3E3-FA8A044F8C58}';
  DOC_PRIVATE_GUID:     String = '{3EBB2B15-DC00-4056-9304-90A3E8018550}';
  DOC_PRINT_GUID:       String = '{8D8BF3FE-DA38-435B-B2C8-2CF42F82C466}';
  DOC_ORDMARK_GUID:     String = '{B2BA711B-8A95-42B4-8CAC-B01914BB54C6}';
  DOC_TEMP_GUID:        String = '{278F506E-BFE5-4722-BE21-21575DDBE4EF}';

  //DOC 系统之个人资料夹
  DOC_PRIVATE_ROOT     : smallint = 1; //个人资料夹之根目录
  //
  DOC_PRIVATE_MailIn   : smallint = 9; //收件箱
  DOC_PRIVATE_ACCEPT   : smallint = 4; //待核文件夹
  DOC_PRIVATE_TEMP     : smallint = 2; //垃圾邮件
  DOC_PRIVATE_SEND     : smallint = 5; //草稿
  DOC_PRIVATE_MailOut  : smallint = 8; //已发送邮件
  DOC_PRIVATE_COFFER   : smallint = 6; //已删除邮件
  
  DOC_PRIVATE_DOWN     : smallint = 3; //已核文件夹
  DOC_PRIVATE_NG       : smallint = 7; //未准资料夹

  FILE_CLASS_REMARK    =  1; // 来源于备注档
  FILE_CLASS_NORAMAL   =  0; // 一般文件
  FILE_CLASS_PACKAGE   = -1; // 来源于文件包、邮件
  FILE_CLASS_LINK_IN   = -2; // 内键类型
  FILE_CLASS_LINK_OUT  = -3; // 外键类型

  //FileImage档Source状态
  SOURCE_KMMAGIC       = 1; //文档数据
  SOURCE_WORKFLOW      = 2; //WorkFlow数据
  SOURCE_MAILFLOW      = 3; //MailFlow数据
  SOURCE_UPDATEFILE    = 4; //系统程式数据
  SOURCE_JOB           = 5; //来源人事系统

  //MAILFLOW邮件状态

  MAIL_INBOX           =  1; //收件匣
  MAIL_WAITSEND        =  2; //寄件匣
  MAIL_OUTBOX          =  3; //寄件备份
  MAIL_DRAFT           =  0; //草稿
  MAIL_DELETE          = -1; //删除的邮件

  MAIL_INBOX_FLOW      =  4; //收件匣(待签)
  MAIL_OUTBOX_FLOW     =  5; //寄件匣(待签)

  //DirCoffer 档 Type 取值
  DIRCOFFER_USERDEF    = 999;

  //系统参数值
  NREG_01_0001        = '01-0001.mrp.订单计价方式';
  NREG_01_0002        = '01-0002.mrp.制令单上线日期检测';
  NREG_01_0003        = '01-0003.mrp.群组类别码';
  NREG_01_0004        = '01-0004.mrp.生产日报表异常项目';
  NREG_01_0005        = '01-0005.mrp.厂商付款方式';
  NREG_01_0006        = '01-0006.mrp.启动制造参数管理';
  NREG_01_0007        = '01-0007.mrp.启动包装号作业模式';

  NREG_CRCP0002       = 'CRCP0002.CRCP.应付帐款工作年月';
  NREG_CRCP0014       = 'CRCP0014.CRCP.应付帐款关帐状态';
  NREG_CRCP0019       = 'CRCP0019.CRCP.银行发票作业年月';
  NREG_CRCP0020       = 'CRCP0020.CRCP.采购付款方式';
  NREG_CRCP0021       = 'CRCP0021.CRCP.采购收料超交付款否';

  PDM_001             = 'PDM-001.pdm.产品附档类别';
  NREG_SY_0001        = 'SY_0001.system.系统参数类别名称';
  NREG_SY_0002        = 'SY_0002.system.可选公司帐别';
  NREG_SY_0003        = 'SY_0003.system.集团版多帐别状态';
  NREG_SY_0004        = 'SY_0004.system.发票类型';
  NREG_SY_0005        = 'SY_0005.system.启动库别权限管理';
  NREG_CRM_TYPE       = 'CM_0001.crm.客户联络方式';
  NREG_CRM_LEVEL      = 'CM_0002.crm.客户联络质量';
  {$message '此系统参数NREG_AT_0001予以作废，Jason at 2009/3/12'}
  NREG_AT_0001        = 'AT_0001.Attend.考勤卡用途分类';

  drCurWeek           = 3;
  drCurMonth          = 5;
  drCurYear           = 7;

  //TZjhTool事件码
  seExcelEdit         = -101;
  seDelete            = -102;
  PDM_DEFAULTTYPE     = '产品图片';

  ctAppend            = 1; //增加
  ctDelete            = 2; //删除
  ctModify            = 3; //修改

  //窗体显示方式
  CONST_FORM_SHOW = 0;
  CONST_FORM_SHOWMODAL = 1;
  CONST_FORM_SHOWCHILD = 2;

  //主窗体
  CONST_MAINFORM = 100000;
  CONST_MAINFORM_SETMAX          = CONST_MAINFORM +  1; //设置Statusbar宽度
  CONST_MAINFORM_SETPOSITION     = CONST_MAINFORM +  2; //设置Statusbar位置
  //CONST_MAINFORM_ADDPROTECT    = CONST_MAINFORM +  3; //添加AddProtect
  //CONST_MAINFORM_ADDDYNMENU    = CONST_MAINFORM +  4; //添加动态菜单
  //CONST_MAINFORM_APPENDNODE    = CONST_MAINFORM +  5; //添加动态节点
  //CONST_MAINFORM_APPENDMENU    = CONST_MAINFORM +  5; //添加菜单
  //CONST_MAINFORM_NAVIGATE      = CONST_MAINFORM +  6; //导航到某个地址
  //CONST_MAINFORM_ONREPORTOUTPUT  = CONST_MAINFORM +  7; //取得默认的报表事件
  //CONST_MAINFORM_RESIZE        = CONST_MAINFORM +  8; //改变窗体为最大化
  //CONST_MAINFORM_TOOLMAP       = CONST_MAINFORM +  9; //窗体按钮操作
  //CONST_MAINFORM_NEWFORM         = CONST_MAINFORM + 10;//创建主窗体
  //CONST_MAINFORM_GETHELPURL      = CONST_MAINFORM + 11;//取得帮助地址GetHelpURL
  //CONST_MAINFORM_CALLPROGRAM     = CONST_MAINFORM + 12;//调用相关模块CallProgram
  //CONST_MAINFORM_MOVEPROGRESSBAR = CONST_MAINFORM + 13;//调整进度条MoveProgressBar
  //CONST_MAINFORM_SHOWFORM        = CONST_MAINFORM + 14;//创建主窗体
  //CONST_MAINFORM_STATUSMESSAGE   = CONST_MAINFORM + 15;//
  //CONST_MAINFORM_GETBITMAP       = CONST_MAINFORM + 16;//
  //CONST_MAINFORM_MESSAGE         = CONST_MAINFORM + 17;//
  //CONST_MAINFORM_EXCELUPDATE     = CONST_MAINFORM + 18;//
  CONST_MAINFORM_SetQuickToolID  = CONST_MAINFORM + 19;//
  CONST_MAINFORM_SETIMAGERES     = CONST_MAINFORM + 20;
  //CONST_MAINFORM_LOADCLASS       = CONST_MAINFORM + 21;
  {
  CONST_MAINFORM_DoOnNewRecord   = CONST_MAINFORM + 22; //用于TZjhDataSet设置UpdateKey等;
  CONST_MAINFORM_DoOnBeforePost  = CONST_MAINFORM + 23;  //用于TZjhDataSet设置初始值;
  CONST_MAINFORM_DoOnBeforeGetRecords = CONST_MAINFORM + 24;  //用于TZjhDataSet设置初始值;
  CONST_MAININTF_COMMAND         = CONST_MAINFORM + 25;
  }
  CONST_BUFFER_CREATE            = CONST_MAINFORM + 26;
  CONST_BUFFER_DESTORY           = CONST_MAINFORM + 27;
  CONST_MAINFORM_ADDRESS         = CONST_MAINFORM + 28;
  CONST_MAINFORM_HTMLTEXT        = CONST_MAINFORM + 29;
  CONST_MAINFORM_BODYTEXT        = CONST_MAINFORM + 30;
  CONST_MAINFORM_CHANGECORP      = CONST_MAINFORM + 31;
  CONST_MAINFORM_CLOSEFORM       = CONST_MAINFORM + 32;

  //插件
  CONST_PLUGINS = 400;
  //CONST_PLUGINS_INIT             = CONST_PLUGINS;
  CONST_PLUGINS_CREATECORPMENU   = CONST_PLUGINS +  1;
  CONST_PLUGINS_CREATESYSTEMMENU = CONST_PLUGINS +  2;
  CONST_PLUGINS_UPDATETREEMENU   = CONST_PLUGINS +  3;
  CONST_PLUGINS_CHANGETREEMENU   = CONST_PLUGINS +  4;
  CONST_PLUGINS_NAVIGATE         = CONST_PLUGINS +  5;
  CONST_PLUGINS_BUTTONCLICK      = CONST_PLUGINS +  6;
  //CONST_PLUGINS_CHECKVERSION     = CONST_PLUGINS +  7;
  CONST_PLUGINS_LOADFAVORITE     = CONST_PLUGINS +  8;
  CONST_PLUGINS_ADDFAVORITE      = CONST_PLUGINS +  9;
  CONST_PLUGINS_SETFAVORITE      = CONST_PLUGINS + 10;
  CONST_PLUGINS_ALLREADY         = CONST_PLUGINS + 11;
  CONST_PLUGINS_SYSMENU_SHOW     = CONST_PLUGINS + 12;
  CONST_PLUGINS_SYSMENU_HIDE     = CONST_PLUGINS + 13;

  //TFrmHelp
  CONST_WEBHELP = 101100;
  CONST_WEBHELP_ADDRESS     = CONST_WEBHELP + 1;
  CONST_WEBHELP_HTMLTEXT    = CONST_WEBHELP + 2;
  CONST_WEBHELP_BODYTEXT    = CONST_WEBHELP + 3;
  CONST_WEBHELP_ACTION      = CONST_WEBHELP + 4;

  //TSelectDialog
  CONST_SELECTDIALOG = 102000;
  CONST_SELECTDIALOG_SELACCOUNT        = CONST_SELECTDIALOG + 1; //SelAccount函数
  CONST_SELECTDIALOG_OPENCOMMAND       = CONST_SELECTDIALOG + 2; //OpenCommand函数
  CONST_SELECTDIALOG_ADDTITLE          = CONST_SELECTDIALOG + 3; //AddTitle函数
  CONST_SELECTDIALOG_OPENBUFFER        = CONST_SELECTDIALOG + 4; //OpenBuffer函数
  CONST_SELECTDIALOG_EXECUTE           = CONST_SELECTDIALOG + 5; //Execute函数
  CONST_SELECTDIALOG_SETRESULTCOLUMNNO = CONST_SELECTDIALOG + 6; //SetResultColumnNo函数
  CONST_SELECTDIALOG_MULTISELECT       = CONST_SELECTDIALOG + 7; //MultiSelect函数

  //TFrmChoice
  CONST_FRMCHOICE = 112000;
  CONST_FRMCHOICE_ADDITEM = CONST_FRMCHOICE + 1; //AddItem函数
  CONST_FRMCHOICE_EXECUTE = CONST_FRMCHOICE + 2; //Execute函数
  //CONST_FRMCHOICE_ADDDATASET = CONST_FRMCHOICE + 3; //AddDataSet函数

  {

  //Icon List
  SAVE_ICON           = 1;
  CONST_FAVORITES        = 10000;

  CONST_FAVORITES_ADD    = CONST_FAVORITES + 1;
  CONST_FAVORITES_CLICK  = CONST_FAVORITES + 2;
  CONST_FAVORITES_LOAD   = CONST_FAVORITES + 3;

  //TSchPub
  CONST_SCHPUB = 101000;
  CONST_SCHPUB_GETFORM = CONST_SCHPUB + 1; //GetForm函数

  //TSelReport
  CONST_SELREPORT = 103000;
  CONST_SELREPORT_OUTPUT = CONST_SELREPORT + 1; //Output函数
  CONST_SELREPORT_PUTOFFICE = CONST_SELREPORT + 2; //PutOffice函数
  CONST_SELREPORT_EXECUTE = CONST_SELREPORT + 3; //Execute函数
  CONST_SELREPORT_EXCELUPDATE = CONST_SELREPORT + 4; //ExcelUpdate函数

  //TFrmFuncProperty
  CONST_FRMFUNCPROPERTY = 104000;
  CONST_FRMFUNCPROPERTY_SETMASTERKEY = CONST_FRMFUNCPROPERTY + 1; //SetMasterKey函数

  //TEdtTran
  CONST_EDITTRAN = 105000;
  CONST_EDITTRAN_GOTORECORD = CONST_EDITTRAN + 1; //GotoRecord函数

  //TFrmSelAccSub
  CONST_FRMSELACCSUB = 108000;
  CONST_FRMSELACCSUB_SETSHOWROOT = CONST_FRMSELACCSUB + 1; //SetShowRoot函数

  //TSchStockNum
  CONST_SCHSTOCKNUM = 110000;
  CONST_SCHSTOCKNUM_GOTORECORD = CONST_SCHSTOCKNUM + 1; //GotoRecord函数

  //TFrmBewrite
  CONST_FRMBEWRITE = 111000;
  CONST_FRMBEWRITE_SHOW = CONST_FRMBEWRITE + 1; //Show函数

  //TFrmShowMsg
  CONST_FRMSHOWMSG = 113000;
  CONST_FRMSHOWMSG_ADDMESSAGE = CONST_FRMSHOWMSG + 1; //AddMessage函数

  //TFrmSetAccess
  CONST_FRMSETACCESS = 114000;
  CONST_FRMSETACCESS_GOTORECORD = CONST_FRMSETACCESS + 1; //AddMessage函数

  //TFrmAccountGroup
  CONST_FRMACCOUNTGROUP = 115000;
  CONST_FRMACCOUNTGROUP_GOTORECORD = CONST_FRMACCOUNTGROUP + 1; //AddMessage函数

  //TFrmAccount
  CONST_FRMACCOUNT = 116000;
  CONST_FRMACCOUNT_GOTORECORD = CONST_FRMACCOUNT + 1; //AddMessage函数

  //TFrmUpdatePassword
  CONST_FRMUPDATEPASSWORD = 117000;
  CONST_FRMUPDATEPASSWORD_GOTORECORD = CONST_FRMUPDATEPASSWORD + 1; //AddMessage函数

  //VirForm;
  CONST_VIRFORM = 118000;
  CONST_VIRFORM_FORMCOAT = CONST_VIRFORM + 1;

  //TSelAccount
  CONST_SELACCOUNT = 119000;
  CONST_SELACCOUNT_SELACCOUNT = CONST_SELACCOUNT + 1;
  CONST_SELACCOUNT_GETNEWACCOUNT = CONST_SELACCOUNT + 2;
  CONST_SELACCOUNT_GETACCOUNTID = CONST_SELACCOUNT + 3;

  //TSelFileDir
  CONST_SELFILEDIR = 120000;
  CONST_SELFILEDIR_GETDIRECTORY = CONST_SELFILEDIR + 1;
  CONST_SELFILEDIR_GETLOCALDIRECTORY = CONST_SELFILEDIR + 2;

  }
  //TSelPart
  //CONST_SELPART = 109000;
  CONST_SELPART_SHOWCHOICE = 109000 + 1; //ShowChoice函数
  CONST_CLASS_NAMES = 'Classes';
  //TFrmDocEnterprise
  //CONST_FRMDOCENTERPRISE = 121000;
  CONST_FRMDOCENTERPRISE_REFRESHDOCVIEW = 121000 + 1;

  BMP_BACKIMAGE    = 1001;
  JPG_ERPKEY_LEFT  = 2001;
  JPG_ERPKEY_TITLE = 2002;
  JPG_PROCESSING   = 2003;
  JPG_SPLASH       = 2004;
  JPG_SETUP        = 2005;

  //
  EMPTY_VARIANT = '{8E3A5093-469C-4310-B1D5-77DBE224CDF2}';

resourcestring
  //UNKNOWN_SYSTEM = '不支持的操作系统：%s';
  UNKNOWN_SYSTEM = 'The OS for %s don''t support!';

var
  pub_SystemRootPath: String;
  pub_sreg, pub_ureg: TIniFile;

implementation

function SystemRootPath: String;
var
  i: Integer;
  VolumnType: string;
  OtherDrive: Boolean;
  WinDir: array[0..255] of char;
begin
  if pub_SystemRootPath = '' then
  begin
    //默认为系统安装盘
    GetWindowsDirectory(WinDir, SizeOf(WinDir));
    pub_SystemRootPath := WinDir[0] + WinDir[1] + WinDir[2] + 'HWASOFT\';
    OtherDrive := False;
    //查找有无其它盘符
    for i := 65 to 65 + 25 do
    begin
      if GetDriveType(PChar(Char(i) + ':\')) = DRIVE_Fixed then
      begin
        if OtherDrive then
          begin
            VolumnType := GetDiskInfo(Char(i), 2);
            if (UpperCase(VolumnType) = 'NTFS') or (UpperCase(VolumnType) = 'FAT32') then
            begin
              pub_SystemRootPath := Char(i) + ':\HWASOFT\';
              Break;
            end
          end
        else if Char(i) = WinDir[0] then
          OtherDrive := True;
      end;
    end;
    if not DirectoryExists(pub_SystemRootPath) then
      CreateDirectory(PWideChar(pub_SystemRootPath), nil);
  end;
  Result := pub_SystemRootPath;
end;

function sreg: TIniFile;
begin
  if not Assigned(pub_sreg) then
  begin
    pub_sreg := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'bsii.cfg');
  end;
  Result := pub_sreg;
end;

function ureg: TIniFile;
begin
  if not Assigned(pub_ureg) then
  begin
    pub_ureg := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'bsii.dat');
    {
    if not pub_ureg.ValueExists('system','config') then
      pub_ureg.WriteString('system','config',
        ExtractFilePath(Application.ExeName) + 'bsii.cfg');
    }
  end;
  Result := pub_ureg;
end;


function NewGuid(): String;
var
  NID: TGuid;
begin
  CreateGuid(NID);
  Result := GuidToString(NID);
end;

function iif(const bFlag: Boolean; const Str1,Str2: String): String;
begin
  if bFlag then Result := Str1 else Result := Str2;
end;

function iif(const bFlag: Boolean; val1,val2: Integer): Integer;
begin
  if bFlag then Result := val1 else Result := val2;
end;

function iif(const bFlag: Boolean; val1,val2: Double): Double;
begin
  if bFlag then Result := val1 else Result := val2;
end;

procedure MsgBox(const AValue, ACaption: String);
begin
  if Assigned(Screen.ActiveForm) then
    MessageBox(Screen.ActiveForm.Handle,PChar(AValue),PChar(ACaption),MB_ICONINFORMATION)
  else
    MessageBox(Application.Handle,PChar(AValue),PChar(ACaption),MB_ICONINFORMATION);
end;

procedure MsgBox(AValue: Integer; const ACaption: String);
begin
  MsgBox(IntToStr(AValue),ACaption);
end;

procedure MsgBox(const AFmt: String; const Args: array of const);
var
  str: String;
begin
  str := Format(AFmt,Args);
  MsgBox(str);
end;

function IsIPAddress(const Value: String): Boolean;
var
  p: PChar;
  i: Integer;
begin
  Result := True;
  p := PChar(Value);
  for i := 0 to Length(Value) - 1 do
  begin
    if not CharInSet((p + i)^, ['0'..'9','.',' ']) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function GetMachNo_OLD: String;
var
  R: TIniFile;
  function NGuid: String;
  var
    i: Integer;
    Guid: TGuid;
    tmp: String;
  begin
    Result := '';
    CreateGuid(Guid);
    tmp := GuidToString(Guid);
    for i := 2 to Length(tmp) - 1 do
      if Copy(tmp,i,1) <> '-' then Result := Result + Copy(tmp,i,1)
  end;
begin
  Result := NGuid;
  R := TIniFile.Create(SystemRootPath() + 'system.ini');
  try
    //R.RootKey := HKEY_CURRENT_USER;
    //R.RootKey := HKEY_CLASSES_ROOT;
    if not R.ValueExists(MACHNO_GUID, 'MachNo') then
      begin
        Result := NGuid();
        R.WriteString(MACHNO_GUID, 'MachNo',Result);
      end
    else
      Result := R.ReadString(MACHNO_GUID, 'MachNo', '');
  finally
    R.Free;
  end;
end;

function GetMachNo(Buffer: PChar): Integer;
var
  strTemp: String;
begin
  //strTemp := NBGetAdapterAddress(); //取网卡硬件编号
  strTemp := GetDiskInfo('C',1) + GetDiskInfo('C',2);
  strTemp := Copy(Encrypt(strTemp,GetMachNo_OLD,True),1,24);
  StrCopy(Buffer,PChar(strTemp));
  Result := 24;
end;

function NBGetAdapterAddress: String;
var
  Index: Integer; //Index 指定多个网卡适配器中的哪一?0，1，2...
  NCB: TNCB; // Netbios control block file://NetBios控制块
  ADAPTER: TADAPTERSTATUS; // Netbios adapter status//取网卡状态
  LANAENUM: TLANAENUM; // Netbios lana
  intIdx: Integer; // Temporary work value//临时变量
  cRC: AnsiChar;   // Netbios return code//NetBios返回值
  strTemp : String; // Temporary string//临时变量
Begin
  // Initialize
  strTemp := '';
  try
    Index := 0; //指定第一块网卡
    for intIdx := 0 to 5 do ADAPTER.adapter_address[intIdx] := #0;
    // Zero control blocl
    ZeroMemory(@NCB, SizeOf(NCB));
    // Issue enum command
    NCB.ncb_command:=Chr(NCBENUM);
    //cRC := NetBios(@NCB);
    NetBios(@NCB);
    // Reissue enum command
    NCB.ncb_buffer := @LANAENUM;
    NCB.ncb_length := SizeOf(LANAENUM);
    cRC := NetBios(@NCB);
    If Ord(cRC)<>0 Then
      exit;
    // Reset adapter
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBRESET);
    NCB.ncb_lana_num := LANAENUM.lana[Index];
    //cRC := NetBios(@NCB);
    NetBios(@NCB);
    if Ord(cRC)<>0 Then Exit;
    // Get adapter address
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBASTAT);
    NCB.ncb_lana_num := LANAENUM.lana[Index];
    StrPCopy(NCB.ncb_callname, '*');
    NCB.ncb_buffer := @ADAPTER;
    NCB.ncb_length := SizeOf(ADAPTER);
    //CRC := NetBios(@NCB);
    NetBios(@NCB);
    // Convert it to string
    for intIdx := 0 to 5 Do
      strTemp := strTemp + IntToHex(Integer(ADAPTER.adapter_address[intIdx]),2);
  finally
    Result := strTemp + StringOfChar('0',12 - Length(strTemp))
  end;
end;

function NBGetVolumnNo: string;
var
  i: Integer;
  MachNo: string;
  DriveChar: Char;
  OtherDrive: Boolean;
  VolumnType: string;
  WinDir: array[0..255] of char;
begin
  Result := '';
  MachNo := GetMachNo_OLD;
  //默认为系统安装盘
  GetWindowsDirectory(WinDir, SizeOf(WinDir));
  DriveChar := WinDir[0];
  OtherDrive := False;
  //查找有无其它盘符
  for i := 65 to 65 + 25 do
  begin
    if GetDriveType(PChar(Char(i) + ':\')) = DRIVE_Fixed then
    begin
      if OtherDrive then
        begin
          VolumnType := GetDiskInfo(Char(i), 2);
          if (UpperCase(VolumnType) = 'NTFS') or (UpperCase(VolumnType) = 'FAT32') then
          begin
            DriveChar := Char(i);
            Break;
          end;
        end
      else if Char(i) = WinDir[0] then
        OtherDrive := True;
    end;
  end;
  Result := GetDiskInfo(DriveChar, 1);
  Result := Copy(Encrypt(Result, MachNo, True), 1, 16);
end;

function GetDiskInfo(DriveChar: Char; const Flag: Integer): string;
var
  OldErrorMode: Integer;
  SerialID, VolFlags, SerialFlags: DWORD;
  VolumeID, FileType: array [0..MAX_PATH] of Char;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    VolumeID[0] := #$00;
    if GetVolumeInformation(PChar(DriveChar + ':\'), VolumeID, DWORD(SizeOf(VolumeID)),
      @SerialID, SerialFlags, VolFlags, FileType, DWORD(SizeOf(FileType))) then
      begin
        case Flag of
        0: SetString(Result, VolumeID, StrLen(VolumeID));
        1: Result := IntToHex(SerialID,8);
        2: SetString(Result, FileType, StrLen(FileType));
        end;
      end
    else
      Result := '';
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

procedure Encrypt(Value: PChar; Size: Integer; const PSW: String); overload;
var
  i,l: Integer; w: PChar;
  procedure E(ic: PChar; pc: Char); begin ic^ := Char(Byte((ic^)) xor Byte(pc)); end;
begin
  w := PChar(PSW); l := Length(PSW);
  for i := 0 to Size - 1 do E((Value + i),(w + (i mod l))^);
end;

function Encrypt(Value: String; const PSW: String; Flag: Boolean): String; overload
var
  Data: String;
  i: Integer;
  p: PChar;
begin
  Result := '';
  if Flag then begin // 加密后编码
    if Length(Value) = 0 then Exit;
    SetLength(Data,Length(Value)); StrCopy(PChar(Data),PChar(Value));
    Encrypt(PChar(Data),Length(Data),PSW); p := PChar(Data);
    for i := 0 to Length(Data) - 1 do
      Result := Result + IntToHex(Byte(Char((p+i)^)),2);
  end else begin     // 编码后解密
    p := PChar(Value);
    for i := 0 to Length(Value) - 1 do
      if not CharInSet((p + i)^ , ['0'..'9','A'..'F']) then Exit;
    for i := 1 to Length(Value) div 2 do
      Result := Result + Char(StrToInt('0x' + Copy(Value,i*2-1,2)));
    Encrypt(PChar(Result),Length(Result),PSW);
  end;
end;

{
procedure OpenConnection(DCOM: TSocketConnection; const Address, KeyCard,
  Account, Password: String);
var
  t_MachNo: String;
  Param, R: OleVariant;
begin
  if DCOM.Connected then DCOM.Close;
  if IsIPAddress(Address) then DCOM.Address := Address else DCOM.Host := Address;
  DCOM.Open;
  Param := VarArrayCreate([0,2],varVariant);
  Param[0] := Account;
  Param[1] := Password;
  //SetLength(t_MachNo,24); GetMachNo(PChar(t_MachNo));
  t_MachNo := NBGetAdapterAddress(); //取网卡号
  Param[2] := ComputerName() + '/' + GuidNull + '/' + t_MachNo;
  R := DCOM.AppServer.Exec(APS_LOGIN,Param);
  if R[0] <> RET_OK then
    begin
      DCOM.Close;
      Raise Exception.Create(R[3]);
    end
  else
    DCOM.AppServer.LoginID := R[1];
end;
}

function ComputerName: String;
var
  Tmp: String;
  bFlag: Boolean;
  nSize: DWORD;
begin
  SetLength(Tmp,MAX_COMPUTERNAME_LENGTH + 1);
  nSize := MAX_COMPUTERNAME_LENGTH;
  bFlag := GetComputerName(PChar(Tmp),nSize);
  if bFlag then Result := Copy(Tmp,1,nSize) else Result := 'UnKnow';
end;

function GuidFixStr(const Value: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 2 to Length(Value) - 1 do
    if Copy(Value,i,1) <> '-' then Result := Result + Copy(Value,i,1)
end;

function GetWinSys: String;
var
  str: String;
begin
  SetLength(str,MAX_PATH);
  Result := Copy(str,1,GetSystemDirectory(PChar(str),MAX_PATH));
end;

function md5(S: String): String;
var
  md5: TIdHashMessageDigest5;
begin
  md5 := TIdHashMessageDigest5.Create;
  try
    Result := LowerCase(md5.HashStringAsHex(s, TEncoding.UTF8));
  finally
    md5.Free;
  end;
end;

//载入控件选项值
procedure LoadOptions(const Section: String; const Args: array of TComponent);
var
  sEvent: TNotifyEvent;
  i, j: Integer;
begin
  for i := Low(Args) to High(Args) do
  begin
    if Args[i] is TCheckBox then
      begin
        sEvent := TCheckBox(Args[i]).OnClick;
        try
          TCheckBox(Args[i]).OnClick := nil;
          TCheckBox(Args[i]).Checked := ureg.ReadBool(Section,Args[i].Name,TCheckBox(Args[i]).Checked);
        finally
          TCheckBox(Args[i]).OnClick := sEvent;
        end;
      end
    else if Args[i] is TEdit then
      begin
        sEvent := TEdit(Args[i]).OnChange;
        try
          TEdit(Args[i]).OnChange := nil;
          TEdit(Args[i]).Text := ureg.ReadString(Section,Args[i].Name,TEdit(Args[i]).Text)
        finally
          TEdit(Args[i]).OnChange := sEvent;
        end;
      end
    else if Args[i] is TCustomEdit then
      begin
        TCustomEdit(Args[i]).Text := ureg.ReadString(Section,Args[i].Name,TCustomEdit(Args[i]).Text)
      end
    else if Args[i] is TDateTimePicker then
      TDateTimePicker(Args[i]).DateTime := ureg.ReadDateTime(Section,Args[i].Name,TDateTimePicker(Args[i]).DateTime)
    else if Args[i] is TComboBox then
      begin
        j := ureg.ReadInteger(Section,Args[i].Name,TComboBox(Args[i]).ItemIndex);
        if (j = -1) or (j in [0..TComboBox(Args[i]).Items.Count-1]) then
          TComboBox(Args[i]).ItemIndex := j;
      end;
  end;
end;

//保存控件选项值
procedure SaveOptions(const Section: String; const Args: array of TComponent);
var
  i: Integer;
begin
  for i := Low(Args) to High(Args) do
  begin
    if Args[i] is TCheckBox then
      ureg.WriteBool(Section,Args[i].Name,TCheckBox(Args[i]).Checked)
    else if Args[i] is TCustomEdit then
      ureg.WriteString(Section,Args[i].Name,TCustomEdit(Args[i]).Text)
    else if Args[i] is TDateTimePicker then
      ureg.WriteDateTime(Section,Args[i].Name,TDateTimePicker(Args[i]).DateTime)
    else if Args[i] is TComboBox then
      ureg.WriteInteger(Section,Args[i].Name,TComboBox(Args[i]).ItemIndex);
  end;
end;

procedure LoadOptions(Sender: TForm);
var
  i, j: Integer;
  Args: array of TComponent;
  P: TComponent;
begin
  j := 0;
  for i := 0 to Sender.ComponentCount - 1 do
  begin
    P := Sender.Components[i];
    if (P is TCheckBox)       or (P is TCustomEdit) or
       (P is TDateTimePicker) or (P is TComboBox)   then
    begin
      Inc(j);
      SetLength(Args, j);
      Args[j-1] := P;
    end;
  end;
  if j > 0 then LoadOptions(Sender.Name, Args);
  Args := nil;
end;

procedure SaveOptions(Sender: TForm);
var
  i, j: Integer;
  Args: array of TComponent;
  P: TComponent;
begin
  j := 0;
  for i := 0 to Sender.ComponentCount - 1 do
  begin
    P := Sender.Components[i];
    if (P is TCheckBox)       or (P is TCustomEdit) or
       (P is TDateTimePicker) or (P is TComboBox)   then
    begin
      Inc(j);
      SetLength(Args, j);
      Args[j-1] := P;
    end;
  end;
  if j > 0 then SaveOptions(Sender.Name, Args);
  Args := nil;
end;

function IsNull(Value, Default: Variant): Variant;
begin
  if VarIsNull(Value) then Result := Default else Result := Value;
end;

function SafeString(const Value: String): String;
begin
  Result := StringReplace(Value, '''', '', [rfReplaceAll]);
end;

end.

