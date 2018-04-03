unit ScanLibCtl_TLB;

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
// File generated on 2002/11/7 ÉÏÎç 07:55:46 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINNT\system32\ImgScan.ocx (1)
// LIBID: {84926CA3-2941-101C-816F-0E6013114B7F}
// LCID: 0
// Helpfile: C:\WINNT\Help\imgocxd.hlp
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\stdvcl40.dll)
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
  ScanLibCtlMajorVersion = 1;
  ScanLibCtlMinorVersion = 0;

  LIBID_ScanLibCtl: TGUID = '{84926CA3-2941-101C-816F-0E6013114B7F}';

  DIID__DImgScan: TGUID = '{84926CA1-2941-101C-816F-0E6013114B7F}';
  DIID__DImgScanEvents: TGUID = '{84926CA2-2941-101C-816F-0E6013114B7F}';
  CLASS_ImgScan: TGUID = '{84926CA0-2941-101C-816F-0E6013114B7F}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum FileTypeConstants
type
  FileTypeConstants = TOleEnum;
const
  TIFF = $00000001;
  AWD_MicrosoftFax = $00000002;
  BMP_Bitmap = $00000003;
  JPG_File = $00000006;

// Constants for enum CompressionTypeConstants
type
  CompressionTypeConstants = TOleEnum;
const
  NoCompression = $00000001;
  CCITTGroup3_1d_Fax = $00000002;
  CCITTGroup3_1d_ModifiedHuffman = $00000003;
  PackedBits = $00000004;
  CCITTGroup4_2d_Fax = $00000005;
  JPEG = $00000006;
  LZW = $00000007;

// Constants for enum PageOptionConstants
type
  PageOptionConstants = TOleEnum;
const
  CreateNewFile = $00000000;
  PromptToCreateNewFile = $00000001;
  AppendPages = $00000002;
  InsertPages = $00000003;
  OverwritePages = $00000004;
  PromptToOverwritePages = $00000005;
  OverwriteAllPages = $00000006;

// Constants for enum PageTypeConstants
type
  PageTypeConstants = TOleEnum;
const
  BlackAndWhite = $00000001;
  Gray16Shades = $00000002;
  Gray256Shades = $00000003;
  Color16Count = $00000004;
  Color256Count = $00000005;
  TrueColor24bit = $00000006;
  HighColor24bit = $00000007;

// Constants for enum ImageTypeConstants
type
  ImageTypeConstants = TOleEnum;
const
  BlackAndWhite1Bit = $00000001;
  Gray4Bit = $00000002;
  Gray8Bit = $00000003;
  ColorPal8Bit = $00000004;
  TrueColor24bitRGB = $00000005;
  ColorPal4Bit = $00000006;

// Constants for enum CompPreferenceConstants
type
  CompPreferenceConstants = TOleEnum;
const
  BestDisplay = $00000000;
  GoodDisplay = $00000001;
  SmallestFile = $00000002;
  CustomSettings = $00000003;

// Constants for enum CompTypeConstants
type
  CompTypeConstants = TOleEnum;
const
  Uncompressed = $00000000;
  CCITTGroup31D = $00000001;
  CCITTGroup42D = $00000002;
  TIFFPackbits = $00000004;
  JPEGCompression = $00000008;
  LZWCompression = $00000015;

// Constants for enum CompInfoConstants
type
  CompInfoConstants = TOleEnum;
const
  NoCompInfo = $00000000;
  G31DModifiedHuffman = $00001000;
  G31DModifiedHuffmanRBO = $00000000;
  G31DFax = $00001900;
  G31DFaxRBO = $00000900;
  G42DFax = $00001200;
  G42DFaxRBO = $00000200;
  TIFFPackbitsInfo = $00000000;
  LZWInfo = $00000000;
  JPEGLowLow = $00002D5A;
  JPEGLowMed = $00001E3C;
  JPEGLowHigh = $00000F1E;
  JPEGMedLow = $00006D5A;
  JPEGMedMed = $00005E3C;
  JPEGMedHigh = $00004F1E;
  JPEGHighLow = $FFFFAD5A;
  JPEGHighMed = $FFFF9E3C;
  JPEGHighHigh = $FFFF8F1E;

// Constants for enum ScanToConstants
type
  ScanToConstants = TOleEnum;
const
  DisplayOnly = $00000000;
  DisplayAndFile = $00000001;
  FileOnly = $00000002;
  DisplayAndUseFileTemplate = $00000003;
  UseFileTemplateOnly = $00000004;
  FaxOnly = $00000005;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _DImgScan = dispinterface;
  _DImgScanEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ImgScan = _DImgScan;


