object FraOrdDetail: TFraOrdDetail
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
    Height = 304
    Align = alClient
    Ctl3D = True
    DataSource = dsView
    ParentCtl3D = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'TBDate_'
        Title.Alignment = taCenter
        Title.Caption = #24322#21160#26085#26399
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CusCode_'
        Title.Alignment = taCenter
        Title.Caption = #23458#25143#20195#30721
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'It_'
        Title.Alignment = taCenter
        Title.Caption = #24207
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Num_'
        Title.Alignment = taCenter
        Title.Caption = #25968#37327
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SpareNum_'
        Title.Alignment = taCenter
        Title.Caption = #20869#21547#22791#21697
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'OriUP_'
        Title.Alignment = taCenter
        Title.Caption = #38144#21806#21333#20215
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Amount'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #26410#31246#37329#39069
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Unit_'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #21333#20301
        Width = 41
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Finish_'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #32467#26696#21542
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FinishDate_'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #32467#26696#26085#26399
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DisCount_'
        Title.Alignment = taCenter
        Title.Caption = #25240#25968
        Width = 65
        Visible = True
      end
      item
        ButtonStyle = cbsEllipsis
        Expanded = False
        FieldName = 'PartCode_'
        Title.Alignment = taCenter
        Title.Caption = #26009#21697#32534#21495
        Width = 115
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'WHCode_'
        Title.Alignment = taCenter
        Title.Caption = #24211#21035
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Desc_'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #21697#21517
        Width = 125
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Spec_'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #35268#26684
        Width = 179
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Bewrite'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #26009#21697#25551#36848
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'OutDate_'
        Title.Alignment = taCenter
        Title.Caption = #39044#35746#20986#36135
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'OutNum_'
        Title.Alignment = taCenter
        Title.Caption = #24050#20986#36135#37327
        Width = 69
        Visible = True
      end>
  end
  object cdsView: TZjhDataSet
    Aggregates = <>
    CommandText = 'select top 0 * from ordb'
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    ReadOnly = True
    OnCalcFields = cdsViewCalcFields
    Left = 24
    Top = 32
    object cdsViewTBDate_: TDateTimeField
      FieldName = 'TBDate_'
    end
    object cdsViewCusCode_: TWideStringField
      FieldName = 'CusCode_'
      Size = 10
    end
    object cdsViewPID_: TGuidField
      FieldName = 'PID_'
      Size = 38
    end
    object cdsViewID_: TGuidField
      FieldName = 'ID_'
      Size = 38
    end
    object cdsViewTBNo_: TWideStringField
      FieldName = 'TBNo_'
      FixedChar = True
      Size = 12
    end
    object cdsViewOrdCode_: TWideStringField
      FieldName = 'OrdCode_'
      Size = 15
    end
    object cdsViewPartCode_: TWideStringField
      FieldName = 'PartCode_'
      Size = 18
    end
    object cdsViewWHCode_: TWideStringField
      FieldName = 'WHCode_'
      FixedChar = True
      Size = 6
    end
    object cdsViewIt_: TIntegerField
      FieldName = 'It_'
    end
    object cdsViewOutDate_: TDateTimeField
      FieldName = 'OutDate_'
    end
    object cdsViewNum_: TFloatField
      FieldName = 'Num_'
    end
    object cdsViewSpareNum_: TFloatField
      FieldName = 'SpareNum_'
    end
    object cdsViewDisCount_: TFloatField
      FieldName = 'DisCount_'
    end
    object cdsViewUnit_: TWideStringField
      FieldName = 'Unit_'
      FixedChar = True
      Size = 4
    end
    object cdsViewDesc_: TWideStringField
      FieldName = 'Desc_'
      Size = 30
    end
    object cdsViewSpec_: TWideStringField
      FieldName = 'Spec_'
      Size = 30
    end
    object cdsViewCostUP_: TFloatField
      FieldName = 'CostUP_'
    end
    object cdsViewPINO_: TWideStringField
      FieldName = 'PINO_'
      Size = 12
    end
    object cdsViewOriUP_: TFloatField
      FieldName = 'OriUP_'
      DisplayFormat = '#0.0000'
    end
    object cdsViewCusModle_: TWideStringField
      FieldName = 'CusModle_'
      Size = 30
    end
    object cdsViewFinish_: TSmallintField
      FieldName = 'Finish_'
    end
    object cdsViewFinishDate_: TDateTimeField
      FieldName = 'FinishDate_'
    end
    object cdsViewUpdateKey_: TGuidField
      FieldName = 'UpdateKey_'
      Size = 38
    end
    object cdsViewOutNum_: TFloatField
      FieldName = 'OutNum_'
    end
    object cdsViewAmount: TFloatField
      FieldKind = fkCalculated
      FieldName = 'Amount'
      DisplayFormat = '#0.00'
      Calculated = True
    end
    object cdsViewBewrite: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'Bewrite'
      Size = 1024
      Calculated = True
    end
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 24
    Top = 64
  end
end
