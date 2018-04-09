unit DatetimeSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, Calendar, StdCtrls, Buttons, DB, ZjhCtrls, ComCtrls,
  DBForms, uBaseIntf, ApConst;

type
  TSelectDatetime = class(TDBForm, ISelectDialog)
    Panel3: TPanel;
    Panel4: TPanel;
    MonthCalendar1: TCalendar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    BitBtn4: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    s: TZjhSkin;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure MonthCalendar1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefrushDate();
  public
    { Public declarations }
    procedure Display(const Sender: TObject; const Param: Variant);
    function Execute(const Args: array of TObject; const Param: Variant): Variant;
  end;

implementation

uses InfoBox;

{$R *.dfm}

procedure TSelectDatetime.RefrushDate;
begin
  Label2.Caption := IntToStr(MonthCalendar1.Year) + Chinese.AsString('年');
  Label1.Caption := IntToStr(MonthCalendar1.Month) + Chinese.AsString('月');
end;

procedure TSelectDatetime.FormCreate(Sender: TObject);
begin
  MonthCalendar1.CalendarDate := Date();
  RefrushDate;
end;

procedure TSelectDatetime.BitBtn3Click(Sender: TObject);
begin
  MonthCalendar1.CalendarDate := Date();
  ModalResult := mrOk;
end;

procedure TSelectDatetime.BitBtn1Click(Sender: TObject);
begin
  if MonthCalendar1.Day = 1 then
    begin
      if MonthCalendar1.Month = 1 then
        begin
          MonthCalendar1.PrevYear;
          MonthCalendar1.Month :=12;
        end
      else
        MonthCalendar1.PrevMonth;
      case MonthCalendar1.Month of
      4,6,9,11:MonthCalendar1.Day := 30;
      1,3,5,7,8,10,12:MonthCalendar1.Day := 31;
      2:begin
          if ((MonthCalendar1.Year mod 4) = 0) and not((MonthCalendar1.Year mod 100) = 0) then
            MonthCalendar1.Day := 29
          else MonthCalendar1.Day := 28;
        end;
      end;
    end
  else
    MonthCalendar1.Day := MonthCalendar1.Day - 1;
  ModalResult := mrOk;
end;

procedure TSelectDatetime.BitBtn2Click(Sender: TObject);
var
  Day: integer;
begin
  Day := 30;
  case MonthCalendar1.Month of
    4,6,9,11: Day := 30;
    1,3,5,7,8,10,12: Day := 31;
    2:begin
      if ((MonthCalendar1.Year mod 4) = 0) and not((MonthCalendar1.Year mod 100) = 0) then
        Day := 29
      else Day := 28;
    end;
  end;
  if MonthCalendar1.Day = Day then
    begin
      if MonthCalendar1.Month = 12 then
        begin
          MonthCalendar1.NextYear;
          MonthCalendar1.Month :=1;
        end
      else MonthCalendar1.NextMonth;
      MonthCalendar1.Day := 1;
    end
  else
    MonthCalendar1.Day := MonthCalendar1.Day + 1;
  ModalResult := mrOk;
end;

procedure TSelectDatetime.BitBtn5Click(Sender: TObject);
begin
  MonthCalendar1.PrevMonth;
  ModalResult := mrOk;
end;

procedure TSelectDatetime.BitBtn6Click(Sender: TObject);
begin
  MonthCalendar1.NextMonth;
  ModalResult := mrOk;
end;

procedure TSelectDatetime.SpeedButton1Click(Sender: TObject);
begin
  MonthCalendar1.PrevYear;
  RefrushDate();
end;

procedure TSelectDatetime.SpeedButton2Click(Sender: TObject);
begin
  MonthCalendar1.PrevMonth;
  RefrushDate();
end;

procedure TSelectDatetime.SpeedButton3Click(Sender: TObject);
begin
  MonthCalendar1.NextMonth;
  RefrushDate();
end;

procedure TSelectDatetime.SpeedButton4Click(Sender: TObject);
begin
  MonthCalendar1.NextYear;
  RefrushDate();
end;

procedure TSelectDatetime.BitBtn4Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSelectDatetime.MonthCalendar1DblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TSelectDatetime.Display(const Sender: TObject;
  const Param: Variant);
begin
  ;
end;

function TSelectDatetime.Execute(const Args: array of TObject;
  const Param: Variant): Variant;
begin
  RefrushDate(); //add by jrlee at 2006/7/3
  if High(Args) = -1 then
    begin
      if ShowModal = mrOK then
        Result :=MonthCalendar1.CalendarDate;
    end
  else
    begin
      Result := ShowModal = mrOk;
      if Result then
      begin
        if Args[0] is TCustomEdit then
          TCustomEdit(Args[0]).Text := DateToStr(MonthCalendar1.CalendarDate)
        else if Args[0] is TField then
          begin
            TField(Args[0]).DataSet.Edit;
            TField(Args[0]).AsDateTime := MonthCalendar1.CalendarDate;
          end
        else if Args[0] is TDateTimePicker then
          TDateTimePicker(Args[0]).Date := MonthCalendar1.CalendarDate
        else
          raise Exception.CreateFmt(Chinese.AsString('不能支持的类别：%s'),[Args[0].ClassName]);
      end;
    end;
  if High(Args) <> -1 then   // Modify by jrlee 2006/04/05 增加条件,否则用GetSelectDate报错
  begin
    if Args[0] is TDateTimePicker then
      MonthCalendar1.CalendarDate := TDateTimePicker(Args[0]).Date;
  end;
end;

initialization
  RegClass(TSelectDatetime);

finalization
  UnRegClass(TSelectDatetime);

end.


