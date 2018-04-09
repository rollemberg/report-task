unit AdminLibCtl_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision: 1.1 $
// File generated on 2002/11/7 ÉÏÎç 07:55:01 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINNT\system32\ImgAdmin.ocx (1)
// LIBID: {009541A3-3B81-101C-92F3-040224009C02}
// LCID: 0
// Helpfile: C:\WINNT\Help\imgocxd.hlp
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\stdvcl40.dll)
// Errors:
//   Hint: Parameter 'Object' of _DImgAdmin.Delete changed to 'Object_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants, 
  Windows, ApConst;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  AdminLibCtlMajorVersion = 2;
  AdminLibCtlMinorVersion = 1;

  LIBID_AdminLibCtl: TGUID = '{009541A3-3B81-101C-92F3-040224009C02}';

  DIID__DImgAdmin: TGUID = '{009541A1-3B81-101C-92F3-040224009C02}';
  DIID__DImgAdminEvents: TGUID = '{009541A2-3B81-101C-92F3-040224009C02}';
  CLASS_ImgAdmin: TGUID = '{009541A0-3B81-101C-92F3-040224009C02}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum FileTypeValue
type
  FileTypeValue = TOleEnum;
const
  FileTypeUnk = $00000000;
  FileTypeTIFF = $00000001;
  FileTypeAWD = $00000002;
  FileTypeBMP = $00000003;
  FileTypePCX = $00000004;
  FileTypeDCX = $00000005;
  FileTypeJPEG = $00000006;
  FileTypeXIF = $00000007;
  FileTypeGIF = $00000008;
  FileTypeWIFF = $00000009;

// Constants for enum PageTypeValue
type
  PageTypeValue = TOleEnum;
const
  PageTypeUnk = $00000000;
  PageTypeBW = $00000001;
  PageTypeGray4 = $00000002;
  PageTypeGray8 = $00000003;
  PageTypePal4 = $00000004;
  PageTypePal8 = $00000005;
  PageTypeRGB24 = $00000006;
  PageTypeBGR24 = $00000007;

// Constants for enum CompTypeValue
type
  CompTypeValue = TOleEnum;
const
  CompTypeUnk = $00000000;
  CompTypeNone = $00000001;
  CompTypeGroup3 = $00000002;
  CompTypeGroup3Huff = $00000003;
  CompTypePacked = $00000004;
  CompTypeGroup4 = $00000005;
  CompTypeJPEG = $00000006;
  CompTypeGroup32DFax = $00000008;
  CompTypeLZW = $00000009;

// Constants for enum PrintFormatValue
type
  PrintFormatValue = TOleEnum;
const
  OutPixel = $00000000;
  OutActualSize = $00000001;
  OutFitPage = $00000002;

// Constants for enum RangeValue
type
  RangeValue = TOleEnum;
const
  PrintAll = $00000000;
  PrintRange = $00000001;
  PrintCurrent = $00000002;

// Constants for enum DlgOptionValue
type
  DlgOptionValue = TOleEnum;
const
  OpenDlg = $00000000;
  SaveDlg = $00000001;

// Constants for enum VerifyValue
type
  VerifyValue = TOleEnum;
const
  VerifyExists = $00000000;
  VerifyRead = $00000001;
  VerifyWrite = $00000002;
  VerifyReadWrite = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _DImgAdmin = dispinterface;
  _DImgAdminEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ImgAdmin = _DImgAdmin;


