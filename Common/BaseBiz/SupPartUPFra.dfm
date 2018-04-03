object FraSupPartUP: TFraSupPartUP
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object DBGrid4: TDBGrid
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
        FieldName = 'SupCode_'
        Title.Alignment = taCenter
        Title.Caption = #21378#21830#20195#30721
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SupName'
        Title.Alignment = taCenter
        Title.Caption = #21378#21830#31616#31216
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
        FieldName = 'UP_'
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
        Title.Caption = #29983#25928#26102#38388
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EnabledTimeFm_'
        Title.Alignment = taCenter
        Title.Caption = #25130#27490#26102#38388
        Width = 65
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
        FieldName = 'Desc'
        Title.Alignment = taCenter
        Title.Caption = #21697#21517
        Width = 179
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Spec'
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
  object cdsView: TZjhDataSet
    TableName = 'PartSupply'
    Aggregates = <>
    CommandText = 'SELECT top 0 * FROM PartSupply'
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    ReadOnly = True
    OnCalcFields = cdsViewCalcFields
    Left = 21
    Top = 50
    object cdsViewPID_: TGuidField
      FieldName = 'PID_'
      Size = 38
    end
    object cdsViewID_: TGuidField
      FieldName = 'ID_'
      Size = 38
    end
    object cdsViewIndex_: TSmallintField
      FieldName = 'Index_'
    end
    object cdsViewType_: TSmallintField
      FieldName = 'Type_'
      OnGetText = cdsViewType_GetText
    end
    object cdsViewSupCode_: TWideStringField
      FieldName = 'SupCode_'
      Size = 10
    end
    object cdsViewPartCode_: TWideStringField
      FieldName = 'PartCode_'
      Size = 18
    end
    object cdsViewCurrency_: TWideStringField
      FieldName = 'Currency_'
      FixedChar = True
      Size = 4
    end
    object cdsViewUP_: TFloatField
      FieldName = 'UP_'
    end
    object cdsViewLotMinNum_: TFloatField
      FieldName = 'LotMinNum_'
    end
    object cdsViewLotMaxNum_: TFloatField
      FieldName = 'LotMaxNum_'
    end
    object cdsViewEnabledTimeFm_: TDateTimeField
      FieldName = 'EnabledTimeFm_'
      DisplayFormat = 'yyyy/MM/dd'
      EditMask = '!9999/99/00;1;_'
    end
    object cdsViewEnabledTimeTo_: TDateTimeField
      FieldName = 'EnabledTimeTo_'
      DisplayFormat = 'yyyy/MM/dd'
      EditMask = '!9999/99/00;1;_'
    end
    object cdsViewEnabledStatus_: TBooleanField
      FieldName = 'EnabledStatus_'
      OnGetText = cdsViewEnabledStatus_GetText
    end
    object cdsViewUpdateKey_: TGuidField
      FieldName = 'UpdateKey_'
      Size = 38
    end
    object cdsViewSupName: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'SupName'
      Calculated = True
    end
    object cdsViewDelivaryDays_: TSmallintField
      FieldName = 'DelivaryDays_'
    end
    object cdsViewStartTBNo_: TWideStringField
      FieldName = 'StartTBNo_'
      Size = 14
    end
    object cdsViewUnit_: TWideStringField
      FieldName = 'Unit_'
      FixedChar = True
      Size = 4
    end
    object cdsViewDiscount_: TFloatField
      FieldName = 'Discount_'
    end
    object cdsViewMaterialCost_: TFloatField
      FieldName = 'MaterialCost_'
    end
    object cdsViewLabCost_: TFloatField
      FieldName = 'LabCost_'
    end
    object cdsViewManuCost_: TFloatField
      FieldName = 'ManuCost_'
    end
    object cdsViewFinal_: TBooleanField
      FieldName = 'Final_'
    end
    object cdsViewIt_: TIntegerField
      FieldName = 'It_'
    end
    object cdsViewDesc: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'Desc'
      Size = 30
      Calculated = True
    end
    object cdsViewSpec: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'Spec'
      Size = 30
      Calculated = True
    end
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 21
    Top = 82
  end
end
