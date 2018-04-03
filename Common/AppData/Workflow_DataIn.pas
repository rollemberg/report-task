unit Workflow_DataIn;

interface

uses
  AppBean, AppData, Variants;

type
  TWorkflow_DataIn = class(TAppData)
  private
    FCurStatus: Integer;
    FTBID: String;
    FFlowCode: String;
    FFlowClass: Integer;
    FNewStatus: Integer;
    procedure SetCurStatus(const Value: Integer);
    procedure SetFlowClass(const Value: Integer);
    procedure SetFlowCode(const Value: String);
    procedure SetNewStatus(const Value: Integer);
    procedure SetTBID(const Value: String);
  public
    procedure SetVariant(const Value: Variant); override;
    function GetVariant: Variant; override;
  published
    property TBID: String read FTBID write SetTBID;
    property CurStatus: Integer read FCurStatus write SetCurStatus;
    property NewStatus: Integer read FNewStatus write SetNewStatus;
    property FlowClass: Integer read FFlowClass write SetFlowClass;
    property FlowCode: String read FFlowCode write SetFlowCode;
  end;

implementation

{ TWorkflow_DataIn }

function TWorkflow_DataIn.GetVariant: Variant;
begin
  if FlowClass = 0 then
    Result := VarArrayOf([TBID, CurStatus, NewStatus, FlowCode])
  else
    Result := VarArrayOf([TBID, CurStatus, NewStatus, FlowClass]);
end;

procedure TWorkflow_DataIn.SetCurStatus(const Value: Integer);
begin
  FCurStatus := Value;
end;

procedure TWorkflow_DataIn.SetFlowClass(const Value: Integer);
begin
  FFlowClass := Value;
end;

procedure TWorkflow_DataIn.SetFlowCode(const Value: String);
begin
  FFlowCode := Value;
end;

procedure TWorkflow_DataIn.SetNewStatus(const Value: Integer);
begin
  FNewStatus := Value;
end;

procedure TWorkflow_DataIn.SetTBID(const Value: String);
begin
  FTBID := Value;
end;

procedure TWorkflow_DataIn.SetVariant(const Value: Variant);
begin
  FTBID := Value[0];
  FCurStatus := Value[1];
  FNewStatus := Value[2];
  if VarIsNumeric(Value[3]) then
    FFlowClass := Value[3]
  else
    FFlowCode := Value[3];
end;

end.
