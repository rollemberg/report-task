unit OrdMarkFra;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, DBCtrls, StdCtrls, ExtCtrls, ComCtrls, DB, DBClient, ZjhCtrls,
  DocumentFra, Buttons, uBaseIntf;

type
  TFraOrdMark = class(TFrame)
    cdsView: TZjhDataSet;
    cdsViewCode_: TWideStringField;
    cdsViewName_: TWideStringField;
    cdsViewUpdateKey_: TGuidField;
    dsView: TDataSource;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    cdsViewMark1_: TWideMemoField;
    cdsViewMark2_: TWideMemoField;
    TabSheet3: TTabSheet;
    DBMOrdMark1: TDBMemo;
    Panel2: TPanel;
    sbSave: TSpeedButton;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBMOrdMark2: TDBMemo;
    Panel3: TPanel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label1: TLabel;
    TabSheet4: TTabSheet;
    DBMOrdMark3: TDBMemo;
    cdsViewOther_: TWideMemoField;
    procedure sbSaveClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    FActive: Boolean;
    FMarkNo: String;
    FraDoc: TFraDocument;
    procedure SetActive(const Value: Boolean);
    procedure SetMarkNo(const Value: String);
    procedure SetReadOnly(const Value: Boolean);
    function GetReadOnly: Boolean;
  public
    { Public declarations }
    property Active: Boolean read FActive write SetActive;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property MarkNo: String read FMarkNo write SetMarkNo;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    //function PostMessage(MsgType: Integer; Msg: Variant): Variant; override; // add by jrlee at 2006/5/17
    procedure RefreshView(const Flag: Boolean);
    procedure Save;
  end;

implementation

uses ApConst;

{$R *.dfm}

{ TFraOrdMark }

constructor TFraOrdMark.Create(AOwner: TComponent);
begin
  inherited;
  PageControl1.ActivePageIndex := 0;
  sbSave.Visible := not ReadOnly;
  //
  FraDoc := CreateClass('TFraDocument', Self) as TFraDocument;
  FraDoc.DefRootName := Chinese.AsString('订单唛头资料');
  FraDoc.RootID := DOC_ORDMARK_GUID;
  FraDoc.Parent := TabSheet3;
  FraDoc.Visible := True;
  FraDoc.ReadOnly := ReadOnly;
end;

procedure TFraOrdMark.RefreshView(const Flag: Boolean);
begin
  if Flag then
    begin
      with cdsView do
      begin
        Active := False;
        if MarkNo <> '' then
        begin
          CommandText := Format('Select * From WL_OrdMark '
            + 'Where Code_=''%s''', [MarkNo]);
          Open;
          if Eof and (not ReadOnly) then
          begin
            if MessageDlg(Chinese.AsString(Format('唛头编号 %s 不存在，要增加吗？',
              [MarkNo])),mtConfirmation,[mbYes,mbNo],0) = mrYes then
              begin
                Append;
                FieldByName('Code_').AsString := MarkNo;
                FieldByName('Name_').AsString := Chinese.AsString('(请在此输入唛头名称)');
                Post;
              end
            else
              Self.ReadOnly := False;
          end;
        end;
        if Active and (RecordCount > 0) then
          begin
            FraDoc.PathName := MarkNo;
            FraDoc.Active := True;
          end
        else
          FraDoc.RefreshView(False);
      end;
    end
  else
    begin
      with cdsView do
      begin
        if not Active then Exit;
        if State in [dsInsert, dsEdit] then Post;
        if (ChangeCount > 0) and (MessageDlg(Chinese.AsString('当前数据没有保存，您真的要保存并退出吗？'),mtConfirmation,
          [mbYes,mbNo,mbCancel],0) = mrYes) then PostPro(0);
      end;
      Active := False;
      FraDoc.RefreshView(False);
    end;
end;

procedure TFraOrdMark.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RefreshView(Value);
  end;
end;

procedure TFraOrdMark.SetMarkNo(const Value: String);
begin
  if FMarkNo <> Value then
  begin
    FMarkNo := Value;
    if FActive then RefreshView(True);
  end;
end;

procedure TFraOrdMark.SetReadOnly(const Value: Boolean);
begin
  cdsView.ReadOnly := Value;
  FraDoc.ReadOnly := Value;
  sbSave.Visible := not Value;
end;

function TFraOrdMark.GetReadOnly: Boolean;
begin
  Result := cdsView.ReadOnly;
end;

procedure TFraOrdMark.sbSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TFraOrdMark.Save;
begin
  with cdsView do
  begin
    if Active and (not ReadOnly) then PostPro(0);
  end;
end;

procedure TFraOrdMark.Label1Click(Sender: TObject);
begin
  MainIntf.GetForm('TFrmOrdMark');
end;

initialization
  RegClass(TFraOrdMark);

finalization
  UnRegClass(TFraOrdMark);

end.
