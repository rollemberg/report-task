object FraMakeProcess: TFraMakeProcess
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    Align = alClient
    DataSource = dsView
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ParentCode_'
        Title.Alignment = taCenter
        Title.Caption = #20135#21697#32534#21495
        Width = 115
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'It_'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #24207
        Width = 45
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Code_'
        Title.Alignment = taCenter
        Title.Caption = #24037#24207#32534#21495
        Width = 95
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'WorkName'
        Title.Alignment = taCenter
        Title.Caption = #21517#31216
        Width = 115
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'WaitTime_'
        Title.Alignment = taCenter
        Title.Caption = #20934#22791#24037#26102
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'WorkTime_'
        Title.Alignment = taCenter
        Title.Caption = #26631#20934#24037#26102
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BalanceTime_'
        Title.Alignment = taCenter
        Title.Caption = #24179#34913#24037#26102
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UsePerson_'
        Title.Alignment = taCenter
        Title.Caption = #20351#29992#20154#25968
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Remark_'
        Title.Alignment = taCenter
        Title.Caption = #22791#27880#35828#26126
        Width = 145
        Visible = True
      end>
  end
  object cdsView: TZjhDataSet
    TableName = 'WL_MakeProcess'
    Aggregates = <>
    CommandText = 'SELECT * FROM WL_MakeProcess'
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    ReadOnly = True
    OnCalcFields = cdsViewCalcFields
    Left = 24
    Top = 40
    object cdsViewParentCode_: TWideStringField
      FieldName = 'ParentCode_'
      Size = 18
    end
    object cdsViewWaitTime_: TFloatField
      FieldName = 'WaitTime_'
    end
    object cdsViewWorkTime_: TFloatField
      FieldName = 'WorkTime_'
    end
    object cdsViewBalanceTime_: TFloatField
      FieldName = 'BalanceTime_'
    end
    object cdsViewUsePerson_: TFloatField
      FieldName = 'UsePerson_'
    end
    object cdsViewRemark_: TWideStringField
      FieldName = 'Remark_'
      Size = 80
    end
    object cdsViewCode_: TWideStringField
      FieldName = 'Code_'
      Size = 10
    end
    object cdsViewWordName: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'WorkName'
      Size = 30
      Calculated = True
    end
    object cdsViewIt_: TIntegerField
      FieldName = 'It_'
    end
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 24
    Top = 72
  end
end
