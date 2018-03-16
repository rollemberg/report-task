object FraCusPartUP: TFraCusPartUP
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object DBGrid5: TZjhDBGrid
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    Align = alClient
    DataSource = dsView
    ReadOnly = True
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
        FieldName = 'Type_'
        Title.Alignment = taCenter
        Title.Caption = #31867#21035
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CusCode_'
        Title.Alignment = taCenter
        Title.Caption = #23458#25143#32534#21495
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CusName_'
        Title.Alignment = taCenter
        Title.Caption = #23458#25143#31616#31216
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Currency_'
        Title.Alignment = taCenter
        Title.Caption = #24065#21035
        Width = 41
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TaxUP_'
        Title.Alignment = taCenter
        Title.Caption = #21333#20215
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Discount_'
        Title.Alignment = taCenter
        Title.Caption = #25240#25968
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LotMinNum_'
        Title.Alignment = taCenter
        Title.Caption = #26368#23567#25209#37327
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LotMaxNum_'
        Title.Alignment = taCenter
        Title.Caption = #26368#22823#25209#37327
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EnabledTimeFm_'
        Title.Alignment = taCenter
        Title.Caption = #26377#25928#26102#38388
        Width = 69
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EnabledTimeTo_'
        Title.Alignment = taCenter
        Title.Caption = #25130#27490#26102#38388
        Width = 69
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'EnabledStatus_'
        Title.Alignment = taCenter
        Title.Caption = #29983#25928#21542
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Remark_'
        Title.Alignment = taCenter
        Title.Caption = #22791#27880
        Width = 201
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PartCode_'
        Title.Alignment = taCenter
        Title.Caption = #26009#21697#32534#21495
        Width = 115
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Desc_'
        Title.Alignment = taCenter
        Title.Caption = #21697#21517
        Width = 179
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Spec_'
        Title.Alignment = taCenter
        Title.Caption = #35268#26684
        Width = 179
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Unit_'
        Title.Alignment = taCenter
        Title.Caption = #21333#20301
        Width = 31
        Visible = True
      end>
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 85
    Top = 82
  end
  object cdsView: TZjhDataSet
    TableName = 'PartTypeUP'
    Aggregates = <>
    CommandText = 'SELECT * FROM PartSale'
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    ReadOnly = True
    Left = 85
    Top = 50
    object cdsViewID_: TGuidField
      FieldName = 'ID_'
      Size = 38
    end
    object cdsViewTBNo_: TWideStringField
      FieldName = 'TBNo_'
      Size = 14
    end
    object cdsViewIt_: TIntegerField
      FieldName = 'It_'
    end
    object cdsViewTBDate_: TDateTimeField
      FieldName = 'TBDate_'
    end
    object cdsViewReasonCode_: TWideStringField
      FieldName = 'ReasonCode_'
      FixedChar = True
      Size = 6
    end
    object cdsViewType_: TSmallintField
      FieldName = 'Type_'
      OnGetText = cdsViewType_GetText
    end
    object cdsViewCusCode_: TWideStringField
      FieldName = 'CusCode_'
      Size = 10
    end
    object cdsViewPartCode_: TWideStringField
      FieldName = 'PartCode_'
      Size = 18
    end
    object cdsViewUnit_: TWideStringField
      FieldName = 'Unit_'
      Size = 4
    end
    object cdsViewCurrency_: TWideStringField
      FieldName = 'Currency_'
      FixedChar = True
      Size = 4
    end
    object cdsViewDiscount_: TFloatField
      FieldName = 'Discount_'
    end
    object cdsViewLotMinNum_: TFloatField
      FieldName = 'LotMinNum_'
    end
    object cdsViewLotMaxNum_: TFloatField
      FieldName = 'LotMaxNum_'
    end
    object cdsViewEnabledTimeFm_: TDateTimeField
      FieldName = 'EnabledTimeFm_'
    end
    object cdsViewEnabledTimeTo_: TDateTimeField
      FieldName = 'EnabledTimeTo_'
    end
    object cdsViewEnabledStatus_: TBooleanField
      FieldName = 'EnabledStatus_'
      OnGetText = cdsViewEnabledStatus_GetText
    end
    object cdsViewFinal_: TBooleanField
      FieldName = 'Final_'
    end
    object cdsViewCusName_: TWideStringField
      FieldName = 'CusName_'
      Size = 10
    end
    object cdsViewDesc_: TWideStringField
      FieldName = 'Desc_'
      Size = 30
    end
    object cdsViewSpec_: TWideStringField
      FieldName = 'Spec_'
      Size = 30
    end
    object cdsViewTaxUP_: TFloatField
      FieldName = 'TaxUP_'
    end
  end
end
