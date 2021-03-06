object FraSTDBOM: TFraSTDBOM
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 451
    Height = 273
    Align = alClient
    DataSource = dsView
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'It_'
        Title.Alignment = taCenter
        Title.Caption = #24207
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Level_'
        Title.Alignment = taCenter
        Title.Caption = #23637#24320#23618#32423
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PartCode_'
        Title.Alignment = taCenter
        Title.Caption = #32452#25104#26009#21495
        Width = 115
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AssNum_'
        Title.Alignment = taCenter
        Title.Caption = #32452#25104#29992#37327
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BaseNum_'
        Title.Alignment = taCenter
        Title.Caption = #24213#25968
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LossRate_'
        Title.Alignment = taCenter
        Title.Caption = #25439#32791#29575
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Desc'
        Title.Alignment = taCenter
        Title.Caption = #21697#21517
        Width = 145
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Spec'
        Title.Alignment = taCenter
        Title.Caption = #35268#26684
        Width = 145
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Unit'
        Title.Alignment = taCenter
        Title.Caption = #21333#20301
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Remark_'
        Title.Alignment = taCenter
        Title.Caption = #22270#21495
        Width = 98
        Visible = True
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 273
    Width = 451
    Height = 31
    Align = alBottom
    BevelOuter = bvLowered
    BorderWidth = 8
    TabOrder = 1
    object lblStatus: TLabel
      Left = 9
      Top = 9
      Width = 433
      Height = 13
      Align = alClient
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Record'#65306'0 / 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 425
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 9
      Width = 129
      Height = 17
      Caption = #26174#31034#25152#26377#23376#38454
      TabOrder = 0
      OnClick = CheckBox2Click
    end
  end
  object cdsView: TZjhDataSet
    Aggregates = <>
    CommandText = 'extendbom '#39'{00000000-0000-0000-0000-000000000000}'#39',10'
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    AfterScroll = cdsViewAfterScroll
    OnCalcFields = cdsViewCalcFields
    Left = 23
    Top = 34
    object cdsViewParentCode_: TWideStringField
      FieldName = 'ParentCode_'
      Size = 18
    end
    object cdsViewID_: TGuidField
      FieldName = 'ID_'
      Size = 38
    end
    object cdsViewIt_: TAutoIncField
      FieldName = 'It_'
      ReadOnly = True
    end
    object cdsViewPartCode_: TWideStringField
      FieldName = 'PartCode_'
      Size = 18
    end
    object cdsViewAssNum_: TFloatField
      FieldName = 'AssNum_'
    end
    object cdsViewBaseNum_: TIntegerField
      FieldName = 'BaseNum_'
    end
    object cdsViewLossRate_: TFloatField
      FieldName = 'LossRate_'
    end
    object cdsViewAppDate_: TDateTimeField
      FieldName = 'AppDate_'
    end
    object cdsViewStartDate_: TDateTimeField
      FieldName = 'StartDate_'
    end
    object cdsViewEndDate_: TDateTimeField
      FieldName = 'EndDate_'
    end
    object cdsViewStatus_: TIntegerField
      FieldName = 'Status_'
    end
    object cdsViewLevel_: TIntegerField
      FieldName = 'Level_'
    end
    object cdsViewTitem_: TIntegerField
      FieldName = 'Titem_'
    end
    object cdsViewRemark_: TWideStringField
      FieldName = 'Remark_'
      Size = 50
    end
    object cdsViewDesc: TWideStringField
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'Desc'
      Size = 100
      Calculated = True
    end
    object cdsViewSpec: TWideStringField
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'Spec'
      Size = 100
      Calculated = True
    end
    object cdsViewPosition_: TWideMemoField
      FieldName = 'Position_'
      BlobType = ftMemo
    end
    object cdsViewUnit: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'Unit'
      Size = 4
      Calculated = True
    end
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 23
    Top = 66
  end
end