// *********************************************************************//
// DispIntf:  _DImgAdmin
// Flags:     (4096) Dispatchable
// GUID:      {009541A1-3B81-101C-92F3-040224009C02}
// *********************************************************************//
  _DImgAdmin = dispinterface
    ['{009541A1-3B81-101C-92F3-040224009C02}']
    property Filter: WideString dispid 1;
    property HelpFile: WideString dispid 2;
    property Flags: Integer dispid 3;
    property DefaultExt: WideString dispid 6;
    property InitDir: WideString dispid 7;
    property Image: WideString dispid 4;
    property PageCount: Integer dispid 12;
    property CompressionInfo: Integer dispid 8;
    property FileType: FileTypeValue dispid 9;
    property FilterIndex: Integer dispid 10;
    property PageNumber: Integer dispid 13;
    property PageType: PageTypeValue dispid 14;
    property HelpCommand: Smallint dispid 11;
    property StatusCode: Integer dispid 5;
    property ImageHeight: Integer dispid 17;
    property ImageWidth: Integer dispid 18;
    property HelpKey: WideString dispid 25;
    property ImageResolutionY: Integer dispid 20;
    property ImageResolutionX: Integer dispid 19;
    property PrintOutputFormat: PrintFormatValue dispid 16;
    property PrintNumCopies: Integer dispid 26;
    property DialogTitle: WideString dispid 22;
    property CancelError: WordBool dispid 23;
    property PrintRangeOption: RangeValue dispid 15;
    property PrintAnnotations: WordBool dispid 27;
    property HelpContextId: Smallint dispid 24;
    property CompressionType: CompTypeValue dispid 21;
    property PrintEndPage: Integer dispid 28;
    property PrintStartPage: Integer dispid 29;
    property PrintToFile: WordBool dispid 30;
    property Author: WideString dispid 31;
    property Comments: WideString dispid 32;
    property Keywords: WideString dispid 33;
    property Subject: WideString dispid 34;
    property Title: WideString dispid 35;
    property SaveAsName: WideString dispid 47;
    function  GetUniqueName(const Path: WideString; const Template: WideString; 
                            const Extension: WideString): WideString; dispid 101;
    procedure CreateDirectory(const lpszPath: WideString); dispid 102;
    procedure Delete(const Object_: WideString); dispid 103;
    procedure ShowPrintDialog(hParentWnd: OleVariant); dispid 104;
    procedure Append(const Source: WideString; SourcePage: Integer; NumPages: Integer; 
                     CompressionType: OleVariant; CompressionInfo: OleVariant); dispid 105;
    function  GetSysCompressionType(ImageType: Smallint): CompTypeValue; dispid 106;
    function  GetSysCompressionInfo(ImageType: Smallint): Integer; dispid 107;
    function  GetSysFileType(ImageType: Smallint): FileTypeValue; dispid 108;
    procedure DeletePages(StartPage: Integer; NumPages: Integer); dispid 109;
    procedure Insert(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                     NumPages: Integer; CompressionType: OleVariant; CompressionInfo: OleVariant); dispid 110;
    procedure Replace(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                      NumPages: Integer; CompressionType: OleVariant; CompressionInfo: OleVariant); dispid 111;
    procedure SetSystemFileAttributes(PageType: PageTypeValue; FileType: FileTypeValue; 
                                      CompressionType: CompTypeValue; CompressionInfo: Integer); dispid 112;
    procedure ShowFileDialog(DialogOption: DlgOptionValue; hParentWnd: OleVariant); dispid 113;
    function  VerifyImage(sOption: VerifyValue): WordBool; dispid 114;
    function  GetVersion: WideString; dispid 115;
    function  ShowFileProperties(const OriginalFile: WideString; 
                                 bShowImageTabForOriginalFile: OleVariant; bIsReadOnly: OleVariant): Integer; dispid 120;
    procedure SetFileProperties; dispid 121;
    procedure AboutBox; dispid -552;
    property PromptICM: WordBool dispid 39;
    property ConvertICM: WordBool dispid 38;
  end;

