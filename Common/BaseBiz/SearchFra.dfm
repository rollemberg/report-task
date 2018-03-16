object FraSearch: TFraSearch
  Left = 0
  Top = 0
  Width = 225
  Height = 390
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  DesignSize = (
    225
    390)
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 225
    Height = 390
    Align = alClient
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 153
    Height = 13
    AutoSize = False
    Caption = #35831#36755#20837#26597#35810#26465#20214#65306
  end
  object SpeedButton1: TSpeedButton
    Left = 199
    Top = 3
    Width = 23
    Height = 22
    Flat = True
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000DEE7E7C6D3D6
      CED3D6CED3D6CED3D6CED7D6CED7D6CED7D6CED7D6CEDBDECEDBDECEDBDECEDB
      DECED7DECED3D6D6DBDEDEEBEFE7EBEFE7EFEFE7EFEFE7EFEFE7EFEFE7EFEFE7
      EFEFE7EFEFE7EFF7E7EFF7E7F3F7E7F3F7E7EFF7E7EFEFCED3D6E7EFEFE7EFF7
      E7F3F7E7F3F7E7F3F7E7F3F7E7F3F7E7F3F7E7F3F7EFF3F7EFF3F7EFF3F7EFF3
      F7EFF3F7E7EFF7CEDBDEE7EFF7E7F3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7EF
      F3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7E7EFF7D6DBDEE7EFF7E7F3F7
      EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3
      F7EFF3F7E7EFF7D6DBDEE7EFF7EFF3F7EFF3F7EFF3F79CA2A5636D6BEFF3F7EF
      F3F7EFF3F7EFF3F7636D6B9CA2A5EFF3F7EFF3F7E7EFF7CEDBDEE7EFF7EFF3F7
      EFF3F7EFF3F7636D6B636D6B636D6BEFF3F7EFF3F7636D6B636D6B636D6BEFF3
      F7EFF3F7E7EFF7CEDBDEEFF3F7EFF3F7EFF3F7EFF3F7EFF3F7636D6B636D6B7B
      82847B8284636D6B636D6BE7F3F7E7F3F7E7F3F7E7EFEFCED7DEEFF3F7EFF3F7
      EFF3F7EFF3F7EFF3F7E7F3F77B8284636D6B636D6B7B8284E7F3F7E7F3F7E7F3
      F7E7F3F7E7EFEFCED7DEEFF3F7EFF3F7EFF3F7EFF3F7EFF3F7E7F3F77B828463
      6D6B636D6B7B8284E7F3F7E7F3F7E7F3F7E7F3F7E7EFEFCED7DEEFF3F7EFF7F7
      EFF3F7EFF3F7EFF3F7636D6B636D6B7B82847B8284636D6B636D6BE7EFF7E7EF
      F7E7EFEFE7EFEFCED7DEEFF3F7EFF7F7EFF3F7EFF3F7636D6B636D6B636D6BE7
      EFF7E7EFF7636D6B636D6B636D6BE7EFF7E7EFEFE7EFEFCED7DEEFF3F7EFF7F7
      EFF7F7EFF3F79CA6A5636D6BE7F3F7E7F3F7E7F3F7E7EFF7636D6B9CA2A5E7EF
      F7E7EFF7E7EFEFCED7D6EFF3F7EFF7F7EFF7F7EFF3F7EFF3F7E7F3F7E7F3F7E7
      F3F7E7F3F7E7EFF7E7EFF7E7EFF7E7EFF7E7EFF7E7EFEFCED7D6EFF7F7F7F7FF
      EFF7F7EFF7F7EFF7F7EFF3F7EFF3F7E7F3F7E7F3F7E7F3F7E7F3F7E7EFF7E7EF
      F7E7EFF7E7EFEFCED7D6F7F7FFF7FBFFF7F7FFEFF7F7EFF7F7EFF7F7EFF7F7EF
      F3F7EFF3F7EFF3F7EFF3F7EFF3F7EFF3F7E7F3F7E7EFEFCED7D6}
    OnClick = SpeedButton1Click
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 36
    Width = 209
    Height = 237
    Anchors = [akLeft, akTop, akBottom]
    Ctl3D = False
    DataSource = dsSearch
    DefaultDrawing = False
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    OnDrawColumnCell = DBGrid1DrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'Check_'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = '@'
        Width = 21
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Name_'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = #26465#20214
        Width = 61
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Value_'
        Title.Alignment = taCenter
        Title.Caption = #21462#20540
        Width = 100
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 280
    Width = 225
    Height = 105
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 1
    object chkSearchClose: TCheckBox
      Left = 8
      Top = 48
      Width = 113
      Height = 17
      Caption = #26597#35810#21518#20851#38381#26465#20214
      PopupMenu = PopupMenu1
      TabOrder = 0
    end
    object chkSearchWindowMax: TCheckBox
      Left = 8
      Top = 24
      Width = 209
      Height = 17
      Caption = #22312#26597#35810#26102#65292#26368#22823#21270#24403#21069#31383#21475
      PopupMenu = PopupMenu1
      TabOrder = 1
      OnClick = chkSearchWindowMaxClick
    end
    object chkSearchSaveOption: TCheckBox
      Left = 8
      Top = 0
      Width = 209
      Height = 17
      Caption = #20445#23384#24403#21069#26465#20214','#65292#20379#19979#27425#20351#29992
      PopupMenu = PopupMenu1
      TabOrder = 2
    end
    object btnFind: TBitBtn
      Left = 134
      Top = 64
      Width = 75
      Height = 25
      Caption = #25628#23547'(&S)'
      Default = True
      DoubleBuffered = True
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000100000000F0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFF00000FFFFF00000F0F000FFFFF0F000F0F000FFFFF0F000F0000000F0000
        000F00F000000F00000F00F000F00F00000F00F000F00F00000FF00000000000
        00FFFF0F000F0F000FFFFF00000F00000FFFFFF000FFF000FFFFFFF0F0FFF0F0
        FFFFFFF000FFF000FFFFFFFFFFFFFFFFFFFF}
      ParentDoubleBuffered = False
      TabOrder = 3
      OnClick = btnFindClick
    end
  end
  object cdsSearch: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = cdsSearchBeforeInsert
    AfterScroll = cdsSearchAfterScroll
    Left = 16
    Top = 80
    object cdsSearchCheck_: TIntegerField
      Alignment = taCenter
      FieldName = 'Check_'
      OnGetText = cdsSearchCheck_GetText
    end
    object cdsSearchCode_: TWideStringField
      FieldName = 'Code_'
      Size = 100
    end
    object cdsSearchName_: TWideStringField
      FieldName = 'Name_'
      Size = 50
    end
    object cdsSearchValue_: TWideStringField
      FieldName = 'Value_'
      Size = 200
    end
    object cdsSearchType_: TIntegerField
      FieldName = 'Type_'
    end
    object cdsSearchWindow_: TWideStringField
      FieldName = 'Window_'
      Size = 200
    end
    object cdsSearchOptior: TWideStringField
      FieldName = 'Optior'
      Size = 10
    end
  end
  object dsSearch: TDataSource
    DataSet = cdsSearch
    Left = 16
    Top = 112
  end
  object SelectCode1: TSelectCode
    OnSelected = SelectCode1Selected
    Left = 48
    Top = 80
  end
  object xml: TXMLDocument
    Left = 48
    Top = 112
    DOMVendorDesc = 'MSXML'
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 80
    Top = 80
    object N1: TMenuItem
      Caption = #20445#23384#34920#26684#20449#24687#65292#20197#20379#35843#25972
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #32534#36753#26597#35810#26465#20214#65292#20197#20379#35843#25972
    end
  end
end
