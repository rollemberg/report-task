unit FunctionManager;

interface

uses
  SysUtils, Variants, Classes, DB, ZjhCtrls, DateUtils, InfoBox, uBaseIntf,
  uSelect, XmlIntf, MainData, Parser10, ApConst, Dialogs, ErpTools,
  FunctionConfig;

type
  IFunctionManager = interface
    ['{C3B749EB-D6AF-4278-ADD0-A96E5CF1C1A8}']
    function isXXX(const FuncText: String): Boolean;
    function getXXX(const FuncText: String): Variant;
    procedure LoadFromConfig(const Section: String);
  end;
  IFunction = interface
    ['{7A3E3750-E910-43B7-8834-1D5A6CC62CED}']
    procedure Init(const FuncName: String; Param: IXmlNode);
    function Process(const FuncName: String; const Param: Variant): Variant;
  end;
  IFunctionMessage = interface
    ['{1799863F-7EB7-47A4-85A3-8C3CC9FAC69E}']
    procedure AddMessage(const Text: String);
  end;
  //
  TFunctionManager = class(TComponent, IFunctionManager)
  private
    mp1: TMathParser;
    FItems: TStringList;
    FClasses: TStringList;
    function getProcess(const FuncName: String; const Param: Variant): Variant;
    function isProcess(const FuncText: String): Boolean;
    function ParseString(const Value: String): Double;
    function getFunctionParam(const Value: String): String;
    function getFunctionName(const Value: String): String;
    function getFunction(const Text: String): String;
    function isFunction(const Text: String): Boolean;
    function ClearSpace(const Value: String): String;
    procedure ReadConfig(sc: TFunctionConfig; const Section: String);
    procedure InstallFunction(root: IXmlNode; obj: TComponent);
    function GetClasses: TStrings;
    function GetItems: TStrings;
  protected
    procedure AddMessage(const Text: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(cdsView: TDataSet): Boolean; virtual;
    //IFunctionManager
    function isXXX(const FuncText: String): Boolean;
    function getXXX(const FuncText: String): Variant;
    procedure LoadFromConfig(const Section: String);
    property ClassList: TStrings read GetClasses;
    property FunctionList: TStrings read GetItems;
  end;

implementation

{ TAttendManager }

constructor TFunctionManager.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TStringList.Create;
  FClasses := TStringList.Create;
  mp1 := TMathParser.Create(Self);
end;

destructor TFunctionManager.Destroy;
begin
  mp1.Free;
  FClasses.Free;
  FItems.Free;
  inherited;
end;

function TFunctionManager.Execute(cdsView: TDataSet): Boolean;
begin
  raise Exception.Create(Chinese.AsString('不可以直接使用此基类的函数！'));
end;

function TFunctionManager.getXXX(const FuncText: String): Variant;
var
  i: Integer;
  sl: TStringList;
  s0, s1, s2, s3: String;
begin
  sl := TStringList.Create;
  try
    s3 := '';
    //分离字符串
    i := 0;
    while i < Length(FuncText) do
    begin
      Inc(i);
      if FuncText[i] in ['a'..'z', 'A'..'Z', '_'] then
        begin //遇到函数
          s0 := getFunction(Copy(FuncText, i, Length(FuncText)));
          i := i + Length(s0) - 1;
          sl.Add(s0);
        end
      else
        sl.Add(FuncText[i]);
    end;
    //解析字符串
    if sl.Count > 1 then
      begin
        s3 := '';
        for i := 0 to sl.Count - 1 do
        begin
          s0 := sl.Strings[i];
          if isFunction(s0) then
            begin
              s1 := getFunctionName(s0);
              s2 := getFunctionParam(Copy(s0, Pos('(', s0) + 1, Length(s0)));
              s3 := s3 + VarToStr(getProcess(s1, s2));
            end
          else
            s3 := s3 + sl.Strings[i];
        end;
        Result := ParseString(ClearSpace(s3));
      end
    else if sl.Count = 1 then
      begin
        s0 := sl.Strings[0];
        if isFunction(s0) then
          begin
            s1 := getFunctionName(s0);
            s2 := getFunctionParam(Copy(s0, Pos('(', s0) + 1, Length(s0)));
            Result := getProcess(s1, s2);
          end
        else
          Result := ParseString(ClearSpace(s0));
      end;
    addMessage(Format('getXXX: %s, Result: %s', [FuncText, VarToStr(Result)]));
  finally
    sl.Free;
  end;
end;

function TFunctionManager.isXXX(const FuncText: String): Boolean;
var
  i: Integer;
  ss: String;
begin
  Result := False;
  ss := Trim(FuncText);
  while ss <> '' do
  begin
    i := Pos(UpperCase(' and '), UpperCase(ss));
    if i > 0 then
      begin
        Result := isProcess(Copy(ss, 1, i - 1));
        if not Result then
          Break;
        ss := Trim(Copy(ss, i + 5, Length(ss)));
      end
    else
      begin
        Result := isProcess(ss);
        Break;
      end;
  end;
  addMessage(Format('isXXX: %s, Result: %s', [FuncText, VarToStr(Result)]));
end;

function TFunctionManager.ParseString(const Value: String): Double;
begin
  mp1.ParseString := Value;
  mp1.Parse;
  if mp1.ParseError then
    begin
      AddMessage(mp1.Expression);
      Result := 0;
    end
  else
    Result := mp1.ParseValue;
  AddMessage(Format('Parse String: %s, Parse Result: %s', [Value, VarToStr(Result)]));
end;

function TFunctionManager.getProcess(const FuncName: String;
  const Param: Variant): Variant;
var
  i: Integer;
  FuncParam: Variant;
  AIntf: IFunction;
  pp: TParamParse;
begin
  if VarIsStr(Param) and (Pos('(', Param) > 0) and (Pos(')', Param) > 0) then
    begin
      FuncParam := '';
      pp := TParamParse.Create(Param);
      for i := 0 to pp.ParamCount - 1 do
      begin
        if isFunction(pp.Params[i]) then
          FuncParam := FuncParam + VarToStr(getXXX(pp.Params[i])) + ','
        else
          FuncParam := FuncParam + pp.Params[i] + ',';
      end;
      if FuncParam <> '' then
        FuncParam := Copy(FuncParam, 1, Length(FuncParam) - 1);
    end
  else
    FuncParam := Param;
  i := FItems.IndexOf(FuncName);
  if i > -1 then
    begin
      AIntf := TComponent(FItems.Objects[i]) as IFunction;
      try
        Result := AIntf.Process(FuncName, FuncParam);
      finally
        AIntf := nil;
      end;
    end
  else
    raise Exception.CreateFmt(Chinese.AsString('    无法解析函数：%s'), [FuncName]);
end;

function TFunctionManager.getFunctionName(const Value: String): String;
var
  i, k: Integer;
begin
  k := 1;
  for i := 1 to Length(Value) do
  begin
    if Value[i] = '(' then
      begin
        Result := Copy(Value, k, i - k);
        Break;
      end
    else if Value[i] in ['+', '-', '*', '/', ' '] then
      k := k + 1;
  end;
end;

function TFunctionManager.getFunctionParam(const Value: String): String;
var
  i, k: Integer;
begin
  Result := '';
  k := 0;
  for i := 1 to Length(Value) do
  begin
    if Value[i] = '(' then
      k := k + 1;
    if Value[i] = ')' then
    begin
      if k = 0 then
      begin
        Result := Copy(Value, 1, i - 1);
        Break;
      end;
      k := k - 1;
    end;
  end;
end;

function TFunctionManager.isFunction(const Text: String): Boolean;
begin
  Result := False;
  if Length(Text) > 1 then
  if Text[1] in ['a'..'z', 'A'..'Z', '_'] then
  if Pos('(', Text) > 0 then
  if Pos(')', Text) > 0 then
    Result := True;
end;

function TFunctionManager.getFunction(const Text: String): String;
var
  i, k: Integer;
begin
  Result := '';
  k := 0;
  for i := 1 to Length(Text) do
  begin
    if Text[i] = '(' then
      k := k + 1;
    if Text[i] = ')' then
    begin
      if k = 1 then
      begin
        Result := Copy(Text, 1, i);
        Break;
      end;
      k := k - 1;
    end;
  end;
end;

procedure TFunctionManager.AddMessage(const Text: String);
var
  AIntf: IFunctionMessage;
begin
  if Supports(Self.Owner, IFunctionMessage) then
  begin
    AIntf := Self.Owner as IFunctionMessage;
    try
      AIntf.AddMessage(Text);
    finally
      AIntf := nil;
    end;
  end;
end;

function TFunctionManager.isProcess(const FuncText: String): Boolean;
var
  Rst: String;
  i: Integer;
  bLeft, bRight: Variant;
  s0, s2, s3: String;
begin
  if FuncText = '' then
  begin
    Result := True;
    Exit;
  end;
  Result := False;
  //取出表达式的左边，放到Rst中
  for i := 1 to Length(FuncText) do
  begin
    if FuncText[i] in ['>', '<', '='] then
    begin
      Rst := getXXX(Copy(FuncText, 1, i - 1));
      s0 := ClearSpace(Copy(FuncText, i, Length(FuncText)));
      Break;
    end;
  end;
  //取出表达式的另一边
  if Pos('"', s0) > 0 then    //字符型比较
    begin
      bLeft := Rst;
      bRight := Copy(s0, Pos('"', s0) + 1, Length(s0));
      bRight := Copy(bRight, 1, Pos('"', bRight) - 1);
      if Copy(s0, 1, 2) = '>=' then
        Result := bLeft >= bRight
      else if Copy(s0, 1, 2) = '<=' then
        Result := bLeft <= bRight
      else if Copy(s0, 1, 2) = '<>' then
        Result := bLeft <> bRight
      else if Copy(s0, 1, 1) = '>' then
        Result := bLeft > bRight
      else if Copy(s0, 1, 1) = '<' then
        Result := bLeft < bRight
      else if Copy(s0, 1, 1) = '=' then
        Result := bLeft = bRight;
    end
  else if Length(s0) > 0 then //数字型比较
    begin
      bLeft := ParseString(Rst);
      if Copy(s0, 1, 2) = '>=' then
        begin
          bRight := StrToFloat(Trim(Copy(s0, 3, Length(s0))));
          Result := bLeft >= bRight;
        end
      else if Copy(s0, 1, 2) = '<=' then
        begin
          bRight := StrToFloat(Trim(Copy(s0, 3, Length(s0))));
          Result := bLeft <= bRight;
        end
      else if Copy(s0, 1, 2) = '<>' then
        begin
          bRight := StrToFloat(Trim(Copy(s0, 3, Length(s0))));
          Result := bLeft <> bRight;
        end
      else if Copy(s0, 1, 1) = '>' then
        begin
          bRight := StrToFloat(Trim(Copy(s0, 2, Length(s0))));
          Result := bLeft > bRight;
        end
      else if Copy(s0, 1, 1) = '<' then
        begin
          bRight := StrToFloat(Trim(Copy(s0, 2, Length(s0))));
          Result := bLeft < bRight;
        end
      else if Copy(s0, 1, 1) = '=' then
        begin
          bRight := StrToFloat(Trim(Copy(s0, 2, Length(s0))));
          Result := bLeft = bRight;
        end;
    end
  else                        //逻辑型
    begin
      if (Pos('(', FuncText) > 0) and (Pos(')', FuncText) > 0) then
        begin
          s2 := Copy(FuncText, 1, Pos('(', FuncText)-1);
          s3 := Copy(FuncText, Pos('(', FuncText)+1, Length(FuncText));
          s3 := Trim(Copy(s3, 1, Pos(')', s3)-1));
          if Length(s3) >= 2 then //处理字符型参数
          begin
            if (s3[1] = '"') and (s3[Length(s3)] = '"') then
              s3 := Copy(s3, 2, Length(s3) - 2); 
          end;
          Result := getProcess(s2, s3);
        end
      else
        begin
          addMessage(Chinese.AsString('不合法的函数：') + FuncText);
          Result := False;
        end;
    end;
end;

procedure TFunctionManager.LoadFromConfig(const Section: String);
var
  sc: TFunctionConfig;
begin
  //读取函数列表
  sc := TFunctionConfig.Create(Self);
  try
    ReadConfig(sc, Section);
    if sc.LoadFromXml('standard.xml') then
      ReadConfig(sc, Section);
  finally
    sc.Free;
  end;
end;

procedure TFunctionManager.ReadConfig(sc: TFunctionConfig; const Section: String);
var
  obj: TComponent;
  strClass: String;
  body, nodeClass: IXmlNode;
begin
  body := sc.getBodyNode(Section);
  if Assigned(body) then
  begin
    nodeClass := body.ChildNodes.First;
    while Assigned(nodeClass) do
    begin
      if (nodeClass.NodeName = 'bean') and (nodeClass.Attributes['enabled'] = 'true') then
      begin
        strClass := Trim(nodeClass.Attributes['class']);
        if (strClass <> '') and (FClasses.IndexOf(strClass) = -1) then
        begin
          FClasses.Add(strClass);
          obj := CreateClass(strClass, Self);
          if Assigned(obj) then
          begin
            if Supports(obj, IFunction) then
              InstallFunction(nodeClass, obj)
            else
              obj.Free;
          end;
        end;
      end;
      nodeClass := nodeClass.NextSibling;
    end;
  end;
end;

procedure TFunctionManager.InstallFunction(root: IXmlNode; obj: TComponent);
var
  node: IXmlNode;
  AIntf: IFunction;
  FuncName: String;
begin
  AIntf := obj as IFunction;
  try
    AIntf.Init('', root);
    node := root.ChildNodes.First;
    while Assigned(node) do
    begin
      if (node.NodeName = 'function') and (node.Attributes['enabled'] = 'true') then
      begin
        FuncName := node.Attributes['code'];
        if (FuncName <> '') and (FItems.IndexOf(FuncName) = -1) then
        begin
          AIntf.Init(FuncName, node);
          FItems.AddObject(FuncName, obj)
        end;
      end;
      node := node.NextSibling;
    end;
  finally
    AIntf := nil;
  end;
end;

function TFunctionManager.ClearSpace(const Value: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Value) do
  begin
    if Value[i] <> ' ' then
      Result := Result + Value[i];
  end;
end;

function TFunctionManager.GetClasses: TStrings;
begin
  Result := FClasses;
end;

function TFunctionManager.GetItems: TStrings;
begin
  Result := FItems;
end;

end.