// *********************************************************************//
// DispIntf:  _DImgAdminEvents
// Flags:     (4096) Dispatchable
// GUID:      {009541A2-3B81-101C-92F3-040224009C02}
// *********************************************************************//
  _DImgAdminEvents = dispinterface
    ['{009541A2-3B81-101C-92F3-040224009C02}']
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TImgAdmin
// Help String      : Kodak Image Admin Control
// Default Interface: _DImgAdmin
// Def. Intf. DISP? : Yes
// Event   Interface: _DImgAdminEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TImgAdmin = class(TOleControl)
  private
    FIntf: _DImgAdmin;
    function  GetControlInterface: _DImgAdmin;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function  GetUniqueName(const Path: WideString; const Template: WideString; 
                            const Extension: WideString): WideString;
    procedure CreateDirectory(const lpszPath: WideString);
    procedure Delete(const Object_: WideString);
    procedure ShowPrintDialog; overload;
    procedure ShowPrintDialog(hParentWnd: OleVariant); overload;
    procedure Append(const Source: WideString; SourcePage: Integer; NumPages: Integer); overload;
    procedure Append(const Source: WideString; SourcePage: Integer; NumPages: Integer; 
                     CompressionType: OleVariant); overload;
    procedure Append(const Source: WideString; SourcePage: Integer; NumPages: Integer; 
                     CompressionType: OleVariant; CompressionInfo: OleVariant); overload;
    function  GetSysCompressionType(ImageType: Smallint): CompTypeValue;
    function  GetSysCompressionInfo(ImageType: Smallint): Integer;
    function  GetSysFileType(ImageType: Smallint): FileTypeValue;
    procedure DeletePages(StartPage: Integer; NumPages: Integer);
    procedure Insert(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                     NumPages: Integer); overload;
    procedure Insert(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                     NumPages: Integer; CompressionType: OleVariant); overload;
    procedure Insert(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                     NumPages: Integer; CompressionType: OleVariant; CompressionInfo: OleVariant); overload;
    procedure Replace(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                      NumPages: Integer); overload;
    procedure Replace(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                      NumPages: Integer; CompressionType: OleVariant); overload;
    procedure Replace(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                      NumPages: Integer; CompressionType: OleVariant; CompressionInfo: OleVariant); overload;
    procedure SetSystemFileAttributes(PageType: PageTypeValue; FileType: FileTypeValue; 
                                      CompressionType: CompTypeValue; CompressionInfo: Integer);
    procedure ShowFileDialog(DialogOption: DlgOptionValue); overload;
    procedure ShowFileDialog(DialogOption: DlgOptionValue; hParentWnd: OleVariant); overload;
    function  VerifyImage(sOption: VerifyValue): WordBool;
    function  GetVersion: WideString;
    function  ShowFileProperties(const OriginalFile: WideString): Integer; overload;
    function  ShowFileProperties(const OriginalFile: WideString; 
                                 bShowImageTabForOriginalFile: OleVariant): Integer; overload;
    function  ShowFileProperties(const OriginalFile: WideString; 
                                 bShowImageTabForOriginalFile: OleVariant; bIsReadOnly: OleVariant): Integer; overload;
    procedure SetFileProperties;
    procedure AboutBox;
    property  ControlInterface: _DImgAdmin read GetControlInterface;
    property  DefaultInterface: _DImgAdmin read GetControlInterface;
    property PromptICM: WordBool index 39 read GetWordBoolProp write SetWordBoolProp;
    property ConvertICM: WordBool index 38 read GetWordBoolProp write SetWordBoolProp;
  published
    property Filter: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property HelpFile: WideString index 2 read GetWideStringProp write SetWideStringProp stored False;
    property Flags: Integer index 3 read GetIntegerProp write SetIntegerProp stored False;
    property DefaultExt: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property InitDir: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property Image: WideString index 4 read GetWideStringProp write SetWideStringProp stored False;
    property PageCount: Integer index 12 read GetIntegerProp write SetIntegerProp stored False;
    property CompressionInfo: Integer index 8 read GetIntegerProp write SetIntegerProp stored False;
    property FileType: TOleEnum index 9 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property FilterIndex: Integer index 10 read GetIntegerProp write SetIntegerProp stored False;
    property PageNumber: Integer index 13 read GetIntegerProp write SetIntegerProp stored False;
    property PageType: TOleEnum index 14 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property HelpCommand: Smallint index 11 read GetSmallintProp write SetSmallintProp stored False;
    property StatusCode: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property ImageHeight: Integer index 17 read GetIntegerProp write SetIntegerProp stored False;
    property ImageWidth: Integer index 18 read GetIntegerProp write SetIntegerProp stored False;
    property HelpKey: WideString index 25 read GetWideStringProp write SetWideStringProp stored False;
    property ImageResolutionY: Integer index 20 read GetIntegerProp write SetIntegerProp stored False;
    property ImageResolutionX: Integer index 19 read GetIntegerProp write SetIntegerProp stored False;
    property PrintOutputFormat: TOleEnum index 16 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property PrintNumCopies: Integer index 26 read GetIntegerProp write SetIntegerProp stored False;
    property DialogTitle: WideString index 22 read GetWideStringProp write SetWideStringProp stored False;
    property CancelError: WordBool index 23 read GetWordBoolProp write SetWordBoolProp stored False;
    property PrintRangeOption: TOleEnum index 15 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property PrintAnnotations: WordBool index 27 read GetWordBoolProp write SetWordBoolProp stored False;
    property HelpContextId: Smallint index 24 read GetSmallintProp write SetSmallintProp stored False;
    property CompressionType: TOleEnum index 21 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property PrintEndPage: Integer index 28 read GetIntegerProp write SetIntegerProp stored False;
    property PrintStartPage: Integer index 29 read GetIntegerProp write SetIntegerProp stored False;
    property PrintToFile: WordBool index 30 read GetWordBoolProp write SetWordBoolProp stored False;
    property Author: WideString index 31 read GetWideStringProp write SetWideStringProp stored False;
    property Comments: WideString index 32 read GetWideStringProp write SetWideStringProp stored False;
    property Keywords: WideString index 33 read GetWideStringProp write SetWideStringProp stored False;
    property Subject: WideString index 34 read GetWideStringProp write SetWideStringProp stored False;
    property Title: WideString index 35 read GetWideStringProp write SetWideStringProp stored False;
    property SaveAsName: WideString index 47 read GetWideStringProp write SetWideStringProp stored False;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ZJHOA';

