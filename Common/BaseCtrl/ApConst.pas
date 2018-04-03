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
  
  //�춯�����¼
  TTBRecord = record
    ID: String;
    Name: String;    //�Զ��嵥��
    SysTB: String;   //ϵͳ����
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
    RefCount: Integer; //���ü���
  end;
  PHRPackageItem = ^THRPackageItem;

  AllowCharOption = (acNumeric,acASCII);
  TViewFileOption = (vfPrint, vfSaveAs);
  TViewFileOptions = set of TViewFileOption;

  function GetMachNo(Buffer: PChar): Integer;
  function IsIPAddress(const Value: String): Boolean;
  function NBGetAdapterAddress: String;
  function NBGetVolumnNo: string;
  //�ԳƼ��ܺ���
  function Encrypt(Value: String; const PSW: String; Flag: Boolean): String; overload
  procedure Encrypt(Value: PChar; Size: Integer; const PSW: String); overload;
  //����DCOM���ú���
  //procedure OpenConnection(DCOM: TSocketConnection; const Address, KeyCard,
  //  Account, Password: String);
  //ȡ�õ�ǰ���������
  function ComputerName: String;
  // ����һ���µ�Guid
  function NewGuid(): String;
  function iif(const bFlag: Boolean; const Str1,Str2: String): String; overload;
  function iif(const bFlag: Boolean; val1,val2: Integer): Integer; overload;
  function iif(const bFlag: Boolean; val1,val2: Double): Double; overload;
  // ��ʽ����ʾ��Ϣ
  procedure MsgBox(const AValue: String; const ACaption: String = 'Message'); overload;
  procedure MsgBox(AValue: Integer; const ACaption: String = 'Message'); overload;
  procedure MsgBox(const AFmt: String; const Args: array of const); overload;
  // ��һ��Guid���͵��ַ���ȥ��{}��-����
  function GuidFixStr(const Value: String): String;
  function IsNull(Value, Default: Variant): Variant;
  //ȡ��ϵͳĿ¼
  function GetWinSys: String;
  //����md5ֵ
  function md5(S: String): String;
  //
  function GetDiskInfo(DriveChar: Char; const Flag: Integer): string;
  //���롢����ؼ�ѡ��ֵ  Author: Jason 2003.12.11
  procedure LoadOptions(Sender: TForm); overload;
  procedure SaveOptions(Sender: TForm); overload;
  procedure LoadOptions(const Section: String; const Args: array of TComponent); overload;
  procedure SaveOptions(const Section: String; const Args: array of TComponent); overload;
  //������и�Ŀ¼
  function SystemRootPath: String;
  //���������ĸ����ֹSQLע�빥��
  function SafeString(const Value: String): String;