// *********************************************************************//
// DispIntf:  _DImgScan
// Flags:     (4096) Dispatchable
// GUID:      {84926CA1-2941-101C-816F-0E6013114B7F}
// *********************************************************************//
  _DImgScan = dispinterface
    ['{84926CA1-2941-101C-816F-0E6013114B7F}']
    property PageCount: Integer dispid 7;
    property StatusCode: Integer dispid 8;
    property Image: WideString dispid 1;
    property DestImageControl: WideString dispid 2;
    function  ShowScannerSetup: Integer; dispid 101;
    function  GetPageTypeCompressionType(ImageType: ImageTypeConstants): CompTypeConstants; dispid 115;
    property Page: Integer dispid 5;
    property PageOption: PageOptionConstants dispid 6;
    function  OpenScanner: Integer; dispid 100;
    property ScanTo: ScanToConstants dispid 14;
    property MultiPage: WordBool dispid 13;
    property ShowSetupBeforeScan: WordBool dispid 16;
    property Scroll: WordBool dispid 3;
    property StopScanBox: WordBool dispid 4;
    property Zoom: Single dispid 15;
    property FileType: FileTypeConstants dispid 9;
    function  StartScan: Integer; dispid 102;
    function  CloseScanner: Integer; dispid 103;
    function  ScannerAvailable: WordBool; dispid 104;
    function  ShowSelectScanner: Integer; dispid 105;
    function  StopScan: Integer; dispid 106;
    function  ResetScanner: Integer; dispid 107;
    function  ShowScanNew(Modal: OleVariant): Integer; dispid 108;
    function  ShowScanPage(Modal: OleVariant): Integer; dispid 109;
    function  ShowScanPreferences: Integer; dispid 112;
    procedure SetScannerName(const szScannerName: WideString); dispid 119;
    function  GetPageTypeCompressionInfo(ImageType: ImageTypeConstants): CompInfoConstants; dispid 116;
    function  GetVersion: WideString; dispid 111;
    function  SetPageTypeCompressionOpts(CompPref: CompPreferenceConstants; 
                                         ImageType: ImageTypeConstants; 
                                         CompType: CompTypeConstants; CompInfo: CompInfoConstants): Smallint; dispid 118;
    procedure SetExternalImageName(const szImageTitle: WideString); dispid 110;
    procedure AboutBox; dispid -552;
    function  GetCompressionPreference: CompPreferenceConstants; dispid 117;
    property CompressionInfo: Integer dispid 12;
    property CompressionType: CompressionTypeConstants dispid 11;
    property PageType: PageTypeConstants dispid 10;
  end;

// *********************************************************************//
// DispIntf:  _DImgScanEvents
// Flags:     (4096) Dispatchable
// GUID:      {84926CA2-2941-101C-816F-0E6013114B7F}
// *********************************************************************//
  _DImgScanEvents = dispinterface
    ['{84926CA2-2941-101C-816F-0E6013114B7F}']
    procedure ScanStarted; dispid 1;
    procedure ScanDone; dispid 2;
    procedure PageDone(PageNumber: Integer); dispid 3;
    procedure ScanUIDone; dispid 4;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TImgScan
// Help String      : Kodak Image Scan Control
// Default Interface: _DImgScan
// Def. Intf. DISP? : Yes
// Event   Interface: _DImgScanEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TImgScanPageDone = procedure(Sender: TObject; PageNumber: Integer) of object;

  TImgScan = class(TOleControl)
  private
    FOnScanStarted: TNotifyEvent;
    FOnScanDone: TNotifyEvent;
    FOnPageDone: TImgScanPageDone;
    FOnScanUIDone: TNotifyEvent;
    FIntf: _DImgScan;
    function  GetControlInterface: _DImgScan;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function  ShowScannerSetup: Integer;
    function  GetPageTypeCompressionType(ImageType: ImageTypeConstants): CompTypeConstants;
    function  OpenScanner: Integer;
    function  StartScan: Integer;
    function  CloseScanner: Integer;
    function  ScannerAvailable: WordBool;
    function  ShowSelectScanner: Integer;
    function  StopScan: Integer;
    function  ResetScanner: Integer;
    function  ShowScanNew: Integer; overload;
    function  ShowScanNew(Modal: OleVariant): Integer; overload;
    function  ShowScanPage: Integer; overload;
    function  ShowScanPage(Modal: OleVariant): Integer; overload;
    function  ShowScanPreferences: Integer;
    procedure SetScannerName(const szScannerName: WideString);
    function  GetPageTypeCompressionInfo(ImageType: ImageTypeConstants): CompInfoConstants;
    function  GetVersion: WideString;
    function  SetPageTypeCompressionOpts(CompPref: CompPreferenceConstants; 
                                         ImageType: ImageTypeConstants; 
                                         CompType: CompTypeConstants; CompInfo: CompInfoConstants): Smallint;
    procedure SetExternalImageName(const szImageTitle: WideString);
    procedure AboutBox;
    function  GetCompressionPreference: CompPreferenceConstants;
    property  ControlInterface: _DImgScan read GetControlInterface;
    property  DefaultInterface: _DImgScan read GetControlInterface;
    property CompressionInfo: Integer index 12 read GetIntegerProp write SetIntegerProp;
    property CompressionType: TOleEnum index 11 read GetTOleEnumProp write SetTOleEnumProp;
    property PageType: TOleEnum index 10 read GetTOleEnumProp write SetTOleEnumProp;
  published
    property PageCount: Integer index 7 read GetIntegerProp write SetIntegerProp stored False;
    property StatusCode: Integer index 8 read GetIntegerProp write SetIntegerProp stored False;
    property Image: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property DestImageControl: WideString index 2 read GetWideStringProp write SetWideStringProp stored False;
    property Page: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property PageOption: TOleEnum index 6 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property ScanTo: TOleEnum index 14 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property MultiPage: WordBool index 13 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowSetupBeforeScan: WordBool index 16 read GetWordBoolProp write SetWordBoolProp stored False;
    property Scroll: WordBool index 3 read GetWordBoolProp write SetWordBoolProp stored False;
    property StopScanBox: WordBool index 4 read GetWordBoolProp write SetWordBoolProp stored False;
    property Zoom: Single index 15 read GetSingleProp write SetSingleProp stored False;
    property FileType: TOleEnum index 9 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property OnScanStarted: TNotifyEvent read FOnScanStarted write FOnScanStarted;
    property OnScanDone: TNotifyEvent read FOnScanDone write FOnScanDone;
    property OnPageDone: TImgScanPageDone read FOnPageDone write FOnPageDone;
    property OnScanUIDone: TNotifyEvent read FOnScanUIDone write FOnScanUIDone;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ZJHOA';