implementation

uses ComObj;

procedure TImgAdmin.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{009541A0-3B81-101C-92F3-040224009C02}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004005*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TImgAdmin.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DImgAdmin;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TImgAdmin.GetControlInterface: _DImgAdmin;
begin
  CreateControl;
  Result := FIntf;
end;

function  TImgAdmin.GetUniqueName(const Path: WideString; const Template: WideString; 
                                  const Extension: WideString): WideString;
begin
  DefaultInterface.GetUniqueName(Path, Template, Extension);
end;

procedure TImgAdmin.CreateDirectory(const lpszPath: WideString);
begin
  DefaultInterface.CreateDirectory(lpszPath);
end;

procedure TImgAdmin.Delete(const Object_: WideString);
begin
  DefaultInterface.Delete(Object_);
end;

procedure TImgAdmin.ShowPrintDialog;
begin
  DefaultInterface.ShowPrintDialog(EmptyParam);
end;

procedure TImgAdmin.ShowPrintDialog(hParentWnd: OleVariant);
begin
  DefaultInterface.ShowPrintDialog(hParentWnd);
end;

procedure TImgAdmin.Append(const Source: WideString; SourcePage: Integer; NumPages: Integer);
begin
  DefaultInterface.Append(Source, SourcePage, NumPages, EmptyParam, EmptyParam);
end;

procedure TImgAdmin.Append(const Source: WideString; SourcePage: Integer; NumPages: Integer; 
                           CompressionType: OleVariant);
begin
  DefaultInterface.Append(Source, SourcePage, NumPages, CompressionType, EmptyParam);
end;

procedure TImgAdmin.Append(const Source: WideString; SourcePage: Integer; NumPages: Integer; 
                           CompressionType: OleVariant; CompressionInfo: OleVariant);
begin
  DefaultInterface.Append(Source, SourcePage, NumPages, CompressionType, CompressionInfo);
end;

function  TImgAdmin.GetSysCompressionType(ImageType: Smallint): CompTypeValue;
begin
  Result := DefaultInterface.GetSysCompressionType(ImageType);
end;

function  TImgAdmin.GetSysCompressionInfo(ImageType: Smallint): Integer;
begin
  Result := DefaultInterface.GetSysCompressionInfo(ImageType);
end;

function  TImgAdmin.GetSysFileType(ImageType: Smallint): FileTypeValue;
begin
  Result := DefaultInterface.GetSysFileType(ImageType);