const
  SECURITY_PASSWORD = 'WinErp';
  //SECURITY_PASSWORD = 'CERCErp';
  SOFTWARE_NAME = 'MIMRC';
  CONFIG_FILE = 'CERCERP.INI';

  MAX_DOCPACKAGE = 10240; //10K ÿ���ݰ�

  RET_OK : Integer = 0;
  RET_ERROR : Integer = -9999;
  RET_OTHERERROR : smallint = -1;
  RET_READONLY : smallint = -2;
  vbCrLf: String = #13 + #10;
  Max_Viability: smallint = 120;  //�������ֵ��120��
  NO_LOGON: smallint = -1;       //û�е�¼
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

  //�ڲ���ϵͳ�̶�����
  SYS_ADMIN_GUID: String  = '{B85954D9-C80E-4F00-8FD7-F94300AABEF0}';
  SYS_PERSON_GUID: String = '{5B8B5550-BCB6-4457-9E51-721C0BA0D845}';

  //�ڲ�Ȩ��������
  GROUP_SALES_GUID: String = '{517E247F-7DD2-4996-9FC5-CEAA14FBC029}';
  GROUP_PUR_GUID: String   = '{AA98C163-C451-44DD-99D4-1CB3801C661B}';
  GROUP_STOCK_GUID: String = '{9AB0B1F8-AD91-439B-AD2E-12CAFBA42648}';
  GROUP_QC_GUID: String    = '{E8324985-05E2-4C87-B9A2-535D190AB656}';
  GROUP_PMC_GUID: String   = '{ED602EFC-0D7B-4A5C-8A71-6741D829D796}';
  GROUP_SGB_GUID: String   = '{26179CEE-5584-4A65-BB59-50075F80410B}';

  //�̶����ܴ���
  FUNC_SYSRIGHT_GUID = '{AD094DD8-BE81-49AA-93B2-DBBD4054F4AF}';

  DOWNLOAD_UPDATE: String = '{91FFE14C-1A4A-4122-87F4-04F9ED847A1D}';
  DOWNLOAD_SETUP: String  = '{769D630E-6045-4F46-8356-9D1C70EA046B}';
  DOWNLOAD_README: String = '{D4F78F10-9EF4-4397-8116-0155AAC1AFF3}';
  DOWNLOAD_REPORT: String = '{37980A6D-9C47-45FD-9C73-5F0FAEB35A5C}';

  ERROR_OWNERDATA_FORMAT = -12;
  RET_PARAM_ERROR = -13;
  RET_NOPASS = -14;
  
  //ÿ������¼��
  CDS_MAXRECORDS: Integer = 1000;

  // use to TCERCERP.EXEC
  APS_CHANGETBSTATUS = 1;
  APS_CONFIRM = 2;
  //APS_GETUSERINFO = 7;
  //APS_LOGOUT = 9;
  //APS_LOGIN = 11;

  // �����ʶ
  TASK_MRP = 1;             //����MRP
  TASK_MadeAttendCard = 2;  //���ɿ���"���ӹ���"
  TASK_CountABNORMITY = 3;  //ͳ�ƿ����춯
  TASK_COUNTRECARDBTABLE = 4; //ͳ�ƿ�����
  TASK_CALCULATESALARY = 5;   //����һ���µ�н��
  TASK_TRAN_QA = 6;
  TASK_TRAN_QB = 7;

  COLOR_BOX_TITLE = 14606560; //clMoneyGreen; //�������ɫ

  // ϵͳ��־���
  SH_SECURITY = 1;
  SH_SYSTASK_INFO = 2;
  SH_SYSTASK_ERROR = 3;
  SH_SysMsg_NoSend = 1001; //'δ������Ϣ';
  SH_PhoneMsg_NoSend = 1002; //'δ������Ѷ';
  SH_SysMsg_Send = 1003; //'�ѷ�����Ϣ';
  SH_ERROR = 999;
  
  //==================
  //Work Flow �����ʶ
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
  // �춯�� A ��
  //-----------------
  wfTranAA      = 100;
  wfTranAB      = 101;
  wfTranAC      = 102;
  wfTranAD      = 103;
  wfTranAE      = 104;
  wfTranAF      = 105;
  wfTranAG      = 106;
  wfTranAH      = 107;
  wfTranAI      = 108; //ί�������˻ص�
  wfTranAJ      = 109;
  //-----------------
  wfTranAK      = 110;
  wfTranAL      = 111;
  wfTranAM      = 112;
  wfTranAN      = 113;
  wfTranAQ      = 114;
  wfTranAR      = 115;
  //==================
  // �춯�� B ��
  //-----------------
  wfTranBA      = 200;
  wfTranBB      = 201;
  wfTranBC      = 202;
  wfTranBD      = 203;
  wfTranBE      = 204;
  wfTranBF      = 205;
  wfTranBG      = 206; //ί��ӹ����ϵ�
  wfTranBH      = 207;
  wfTranBI      = 208;
  wfTranBJ      = 209;
  wfTranBP      = 210;
  wfTranBR      = 211;
  wfTranBQ      = 212;
  wfTranAP      = 213;
  //==================
  // �춯�� B ��
  //-----------------
  wfTranCC      = 250;
  wfTranCD      = 251;
  //==================
  // ���¿���н����
  //-----------------
  wfAssign      = 301;
  wfEngage      = 302;
  wfEdu         = 303;

  // ��Ч����ϵͳ��
  wfWorkReport  = 401;
  wfCSRegister  = 402;

  //�̶��ʲ�
  wfPASysAA     = 700;
  wfPASysAB     = 701;
  wfPASysAC     = 702;
  wfTranAP_EC   = 703;

  // �ĵ�����ϵͳ
  wfFileFlow  = 501;
  //wfFileFlowBA  = 551;

  wfEmail       = 600;
  //����
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
  // �˵���˵�֮����
  MENU_TYPE_HIDDEN  : smallint = 0;
  MENU_TYPE_STANDARD: smallint = 1;
  MENU_TYPE_SEARCH  : smallint = 2;
  MENU_TYPE_SETUP   : smallint = 3;
  MENU_TYPE_TOOLS   : smallint = 4;

  // �춯���ݷ����
  TRAN_SYS_TRAN     : smallint = 1;
  TRANT_SYS_ORDW    : smallint = 2;
  TRANT_SYS_PEASON  : smallint = 3;
  TRANT_SYS_ACC     : smallint = 4;

  //�ĵ�������־����
  ohBrowser  : smallint =  0; //�鿴
  ohAppend   : smallint =  1; //����
  ohDelete   : smallint =  2; //ɾ��
  ohPrint    : smallint =  3; //��ӡ
  ohBorrow   : smallint =  4; //���
  ohRename   : smallint =  5; //����
  ohDownLoad : smallint =  6; //����
  ohOverload : smallint =  7; //����
  ohMove     : smallint =  8; //�ƶ�
  ohClear    : smallint =  9; //���
  ohUpdate   : smallint = 10; //�黹
  ohCopy     : smallint = 11; //����
  ohRecover  : smallint = 12; //��ԭ
  ohEncrypt  : smallint = 13; //
  ohUnencrypt: smallint = 14; //


  //�������뵵������
  //SYSLIST_01      : String = 'SYSLIST.1';  //�ɹ���Ա
  SYSLIST_Sells   : String = 'SYSLIST.2';  //ҵ����Ա
  SYSLIST_Area    : String = 'SYSLIST.3';  //�������
  SYSLIST_04      : String = 'SYSLIST.4';  //ʡ������
  SYSLIST_05      : String = 'SYSLIST.5';  //�ڽ�
  SYSLIST_06      : String = 'SYSLIST.6';  //����
  SYSLIST_07      : String = 'SYSLIST.7';  //ѧ��
  SYSLIST_08      : String = 'SYSLIST.8';  //н�ʼ���
  SYSLIST_Country : String = 'SYSLIST.9';  //����
  SYSLIST_10      : String = 'SYSLIST.10'; //�ʲ��������
  SYSLIST_Bank    : String = 'SYSLIST.11'; //���д���
  SYSLIST_12      : String = 'SYSLIST.12'; //�ʲ�����λ��
  SYSLIST_13      : String = 'SYSLIST.13'; //��Ƴ���ժҪ
  SYSLIST_14      : String = 'SYSLIST.14'; //Ӧ����������
  //SYSLIST_15      : String = 'SYSLIST.15'; //�ֹ���Ա
  //SYSLIST_16      : String = 'SYSLIST.16'; //�����Ա
  SYSLIST_17      : String = 'SYSLIST.17'; //Ӧ�տ�������
  SYSLIST_18      : String = 'SYSLIST.18'; //�ͻ����
  SYSLIST_SupType : String = 'SYSLIST.19'; //�������
  SYSLIST_20      : String = 'SYSLIST.20'; //��Ʒ����
  SYSLIST_21      : String = 'SYSLIST.21'; //�������
  SYSLIST_22      : String = 'SYSLIST.22'; //��Ч��Ŀ
  SYSLIST_23      : String = 'SYSLIST.23'; //��������
  SYSLIST_24      : String = 'SYSLIST.24'; //�ͻ���(�Ϻ�)
  SYSLIST_25      : String = 'SYSLIST.25'; //���̵�(�Ϻ�)
  SYSLIST_26      : String = 'SYSLIST.26'; //���ü�����
  SYSLIST_27      : String = 'SYSLIST.27'; //����������
  SYSLIST_28      : String = 'SYSLIST.28'; //����ԭ�����
  //SYSLIST_29      : String = 'SYSLIST.29'; //Ʒ����Ա
  SYSLIST_30      : String = 'SYSLIST.30'; //��̨���


  // �ĵ�ϵͳ֮�������ϼ�
  DIR_RECYCLED:         String = '{204CAC1F-9D06-4320-85C3-871D592BB162}';
  DIR_RECYCLED_HISTORY: String = '{64D5DA6A-8166-4D0E-9B91-9858EE12A22D}';
  DOC_PART_GUID:        String = '{5A985B89-2E4F-4E9E-B22C-2C76C8A41DC4}';
  DOC_CUS_GUID:         String = '{70C50524-7D07-40F7-A3E3-FA8A044F8C58}';
  DOC_PRIVATE_GUID:     String = '{3EBB2B15-DC00-4056-9304-90A3E8018550}';
  DOC_PRINT_GUID:       String = '{8D8BF3FE-DA38-435B-B2C8-2CF42F82C466}';
  DOC_ORDMARK_GUID:     String = '{B2BA711B-8A95-42B4-8CAC-B01914BB54C6}';
  DOC_TEMP_GUID:        String = '{278F506E-BFE5-4722-BE21-21575DDBE4EF}';

  //DOC ϵͳ֮�������ϼ�
  DOC_PRIVATE_ROOT     : smallint = 1; //�������ϼ�֮��Ŀ¼
  //
  DOC_PRIVATE_MailIn   : smallint = 9; //�ռ���
  DOC_PRIVATE_ACCEPT   : smallint = 4; //�����ļ���
  DOC_PRIVATE_TEMP     : smallint = 2; //�����ʼ�
  DOC_PRIVATE_SEND     : smallint = 5; //�ݸ�
  DOC_PRIVATE_MailOut  : smallint = 8; //�ѷ����ʼ�
  DOC_PRIVATE_COFFER   : smallint = 6; //��ɾ���ʼ�
  
  DOC_PRIVATE_DOWN     : smallint = 3; //�Ѻ��ļ���
  DOC_PRIVATE_NG       : smallint = 7; //δ׼���ϼ�

  FILE_CLASS_REMARK    =  1; // ��Դ�ڱ�ע��
  FILE_CLASS_NORAMAL   =  0; // һ���ļ�
  FILE_CLASS_PACKAGE   = -1; // ��Դ���ļ������ʼ�
  FILE_CLASS_LINK_IN   = -2; // �ڼ�����
  FILE_CLASS_LINK_OUT  = -3; // �������

  //FileImage��Source״̬
  SOURCE_KMMAGIC       = 1; //�ĵ�����
  SOURCE_WORKFLOW      = 2; //WorkFlow����
  SOURCE_MAILFLOW      = 3; //MailFlow����
  SOURCE_UPDATEFILE    = 4; //ϵͳ��ʽ����
  SOURCE_JOB           = 5; //��Դ����ϵͳ

  //MAILFLOW�ʼ�״̬

  MAIL_INBOX           =  1; //�ռ�ϻ
  MAIL_WAITSEND        =  2; //�ļ�ϻ
  MAIL_OUTBOX          =  3; //�ļ�����
  MAIL_DRAFT           =  0; //�ݸ�
  MAIL_DELETE          = -1; //ɾ�����ʼ�

  MAIL_INBOX_FLOW      =  4; //�ռ�ϻ(��ǩ)
  MAIL_OUTBOX_FLOW     =  5; //�ļ�ϻ(��ǩ)

  //DirCoffer �� Type ȡֵ
  DIRCOFFER_USERDEF    = 999;

  //ϵͳ����ֵ
  NREG_01_0001        = '01-0001.mrp.�����Ƽ۷�ʽ';
  NREG_01_0002        = '01-0002.mrp.����������ڼ��';
  NREG_01_0003        = '01-0003.mrp.Ⱥ�������';
  NREG_01_0004        = '01-0004.mrp.�����ձ����쳣��Ŀ';
  NREG_01_0005        = '01-0005.mrp.���̸��ʽ';
  NREG_01_0006        = '01-0006.mrp.���������������';
  NREG_01_0007        = '01-0007.mrp.������װ����ҵģʽ';

  NREG_CRCP0002       = 'CRCP0002.CRCP.Ӧ���ʿ������';
  NREG_CRCP0014       = 'CRCP0014.CRCP.Ӧ���ʿ����״̬';
  NREG_CRCP0019       = 'CRCP0019.CRCP.���з�Ʊ��ҵ����';
  NREG_CRCP0020       = 'CRCP0020.CRCP.�ɹ����ʽ';
  NREG_CRCP0021       = 'CRCP0021.CRCP.�ɹ����ϳ��������';

  PDM_001             = 'PDM-001.pdm.��Ʒ�������';
  NREG_SY_0001        = 'SY_0001.system.ϵͳ�����������';
  NREG_SY_0002        = 'SY_0002.system.��ѡ��˾�ʱ�';
  NREG_SY_0003        = 'SY_0003.system.���Ű���ʱ�״̬';
  NREG_SY_0004        = 'SY_0004.system.��Ʊ����';
  NREG_SY_0005        = 'SY_0005.system.�������Ȩ�޹���';
  NREG_CRM_TYPE       = 'CM_0001.crm.�ͻ����緽ʽ';
  NREG_CRM_LEVEL      = 'CM_0002.crm.�ͻ���������';
  {$message '��ϵͳ����NREG_AT_0001�������ϣ�Jason at 2009/3/12'}
  NREG_AT_0001        = 'AT_0001.Attend.���ڿ���;����';

  drCurWeek           = 3;
  drCurMonth          = 5;
  drCurYear           = 7;

  //TZjhTool�¼���
  seExcelEdit         = -101;
  seDelete            = -102;
  PDM_DEFAULTTYPE     = '��ƷͼƬ';

  ctAppend            = 1; //����
  ctDelete            = 2; //ɾ��
  ctModify            = 3; //�޸�

  //������ʾ��ʽ
  CONST_FORM_SHOW = 0;
  CONST_FORM_SHOWMODAL = 1;
  CONST_FORM_SHOWCHILD = 2;

  //������
  CONST_MAINFORM = 100000;
  CONST_MAINFORM_SETMAX          = CONST_MAINFORM +  1; //����Statusbar���
  CONST_MAINFORM_SETPOSITION     = CONST_MAINFORM +  2; //����Statusbarλ��
  //CONST_MAINFORM_ADDPROTECT    = CONST_MAINFORM +  3; //���AddProtect
  //CONST_MAINFORM_ADDDYNMENU    = CONST_MAINFORM +  4; //��Ӷ�̬�˵�
  //CONST_MAINFORM_APPENDNODE    = CONST_MAINFORM +  5; //��Ӷ�̬�ڵ�
  //CONST_MAINFORM_APPENDMENU    = CONST_MAINFORM +  5; //��Ӳ˵�
  //CONST_MAINFORM_NAVIGATE      = CONST_MAINFORM +  6; //������ĳ����ַ
  //CONST_MAINFORM_ONREPORTOUTPUT  = CONST_MAINFORM +  7; //ȡ��Ĭ�ϵı����¼�
  //CONST_MAINFORM_RESIZE        = CONST_MAINFORM +  8; //�ı䴰��Ϊ���
  //CONST_MAINFORM_TOOLMAP       = CONST_MAINFORM +  9; //���尴ť����
  //CONST_MAINFORM_NEWFORM         = CONST_MAINFORM + 10;//����������
  //CONST_MAINFORM_GETHELPURL      = CONST_MAINFORM + 11;//ȡ�ð�����ַGetHelpURL
  //CONST_MAINFORM_CALLPROGRAM     = CONST_MAINFORM + 12;//�������ģ��CallProgram
  //CONST_MAINFORM_MOVEPROGRESSBAR = CONST_MAINFORM + 13;//����������MoveProgressBar
  //CONST_MAINFORM_SHOWFORM        = CONST_MAINFORM + 14;//����������
  //CONST_MAINFORM_STATUSMESSAGE   = CONST_MAINFORM + 15;//
  //CONST_MAINFORM_GETBITMAP       = CONST_MAINFORM + 16;//
  //CONST_MAINFORM_MESSAGE         = CONST_MAINFORM + 17;//
  //CONST_MAINFORM_EXCELUPDATE     = CONST_MAINFORM + 18;//
  CONST_MAINFORM_SetQuickToolID  = CONST_MAINFORM + 19;//
  CONST_MAINFORM_SETIMAGERES     = CONST_MAINFORM + 20;
  //CONST_MAINFORM_LOADCLASS       = CONST_MAINFORM + 21;
  {
  CONST_MAINFORM_DoOnNewRecord   = CONST_MAINFORM + 22; //����TZjhDataSet����UpdateKey��;
  CONST_MAINFORM_DoOnBeforePost  = CONST_MAINFORM + 23;  //����TZjhDataSet���ó�ʼֵ;
  CONST_MAINFORM_DoOnBeforeGetRecords = CONST_MAINFORM + 24;  //����TZjhDataSet���ó�ʼֵ;
  CONST_MAININTF_COMMAND         = CONST_MAINFORM + 25;
  }
  CONST_BUFFER_CREATE            = CONST_MAINFORM + 26;
  CONST_BUFFER_DESTORY           = CONST_MAINFORM + 27;
  CONST_MAINFORM_ADDRESS         = CONST_MAINFORM + 28;
  CONST_MAINFORM_HTMLTEXT        = CONST_MAINFORM + 29;
  CONST_MAINFORM_BODYTEXT        = CONST_MAINFORM + 30;
  CONST_MAINFORM_CHANGECORP      = CONST_MAINFORM + 31;
  CONST_MAINFORM_CLOSEFORM       = CONST_MAINFORM + 32;

  //���
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
  CONST_SELECTDIALOG_SELACCOUNT        = CONST_SELECTDIALOG + 1; //SelAccount����
  CONST_SELECTDIALOG_OPENCOMMAND       = CONST_SELECTDIALOG + 2; //OpenCommand����
  CONST_SELECTDIALOG_ADDTITLE          = CONST_SELECTDIALOG + 3; //AddTitle����
  CONST_SELECTDIALOG_OPENBUFFER        = CONST_SELECTDIALOG + 4; //OpenBuffer����
  CONST_SELECTDIALOG_EXECUTE           = CONST_SELECTDIALOG + 5; //Execute����
  CONST_SELECTDIALOG_SETRESULTCOLUMNNO = CONST_SELECTDIALOG + 6; //SetResultColumnNo����
  CONST_SELECTDIALOG_MULTISELECT       = CONST_SELECTDIALOG + 7; //MultiSelect����

  //TFrmChoice
  CONST_FRMCHOICE = 112000;
  CONST_FRMCHOICE_ADDITEM = CONST_FRMCHOICE + 1; //AddItem����
  CONST_FRMCHOICE_EXECUTE = CONST_FRMCHOICE + 2; //Execute����
  //CONST_FRMCHOICE_ADDDATASET = CONST_FRMCHOICE + 3; //AddDataSet����

  {

  //Icon List
  SAVE_ICON           = 1;
  CONST_FAVORITES        = 10000;

  CONST_FAVORITES_ADD    = CONST_FAVORITES + 1;
  CONST_FAVORITES_CLICK  = CONST_FAVORITES + 2;
  CONST_FAVORITES_LOAD   = CONST_FAVORITES + 3;

  //TSchPub
  CONST_SCHPUB = 101000;
  CONST_SCHPUB_GETFORM = CONST_SCHPUB + 1; //GetForm����

  //TSelReport
  CONST_SELREPORT = 103000;
  CONST_SELREPORT_OUTPUT = CONST_SELREPORT + 1; //Output����
  CONST_SELREPORT_PUTOFFICE = CONST_SELREPORT + 2; //PutOffice����
  CONST_SELREPORT_EXECUTE = CONST_SELREPORT + 3; //Execute����
  CONST_SELREPORT_EXCELUPDATE = CONST_SELREPORT + 4; //ExcelUpdate����

  //TFrmFuncProperty
  CONST_FRMFUNCPROPERTY = 104000;
  CONST_FRMFUNCPROPERTY_SETMASTERKEY = CONST_FRMFUNCPROPERTY + 1; //SetMasterKey����

  //TEdtTran
  CONST_EDITTRAN = 105000;
  CONST_EDITTRAN_GOTORECORD = CONST_EDITTRAN + 1; //GotoRecord����

  //TFrmSelAccSub
  CONST_FRMSELACCSUB = 108000;
  CONST_FRMSELACCSUB_SETSHOWROOT = CONST_FRMSELACCSUB + 1; //SetShowRoot����

  //TSchStockNum
  CONST_SCHSTOCKNUM = 110000;
  CONST_SCHSTOCKNUM_GOTORECORD = CONST_SCHSTOCKNUM + 1; //GotoRecord����

  //TFrmBewrite
  CONST_FRMBEWRITE = 111000;
  CONST_FRMBEWRITE_SHOW = CONST_FRMBEWRITE + 1; //Show����

  //TFrmShowMsg
  CONST_FRMSHOWMSG = 113000;
  CONST_FRMSHOWMSG_ADDMESSAGE = CONST_FRMSHOWMSG + 1; //AddMessage����

  //TFrmSetAccess
  CONST_FRMSETACCESS = 114000;
  CONST_FRMSETACCESS_GOTORECORD = CONST_FRMSETACCESS + 1; //AddMessage����

  //TFrmAccountGroup
  CONST_FRMACCOUNTGROUP = 115000;
  CONST_FRMACCOUNTGROUP_GOTORECORD = CONST_FRMACCOUNTGROUP + 1; //AddMessage����

  //TFrmAccount
  CONST_FRMACCOUNT = 116000;
  CONST_FRMACCOUNT_GOTORECORD = CONST_FRMACCOUNT + 1; //AddMessage����

  //TFrmUpdatePassword
  CONST_FRMUPDATEPASSWORD = 117000;
  CONST_FRMUPDATEPASSWORD_GOTORECORD = CONST_FRMUPDATEPASSWORD + 1; //AddMessage����

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
  CONST_SELPART_SHOWCHOICE = 109000 + 1; //ShowChoice����
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
  //UNKNOWN_SYSTEM = '��֧�ֵĲ���ϵͳ��%s';
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
    //Ĭ��Ϊϵͳ��װ��
    GetWindowsDirectory(WinDir, SizeOf(WinDir));
    pub_SystemRootPath := WinDir[0] + WinDir[1] + WinDir[2] + 'HWASOFT\';
    OtherDrive := False;
    //�������������̷�
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
  //strTemp := NBGetAdapterAddress(); //ȡ����Ӳ�����
  strTemp := GetDiskInfo('C',1) + GetDiskInfo('C',2);
  strTemp := Copy(Encrypt(strTemp,GetMachNo_OLD,True),1,24);
  StrCopy(Buffer,PChar(strTemp));
  Result := 24;
end;

function NBGetAdapterAddress: String;
var
  Index: Integer; //Index ָ����������������е���һ?0��1��2...
  NCB: TNCB; // Netbios control block file://NetBios���ƿ�
  ADAPTER: TADAPTERSTATUS; // Netbios adapter status//ȡ����״̬
  LANAENUM: TLANAENUM; // Netbios lana
  intIdx: Integer; // Temporary work value//��ʱ����
  cRC: AnsiChar;   // Netbios return code//NetBios����ֵ
  strTemp : String; // Temporary string//��ʱ����
Begin
  // Initialize
  strTemp := '';
  try
    Index := 0; //ָ����һ������
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
  //Ĭ��Ϊϵͳ��װ��
  GetWindowsDirectory(WinDir, SizeOf(WinDir));
  DriveChar := WinDir[0];
  OtherDrive := False;
  //�������������̷�
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
  if Flag then begin // ���ܺ����
    if Length(Value) = 0 then Exit;
    SetLength(Data,Length(Value)); StrCopy(PChar(Data),PChar(Value));
    Encrypt(PChar(Data),Length(Data),PSW); p := PChar(Data);
    for i := 0 to Length(Data) - 1 do
      Result := Result + IntToHex(Byte(Char((p+i)^)),2);
  end else begin     // ��������
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
  t_MachNo := NBGetAdapterAddress(); //ȡ������
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

//����ؼ�ѡ��ֵ
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

//����ؼ�ѡ��ֵ
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

