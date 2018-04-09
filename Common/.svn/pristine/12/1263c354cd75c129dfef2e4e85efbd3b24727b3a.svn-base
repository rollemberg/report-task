unit CalMrpNum_class;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, DB, ADODB, Grids, DBGrids, ComCtrls, ApConst,
  StdCtrls, Buttons, DateUtils, Math, AppBean, NetRegistry;

type
  //
  THRCalMrpNumKind = (mrpNone, mrpOrdNum, mrpMakeNum, mrpPlanNum, mrpReqNum, mrpPurNum);
  //重算Mrp参量
  THRCalMrpNum = class(TAppBean)
  private
    FPartCode: String;
    FKind: THRCalMrpNumKind;
    procedure SetPartCode(const Value: String);
    procedure SetKind(const Value: THRCalMrpNumKind);
  public
    constructor Create(AOwner: TComponent); override;
    function Execute(const Param: OleVariant; var Data: OleVariant): Boolean; override;
    property PartCode: String read FPartCode write SetPartCode;
    property Kind: THRCalMrpNumKind read FKind write SetKind;
    procedure Update; overload;
    procedure Update(const APartCode: String); overload;
    procedure Update(const APartCode: String; AKind: THRCalMrpNumKind); overload;
  end;
  function GetCostDeptWHCode(Sender: TAppBean; var TOTALWH: String): Boolean;

implementation

function GetCostDeptWHCode(Sender: TAppBean; var TOTALWH: String): Boolean;
var
  cdsTmp: TAppQuery;
  nreg: TNetRegistry;
begin
  TOTALWH := 'TOTAL';
  nreg := TNetRegistry.Create(Sender);
  try
    if nreg.ReadInit('system', 'SYS08008') = 0 then
      begin
        Result := False;
      end
    else
      begin
        Result := True;
        if Sender.Session.Version = 2008 then
          begin
            {$message '此处可用于处理一个帐号多个成本中心的问题，Jason at 2010/8/28'}
            cdsTmp := TAppQuery.Create(nil);
            try
              with cdsTmp do
              begin
                Connection := Sender.Session.Connection;
                SQL.Text := Format('Select CostDept_ From SysUserProperty '
                  + 'Where UserCode_=''%s''',
                  [Sender.Session.UserCode]);
                Open;
                if not Eof then
                  TOTALWH := FieldByName('CostDept_').AsString;
              end;
            finally
              cdsTmp.Free;
            end;
          end
        else
          TOTALWH := Sender.Session.CostDept;
      end;
  finally
    nreg.Free;
  end;
end;

{ THRCalMrpNum }

constructor THRCalMrpNum.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FKind := mrpNone;
end;

function THRCalMrpNum.Execute(const Param: OleVariant;
  var Data: OleVariant): Boolean;
begin
  Result := False;
end;

procedure THRCalMrpNum.SetKind(const Value: THRCalMrpNumKind);
begin
  FKind := Value;
end;

procedure THRCalMrpNum.SetPartCode(const Value: String);
begin
  FPartCode := Value;
end;

procedure THRCalMrpNum.Update;
var
  sKind: String;
begin
  sKind := '';
  case Kind of
  mrpOrdNum: sKind := 'OrdNum';
  mrpMakeNum: sKind := 'MakeNum';
  mrpPlanNum: sKind := 'PlanNum';
  mrpReqNum: sKind := 'ReqNum';
  mrpPurNum: sKind := 'PurNum';
  else
    raise Exception.Create(ChineseAsString('RS001', 'THRCalMrpNum.Kind没有被初始化，调用失败！'));
  end;
  if sKind <> '' then
    Session.Connection.Execute(Format('CalMrpNum ''%s'', ''%s'', ''%s''',
      [Self.Session.UserCode, sKind, PartCode]));
end;

procedure THRCalMrpNum.Update(const APartCode: String);
begin
  PartCode := APartCode;
  Update;
end;

procedure THRCalMrpNum.Update(const APartCode: String;
  AKind: THRCalMrpNumKind);
begin
  PartCode := APartCode;
  Kind := AKind;
  Update;
end;

end.
