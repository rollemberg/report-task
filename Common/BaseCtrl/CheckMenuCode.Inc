  //菜单创建前检查代码，主要用于解决根据参数不同而创建不同窗体的需求
  IHRCheckMenuCode = interface
    ['{4665BA80-BAE3-4499-B8E6-841748FCE625}']
    function CheckMenuCode(Sender: TObject; var MenuCode: String): Boolean;
  end;
  {$message 'IHRCheckMenuCode 接口后需移至uBaseIntf中！'}
