unit CustomSync;

interface

uses
  Classes, SysUtils, uBaseIntf, ApConst, AppDB2, AppDB;

type
  ISyncItem = interface
    ['{10C0033B-626E-45EC-B547-79FB764504E4}']
    function execSync: Boolean;
    procedure setDataOut(value: AppDB2.TAppDataSet);
  end;
  TCustomSync = class(TAppBean2, ISyncItem)
  private
  public
    dataOut: AppDB2.TAppDataSet;
    procedure setDataOut(value: AppDB2.TAppDataSet);
    function execSync: Boolean; virtual;
    function Exec(const AFirstParam: String): Boolean; override;
  end;

implementation

{ TCustomSync }

function TCustomSync.Exec(const AFirstParam: String): Boolean;
begin
  Result := false;
end;

function TCustomSync.execSync: Boolean;
begin
  Result := False;
end;

procedure TCustomSync.setDataOut(value: AppDB2.TAppDataSet);
begin
  dataOut := value;
end;

end.
