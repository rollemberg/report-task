  IZLSysEncoded = interface
    ['{A5EA3983-5477-4B70-9D47-5DEEDC2B79C9}']
    function LoadConfig(ATableCode: String): Boolean;
    function GetFirstLength(): Integer;
    function GetAllowLength(): Integer;
    function GetMaxLength(): Integer;
    function GetNextLength(CurLength: Integer): Integer;
  end;