implementation

uses ComObj;

procedure TImgScan.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $00000001, $00000002, $00000003, $00000004);
  CControlData: TControlData2 = (
    ClassID: '{84926CA0-2941-101C-816F-0E6013114B7F}';
    EventIID: '{84926CA2-2941-101C-816F-0E6013114B7F}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004005*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnScanStarted) - Cardinal(Self);
end;

procedure TImgScan.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DImgScan;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TImgScan.GetControlInterface: _DImgScan;
begin
  CreateControl;
  Result := FIntf;
end;

function  TImgScan.ShowScannerSetup: Integer;
begin
  Result := DefaultInterface.ShowScannerSetup;
end;

function  TImgScan.GetPageTypeCompressionType(ImageType: ImageTypeConstants): CompTypeConstants;
begin
  Result := DefaultInterface.GetPageTypeCompressionType(ImageType);
end;

function  TImgScan.OpenScanner: Integer;
begin
  Result := DefaultInterface.OpenScanner;
end;

function  TImgScan.StartScan: Integer;
begin
  Result := DefaultInterface.StartScan;
end;

function  TImgScan.CloseScanner: Integer;
begin
  Result := DefaultInterface.CloseScanner;
end;

function  TImgScan.ScannerAvailable: WordBool;
begin
  Result := DefaultInterface.ScannerAvailable;
end;

function  TImgScan.ShowSelectScanner: Integer;
begin
  Result := DefaultInterface.ShowSelectScanner;
end;

function  TImgScan.StopScan: Integer;
begin
  Result := DefaultInterface.StopScan;
end;

function  TImgScan.ResetScanner: Integer;
begin
  Result := DefaultInterface.ResetScanner;
end;

function  TImgScan.ShowScanNew: Integer;
begin
  Result := DefaultInterface.ShowScanNew(EmptyParam);
end;

function  TImgScan.ShowScanNew(Modal: OleVariant): Integer;
begin
  Result := DefaultInterface.ShowScanNew(Modal);
end;

function  TImgScan.ShowScanPage: Integer;
begin
  Result := DefaultInterface.ShowScanPage(EmptyParam);
end;

function  TImgScan.ShowScanPage(Modal: OleVariant): Integer;
begin
  Result := DefaultInterface.ShowScanPage(Modal);
end;

function  TImgScan.ShowScanPreferences: Integer;
begin
  Result := DefaultInterface.ShowScanPreferences;
end;

procedure TImgScan.SetScannerName(const szScannerName: WideString);
begin
  DefaultInterface.SetScannerName(szScannerName);
end;

function  TImgScan.GetPageTypeCompressionInfo(ImageType: ImageTypeConstants): CompInfoConstants;
begin
  Result := DefaultInterface.GetPageTypeCompressionInfo(ImageType);
end;

function  TImgScan.GetVersion: WideString;
begin
  DefaultInterface.GetVersion;
end;

function  TImgScan.SetPageTypeCompressionOpts(CompPref: CompPreferenceConstants; 
                                              ImageType: ImageTypeConstants; 
                                              CompType: CompTypeConstants; 
                                              CompInfo: CompInfoConstants): Smallint;
begin
  Result := DefaultInterface.SetPageTypeCompressionOpts(CompPref, ImageType, CompType, CompInfo);
end;

procedure TImgScan.SetExternalImageName(const szImageTitle: WideString);
begin
  DefaultInterface.SetExternalImageName(szImageTitle);
end;

procedure TImgScan.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

function  TImgScan.GetCompressionPreference: CompPreferenceConstants;
begin
  Result := DefaultInterface.GetCompressionPreference;
end;

procedure Register;
begin
  RegisterComponents(SOFTWARE_NAME,[TImgScan]);
end;

end.
