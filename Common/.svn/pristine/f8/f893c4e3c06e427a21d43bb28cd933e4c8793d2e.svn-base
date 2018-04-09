object FraPartPackage: TFraPartPackage
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
    DataSource = dsView
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Code_'
        Title.Alignment = taCenter
        Title.Caption = #21253#35013#21495
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name_'
        Title.Alignment = taCenter
        Title.Caption = #21253#35013#21517#31216
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Remark_'
        Title.Alignment = taCenter
        Title.Caption = #22791#27880#35828#26126
        Width = 135
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Inner_'
        Title.Alignment = taCenter
        Title.Caption = #20869#31665#23481#37327
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Box_'
        Title.Alignment = taCenter
        Title.Caption = #22806#31665#23481#37327
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GrossW_'
        Title.Alignment = taCenter
        Title.Caption = #27611#37325
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NetW_'
        Title.Alignment = taCenter
        Title.Caption = #20928#37325
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Capasorty_'
        Title.Alignment = taCenter
        Title.Caption = #26448#31215
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'InnerCode_'
        Title.Alignment = taCenter
        Title.Caption = #20869#31665#32534#21495
        Width = 95
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BoxCode_'
        Title.Alignment = taCenter
        Title.Caption = #22806#31665#32534#21495
        Width = 95
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UP_'
        Title.Alignment = taCenter
        Title.Caption = #21333#20215
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PartCode_'
        Title.Alignment = taCenter
        Title.Caption = #20135#21697#32534#21495
        Width = 115
        Visible = True
      end>
  end
  object cdsView: TZjhDataSet
    TableName = 'WL_Package'
    Aggregates = <>
    CommandText = 'SELECT * FROM WL_Package'
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    ReadOnly = True
    Left = 24
    Top = 32
    object cdsViewPartCode_: TWideStringField
      FieldName = 'PartCode_'
      Size = 18
    end
    object cdsViewCode_: TWideStringField
      FieldName = 'Code_'
      Size = 10
    end
    object cdsViewName_: TWideStringField
      FieldName = 'Name_'
      Size = 30
    end
    object cdsViewRemark_: TWideStringField
      FieldName = 'Remark_'
      Size = 80
    end
    object cdsViewInner_: TIntegerField
      FieldName = 'Inner_'
    end
    object cdsViewBox_: TIntegerField
      FieldName = 'Box_'
    end
    object cdsViewGrossW_: TFloatField
      FieldName = 'GrossW_'
    end
    object cdsViewNetW_: TFloatField
      FieldName = 'NetW_'
    end
    object cdsViewCapasorty_: TFloatField
      FieldName = 'Capasorty_'
    end
    object cdsViewInnerCode_: TWideStringField
      FieldName = 'InnerCode_'
      Size = 18
    end
    object cdsViewBoxCode_: TWideStringField
      FieldName = 'BoxCode_'
      Size = 18
    end
    object cdsViewUP_: TFloatField
      FieldName = 'UP_'
    end
    object cdsViewEnabled_: TBooleanField
      FieldName = 'Enabled_'
    end
    object cdsViewUpdateKey_: TGuidField
      FieldName = 'UpdateKey_'
      Size = 38
    end
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 24
    Top = 64
  end
end