end;

procedure TImgAdmin.DeletePages(StartPage: Integer; NumPages: Integer);
begin
  DefaultInterface.DeletePages(StartPage, NumPages);
end;

procedure TImgAdmin.Insert(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                           NumPages: Integer);
begin
  DefaultInterface.Insert(Source, SourcePage, DestinationPage, NumPages, EmptyParam, EmptyParam);
end;

procedure TImgAdmin.Insert(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                           NumPages: Integer; CompressionType: OleVariant);
begin
  DefaultInterface.Insert(Source, SourcePage, DestinationPage, NumPages, CompressionType, EmptyParam);
end;

procedure TImgAdmin.Insert(const Source: WideString; SourcePage: Integer; DestinationPage: Integer; 
                           NumPages: Integer; CompressionType: OleVariant; 
                           CompressionInfo: OleVariant);
begin
  DefaultInterface.Insert(Source, SourcePage, DestinationPage, NumPages, CompressionType, 
                          CompressionInfo);
end;

procedure TImgAdmin.Replace(const Source: WideString; SourcePage: Integer; 
                            DestinationPage: Integer; NumPages: Integer);
begin
  DefaultInterface.Replace(Source, SourcePage, DestinationPage, NumPages, EmptyParam, EmptyParam);
end;

procedure TImgAdmin.Replace(const Source: WideString; SourcePage: Integer; 
                            DestinationPage: Integer; NumPages: Integer; CompressionType: OleVariant);
begin
  DefaultInterface.Replace(Source, SourcePage, DestinationPage, NumPages, CompressionType, 
                           EmptyParam);
end;

procedure TImgAdmin.Replace(const Source: WideString; SourcePage: Integer; 
                            DestinationPage: Integer; NumPages: Integer; 
                            CompressionType: OleVariant; CompressionInfo: OleVariant);
begin
  DefaultInterface.Replace(Source, SourcePage, DestinationPage, NumPages, CompressionType, 
                           CompressionInfo);
end;

procedure TImgAdmin.SetSystemFileAttributes(PageType: PageTypeValue; FileType: FileTypeValue; 
                                            CompressionType: CompTypeValue; CompressionInfo: Integer);
begin
  DefaultInterface.SetSystemFileAttributes(PageType, FileType, CompressionType, CompressionInfo);
end;

procedure TImgAdmin.ShowFileDialog(DialogOption: DlgOptionValue);
begin
  DefaultInterface.ShowFileDialog(DialogOption, EmptyParam);
end;

procedure TImgAdmin.ShowFileDialog(DialogOption: DlgOptionValue; hParentWnd: OleVariant);
begin
  DefaultInterface.ShowFileDialog(DialogOption, hParentWnd);
end;

function  TImgAdmin.VerifyImage(sOption: VerifyValue): WordBool;
begin
  Result := DefaultInterface.VerifyImage(sOption);
end;

function  TImgAdmin.GetVersion: WideString;
begin
  Result := DefaultInterface.GetVersion;
end;

function  TImgAdmin.ShowFileProperties(const OriginalFile: WideString): Integer;
begin
  Result := DefaultInterface.ShowFileProperties(OriginalFile, EmptyParam, EmptyParam);
end;

function  TImgAdmin.ShowFileProperties(const OriginalFile: WideString; 
                                       bShowImageTabForOriginalFile: OleVariant): Integer;
begin
  Result := DefaultInterface.ShowFileProperties(OriginalFile, bShowImageTabForOriginalFile, EmptyParam);
end;

function  TImgAdmin.ShowFileProperties(const OriginalFile: WideString; 
                                       bShowImageTabForOriginalFile: OleVariant; 
                                       bIsReadOnly: OleVariant): Integer;
begin
  Result := DefaultInterface.ShowFileProperties(OriginalFile, bShowImageTabForOriginalFile, bIsReadOnly);
end;

procedure TImgAdmin.SetFileProperties;
begin
  DefaultInterface.SetFileProperties;
end;

procedure TImgAdmin.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents(SOFTWARE_NAME,[TImgAdmin]);
end;

end.





